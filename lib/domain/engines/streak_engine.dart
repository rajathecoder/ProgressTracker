import '../../core/constants/app_constants.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import 'level_engine.dart';

/// One evaluated day in the streak walk.
class StreakDay {
  const StreakDay({
    required this.date,
    required this.dateKey,
    required this.scheduledCount,
    required this.completedCount,
    required this.satisfied,
    required this.neutral,
    required this.shieldConsumed,
    required this.brokeStreak,
    required this.streakAfter,
  });

  final DateTime date;
  final String dateKey;
  final int scheduledCount;
  final int completedCount;

  /// Every scheduled habit complete.
  final bool satisfied;

  /// Pre-install, nothing scheduled, or still in progress - carries the streak
  /// without extending it.
  final bool neutral;

  final bool shieldConsumed;
  final bool brokeStreak;
  final int streakAfter;

  double get ratio => scheduledCount == 0 ? 0 : completedCount / scheduledCount;
}

/// The full recomputed streak state. Everything here is derived - none of it is
/// trusted from storage, so an imported backup produces identical numbers
/// (data_integrity.restore.guards).
class StreakResult {
  const StreakResult({
    required this.currentStreak,
    required this.bestStreak,
    required this.shieldsHeld,
    required this.shieldsConsumedTotal,
    required this.perfectDays,
    required this.multiplier,
    required this.days,
    required this.lastShieldConsumedKey,
    required this.daysSinceShieldConsumed,
  });

  final int currentStreak;
  final int bestStreak;
  final int shieldsHeld;
  final int shieldsConsumedTotal;
  final int perfectDays;
  final double multiplier;
  final List<StreakDay> days;
  final String? lastShieldConsumedKey;
  final int daysSinceShieldConsumed;

  static const empty = StreakResult(
    currentStreak: 0,
    bestStreak: 0,
    shieldsHeld: 0,
    shieldsConsumedTotal: 0,
    perfectDays: 0,
    multiplier: 1.0,
    days: [],
    lastShieldConsumedKey: null,
    daysSinceShieldConsumed: 0,
  );
}

/// core_features.streak_resilience
///
/// Positive reinforcement, not punishment. A hard reset on day 41 is the single
/// most common reason people delete habit trackers, so a miss spends a shield
/// first and only breaks the streak when there is nothing left to spend. No XP
/// is ever removed (gamification_engine.penalty_policy).
abstract final class StreakEngine {
  static StreakResult compute({
    required List<DateTime> arcDays,
    required Map<String, DailyLog> logsByKey,
    required Map<int, Habit> habitsById,
    required AppSettings settings,
    required DateTime today,
  }) {
    var streak = 0;
    var best = 0;
    var shields = 0;
    var consumed = 0;
    var perfect = 0;
    String? lastShieldKey;
    final days = <StreakDay>[];

    final todayOnly = ArcDate.dayOnly(today);

    for (final day in arcDays) {
      if (day.isAfter(todayOnly)) break;

      final key = ArcDate.keyOf(day);
      final log = logsByKey[key];
      final isToday = ArcDate.isSameDay(day, todayOnly);

      // Daily satisfaction deliberately ignores weekly_target habits: the
      // spec's frequency engine says their streak unit is the week, not the
      // day ("Streak counts weeks satisfied, not days"). They are checked once
      // per week, on the last day of the ISO week, below.
      final scheduled = [
        for (final id in log?.scheduledHabitIds ?? const <int>[])
          if (habitsById[id]?.frequencyType != FrequencyTypes.weeklyTarget) id,
      ];
      final scheduledCount = scheduled.length;
      var completed = 0;
      for (final id in scheduled) {
        final e = log?.entryFor(id);
        if (e != null && e.isComplete) completed++;
      }

      // Sunday closes the ISO week: any weekly_target habit that missed its
      // quota turns the day into a miss, which a shield can still absorb.
      final weekFailed =
          day.weekday == DateTime.sunday &&
          _weeklyTargetsFailed(day, logsByKey, habitsById);

      final preInstall = log?.isPreInstall ?? false;
      final satisfied =
          !weekFailed && scheduledCount > 0 && completed == scheduledCount;

      if (preInstall || (scheduledCount == 0 && !weekFailed)) {
        days.add(
          StreakDay(
            date: day,
            dateKey: key,
            scheduledCount: scheduledCount,
            completedCount: completed,
            satisfied: false,
            neutral: true,
            shieldConsumed: false,
            brokeStreak: false,
            streakAfter: streak,
          ),
        );
        continue;
      }

      if (satisfied) {
        streak++;
        perfect++;
        if (streak > best) best = streak;
        // 1 shield per 7 consecutive fully-completed days, capped at 3.
        if (settings.shieldsEnabled &&
            streak % AppConstants.shieldEarnStreakDays == 0 &&
            shields < AppConstants.maxShields) {
          shields++;
        }
        days.add(
          StreakDay(
            date: day,
            dateKey: key,
            scheduledCount: scheduledCount,
            completedCount: completed,
            satisfied: true,
            neutral: false,
            shieldConsumed: false,
            brokeStreak: false,
            streakAfter: streak,
          ),
        );
        continue;
      }

      // Today is not a miss until it is over.
      if (isToday) {
        days.add(
          StreakDay(
            date: day,
            dateKey: key,
            scheduledCount: scheduledCount,
            completedCount: completed,
            satisfied: false,
            neutral: true,
            shieldConsumed: false,
            brokeStreak: false,
            streakAfter: streak,
          ),
        );
        continue;
      }

      // A real miss. Spend a shield if one is held.
      if (settings.shieldsEnabled && shields > 0) {
        shields--;
        consumed++;
        lastShieldKey = key;
        days.add(
          StreakDay(
            date: day,
            dateKey: key,
            scheduledCount: scheduledCount,
            completedCount: completed,
            satisfied: false,
            neutral: false,
            shieldConsumed: true,
            brokeStreak: false,
            streakAfter: streak,
          ),
        );
        continue;
      }

      if (streak > best) best = streak;
      streak = 0;
      days.add(
        StreakDay(
          date: day,
          dateKey: key,
          scheduledCount: scheduledCount,
          completedCount: completed,
          satisfied: false,
          neutral: false,
          shieldConsumed: false,
          brokeStreak: true,
          streakAfter: 0,
        ),
      );
    }

    if (streak > best) best = streak;

    var sinceShield = 0;
    for (final d in days.reversed) {
      if (d.neutral) continue;
      if (d.shieldConsumed) break;
      sinceShield++;
    }

    return StreakResult(
      currentStreak: streak,
      bestStreak: best,
      shieldsHeld: shields,
      shieldsConsumedTotal: consumed,
      perfectDays: perfect,
      multiplier: MultiplierEngine.forStreak(streak),
      days: days,
      lastShieldConsumedKey: lastShieldKey,
      daysSinceShieldConsumed: sinceShield,
    );
  }

  /// True when at least one weekly_target habit due in [day]'s ISO week ended
  /// the week short of its quota.
  static bool _weeklyTargetsFailed(
    DateTime day,
    Map<String, DailyLog> logsByKey,
    Map<int, Habit> habitsById,
  ) {
    final monday = ArcDate.startOfIsoWeek(day);
    final weekly = habitsById.values.where(
      (h) => h.frequencyType == FrequencyTypes.weeklyTarget,
    );
    for (final habit in weekly) {
      var scheduledThisWeek = false;
      var completions = 0;
      for (var i = 0; i < 7; i++) {
        final d = monday.add(Duration(days: i));
        final log = logsByKey[ArcDate.keyOf(d)];
        if (log == null || log.isPreInstall) continue;
        if (log.scheduledHabitIds.contains(habit.id)) scheduledThisWeek = true;
        final e = log.entryFor(habit.id);
        if (e != null && e.isComplete) completions++;
      }
      if (scheduledThisWeek && completions < habit.frequencyValue) return true;
    }
    return false;
  }

  /// The longest run of consecutive satisfied days that begins immediately
  /// after a broken day - the Phoenix Protocol condition.
  static bool hasComebackRun(StreakResult result, {int length = 7}) {
    final days = result.days.where((d) => !d.neutral).toList();
    for (var i = 0; i < days.length; i++) {
      if (!days[i].brokeStreak) continue;
      var run = 0;
      for (var j = i + 1; j < days.length; j++) {
        if (days[j].satisfied) {
          run++;
          if (run >= length) return true;
        } else {
          break;
        }
      }
    }
    return false;
  }

  /// perfect_arc: every day of the arc satisfied, with no unshielded miss.
  static bool isPerfectArc(StreakResult result, int arcLengthDays) {
    final counted = result.days.where((d) => !d.neutral).toList();
    if (counted.length < arcLengthDays) return false;
    return !counted.any((d) => d.brokeStreak);
  }
}
