import 'package:arccore/domain/engines/level_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('level curve', () {
    test('matches the spec examples', () {
      expect(LevelEngine.xpToNextLevel(1), 66);
      expect(LevelEngine.xpToNextLevel(10), 174);
      expect(LevelEngine.xpToNextLevel(25), 354);
      expect(LevelEngine.xpToNextLevel(49), 642);
    });

    test('cumulative formula is the running sum of the per-level cost', () {
      var running = 0;
      for (var level = 1; level <= 60; level++) {
        expect(
          LevelEngine.totalXpForLevel(level),
          running,
          reason: 'cumulative XP for level $level',
        );
        running += LevelEngine.xpToNextLevel(level);
      }
    });

    test('levelForXp inverts totalXpForLevel exactly at every boundary', () {
      for (var level = 1; level <= 80; level++) {
        final threshold = LevelEngine.totalXpForLevel(level);
        expect(LevelEngine.levelForXp(threshold), level);
        if (level > 1) {
          expect(LevelEngine.levelForXp(threshold - 1), level - 1);
        }
      }
    });

    test('a perfect 122-day arc lands around level 51', () {
      // gamification_engine.level_curve.calibration: max daily XP is 150.
      const perfectArc = 150 * 122;
      final level = LevelEngine.levelForXp(perfectArc);
      expect(level, greaterThanOrEqualTo(50));
      expect(level, lessThanOrEqualTo(52));
    });

    test('a realistic 70% arc lands around level 42', () {
      final level = LevelEngine.levelForXp((150 * 122 * 0.7).round());
      expect(level, greaterThanOrEqualTo(40));
      expect(level, lessThanOrEqualTo(44));
    });

    test('progress within a level is bounded', () {
      for (final xp in [0, 1, 66, 67, 500, 5000, 18300]) {
        final p = LevelEngine.levelProgress(xp);
        expect(p, inInclusiveRange(0.0, 1.0));
      }
      expect(LevelEngine.levelProgress(0), 0);
      expect(LevelEngine.xpIntoLevel(66), 0);
    });
  });

  group('ranks', () {
    test('resolve at the 9/10 and 49/50 boundaries', () {
      expect(LevelEngine.rankKeyForLevel(9), 'rankEmberSpark');
      expect(LevelEngine.rankKeyForLevel(10), 'rankFrostInitiate');
      expect(LevelEngine.rankKeyForLevel(19), 'rankFrostInitiate');
      expect(LevelEngine.rankKeyForLevel(20), 'rankIronAscetic');
      expect(LevelEngine.rankKeyForLevel(29), 'rankIronAscetic');
      expect(LevelEngine.rankKeyForLevel(30), 'rankStormWarden');
      expect(LevelEngine.rankKeyForLevel(39), 'rankStormWarden');
      expect(LevelEngine.rankKeyForLevel(40), 'rankArcChampion');
      expect(LevelEngine.rankKeyForLevel(49), 'rankArcChampion');
      expect(LevelEngine.rankKeyForLevel(50), 'rankWinterSovereign');
      expect(LevelEngine.rankKeyForLevel(120), 'rankWinterSovereign');
    });

    test('crossedRank only fires on a band change', () {
      expect(LevelEngine.crossedRank(9, 10), isTrue);
      expect(LevelEngine.crossedRank(10, 11), isFalse);
      expect(LevelEngine.crossedRank(49, 50), isTrue);
    });
  });

  group('multiplier tiers', () {
    test('match the spec table', () {
      expect(MultiplierEngine.forStreak(0), 1.0);
      expect(MultiplierEngine.forStreak(6), 1.0);
      expect(MultiplierEngine.forStreak(7), 1.1);
      expect(MultiplierEngine.forStreak(13), 1.1);
      expect(MultiplierEngine.forStreak(14), 1.2);
      expect(MultiplierEngine.forStreak(29), 1.2);
      expect(MultiplierEngine.forStreak(30), 1.35);
      expect(MultiplierEngine.forStreak(59), 1.35);
      expect(MultiplierEngine.forStreak(60), 1.5);
      expect(MultiplierEngine.forStreak(200), 1.5);
    });

    test('formats without float noise', () {
      expect(MultiplierEngine.format(1.0), '1.0');
      expect(MultiplierEngine.format(1.35), '1.35');
    });
  });

  group('boss weeks', () {
    test('are scheduled every fourth week with the spec payouts', () {
      expect(BossWeekEngine.forArcWeek(4)?.bonusXp, 300);
      expect(BossWeekEngine.forArcWeek(8)?.bonusXp, 400);
      expect(BossWeekEngine.forArcWeek(12)?.bonusXp, 500);
      expect(BossWeekEngine.forArcWeek(16)?.bonusXp, 750);
      expect(BossWeekEngine.forArcWeek(5), isNull);
      expect(BossWeekEngine.totalBonusXp, 1950);
    });

    test('The Cold Open needs 5 of 7 days, the rest need all 7', () {
      expect(BossWeekEngine.requiredDays(BossWeekEngine.schedule[0]), 5);
      expect(BossWeekEngine.requiredDays(BossWeekEngine.schedule[1]), 7);
      expect(BossWeekEngine.requiredDays(BossWeekEngine.schedule[3]), 7);
    });
  });
}
