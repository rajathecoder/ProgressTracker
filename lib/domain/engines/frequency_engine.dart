import '../../core/constants/app_constants.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';

/// core_features.frequency_engine
///
/// The fix for "Gym 4-5 days a week". Under a daily boolean model three rest
/// days a week read as a 57% completion rate and a permanently broken streak.
/// A habit that is not due on a day is not a failure on that day - it is not
/// scheduled, and it leaves both the numerator and the denominator alone.
abstract final class FrequencyEngine {
  /// Is [habit] due on [day]?
  ///
  /// [weekCompletions] is how many times the habit has already been completed
  /// in the ISO week containing [day], counting days strictly *before* [day].
  /// It only matters for weekly_target.
  static bool isScheduled(
    Habit habit,
    DateTime day, {
    int weekCompletionsBefore = 0,
  }) {
    if (habit.isArchived) {
      // An archived habit never appears on a future day, but historical logs
      // keep it in their scheduled snapshot
      // (edge_case_handling.habit_archived_mid_arc).
      final archivedAt = habit.archivedAt;
      if (archivedAt == null ||
          !ArcDate.dayOnly(day).isBefore(ArcDate.dayOnly(archivedAt))) {
        return false;
      }
    }
    if (ArcDate.dayOnly(day).isBefore(ArcDate.dayOnly(habit.createdAt))) {
      return false;
    }

    switch (habit.frequencyType) {
      case FrequencyTypes.daily:
        return true;

      case FrequencyTypes.specificDays:
        return habit.activeWeekdays.contains(day.weekday);

      case FrequencyTypes.interval:
        final n = habit.frequencyValue <= 0 ? 1 : habit.frequencyValue;
        final delta = ArcDate.daysBetween(habit.createdAt, day);
        return delta >= 0 && delta % n == 0;

      case FrequencyTypes.weeklyTarget:
        // A weekly-target habit stays "due" until the week's quota is met.
        // Once you have hit 4 of 4 gym sessions, Friday is a rest day and the
        // matrix renders it not-scheduled rather than missed.
        final target = habit.frequencyValue <= 0 ? 1 : habit.frequencyValue;
        if (weekCompletionsBefore >= target) return false;
        // Guard: never demand more sessions than days left in the week.
        final daysLeftInWeek = 7 - (day.weekday - DateTime.monday);
        final remaining = target - weekCompletionsBefore;
        return remaining <= daysLeftInWeek;

      default:
        return true;
    }
  }

  /// The habits actually due on [day], given the logs for that day's ISO week.
  ///
  /// The result is what gets frozen into DailyLog.scheduledHabitIds - the
  /// denominator every downstream rate depends on.
  static List<Habit> scheduledFor(
    DateTime day,
    List<Habit> habits,
    Map<String, DailyLog> weekLogsByKey,
  ) {
    final out = <Habit>[];
    for (final h in habits) {
      final before = h.frequencyType == FrequencyTypes.weeklyTarget
          ? weekCompletionsBefore(h, day, weekLogsByKey)
          : 0;
      if (isScheduled(h, day, weekCompletionsBefore: before)) out.add(h);
    }
    return out;
  }

  /// Completions of [habit] earlier in the same ISO week as [day].
  static int weekCompletionsBefore(
    Habit habit,
    DateTime day,
    Map<String, DailyLog> weekLogsByKey,
  ) {
    final monday = ArcDate.startOfIsoWeek(day);
    var count = 0;
    for (
      var d = monday;
      d.isBefore(ArcDate.dayOnly(day));
      d = d.add(const Duration(days: 1))
    ) {
      final log = weekLogsByKey[ArcDate.keyOf(d)];
      final entry = log?.entryFor(habit.id);
      if (entry != null && entry.isComplete) count++;
    }
    return count;
  }

  /// A weekly_target habit's streak unit is the *week*, not the day
  /// (frequency_types.weekly_target).
  static bool weekSatisfied(
    Habit habit,
    DateTime anyDayInWeek,
    Map<String, DailyLog> weekLogsByKey,
  ) {
    if (habit.frequencyType != FrequencyTypes.weeklyTarget) return true;
    final monday = ArcDate.startOfIsoWeek(anyDayInWeek);
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final log = weekLogsByKey[ArcDate.keyOf(monday.add(Duration(days: i)))];
      final entry = log?.entryFor(habit.id);
      if (entry != null && entry.isComplete) count++;
    }
    return count >= habit.frequencyValue;
  }
}
