import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/domain/engines/stat_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  final start = DateTime(2026, 10, 5); // a Monday
  DateTime day(int i) => start.add(Duration(days: i));

  group('normalisation', () {
    test('a perfectly consistent user shows a full pentagon', () {
      final habits = <int, Habit>{
        for (var i = 0; i < StatKeys.all.length; i++)
          i + 1: habit(id: i + 1, stat: StatKeys.all[i], xp: 10 + i * 5),
      };
      final ids = habits.keys.toList();

      final logs = [
        for (var d = 0; d < 7; d++)
          log(day(d), scheduled: ids, values: {for (final id in ids) id: 1.0}),
      ];

      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(6)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );

      for (final stat in StatKeys.all) {
        expect(snapshot[stat], closeTo(100, 1e-6), reason: stat);
      }
    });

    test('raw XP imbalance does not tilt the radar', () {
      // Vitality is worth 45 XP/day, Spirit only 15 - under raw XP the
      // pentagon would be permanently stretched. Both must read 100.
      final habits = <int, Habit>{
        1: habit(id: 1, stat: StatKeys.vitality, xp: 15),
        2: habit(id: 2, stat: StatKeys.vitality, xp: 15),
        3: habit(id: 3, stat: StatKeys.vitality, xp: 15),
        4: habit(id: 4, stat: StatKeys.spirit, xp: 15),
      };
      final logs = [
        for (var d = 0; d < 5; d++)
          log(
            day(d),
            scheduled: const [1, 2, 3, 4],
            values: const {1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0},
          ),
      ];

      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(4)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );
      expect(snapshot[StatKeys.vitality], closeTo(100, 1e-6));
      expect(snapshot[StatKeys.spirit], closeTo(100, 1e-6));
    });

    test('the denominator respects frequency', () {
      // A gym habit due only 4 days out of 7 contributes 4 days of Strength to
      // the denominator, not 7 - so completing all 4 reads as 100%.
      final habits = <int, Habit>{
        1: habit(
          id: 1,
          stat: StatKeys.strength,
          xp: 25,
          frequencyType: FrequencyTypes.weeklyTarget,
          frequencyValue: 4,
        ),
      };
      final logs = [
        for (var d = 0; d < 4; d++)
          log(day(d), scheduled: const [1], values: const {1: 1.0}),
        // Fri/Sat/Sun: quota met, so the habit is not in the day snapshot.
        for (var d = 4; d < 7; d++) log(day(d)),
      ];

      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(6)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );
      expect(snapshot[StatKeys.strength], closeTo(100, 1e-6));
    });

    test('partial completions contribute proportionally', () {
      final habits = <int, Habit>{
        1: habit(
          id: 1,
          stat: StatKeys.strength,
          xp: 20,
          unit: MetricUnits.steps,
          target: 10000,
        ),
      };
      final logs = [
        log(
          day(0),
          scheduled: const [1],
          values: const {1: 5000},
          targets: const {1: 10000},
        ),
      ];
      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(0)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );
      expect(snapshot[StatKeys.strength], closeTo(50, 1e-6));
    });

    test('scores are clamped to 0-100 and default to 0 with no data', () {
      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(6)),
        logsByKey: const {},
        habitsById: const {},
      );
      for (final stat in StatKeys.all) {
        expect(snapshot[stat], 0);
      }
    });

    test('pre-install days are excluded from both sides of the ratio', () {
      final habits = <int, Habit>{1: habit(id: 1, stat: StatKeys.focus)};
      final logs = [
        log(day(0), scheduled: const [1], preInstall: true),
        log(day(1), scheduled: const [1], values: const {1: 1.0}),
      ];
      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(1)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );
      expect(snapshot[StatKeys.focus], closeTo(100, 1e-6));
    });

    test('allAboveFifty backs the Well Rounded achievement', () {
      final habits = <int, Habit>{
        for (var i = 0; i < StatKeys.all.length; i++)
          i + 1: habit(id: i + 1, stat: StatKeys.all[i]),
      };
      final ids = habits.keys.toList();
      final logs = [
        for (var d = 0; d < 4; d++)
          log(
            day(d),
            scheduled: ids,
            values: d < 3 ? {for (final id in ids) id: 1.0} : const {},
          ),
      ];
      final snapshot = StatEngine.compute(
        days: ArcDate.daysInRange(start, day(3)),
        logsByKey: byKey(logs),
        habitsById: habits,
      );
      expect(snapshot.allAboveFifty, isTrue);
    });
  });

  group('progression', () {
    test('emits one cumulative point per elapsed day', () {
      final habits = <int, Habit>{1: habit(id: 1, stat: StatKeys.discipline)};
      final logs = [
        for (var d = 0; d < 5; d++)
          log(
            day(d),
            scheduled: const [1],
            values: d.isEven ? const {1: 1.0} : const {},
          ),
      ];
      final series = StatEngine.progression(
        days: ArcDate.daysInRange(start, day(4)),
        logsByKey: byKey(logs),
        habitsById: habits,
        upTo: day(4),
      );
      expect(series[StatKeys.discipline]!.length, 5);
      expect(series[StatKeys.discipline]!.first, 100);
      expect(series[StatKeys.discipline]!.last, closeTo(60, 1e-6));
    });
  });
}
