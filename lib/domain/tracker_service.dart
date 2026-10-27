import '../core/constants/app_constants.dart';
import '../core/constants/habit_presets.dart';
import '../core/utils/arc_date.dart';
import '../data/models/app_settings.dart';
import '../data/models/arc.dart';
import '../data/models/daily_log.dart';
import '../data/models/habit.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/achievement_repository.dart';
import '../data/repositories/arc_repository.dart';
import '../data/repositories/daily_log_repository.dart';
import '../data/repositories/habit_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/settings_repository.dart';
import 'arc_state.dart';
import 'engines/achievement_evaluator.dart';
import 'engines/frequency_engine.dart';
import 'engines/level_engine.dart';
import 'engines/stat_engine.dart';
import 'engines/streak_engine.dart';
import 'engines/xp_engine.dart';

/// What changed as a result of a write - drives celebrations without the UI
/// having to diff state itself.
class LogOutcome {
  const LogOutcome({
    required this.awardedXp,
    required this.isComplete,
    required this.ratio,
    required this.leveledUp,
    required this.newLevel,
    required this.rankUnlockedKey,
    required this.newAchievementKeys,
    required this.dayCompleted,
    required this.xpSuppressed,
  });

  final int awardedXp;
  final bool isComplete;
  final double ratio;
  final bool leveledUp;
  final int newLevel;
  final String? rankUnlockedKey;
  final List<String> newAchievementKeys;
  final bool dayCompleted;

  /// True when the clock-tamper guard withheld XP for this write.
  final bool xpSuppressed;

  static const none = LogOutcome(
    awardedXp: 0,
    isComplete: false,
    ratio: 0,
    leveledUp: false,
    newLevel: 1,
    rankUnlockedKey: null,
    newAchievementKeys: [],
    dayCompleted: false,
    xpSuppressed: false,
  );
}

/// Ties the pure engines to storage. Every mutation funnels through here so
/// the derived state (streak, stats, level, achievements) is recomputed in one
/// place, exactly once, from the logs themselves.
class TrackerService {
  TrackerService({
    required this.habits,
    required this.logs,
    required this.profiles,
    required this.arcs,
    required this.achievements,
    required this.settingsRepo,
  });

  final HabitRepository habits;
  final DailyLogRepository logs;
  final ProfileRepository profiles;
  final ArcRepository arcs;
  final AchievementRepository achievements;
  final SettingsRepository settingsRepo;

  // ------------------------------------------------------------- bootstrap

  /// Creates the first arc and seeds habits. Called once from onboarding.
  Future<void> createInitialArc({
    required String fullName,
    required String nickname,
    required String themePreference,
    required DateTime startDate,
    required int lengthDays,
    required List<HabitPreset> selectedPresets,
  }) async {
    final start = ArcDate.dayOnly(startDate);
    final end = start.add(Duration(days: lengthDays - 1));

    final arc = Arc.create(
      name: 'Arc ${start.year}',
      startDate: start,
      endDate: end,
      lengthDays: lengthDays,
    );
    final arcId = await arcs.save(arc);
    arc.id = arcId;

    final newHabits = <Habit>[];
    for (var i = 0; i < selectedPresets.length; i++) {
      final h = selectedPresets[i].toHabit(sortOrder: i, arcId: arcId);
      h.createdAt = start;
      newHabits.add(h);
    }
    await habits.saveAll(newHabits);

    final profile = await profiles.getOrCreate()
      ..fullName = fullName
      ..nickname = nickname
      ..themePreference = themePreference
      ..arcStartDate = start
      ..arcEndDate = end
      ..arcLengthDays = lengthDays
      ..currentArcId = arcId
      ..currentLevel = 1
      ..totalXp = 0
      ..onboardingComplete = true
      ..installedAt = DateTime.now();
    profile.statScores.reset();
    await profiles.save(profile);

    await settingsRepo.setOnboardingComplete(true);
    await settingsRepo.setSchemaVersion(AppConstants.schemaVersion);
  }

  // --------------------------------------------------------------- reading

  /// Materialises any missing days and returns the full derived state.
  Future<ArcState?> load(AppSettings settings) async {
    final profile = await profiles.get();
    if (profile == null || !profile.onboardingComplete) return null;

    var arc = await arcs.byId(profile.currentArcId);
    arc ??= await arcs.active();
    if (arc == null) return null;

    final today = ArcDate.effectiveDate(
      DateTime.now(),
      settings.dayRolloverHour,
    );

    final habitList = await habits.forArc(arc.id);
    await _materialiseDays(arc, habitList, profile, today);

    final logList = await logs.forArc(arc.id);
    final logsByKey = {for (final l in logList) l.dateKey: l};
    final arcDays = ArcDate.daysInRange(arc.startDate, arc.endDate);
    final habitsById = {for (final h in habitList) h.id: h};

    final streak = StreakEngine.compute(
      arcDays: arcDays,
      logsByKey: logsByKey,
      habitsById: habitsById,
      settings: settings,
      today: today,
    );

    final stats = StatEngine.compute(
      days: arcDays,
      logsByKey: logsByKey,
      habitsById: habitsById,
      upTo: today,
    );

    final achievementList = await achievements.all();

    return ArcState(
      profile: profile,
      arc: arc,
      settings: settings,
      habits: habitList,
      logsByKey: logsByKey,
      arcDays: arcDays,
      streak: streak,
      stats: stats,
      achievements: achievementList,
      today: today,
      bossWeek: _bossWeekProgress(arc, logsByKey, habitsById, today),
    );
  }

  // --------------------------------------------------------------- writing

  /// Logs a value for one habit on one day.
  ///
  /// [value] is the raw metric (1 for a boolean habit). Passing 0 clears the
  /// entry, which is how un-toggling works.
  Future<LogOutcome> logHabit({
    required ArcState state,
    required Habit habit,
    required DateTime day,
    required double value,
  }) async {
    if (!state.canLog(day)) return LogOutcome.none;

    final dateKey = ArcDate.keyOf(day);
    final log =
        state.logsByKey[dateKey] ??
        DailyLog.create(
          dateKey: dateKey,
          date: ArcDate.dayOnly(day),
          arcId: state.arc.id,
        );

    final xpSuppressed = await _clockMovedBackwards();
    final multiplier = xpSuppressed ? 0.0 : state.multiplier;
    final loggedLate = !ArcDate.isSameDay(day, state.today);

    final before = {for (final a in state.achievements) a.key: a};
    final levelBefore = LevelEngine.levelForXp(state.profile.totalXp);

    // Upsert, never append: the entry for a habit is replaced in place so a
    // second write on the same day cannot double-award.
    //
    // The list is rebuilt rather than mutated because Isar hands back
    // fixed-length lists for embedded collections - mutating one in place
    // throws.
    final entries = [
      for (final e in log.entries)
        if (e.habitId != habit.id) e,
    ];
    if (value > 0) {
      entries.add(
        XpEngine.buildEntry(
          habit: habit,
          value: value,
          multiplier: multiplier,
          partialCreditEnabled: state.settings.partialCreditEnabled,
          loggedLate: loggedLate,
        ),
      );
    }
    log.entries = entries;

    log.totalXpEarned = entries.fold(0, (s, e) => s + e.awardedXp);
    log.multiplierApplied = multiplier == 0 ? 1.0 : multiplier;

    // A weekly_target completion changes what is due later in the same week,
    // so the current week's snapshots are refreshed after every write.
    await logs.save(log);
    await _refreshWeekSnapshots(state.arc, state.habits, day, state.today);

    final refreshed = await _recompute(state.settings);
    final entry = log.entryFor(habit.id);

    final newAchievements = AchievementEvaluator.newlyUnlocked(
      before,
      refreshed?.achievements ?? const [],
    );
    final levelAfter = refreshed?.level ?? levelBefore;

    return LogOutcome(
      awardedXp: entry?.awardedXp ?? 0,
      isComplete: entry?.isComplete ?? false,
      ratio: entry?.completionRatio ?? 0,
      leveledUp: levelAfter > levelBefore,
      newLevel: levelAfter,
      rankUnlockedKey: LevelEngine.crossedRank(levelBefore, levelAfter)
          ? LevelEngine.rankKeyForLevel(levelAfter)
          : null,
      newAchievementKeys: newAchievements,
      dayCompleted: refreshed?.todayLog?.isPerfectDay ?? false,
      xpSuppressed: xpSuppressed,
    );
  }

  /// Convenience for boolean habits.
  Future<LogOutcome> toggleHabit({
    required ArcState state,
    required Habit habit,
    required DateTime day,
  }) {
    final existing = state.logsByKey[ArcDate.keyOf(day)]?.entryFor(habit.id);
    final on = existing?.isComplete ?? false;
    return logHabit(
      state: state,
      habit: habit,
      day: day,
      value: on ? 0 : habit.targetMetric.toDouble(),
    );
  }

  Future<void> saveJournal({
    required ArcState state,
    required DateTime day,
    String? gratitude,
    String? notes,
    int? mood,
    List<String>? tags,
    List<String>? photoPaths,
  }) async {
    final dateKey = ArcDate.keyOf(day);
    final log =
        state.logsByKey[dateKey] ??
        DailyLog.create(
          dateKey: dateKey,
          date: ArcDate.dayOnly(day),
          arcId: state.arc.id,
        );
    if (gratitude != null) log.gratitudeText = gratitude;
    if (notes != null) log.progressNotes = notes;
    if (mood != null) log.mood = mood;
    if (tags != null) log.tags = List<String>.of(tags);
    if (photoPaths != null) log.photoPaths = List<String>.of(photoPaths);
    await logs.save(log);

    // Gratitude entries feed the `gratitude_100` achievement. Writing the log
    // alone left that counter frozen, because only habit logging ever ran the
    // evaluator - so a hundred gratitude entries could never unlock it.
    await _recompute(state.settings);
  }

  /// Records a completed concentration session on [day].
  ///
  /// Additive rather than absolute: two sessions in a day should sum, and a
  /// crash between them must not lose the first.
  Future<void> addFocusSession({
    required ArcState state,
    required DateTime day,
    required int minutes,
  }) async {
    if (minutes <= 0) return;
    final dateKey = ArcDate.keyOf(day);
    final log =
        state.logsByKey[dateKey] ??
        DailyLog.create(
          dateKey: dateKey,
          date: ArcDate.dayOnly(day),
          arcId: state.arc.id,
        );
    log
      ..focusMinutes += minutes
      ..focusSessions += 1;
    await logs.save(log);
  }

  Future<void> saveStepCount({
    required ArcState state,
    required DateTime day,
    required int steps,
  }) async {
    final dateKey = ArcDate.keyOf(day);
    final log = state.logsByKey[dateKey];
    if (log == null || log.stepCount == steps) return;
    log.stepCount = steps;
    await logs.save(log);
  }

  // ------------------------------------------------------- derived recompute

  /// Recomputes streak, stats, level and achievements from the logs and
  /// persists the results onto the profile.
  Future<ArcState?> _recompute(AppSettings settings) async {
    final profile = await profiles.get();
    if (profile == null) return null;
    var arc = await arcs.byId(profile.currentArcId);
    arc ??= await arcs.active();
    if (arc == null) return null;

    final today = ArcDate.effectiveDate(
      DateTime.now(),
      settings.dayRolloverHour,
    );
    final habitList = await habits.forArc(arc.id);
    final logList = await logs.forArc(arc.id);
    final logsByKey = {for (final l in logList) l.dateKey: l};
    final habitsById = {for (final h in habitList) h.id: h};
    final arcDays = ArcDate.daysInRange(arc.startDate, arc.endDate);

    final streak = StreakEngine.compute(
      arcDays: arcDays,
      logsByKey: logsByKey,
      habitsById: habitsById,
      settings: settings,
      today: today,
    );
    final stats = StatEngine.compute(
      days: arcDays,
      logsByKey: logsByKey,
      habitsById: habitsById,
      upTo: today,
    );

    // Total XP is the sum of what was actually awarded, plus boss-week bonuses.
    // Never recomputed from current habit definitions - awarded is awarded.
    var totalXp = 0;
    profile.statScores.reset();
    for (final log in logList) {
      if (log.isPreInstall) continue;
      for (final e in log.entries) {
        totalXp += e.awardedXp;
        final habit = habitsById[e.habitId];
        if (habit != null) {
          profile.statScores.add(habit.statAttribute, e.awardedXp);
        }
      }
    }
    totalXp += _earnedBossBonus(arc, logsByKey, habitsById, today);

    profile
      ..totalXp = totalXp
      ..currentLevel = LevelEngine.levelForXp(totalXp)
      ..currentStreak = streak.currentStreak
      ..bestStreak = streak.bestStreak > profile.bestStreak
          ? streak.bestStreak
          : profile.bestStreak
      ..shieldsHeld = streak.shieldsHeld
      ..shieldsConsumedTotal = streak.shieldsConsumedTotal;
    await profiles.save(profile);

    final existing = await achievements.byKey();
    final progress = AchievementEvaluator.evaluate(
      AchievementEvaluator.contextFor(
        logs: logList,
        habitsById: habitsById,
        streak: streak,
        stats: stats,
        totalXp: totalXp,
        arcLengthDays: arc.lengthDays,
        arcId: arc.id,
        hasBackup: settings.lastBackupAt != null,
      ),
    );
    final reconciled = AchievementEvaluator.reconcile(
      progress: progress,
      existing: existing,
      arcId: arc.id,
      now: DateTime.now(),
    );
    await achievements.saveAll(reconciled);

    return ArcState(
      profile: profile,
      arc: arc,
      settings: settings,
      habits: habitList,
      logsByKey: logsByKey,
      arcDays: arcDays,
      streak: streak,
      stats: stats,
      achievements: reconciled,
      today: today,
      bossWeek: _bossWeekProgress(arc, logsByKey, habitsById, today),
    );
  }

  /// Public recompute - used after import, migration and settings changes that
  /// alter the rules (Hardcore Mode, partial credit, rollover hour).
  Future<ArcState?> recompute(AppSettings settings) => _recompute(settings);

  // ---------------------------------------------------------- day scaffolding

  /// Creates a DailyLog for every elapsed day, snapshotting what was due.
  ///
  /// Days before install are marked is_pre_install and excluded from every rate
  /// (edge_case_handling.arc_started_before_install).
  Future<void> _materialiseDays(
    Arc arc,
    List<Habit> habitList,
    UserProfile profile,
    DateTime today,
  ) async {
    final existing = await logs.forArc(arc.id);
    final byKey = {for (final l in existing) l.dateKey: l};

    final firstDay = ArcDate.dayOnly(arc.startDate);
    final lastDay = today.isAfter(ArcDate.dayOnly(arc.endDate))
        ? ArcDate.dayOnly(arc.endDate)
        : today;
    if (lastDay.isBefore(firstDay)) return;

    final installDay = ArcDate.dayOnly(profile.installedAt);
    final pending = <DailyLog>[];

    for (final day in ArcDate.daysInRange(firstDay, lastDay)) {
      final key = ArcDate.keyOf(day);
      var log = byKey[key];
      final preInstall = day.isBefore(installDay);

      if (log == null) {
        log = DailyLog.create(
          dateKey: key,
          date: day,
          arcId: arc.id,
          isPreInstall: preInstall,
        );
        byKey[key] = log;
        if (!preInstall) {
          log.scheduledHabitIds = _scheduleFor(day, habitList, byKey);
        }
        pending.add(log);
      } else if (log.scheduledHabitIds.isEmpty && !log.isPreInstall) {
        // A day that was materialised before any habits existed.
        log.scheduledHabitIds = _scheduleFor(day, habitList, byKey);
        pending.add(log);
      }
    }

    if (pending.isNotEmpty) await logs.saveAll(pending);

    // Today and the rest of the current ISO week are re-snapshotted every load,
    // because a weekly_target completion changes what is still due.
    await _refreshWeekSnapshots(arc, habitList, today, today);
  }

  Future<void> _refreshWeekSnapshots(
    Arc arc,
    List<Habit> habitList,
    DateTime anyDayInWeek,
    DateTime today,
  ) async {
    final monday = ArcDate.startOfIsoWeek(anyDayInWeek);
    final sunday = monday.add(const Duration(days: 6));
    final upper = today.isBefore(sunday) ? today : sunday;
    if (upper.isBefore(monday)) return;

    final range = await logs.inRange(arc.id, monday, upper);
    final byKey = {for (final l in range) l.dateKey: l};
    final pending = <DailyLog>[];

    for (final day in ArcDate.daysInRange(monday, upper)) {
      if (day.isBefore(ArcDate.dayOnly(arc.startDate))) continue;
      final key = ArcDate.keyOf(day);
      final log = byKey[key];
      if (log == null || log.isPreInstall) continue;
      final next = _scheduleFor(day, habitList, byKey);
      if (!_sameIds(log.scheduledHabitIds, next)) {
        log.scheduledHabitIds = next;
        pending.add(log);
      }
    }
    if (pending.isNotEmpty) await logs.saveAll(pending);
  }

  List<int> _scheduleFor(
    DateTime day,
    List<Habit> habitList,
    Map<String, DailyLog> weekLogs,
  ) => FrequencyEngine.scheduledFor(
    day,
    habitList
        .where(
          (h) =>
              !h.isArchived ||
              (h.archivedAt != null && day.isBefore(h.archivedAt!)),
        )
        .toList(),
    weekLogs,
  ).map((h) => h.id).toList();

  static bool _sameIds(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // ------------------------------------------------------------- boss weeks

  BossWeekProgress? _bossWeekProgress(
    Arc arc,
    Map<String, DailyLog> logsByKey,
    Map<int, Habit> habitsById,
    DateTime today,
  ) {
    final week = ArcDate.arcWeekNumber(arc.startDate, today);
    final boss = BossWeekEngine.forArcWeek(week);
    if (boss == null) return null;
    final completed = _bossCompletedDays(
      arc,
      boss,
      logsByKey,
      habitsById,
      today,
    );
    final required = BossWeekEngine.requiredDays(boss);
    return BossWeekProgress(
      week: boss,
      completed: completed,
      required_: required,
      earned: completed >= required,
    );
  }

  int _bossCompletedDays(
    Arc arc,
    BossWeek boss,
    Map<String, DailyLog> logsByKey,
    Map<int, Habit> habitsById,
    DateTime upTo,
  ) {
    final firstDay = ArcDate.dayOnly(
      arc.startDate,
    ).add(Duration(days: (boss.arcWeek - 1) * 7));
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final day = firstDay.add(Duration(days: i));
      if (day.isAfter(upTo)) break;
      final log = logsByKey[ArcDate.keyOf(day)];
      if (log == null || log.isPreInstall) continue;

      switch (boss.kind) {
        case BossWeekKind.perfectDays:
        case BossWeekKind.perfectWeek:
          if (log.isPerfectDay) count++;
        case BossWeekKind.specificHabitAllWeek:
          final keys = _bossHabitKeys(boss);
          var allDone = keys.isNotEmpty;
          for (final titleKey in keys) {
            final ids = habitsById.values
                .where((h) => h.titleKey == titleKey)
                .map((h) => h.id);
            if (ids.isEmpty) continue;
            final done = ids.any((id) => log.entryFor(id)?.isComplete ?? false);
            if (!done) allDone = false;
          }
          if (allDone) count++;
      }
    }
    return count;
  }

  static List<String> _bossHabitKeys(BossWeek boss) => switch (boss.arcWeek) {
    8 => const ['habitStepsGoal'],
    12 => const ['habitNoJunkFood', 'habitWaterOnly'],
    _ => const [],
  };

  int _earnedBossBonus(
    Arc arc,
    Map<String, DailyLog> logsByKey,
    Map<int, Habit> habitsById,
    DateTime today,
  ) {
    var bonus = 0;
    for (final boss in BossWeekEngine.schedule) {
      final weekEnd = ArcDate.dayOnly(
        arc.startDate,
      ).add(Duration(days: boss.arcWeek * 7 - 1));
      // Only pay out once the boss week has fully elapsed.
      if (today.isBefore(weekEnd)) continue;
      final done = _bossCompletedDays(
        arc,
        boss,
        logsByKey,
        habitsById,
        weekEnd,
      );
      if (done >= BossWeekEngine.requiredDays(boss)) bonus += boss.bonusXp;
    }
    return bonus;
  }

  // --------------------------------------------------------- clock tampering

  /// edge_case_handling.clock_tampering: if wall-clock time moves backwards by
  /// more than an hour, we still record the log but withhold the XP.
  Future<bool> _clockMovedBackwards() async {
    final now = DateTime.now();
    final last = settingsRepo.maxObservedTime;
    if (last != null && now.isBefore(last.subtract(const Duration(hours: 1)))) {
      return true;
    }
    if (last == null || now.isAfter(last)) {
      await settingsRepo.setMaxObservedTime(now);
    }
    return false;
  }

  // ------------------------------------------------------------ arc lifecycle

  /// core_features.multi_arc - archive the finished arc and open the next one.
  Future<int> startNewArc({
    required ArcState state,
    required int lengthDays,
    required bool carryHabits,
    required bool carryStats,
    DateTime? startDate,
  }) async {
    final old = state.arc
      ..status = ArcStatus.completed
      ..finalCompletionRate = state.completionRate
      ..finalLevel = state.level;
    await arcs.save(old);

    final start = ArcDate.dayOnly(startDate ?? state.today);
    final arc = Arc.create(
      name: 'Arc ${start.year} #${old.id + 1}',
      startDate: start,
      endDate: start.add(Duration(days: lengthDays - 1)),
      lengthDays: lengthDays,
      carriedFromArcId: old.id,
    );
    final arcId = await arcs.save(arc);

    if (carryHabits) {
      final copies = [
        for (final h in state.activeHabits)
          h.copyForNewArc(arcId)..createdAt = start,
      ];
      await habits.saveAll(copies);
    }

    final profile = state.profile
      ..currentArcId = arcId
      ..arcStartDate = arc.startDate
      ..arcEndDate = arc.endDate
      ..arcLengthDays = lengthDays
      ..currentStreak = 0
      ..shieldsHeld = 0;
    if (!carryStats) {
      profile
        ..totalXp = 0
        ..currentLevel = 1;
      profile.statScores.reset();
    }
    await profiles.save(profile);
    return arcId;
  }

  /// Rebuilds every derived number from raw logs. Used after restore and after
  /// a schema migration, so an imported backup unlocks identically.
  Future<void> recomputeAfterImport(AppSettings settings) async {
    await achievements.deleteAll();
    await _recompute(settings);
  }
}
