import 'package:flutter/foundation.dart';

import '../core/utils/arc_date.dart';
import '../data/models/achievement.dart';
import '../data/models/app_settings.dart';
import '../data/models/arc.dart';
import '../data/models/daily_log.dart';
import '../data/models/habit.dart';
import '../data/models/user_profile.dart';
import 'engines/level_engine.dart';
import 'engines/stat_engine.dart';
import 'engines/streak_engine.dart';

/// Progress toward the active boss week's target.
@immutable
class BossWeekProgress {
  const BossWeekProgress({
    required this.week,
    required this.completed,
    required this.required_,
    required this.earned,
  });

  final BossWeek week;
  final int completed;
  final int required_;
  final bool earned;

  double get ratio =>
      required_ == 0 ? 0 : (completed / required_).clamp(0.0, 1.0);
}

/// The single derived view of the arc that every screen reads.
///
/// Everything here is recomputed from logs. Nothing is trusted from storage,
/// which is what makes "recompute achievements and levels after import rather
/// than trusting imported derived state" true by construction.
@immutable
class ArcState {
  const ArcState({
    required this.profile,
    required this.arc,
    required this.settings,
    required this.habits,
    required this.logsByKey,
    required this.arcDays,
    required this.streak,
    required this.stats,
    required this.achievements,
    required this.today,
    required this.bossWeek,
  });

  final UserProfile profile;
  final Arc arc;
  final AppSettings settings;

  /// Sorted, includes archived (filter at the call site).
  final List<Habit> habits;
  final Map<String, DailyLog> logsByKey;
  final List<DateTime> arcDays;

  final StreakResult streak;
  final StatSnapshot stats;
  final List<AchievementRecord> achievements;

  /// The effective "today" - already resolved through the rollover hour.
  final DateTime today;

  final BossWeekProgress? bossWeek;

  List<Habit> get activeHabits =>
      habits.where((h) => !h.isArchived).toList(growable: false);

  Map<int, Habit> get habitsById => {for (final h in habits) h.id: h};

  String get todayKey => ArcDate.keyOf(today);

  DailyLog? get todayLog => logsByKey[todayKey];

  /// 1-based; clamped into the arc so a pre-start or post-end day still reads
  /// sensibly in the banner.
  int get arcDayNumber =>
      ArcDate.arcDayNumber(arc.startDate, today).clamp(1, arc.lengthDays);

  bool get arcNotStarted => today.isBefore(ArcDate.dayOnly(arc.startDate));

  bool get arcComplete =>
      today.isAfter(ArcDate.dayOnly(arc.endDate)) ||
      arc.status == ArcStatus.completed;

  int get daysUntilStart => ArcDate.daysBetween(today, arc.startDate);

  List<Habit> scheduledToday() {
    final ids = todayLog?.scheduledHabitIds ?? const <int>[];
    final byId = habitsById;
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!,
    ];
  }

  int get todayCompleted {
    final log = todayLog;
    if (log == null) return 0;
    var n = 0;
    for (final id in log.scheduledHabitIds) {
      if (log.entryFor(id)?.isComplete ?? false) n++;
    }
    return n;
  }

  int get todayScheduledCount => todayLog?.scheduledHabitIds.length ?? 0;

  double get todayRatio =>
      todayScheduledCount == 0 ? 0 : todayCompleted / todayScheduledCount;

  int get level => LevelEngine.levelForXp(profile.totalXp);
  double get levelProgress => LevelEngine.levelProgress(profile.totalXp);
  int get xpIntoLevel => LevelEngine.xpIntoLevel(profile.totalXp);
  int get xpForLevel => LevelEngine.xpToNextLevel(level);
  String get rankKey => LevelEngine.rankKeyForLevel(level);
  double get multiplier => streak.multiplier;

  /// Completion rate over the whole arc so far, using the honest denominator.
  double get completionRate {
    var completed = 0, scheduled = 0;
    for (final log in logsByKey.values) {
      if (log.isPreInstall) continue;
      scheduled += log.scheduledHabitIds.length;
      for (final id in log.scheduledHabitIds) {
        if (log.entryFor(id)?.isComplete ?? false) completed++;
      }
    }
    return scheduled == 0 ? 0 : completed / scheduled;
  }

  Map<String, AchievementRecord> get achievementsByKey => {
    for (final a in achievements) a.key: a,
  };

  int get unlockedAchievementCount =>
      achievements.where((a) => a.isUnlocked).length;

  /// Is [day] inside the retroactive logging window?
  /// Hardcore Mode collapses the window to zero.
  bool canLog(DateTime day) {
    final d = ArcDate.dayOnly(day);
    if (d.isAfter(today)) return false;
    if (d.isBefore(ArcDate.dayOnly(arc.startDate))) return false;
    final back = ArcDate.daysBetween(d, today);
    return back <= settings.effectiveRetroDays;
  }
}
