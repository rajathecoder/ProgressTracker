import '../../core/utils/arc_date.dart';
import '../../data/models/achievement.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import 'level_engine.dart';
import 'stat_engine.dart';
import 'streak_engine.dart';

/// Static catalogue entry. [nameKey]/[descKey] are ARB keys, so the Trophy Hall
/// localises without the evaluator knowing anything about presentation.
class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.nameKey,
    required this.descKey,
    required this.category,
    required this.target,
  });

  final String id;
  final String nameKey;
  final String descKey;
  final String category;
  final int target;
}

/// Everything the evaluator needs, gathered once per pass.
class EvaluationContext {
  const EvaluationContext({
    required this.logs,
    required this.habitsById,
    required this.streak,
    required this.stats,
    required this.totalXp,
    required this.level,
    required this.arcLengthDays,
    required this.arcId,
    required this.hasCustomHabit,
    required this.hasBackup,
  });

  final List<DailyLog> logs;
  final Map<int, Habit> habitsById;
  final StreakResult streak;
  final StatSnapshot stats;
  final int totalXp;
  final int level;
  final int arcLengthDays;
  final int arcId;
  final bool hasCustomHabit;
  final bool hasBackup;
}

/// gamification_engine.achievements + achievement_evaluation
///
/// "Pure functions over Isar data, run in a single evaluator pass after every
/// log write. Never store derived achievement state as the source of truth -
/// recompute on restore so imported backups unlock correctly."
abstract final class AchievementEvaluator {
  static const String catStreak = 'streak';
  static const String catMilestone = 'milestone';
  static const String catHabit = 'habit';
  static const String catComeback = 'comeback';
  static const String catMeta = 'meta';

  static const List<AchievementDef> catalogue = [
    AchievementDef(
      id: 'first_blood',
      nameKey: 'achFirstBlood',
      descKey: 'achFirstBloodDesc',
      category: catMilestone,
      target: 1,
    ),
    AchievementDef(
      id: 'perfect_day',
      nameKey: 'achPerfectDay',
      descKey: 'achPerfectDayDesc',
      category: catMilestone,
      target: 1,
    ),
    AchievementDef(
      id: 'streak_3',
      nameKey: 'achStreak3',
      descKey: 'achStreak3Desc',
      category: catStreak,
      target: 3,
    ),
    AchievementDef(
      id: 'streak_7',
      nameKey: 'achStreak7',
      descKey: 'achStreak7Desc',
      category: catStreak,
      target: 7,
    ),
    AchievementDef(
      id: 'streak_14',
      nameKey: 'achStreak14',
      descKey: 'achStreak14Desc',
      category: catStreak,
      target: 14,
    ),
    AchievementDef(
      id: 'streak_30',
      nameKey: 'achStreak30',
      descKey: 'achStreak30Desc',
      category: catStreak,
      target: 30,
    ),
    AchievementDef(
      id: 'streak_60',
      nameKey: 'achStreak60',
      descKey: 'achStreak60Desc',
      category: catStreak,
      target: 60,
    ),
    AchievementDef(
      id: 'streak_100',
      nameKey: 'achStreak100',
      descKey: 'achStreak100Desc',
      category: catStreak,
      target: 100,
    ),
    AchievementDef(
      id: 'perfect_arc',
      nameKey: 'achPerfectArc',
      descKey: 'achPerfectArcDesc',
      category: catStreak,
      target: 1,
    ),
    AchievementDef(
      id: 'ten_perfect_days',
      nameKey: 'achTenPerfectDays',
      descKey: 'achTenPerfectDaysDesc',
      category: catMilestone,
      target: 10,
    ),
    AchievementDef(
      id: 'early_riser_30',
      nameKey: 'achEarlyRiser30',
      descKey: 'achEarlyRiser30Desc',
      category: catHabit,
      target: 30,
    ),
    AchievementDef(
      id: 'gym_50',
      nameKey: 'achGym50',
      descKey: 'achGym50Desc',
      category: catHabit,
      target: 50,
    ),
    AchievementDef(
      id: 'steps_500k',
      nameKey: 'achSteps500k',
      descKey: 'achSteps500kDesc',
      category: catHabit,
      target: 500000,
    ),
    AchievementDef(
      id: 'gratitude_100',
      nameKey: 'achGratitude100',
      descKey: 'achGratitude100Desc',
      category: catHabit,
      target: 100,
    ),
    AchievementDef(
      id: 'clean_30',
      nameKey: 'achClean30',
      descKey: 'achClean30Desc',
      category: catHabit,
      target: 30,
    ),
    AchievementDef(
      id: 'hydrated_60',
      nameKey: 'achHydrated60',
      descKey: 'achHydrated60Desc',
      category: catHabit,
      target: 60,
    ),
    AchievementDef(
      id: 'level_10',
      nameKey: 'achLevel10',
      descKey: 'achLevel10Desc',
      category: catMilestone,
      target: 10,
    ),
    AchievementDef(
      id: 'level_25',
      nameKey: 'achLevel25',
      descKey: 'achLevel25Desc',
      category: catMilestone,
      target: 25,
    ),
    AchievementDef(
      id: 'level_50',
      nameKey: 'achLevel50',
      descKey: 'achLevel50Desc',
      category: catMilestone,
      target: 50,
    ),
    AchievementDef(
      id: 'balanced',
      nameKey: 'achBalanced',
      descKey: 'achBalancedDesc',
      category: catMilestone,
      target: 5,
    ),
    AchievementDef(
      id: 'phoenix',
      nameKey: 'achPhoenix',
      descKey: 'achPhoenixDesc',
      category: catComeback,
      target: 1,
    ),
    AchievementDef(
      id: 'no_shields_30',
      nameKey: 'achNoShields30',
      descKey: 'achNoShields30Desc',
      category: catComeback,
      target: 30,
    ),
    AchievementDef(
      id: 'first_backup',
      nameKey: 'achFirstBackup',
      descKey: 'achFirstBackupDesc',
      category: catMeta,
      target: 1,
    ),
    AchievementDef(
      id: 'architect',
      nameKey: 'achArchitect',
      descKey: 'achArchitectDesc',
      category: catMeta,
      target: 1,
    ),
  ];

  static AchievementDef? defFor(String id) {
    for (final d in catalogue) {
      if (d.id == id) return d;
    }
    return null;
  }

  /// ARB keys of the preset habits the habit-specific achievements track.
  static const _earlyWakeKey = 'habitEarlyWake';
  static const _gymKey = 'habitGymWorkout';
  static const _stepsKey = 'habitStepsGoal';
  static const _junkKey = 'habitNoJunkFood';
  static const _waterKey = 'habitWaterOnly';

  /// One pass, all 24. Returns id -> raw progress (uncapped).
  static Map<String, int> evaluate(EvaluationContext ctx) {
    var completedAny = 0;
    var perfectDays = 0;
    var gratitudeEntries = 0;
    var cumulativeSteps = 0;
    var earlyWakes = 0;
    var gymSessions = 0;
    var cleanDays = 0;
    var waterDays = 0;

    final byTitleKey = <String, Set<int>>{};
    for (final h in ctx.habitsById.values) {
      final k = h.titleKey;
      if (k != null) (byTitleKey[k] ??= <int>{}).add(h.id);
    }

    int countCompletions(String titleKey) {
      final ids = byTitleKey[titleKey];
      if (ids == null || ids.isEmpty) return 0;
      var n = 0;
      for (final log in ctx.logs) {
        if (log.isPreInstall) continue;
        for (final id in ids) {
          final e = log.entryFor(id);
          if (e != null && e.isComplete) {
            n++;
            break;
          }
        }
      }
      return n;
    }

    for (final log in ctx.logs) {
      if (log.isPreInstall) continue;
      completedAny += log.entries.where((e) => e.isComplete).length;
      if (log.isPerfectDay) perfectDays++;
      if (log.gratitudeText.trim().isNotEmpty) gratitudeEntries++;
      cumulativeSteps += log.stepCount;
    }

    earlyWakes = countCompletions(_earlyWakeKey);
    gymSessions = countCompletions(_gymKey);
    cleanDays = countCompletions(_junkKey);
    waterDays = countCompletions(_waterKey);

    // The steps achievement prefers the pedometer total, but falls back to the
    // logged metric value when the device has no step counter
    // (edge_case_handling.pedometer_unavailable).
    if (cumulativeSteps == 0) {
      final ids = byTitleKey[_stepsKey];
      if (ids != null) {
        for (final log in ctx.logs) {
          if (log.isPreInstall) continue;
          for (final id in ids) {
            final e = log.entryFor(id);
            if (e != null) cumulativeSteps += e.value.round();
          }
        }
      }
    }

    final statsAboveFifty = ctx.stats.scores.values.where((v) => v > 50).length;

    return {
      'first_blood': completedAny > 0 ? 1 : 0,
      'perfect_day': perfectDays > 0 ? 1 : 0,
      'streak_3': ctx.streak.bestStreak,
      'streak_7': ctx.streak.bestStreak,
      'streak_14': ctx.streak.bestStreak,
      'streak_30': ctx.streak.bestStreak,
      'streak_60': ctx.streak.bestStreak,
      'streak_100': ctx.streak.bestStreak,
      'perfect_arc': StreakEngine.isPerfectArc(ctx.streak, ctx.arcLengthDays)
          ? 1
          : 0,
      'ten_perfect_days': perfectDays,
      'early_riser_30': earlyWakes,
      'gym_50': gymSessions,
      'steps_500k': cumulativeSteps,
      'gratitude_100': gratitudeEntries,
      'clean_30': cleanDays,
      'hydrated_60': waterDays,
      'level_10': ctx.level,
      'level_25': ctx.level,
      'level_50': ctx.level,
      'balanced': statsAboveFifty,
      'phoenix': StreakEngine.hasComebackRun(ctx.streak) ? 1 : 0,
      'no_shields_30': ctx.streak.daysSinceShieldConsumed,
      'first_backup': ctx.hasBackup ? 1 : 0,
      'architect': ctx.hasCustomHabit ? 1 : 0,
    };
  }

  /// Reconciles evaluated progress against stored records.
  ///
  /// Unlock timestamps are sticky: once earned, an achievement stays earned
  /// even if the underlying number later drops (a streak resets, a habit is
  /// archived). Only the *unlock decision* is recomputed, never revoked.
  static List<AchievementRecord> reconcile({
    required Map<String, int> progress,
    required Map<String, AchievementRecord> existing,
    required int arcId,
    required DateTime now,
  }) {
    final out = <AchievementRecord>[];
    for (final def in catalogue) {
      final current = progress[def.id] ?? 0;
      final record =
          existing[def.id] ??
          AchievementRecord.create(key: def.id, progressTarget: def.target);
      record.progressTarget = def.target;
      if (current > record.progressCurrent) record.progressCurrent = current;
      if (record.unlockedAt == null && current >= def.target) {
        record.unlockedAt = now;
        record.arcId = arcId;
      }
      out.add(record);
    }
    return out;
  }

  /// Ids newly unlocked between two reconciliations - drives the celebration.
  static List<String> newlyUnlocked(
    Map<String, AchievementRecord> before,
    List<AchievementRecord> after,
  ) => [
    for (final r in after)
      if (r.isUnlocked && !(before[r.key]?.isUnlocked ?? false)) r.key,
  ];

  /// Recompute a whole arc's achievement state from logs - used after import
  /// and after a schema migration.
  static EvaluationContext contextFor({
    required List<DailyLog> logs,
    required Map<int, Habit> habitsById,
    required StreakResult streak,
    required StatSnapshot stats,
    required int totalXp,
    required int arcLengthDays,
    required int arcId,
    required bool hasBackup,
  }) => EvaluationContext(
    logs: logs,
    habitsById: habitsById,
    streak: streak,
    stats: stats,
    totalXp: totalXp,
    level: LevelEngine.levelForXp(totalXp),
    arcLengthDays: arcLengthDays,
    arcId: arcId,
    hasCustomHabit: habitsById.values.any((h) => h.isCustom),
    hasBackup: hasBackup,
  );

  /// Days on which an achievement could plausibly have unlocked - used only by
  /// the recap roll, which orders trophies by unlock date.
  static int compareByUnlock(AchievementRecord a, AchievementRecord b) {
    final ax = a.unlockedAt, bx = b.unlockedAt;
    if (ax == null && bx == null) return 0;
    if (ax == null) return 1;
    if (bx == null) return -1;
    return ax.compareTo(bx);
  }

  static String? dateKeyOf(DateTime? d) => d == null ? null : ArcDate.keyOf(d);
}
