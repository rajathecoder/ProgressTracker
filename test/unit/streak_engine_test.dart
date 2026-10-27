import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/app_settings.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/domain/engines/streak_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  final start = DateTime(2026, 9, 1);
  DateTime day(int i) => start.add(Duration(days: i));

  const normal = AppSettings();
  const hardcore = AppSettings(hardcoreMode: true);

  StreakResult run(
    List<DailyLog> logs,
    int throughDay, {
    AppSettings settings = normal,
    Map<int, dynamic>? habits,
  }) {
    final h = habits ?? {1: habit(id: 1)};
    return StreakEngine.compute(
      arcDays: ArcDate.daysInRange(start, day(throughDay)),
      logsByKey: byKey(logs),
      habitsById: h.map((k, v) => MapEntry(k, v as dynamic)),
      settings: settings,
      today: day(throughDay),
    );
  }

  List<DailyLog> perfectRun(int days, {Set<int> skip = const {}}) => [
    for (var i = 0; i < days; i++)
      log(
        day(i),
        scheduled: const [1],
        values: skip.contains(i) ? const {} : const {1: 1.0},
      ),
  ];

  group('basic streak', () {
    test('counts consecutive fully-completed days', () {
      final r = run(perfectRun(5), 4);
      expect(r.currentStreak, 5);
      expect(r.bestStreak, 5);
      expect(r.perfectDays, 5);
    });

    test('today is not a miss until it is over', () {
      // Day 5 is "today" and is untouched - the streak must survive.
      final logs = [
        ...perfectRun(5),
        log(day(5), scheduled: const [1]),
      ];
      final r = run(logs, 5);
      expect(r.currentStreak, 5);
      expect(r.days.last.neutral, isTrue);
    });

    test('a day with nothing scheduled is neutral, not a break', () {
      final logs = [
        ...perfectRun(3),
        log(day(3)), // no scheduled habits at all
        log(day(4), scheduled: const [1], values: const {1: 1.0}),
      ];
      final r = run(logs, 4);
      expect(r.currentStreak, 4);
    });

    test('pre-install days are neutral', () {
      final logs = [
        log(day(0), scheduled: const [1], preInstall: true),
        log(day(1), scheduled: const [1], preInstall: true),
        ...[
          for (var i = 2; i < 5; i++)
            log(day(i), scheduled: const [1], values: const {1: 1.0}),
        ],
      ];
      final r = run(logs, 4);
      expect(r.currentStreak, 3);
      expect(r.days.where((d) => d.brokeStreak), isEmpty);
    });
  });

  group('shields', () {
    test('one shield is earned per 7 consecutive days, capped at 3', () {
      expect(run(perfectRun(7), 6).shieldsHeld, 1);
      expect(run(perfectRun(14), 13).shieldsHeld, 2);
      expect(run(perfectRun(21), 20).shieldsHeld, 3);
      expect(
        run(perfectRun(35), 34).shieldsHeld,
        AppConstants.maxShields,
        reason: 'capped at 3',
      );
    });

    test('a miss spends a shield instead of resetting the streak', () {
      // 7 perfect days earn a shield, day 8 is missed, day 9 continues.
      final logs = [
        ...perfectRun(9, skip: {7}),
      ];
      final r = run(logs, 8);
      expect(r.shieldsConsumedTotal, 1);
      expect(r.shieldsHeld, 0);
      expect(r.currentStreak, greaterThan(0), reason: 'the streak survived');
      expect(r.days[7].shieldConsumed, isTrue);
      expect(r.days[7].brokeStreak, isFalse);
    });

    test('with no shield left, a past miss breaks the streak', () {
      // Only 3 days of streak, so no shield has been earned yet. Day 3 is a
      // miss in the past (day 4 is today), so it must break rather than be
      // absorbed.
      final r = run(perfectRun(5, skip: {3}), 4);
      expect(r.shieldsHeld, 0);
      expect(r.days[3].brokeStreak, isTrue);
      expect(r.bestStreak, 3);
      expect(r.currentStreak, 1, reason: 'day 4 restarted the count');
    });

    test('Hardcore Mode disables shields entirely', () {
      final logs = perfectRun(9, skip: {7});
      final r = run(logs, 8, settings: hardcore);
      expect(r.shieldsHeld, 0);
      expect(r.shieldsConsumedTotal, 0);
      expect(r.days[7].brokeStreak, isTrue);
      expect(r.currentStreak, 1, reason: 'day 8 restarted the count');
    });
  });

  group('multiplier', () {
    test('tracks the current streak', () {
      expect(run(perfectRun(3), 2).multiplier, 1.0);
      expect(run(perfectRun(7), 6).multiplier, 1.1);
      expect(run(perfectRun(14), 13).multiplier, 1.2);
      expect(run(perfectRun(30), 29).multiplier, 1.35);
    });
  });

  group('weekly_target habits are judged by week, not by day', () {
    final gym = habit(
      id: 2,
      frequencyType: FrequencyTypes.weeklyTarget,
      frequencyValue: 2,
    );

    test('a rest day inside a satisfied week does not break the streak', () {
      // 2026-09-01 is a Tuesday; the ISO week runs Mon 08-31 .. Sun 09-06.
      // Gym is scheduled every day but only completed twice - the quota.
      final logs = [
        for (var i = 0; i < 6; i++)
          log(
            day(i),
            scheduled: const [2],
            values: (i == 0 || i == 1) ? const {2: 1.0} : const {},
          ),
      ];
      final r = run(logs, 5, habits: {2: gym});
      expect(
        r.days.every((d) => !d.brokeStreak),
        isTrue,
        reason: 'daily satisfaction ignores weekly_target habits',
      );
    });
  });

  group('derived flags', () {
    test('hasComebackRun detects the Phoenix Protocol', () {
      // Break on day 3, then 7 straight.
      final logs = [
        ...perfectRun(3),
        log(day(3), scheduled: const [1]),
        for (var i = 4; i < 11; i++)
          log(day(i), scheduled: const [1], values: const {1: 1.0}),
      ];
      final r = run(logs, 10, settings: hardcore);
      expect(StreakEngine.hasComebackRun(r), isTrue);
    });

    test('isPerfectArc requires every counted day satisfied', () {
      final r = run(perfectRun(10), 9);
      expect(StreakEngine.isPerfectArc(r, 10), isTrue);

      final broken = run(perfectRun(10, skip: {4}), 9, settings: hardcore);
      expect(StreakEngine.isPerfectArc(broken, 10), isFalse);
    });

    test('daysSinceShieldConsumed counts back to the last spend', () {
      final logs = perfectRun(12, skip: {7});
      final r = run(logs, 11);
      expect(r.lastShieldConsumedKey, ArcDate.keyOf(day(7)));
      expect(r.daysSinceShieldConsumed, 4);
    });
  });
}
