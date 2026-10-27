import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/domain/engines/analytics_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  final start = DateTime(2026, 9, 1);
  DateTime day(int i) => start.add(Duration(days: i));

  AnalyticsReport compute(List logs, Map<int, Habit> habits, int through) =>
      AnalyticsEngine.compute(
        arcStart: start,
        arcDays: ArcDate.daysInRange(start, day(through)),
        logsByKey: byKey(logs.cast()),
        habitsById: habits,
        today: day(through),
        arcLengthDays: 122,
      );

  test('gates every insight until 7 days of data exist', () {
    final h = {1: habit(id: 1)};
    final report = compute(
      [
        for (var i = 0; i < 6; i++)
          log(day(i), scheduled: const [1], values: const {1: 1.0}),
      ],
      h,
      5,
    );
    expect(report.hasEnoughData, isFalse);
    expect(AppConstants.analyticsMinDays, 7);

    final ok = compute(
      [
        for (var i = 0; i < 7; i++)
          log(day(i), scheduled: const [1], values: const {1: 1.0}),
      ],
      h,
      6,
    );
    expect(ok.hasEnoughData, isTrue);
  });

  test('correlation cards need 14 days', () {
    final h = {1: habit(id: 1), 2: habit(id: 2)};
    final report = compute(
      [
        for (var i = 0; i < 10; i++)
          log(day(i), scheduled: const [1, 2], values: const {1: 1.0}),
      ],
      h,
      9,
    );
    expect(report.hasCorrelationData, isFalse);
    expect(AppConstants.correlationMinDays, 14);
  });

  test('completion rate excludes pre-install and unscheduled cells', () {
    final h = {1: habit(id: 1), 2: habit(id: 2)};
    final logs = [
      log(day(0), scheduled: const [1, 2], preInstall: true),
      // Only habit 1 was due; habit 2 must not count against the rate.
      log(day(1), scheduled: const [1], values: const {1: 1.0}),
      log(day(2), scheduled: const [1, 2], values: const {1: 1.0}),
      for (var i = 3; i < 8; i++)
        log(day(i), scheduled: const [1], values: const {1: 1.0}),
    ];
    final report = compute(logs, h, 7);
    // Scheduled: 1 + 2 + 5 = 8. Completed: 1 + 1 + 5 = 7.
    expect(report.completionRate, closeTo(7 / 8, 1e-9));
    expect(report.loggedDays, 7, reason: 'the pre-install day is excluded');
  });

  test('heatmap buckets the daily ratio into five levels', () {
    final h = {
      1: habit(id: 1),
      2: habit(id: 2),
      3: habit(id: 3),
      4: habit(id: 4),
    };
    final logs = [
      log(day(0), scheduled: const [1, 2, 3, 4]),
      log(day(1), scheduled: const [1, 2, 3, 4], values: const {1: 1.0}),
      log(
        day(2),
        scheduled: const [1, 2, 3, 4],
        values: const {1: 1.0, 2: 1.0},
      ),
      log(
        day(3),
        scheduled: const [1, 2, 3, 4],
        values: const {1: 1.0, 2: 1.0, 3: 1.0},
      ),
      log(
        day(4),
        scheduled: const [1, 2, 3, 4],
        values: const {1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0},
      ),
      for (var i = 5; i < 8; i++) log(day(i), scheduled: const [1]),
    ];
    final report = compute(logs, h, 7);
    expect(report.heatmap[0].intensity, 0);
    expect(report.heatmap[1].intensity, 2); // 0.25
    expect(report.heatmap[2].intensity, 3); // 0.50
    expect(report.heatmap[3].intensity, 3); // 0.75
    expect(report.heatmap[4].intensity, 4); // 1.00
  });

  test('weekday breakdown surfaces the best and worst day', () {
    final h = {1: habit(id: 1)};
    // 2026-09-01 is a Tuesday. Complete every day except Thursdays.
    final logs = [
      for (var i = 0; i < 14; i++)
        log(
          day(i),
          scheduled: const [1],
          values: day(i).weekday == DateTime.thursday
              ? const {}
              : const {1: 1.0},
        ),
    ];
    final report = compute(logs, h, 13);
    expect(report.worstWeekday, DateTime.thursday);
    expect(report.bestWeekday, isNotNull);
    expect(report.weekday.length, 7);
  });

  test('time-of-day histogram has one bucket per hour', () {
    final h = {1: habit(id: 1)};
    final logs = [
      for (var i = 0; i < 8; i++)
        log(day(i), scheduled: const [1], values: const {1: 1.0}),
    ];
    final report = compute(logs, h, 7);
    expect(report.hourHistogram.length, 24);
    expect(report.hourHistogram.reduce((a, b) => a + b), 8);
  });

  test('weekly consistency groups by arc week', () {
    final h = {1: habit(id: 1)};
    final logs = [
      for (var i = 0; i < 14; i++)
        log(
          day(i),
          scheduled: const [1],
          values: i < 7 ? const {1: 1.0} : const {},
        ),
    ];
    final report = compute(logs, h, 13);
    expect(report.weekly.first.arcWeek, 1);
    expect(report.weekly.first.rate, 1.0);
    expect(report.weekly[1].rate, 0.0);
  });

  test('per-habit stats rank by completion rate', () {
    final h = {1: habit(id: 1), 2: habit(id: 2)};
    final logs = [
      for (var i = 0; i < 8; i++)
        log(
          day(i),
          scheduled: const [1, 2],
          values: i.isEven ? const {1: 1.0, 2: 1.0} : const {1: 1.0},
        ),
    ];
    final report = compute(logs, h, 7);
    expect(report.perHabit.first.habitId, 1);
    expect(report.perHabit.first.rate, 1.0);
    expect(report.perHabit.last.habitId, 2);
  });

  test('correlations only surface above the ratio and sample guards', () {
    final h = {1: habit(id: 1), 2: habit(id: 2), 3: habit(id: 3)};
    // Habit 1 is the "keystone": on days it is done, everything else is done.
    final logs = [
      for (var i = 0; i < 20; i++)
        log(
          day(i),
          scheduled: const [1, 2, 3],
          values: i.isEven ? const {1: 1.0, 2: 1.0, 3: 1.0} : const {2: 1.0},
        ),
    ];
    final report = compute(logs, h, 19);
    expect(report.hasCorrelationData, isTrue);
    final keystone = report.correlations.where((c) => c.habitId == 1);
    expect(keystone, isNotEmpty);
    expect(
      keystone.first.ratio,
      greaterThanOrEqualTo(AppConstants.correlationMinRatio),
    );
  });

  test('projection blends the overall rate with the last 7 days', () {
    final h = {1: habit(id: 1)};
    // Bad first week, perfect second week - the trend-weighted number must be
    // higher than the flat rate.
    final logs = [
      for (var i = 0; i < 14; i++)
        log(
          day(i),
          scheduled: const [1],
          values: i < 7 ? const {} : const {1: 1.0},
        ),
    ];
    final report = compute(logs, h, 13);
    expect(report.projection.linearProjection, closeTo(0.5, 1e-9));
    expect(
      report.projection.trendWeightedProjection,
      greaterThan(report.projection.linearProjection),
    );
  });
}
