import '../../core/constants/app_constants.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import 'stat_engine.dart';

class HeatmapDay {
  const HeatmapDay(this.date, this.ratio, this.intensity, this.counted);
  final DateTime date;
  final double ratio;

  /// 0-4, five buckets.
  final int intensity;
  final bool counted;
}

class WeeklyPoint {
  const WeeklyPoint(this.arcWeek, this.completed, this.scheduled);
  final int arcWeek;
  final int completed;
  final int scheduled;
  double get rate => scheduled == 0 ? 0 : completed / scheduled;
}

class WeekdayPoint {
  const WeekdayPoint(this.weekday, this.completed, this.scheduled);

  /// 1 = Monday .. 7 = Sunday
  final int weekday;
  final int completed;
  final int scheduled;
  double get rate => scheduled == 0 ? 0 : completed / scheduled;
}

class CorrelationInsight {
  const CorrelationInsight({
    required this.habitId,
    required this.ratio,
    required this.sampleDays,
  });
  final int habitId;
  final double ratio;
  final int sampleDays;
}

class HabitStat {
  const HabitStat(this.habitId, this.completed, this.scheduled);
  final int habitId;
  final int completed;
  final int scheduled;
  double get rate => scheduled == 0 ? 0 : completed / scheduled;
}

class ArcProjection {
  const ArcProjection({
    required this.currentRate,
    required this.linearProjection,
    required this.trendWeightedProjection,
    required this.elapsedDays,
  });
  final double currentRate;
  final double linearProjection;
  final double trendWeightedProjection;
  final int elapsedDays;
}

class AnalyticsReport {
  const AnalyticsReport({
    required this.hasEnoughData,
    required this.hasCorrelationData,
    required this.loggedDays,
    required this.completionRate,
    required this.heatmap,
    required this.weekly,
    required this.weekday,
    required this.statProgression,
    required this.correlations,
    required this.perHabit,
    required this.hourHistogram,
    required this.projection,
    required this.bestWeekday,
    required this.worstWeekday,
  });

  final bool hasEnoughData;
  final bool hasCorrelationData;
  final int loggedDays;
  final double completionRate;
  final List<HeatmapDay> heatmap;
  final List<WeeklyPoint> weekly;
  final List<WeekdayPoint> weekday;
  final Map<String, List<double>> statProgression;
  final List<CorrelationInsight> correlations;
  final List<HabitStat> perHabit;

  /// 24 buckets, index == local hour.
  final List<int> hourHistogram;
  final ArcProjection projection;
  final int? bestWeekday;
  final int? worstWeekday;

  static AnalyticsReport get empty => AnalyticsReport(
    hasEnoughData: false,
    hasCorrelationData: false,
    loggedDays: 0,
    completionRate: 0,
    heatmap: const [],
    weekly: const [],
    weekday: const [],
    statProgression: const {},
    correlations: const [],
    perHabit: const [],
    hourHistogram: List<int>.filled(24, 0),
    projection: const ArcProjection(
      currentRate: 0,
      linearProjection: 0,
      trendWeightedProjection: 0,
      elapsedDays: 0,
    ),
    bestWeekday: null,
    worstWeekday: null,
  );
}

/// core_features.analytics_lab
///
/// One indexed pass over the arc. 122 days x ~12 habits is ~1,500 embedded
/// objects - no pre-aggregation tables until the numbers demand it
/// (analytics_engine.revisit_threshold).
abstract final class AnalyticsEngine {
  /// analytics_engine.completion_rate_definition:
  /// completed_scheduled / total_scheduled, excluding pre-install days and
  /// not-scheduled cells. Getting this denominator right is what makes every
  /// downstream number trustworthy.
  static AnalyticsReport compute({
    required DateTime arcStart,
    required List<DateTime> arcDays,
    required Map<String, DailyLog> logsByKey,
    required Map<int, Habit> habitsById,
    required DateTime today,
    required int arcLengthDays,
  }) {
    final todayOnly = ArcDate.dayOnly(today);

    final heatmap = <HeatmapDay>[];
    final weeklyCompleted = <int, int>{};
    final weeklyScheduled = <int, int>{};
    final weekdayCompleted = <int, int>{};
    final weekdayScheduled = <int, int>{};
    final habitCompleted = <int, int>{};
    final habitScheduled = <int, int>{};
    final hours = List<int>.filled(24, 0);

    var totalCompleted = 0;
    var totalScheduled = 0;
    var loggedDays = 0;

    // Correlation bookkeeping: for each habit, the completion rate of *other*
    // habits on days it was done vs days it was not.
    final withHabitNum = <int, double>{};
    final withHabitDen = <int, int>{};
    final withoutHabitNum = <int, double>{};
    final withoutHabitDen = <int, int>{};

    for (final day in arcDays) {
      if (day.isAfter(todayOnly)) break;
      final log = logsByKey[ArcDate.keyOf(day)];

      if (log == null || log.isPreInstall || log.scheduledHabitIds.isEmpty) {
        heatmap.add(HeatmapDay(day, 0, 0, false));
        continue;
      }

      var dayCompleted = 0;
      final dayScheduled = log.scheduledHabitIds.length;

      for (final id in log.scheduledHabitIds) {
        final entry = log.entryFor(id);
        final done = entry?.isComplete ?? false;
        habitScheduled[id] = (habitScheduled[id] ?? 0) + 1;
        if (done) {
          dayCompleted++;
          habitCompleted[id] = (habitCompleted[id] ?? 0) + 1;
        }
      }

      for (final e in log.entries) {
        hours[e.loggedAt.toLocal().hour]++;
      }

      // Correlation: exclude habit A itself from the "other habits" rate.
      for (final id in log.scheduledHabitIds) {
        if (dayScheduled <= 1) continue;
        final otherRate =
            (dayCompleted - ((log.entryFor(id)?.isComplete ?? false) ? 1 : 0)) /
            (dayScheduled - 1);
        if (log.entryFor(id)?.isComplete ?? false) {
          withHabitNum[id] = (withHabitNum[id] ?? 0) + otherRate;
          withHabitDen[id] = (withHabitDen[id] ?? 0) + 1;
        } else {
          withoutHabitNum[id] = (withoutHabitNum[id] ?? 0) + otherRate;
          withoutHabitDen[id] = (withoutHabitDen[id] ?? 0) + 1;
        }
      }

      totalCompleted += dayCompleted;
      totalScheduled += dayScheduled;
      loggedDays++;

      final ratio = dayScheduled == 0 ? 0.0 : dayCompleted / dayScheduled;
      heatmap.add(HeatmapDay(day, ratio, _bucket(ratio), true));

      final week = ArcDate.arcWeekNumber(arcStart, day);
      weeklyCompleted[week] = (weeklyCompleted[week] ?? 0) + dayCompleted;
      weeklyScheduled[week] = (weeklyScheduled[week] ?? 0) + dayScheduled;

      weekdayCompleted[day.weekday] =
          (weekdayCompleted[day.weekday] ?? 0) + dayCompleted;
      weekdayScheduled[day.weekday] =
          (weekdayScheduled[day.weekday] ?? 0) + dayScheduled;
    }

    final weekly = (weeklyScheduled.keys.toList()..sort())
        .map(
          (w) =>
              WeeklyPoint(w, weeklyCompleted[w] ?? 0, weeklyScheduled[w] ?? 0),
        )
        .toList();

    final weekday = [
      for (var d = 1; d <= 7; d++)
        WeekdayPoint(d, weekdayCompleted[d] ?? 0, weekdayScheduled[d] ?? 0),
    ];

    int? best, worst;
    var bestRate = -1.0, worstRate = 2.0;
    for (final w in weekday) {
      if (w.scheduled == 0) continue;
      if (w.rate > bestRate) {
        bestRate = w.rate;
        best = w.weekday;
      }
      if (w.rate < worstRate) {
        worstRate = w.rate;
        worst = w.weekday;
      }
    }

    final correlations = <CorrelationInsight>[];
    for (final id in habitScheduled.keys) {
      final withDen = withHabitDen[id] ?? 0;
      final withoutDen = withoutHabitDen[id] ?? 0;
      final sample = withDen + withoutDen;
      if (sample < AppConstants.correlationMinDays) continue;
      if (withDen == 0 || withoutDen == 0) continue;
      final withMean = withHabitNum[id]! / withDen;
      final withoutMean = withoutHabitNum[id]! / withoutDen;
      if (withoutMean <= 0) continue;
      final ratio = withMean / withoutMean;
      if (ratio < AppConstants.correlationMinRatio) continue;
      correlations.add(
        CorrelationInsight(habitId: id, ratio: ratio, sampleDays: sample),
      );
    }
    correlations.sort((a, b) => b.ratio.compareTo(a.ratio));

    final perHabit =
        habitScheduled.keys
            .map(
              (id) => HabitStat(
                id,
                habitCompleted[id] ?? 0,
                habitScheduled[id] ?? 0,
              ),
            )
            .toList()
          ..sort((a, b) => b.rate.compareTo(a.rate));

    final rate = totalScheduled == 0 ? 0.0 : totalCompleted / totalScheduled;

    // Trend-weighted variant: the last 7 logged days count double, so a user
    // who has turned things around this week sees it reflected.
    final recent = heatmap.where((h) => h.counted).toList();
    final tail = recent.length <= 7
        ? recent
        : recent.sublist(recent.length - 7);
    final tailRate = tail.isEmpty
        ? rate
        : tail.map((h) => h.ratio).reduce((a, b) => a + b) / tail.length;
    final trendWeighted = (rate + tailRate * 2) / 3;

    return AnalyticsReport(
      hasEnoughData: loggedDays >= AppConstants.analyticsMinDays,
      hasCorrelationData: loggedDays >= AppConstants.correlationMinDays,
      loggedDays: loggedDays,
      completionRate: rate,
      heatmap: heatmap,
      weekly: weekly,
      weekday: weekday,
      statProgression: StatEngine.progression(
        days: arcDays,
        logsByKey: logsByKey,
        habitsById: habitsById,
        upTo: todayOnly,
      ),
      correlations: correlations,
      perHabit: perHabit,
      hourHistogram: hours,
      projection: ArcProjection(
        currentRate: rate,
        linearProjection: rate,
        trendWeightedProjection: trendWeighted.clamp(0.0, 1.0),
        elapsedDays: loggedDays,
      ),
      bestWeekday: best,
      worstWeekday: worst,
    );
  }

  /// 5 intensity levels driven by daily completion ratio.
  static int _bucket(double ratio) {
    if (ratio <= 0) return 0;
    if (ratio < 0.25) return 1;
    if (ratio < 0.5) return 2;
    if (ratio < 0.85) return 3;
    return 4;
  }
}
