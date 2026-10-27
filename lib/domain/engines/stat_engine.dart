import '../../core/constants/app_constants.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';

/// gamification_engine.stat_normalization
///
/// Raw stat XP is structurally lopsided by the seed mapping - over a perfect
/// arc Vitality earns 6,710 and Spirit 1,830 - so plotting raw XP makes the
/// pentagon decorative rather than informative. The radar plots
///
///   statScore = earnedStatXp / maxPossibleStatXpForElapsedScheduledDays * 100
///
/// The denominator respects each habit's frequency: a 4x-per-week gym habit
/// contributes 4 days of Strength per week, not 7.
///
/// This is a view-layer projection. Raw XP is still stored on UserProfile.
class StatSnapshot {
  const StatSnapshot(this.scores, this.rawXp);

  /// Normalised 0-100 per StatKeys entry.
  final Map<String, double> scores;

  /// Raw awarded XP per stat over the same window.
  final Map<String, int> rawXp;

  double operator [](String stat) => scores[stat] ?? 0;

  bool get allAboveFifty => StatKeys.all.every((s) => (scores[s] ?? 0) > 50);

  static StatSnapshot get empty => StatSnapshot(
    {for (final s in StatKeys.all) s: 0.0},
    {for (final s in StatKeys.all) s: 0},
  );
}

abstract final class StatEngine {
  static StatSnapshot compute({
    required List<DateTime> days,
    required Map<String, DailyLog> logsByKey,
    required Map<int, Habit> habitsById,
    DateTime? upTo,
  }) {
    final earned = {for (final s in StatKeys.all) s: 0.0};
    final possible = {for (final s in StatKeys.all) s: 0.0};
    final raw = {for (final s in StatKeys.all) s: 0};

    final limit = upTo == null ? null : ArcDate.dayOnly(upTo);

    for (final day in days) {
      if (limit != null && day.isAfter(limit)) break;
      final log = logsByKey[ArcDate.keyOf(day)];
      if (log == null || log.isPreInstall) continue;

      for (final habitId in log.scheduledHabitIds) {
        final habit = habitsById[habitId];
        if (habit == null) continue;
        final stat = habit.statAttribute;
        if (!possible.containsKey(stat)) continue;

        final weight = habit.clampedXp.toDouble();
        possible[stat] = possible[stat]! + weight;

        final entry = log.entryFor(habitId);
        if (entry != null) {
          earned[stat] = earned[stat]! + entry.completionRatio * weight;
          raw[stat] = raw[stat]! + entry.awardedXp;
        }
      }
    }

    final scores = <String, double>{};
    for (final s in StatKeys.all) {
      final denom = possible[s]!;
      scores[s] = denom <= 0
          ? 0
          : ((earned[s]! / denom) * 100).clamp(0.0, 100.0);
    }
    return StatSnapshot(scores, raw);
  }

  /// Cumulative normalised score per day, for the stat progression line chart.
  static Map<String, List<double>> progression({
    required List<DateTime> days,
    required Map<String, DailyLog> logsByKey,
    required Map<int, Habit> habitsById,
    required DateTime upTo,
  }) {
    final earned = {for (final s in StatKeys.all) s: 0.0};
    final possible = {for (final s in StatKeys.all) s: 0.0};
    final series = {for (final s in StatKeys.all) s: <double>[]};
    final limit = ArcDate.dayOnly(upTo);

    for (final day in days) {
      if (day.isAfter(limit)) break;
      final log = logsByKey[ArcDate.keyOf(day)];
      if (log != null && !log.isPreInstall) {
        for (final habitId in log.scheduledHabitIds) {
          final habit = habitsById[habitId];
          if (habit == null) continue;
          final stat = habit.statAttribute;
          if (!possible.containsKey(stat)) continue;
          final weight = habit.clampedXp.toDouble();
          possible[stat] = possible[stat]! + weight;
          final entry = log.entryFor(habitId);
          if (entry != null) {
            earned[stat] = earned[stat]! + entry.completionRatio * weight;
          }
        }
      }
      for (final s in StatKeys.all) {
        final denom = possible[s]!;
        series[s]!.add(
          denom <= 0 ? 0 : ((earned[s]! / denom) * 100).clamp(0.0, 100.0),
        );
      }
    }
    return series;
  }
}
