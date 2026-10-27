import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/domain/engines/frequency_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  // 2026-10-05 is a Monday.
  final monday = DateTime(2026, 10, 5);
  DateTime day(int offset) => monday.add(Duration(days: offset));

  group('daily', () {
    test('is scheduled on every day', () {
      final h = habit();
      for (var i = 0; i < 7; i++) {
        expect(FrequencyEngine.isScheduled(h, day(i)), isTrue);
      }
    });

    test('is never scheduled before its creation date', () {
      final h = habit(createdAt: day(3));
      expect(FrequencyEngine.isScheduled(h, day(2)), isFalse);
      expect(FrequencyEngine.isScheduled(h, day(3)), isTrue);
    });
  });

  group('specific_days', () {
    final h = habit(
      frequencyType: FrequencyTypes.specificDays,
      weekdays: const [1, 3, 5],
    );

    test('applies only on the listed weekdays', () {
      expect(FrequencyEngine.isScheduled(h, day(0)), isTrue); // Mon
      expect(FrequencyEngine.isScheduled(h, day(1)), isFalse); // Tue
      expect(FrequencyEngine.isScheduled(h, day(2)), isTrue); // Wed
      expect(FrequencyEngine.isScheduled(h, day(3)), isFalse); // Thu
      expect(FrequencyEngine.isScheduled(h, day(4)), isTrue); // Fri
      expect(FrequencyEngine.isScheduled(h, day(5)), isFalse); // Sat
      expect(FrequencyEngine.isScheduled(h, day(6)), isFalse); // Sun
    });
  });

  group('interval', () {
    test('applies every N days from the habit start date', () {
      final h = habit(
        frequencyType: FrequencyTypes.interval,
        frequencyValue: 3,
        createdAt: monday,
      );
      expect(FrequencyEngine.isScheduled(h, day(0)), isTrue);
      expect(FrequencyEngine.isScheduled(h, day(1)), isFalse);
      expect(FrequencyEngine.isScheduled(h, day(2)), isFalse);
      expect(FrequencyEngine.isScheduled(h, day(3)), isTrue);
      expect(FrequencyEngine.isScheduled(h, day(6)), isTrue);
    });
  });

  group('weekly_target - the Gym 4-5 days a week fix', () {
    final gym = habit(
      titleKey: 'habitGymWorkout',
      frequencyType: FrequencyTypes.weeklyTarget,
      frequencyValue: 4,
      createdAt: DateTime(2020),
    );

    test('a 4x habit contributes exactly 4 scheduled days to a met week', () {
      // Complete Mon-Thu; Fri/Sat/Sun must then read as not scheduled, so the
      // denominator is 4 and not 7 (stat_normalization.note).
      final logs = <String, dynamic>{};
      var scheduledDays = 0;
      final store = byKey([
        for (var i = 0; i < 4; i++)
          log(day(i), scheduled: [gym.id], values: {gym.id: 1}),
      ]);
      logs.addAll(store);

      for (var i = 0; i < 7; i++) {
        final before = FrequencyEngine.weekCompletionsBefore(
          gym,
          day(i),
          store,
        );
        if (FrequencyEngine.isScheduled(
          gym,
          day(i),
          weekCompletionsBefore: before,
        )) {
          scheduledDays++;
        }
      }
      expect(scheduledDays, 4);
    });

    test('rest days after the quota is met are not misses', () {
      final store = byKey([
        for (var i = 0; i < 4; i++)
          log(day(i), scheduled: [gym.id], values: {gym.id: 1}),
      ]);
      final friday = day(4);
      final before = FrequencyEngine.weekCompletionsBefore(gym, friday, store);
      expect(before, 4);
      expect(
        FrequencyEngine.isScheduled(gym, friday, weekCompletionsBefore: before),
        isFalse,
      );
    });

    test('a completely skipped week yields 4 scheduled days, not 7', () {
      final store = <String, dynamic>{};
      var scheduled = 0;
      for (var i = 0; i < 7; i++) {
        if (FrequencyEngine.isScheduled(
          gym,
          day(i),
          weekCompletionsBefore: 0,
        )) {
          scheduled++;
        }
      }
      expect(store, isEmpty);
      expect(scheduled, 4, reason: 'Mon-Thu are due; by Friday it is settled');
    });

    test('weekSatisfied counts the whole ISO week', () {
      final met = byKey([
        for (var i in [0, 2, 4, 6])
          log(day(i), scheduled: [gym.id], values: {gym.id: 1}),
      ]);
      expect(FrequencyEngine.weekSatisfied(gym, day(3), met), isTrue);

      final short = byKey([
        for (var i in [0, 2])
          log(day(i), scheduled: [gym.id], values: {gym.id: 1}),
      ]);
      expect(FrequencyEngine.weekSatisfied(gym, day(3), short), isFalse);
    });
  });

  group('archiving', () {
    test('an archived habit disappears from future days', () {
      final h = habit(archived: true, archivedAt: day(2));
      expect(FrequencyEngine.isScheduled(h, day(3)), isFalse);
      expect(FrequencyEngine.isScheduled(h, day(2)), isFalse);
    });

    test('but days before the archive date still count it', () {
      final h = habit(archived: true, archivedAt: day(2));
      expect(FrequencyEngine.isScheduled(h, day(1)), isTrue);
    });
  });

  group('scheduledFor', () {
    test('produces the day snapshot the completion rate depends on', () {
      final daily = habit();
      final mwf = habit(
        frequencyType: FrequencyTypes.specificDays,
        weekdays: const [1, 3, 5],
      );
      final gym = habit(
        frequencyType: FrequencyTypes.weeklyTarget,
        frequencyValue: 2,
      );

      final tuesday = day(1);
      final scheduled = FrequencyEngine.scheduledFor(tuesday, [
        daily,
        mwf,
        gym,
      ], const {});
      expect(scheduled.map((h) => h.id), containsAll([daily.id, gym.id]));
      expect(scheduled.map((h) => h.id), isNot(contains(mwf.id)));
    });
  });
}
