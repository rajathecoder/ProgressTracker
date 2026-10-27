import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/domain/engines/xp_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  group('partial credit', () {
    final steps = habit(unit: MetricUnits.steps, target: 10000, xp: 15);

    test('a full completion awards the full reward', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 10000,
        multiplier: 1,
        partialCreditEnabled: true,
      );
      expect(award.isComplete, isTrue);
      expect(award.awardedXp, 15);
      expect(award.ratio, 1.0);
    });

    test('overshooting the target does not award bonus XP', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 25000,
        multiplier: 1,
        partialCreditEnabled: true,
      );
      expect(award.isComplete, isTrue);
      expect(award.awardedXp, 15);
      expect(award.ratio, 1.0, reason: 'ratio is clamped for the radar');
    });

    test('8,400 steps is not a failure - it is proportional credit', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 8400,
        multiplier: 1,
        partialCreditEnabled: true,
      );
      expect(award.isComplete, isFalse);
      expect(award.ratio, closeTo(0.84, 1e-9));
      expect(award.awardedXp, (15 * 0.84).round());
    });

    test('below the 0.5 threshold nothing is awarded', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 4999,
        multiplier: 1,
        partialCreditEnabled: true,
      );
      expect(award.awardedXp, 0);
      expect(award.isComplete, isFalse);
    });

    test('exactly at the threshold does award', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 5000,
        multiplier: 1,
        partialCreditEnabled: true,
      );
      expect(award.awardedXp, greaterThan(0));
      expect(AppConstants.partialCreditThreshold, 0.5);
    });

    test('disabling partial credit makes it all-or-nothing', () {
      final award = XpEngine.evaluate(
        habit: steps,
        value: 9999,
        multiplier: 1,
        partialCreditEnabled: false,
      );
      expect(award.awardedXp, 0);
      expect(award.isComplete, isFalse);
    });
  });

  group('multiplier application', () {
    test('scales the award and rounds', () {
      final h = habit(xp: 25);
      expect(
        XpEngine.evaluate(
          habit: h,
          value: 1,
          multiplier: 1.35,
          partialCreditEnabled: true,
        ).awardedXp,
        (25 * 1.35).round(),
      );
    });

    test('a zero multiplier suppresses XP without failing the log', () {
      final h = habit(xp: 25);
      final award = XpEngine.evaluate(
        habit: h,
        value: 1,
        multiplier: 0,
        partialCreditEnabled: true,
      );
      expect(award.awardedXp, 0);
      expect(award.isComplete, isTrue, reason: 'the day is still logged');
    });

    test('compounds with partial credit', () {
      final h = habit(unit: MetricUnits.minutes, target: 30, xp: 10);
      final award = XpEngine.evaluate(
        habit: h,
        value: 21,
        multiplier: 1.2,
        partialCreditEnabled: true,
      );
      expect(award.awardedXp, ((10 * 0.7).round() * 1.2).round());
    });
  });

  group('xp clamping', () {
    test('a habit above the ceiling is clamped on read', () {
      final h = habit(xp: 999);
      expect(h.clampedXp, AppConstants.maxHabitXp);
      expect(
        XpEngine.evaluate(
          habit: h,
          value: 1,
          multiplier: 1,
          partialCreditEnabled: true,
        ).awardedXp,
        30,
      );
    });

    test('a habit below the floor is clamped on read', () {
      expect(habit(xp: 1).clampedXp, AppConstants.minHabitXp);
    });
  });

  group('entry snapshots', () {
    test('record the target that was active at the time', () {
      final h = habit(unit: MetricUnits.steps, target: 10000, xp: 15);
      final entry = XpEngine.buildEntry(
        habit: h,
        value: 12000,
        multiplier: 1.1,
        partialCreditEnabled: true,
        loggedLate: true,
      );
      expect(entry.targetAtTime, 10000);
      expect(entry.habitVersion, h.version);
      expect(entry.loggedLate, isTrue);
      expect(entry.awardedXp, (15 * 1.1).round());

      // Editing the habit afterwards must not rewrite the entry.
      h
        ..targetMetric = 20000
        ..xpReward = 30
        ..version += 1;
      expect(entry.targetAtTime, 10000);
      expect(entry.awardedXp, (15 * 1.1).round());
    });

    test('a zero value produces an incomplete entry with no XP', () {
      final entry = XpEngine.buildEntry(
        habit: habit(),
        value: 0,
        multiplier: 1.5,
        partialCreditEnabled: true,
        loggedLate: false,
      );
      expect(entry.isComplete, isFalse);
      expect(entry.awardedXp, 0);
      expect(entry.completionRatio, 0);
    });
  });
}
