import '../../core/constants/app_constants.dart';

/// gamification_engine.ranks
class Rank {
  const Rank(this.key, this.minLevel, this.maxLevel);
  final String key;
  final int minLevel;
  final int maxLevel;
}

/// gamification_engine.level_curve
///
///   xpToNextLevel(L) = 12L + 54
///   totalXpForLevel(L) = 6(L-1)^2 + 60(L-1)
///
/// Calibration check (spec): max daily XP with the seed set is 150, so a
/// perfect 122-day arc is 18,300 XP, which lands at ~Level 51.
abstract final class LevelEngine {
  static const List<Rank> ranks = [
    Rank('rankEmberSpark', 1, 9),
    Rank('rankFrostInitiate', 10, 19),
    Rank('rankIronAscetic', 20, 29),
    Rank('rankStormWarden', 30, 39),
    Rank('rankArcChampion', 40, 49),
    Rank('rankWinterSovereign', 50, 1 << 30),
  ];

  static int xpToNextLevel(int level) => 12 * level + 54;

  static int totalXpForLevel(int level) {
    if (level <= 1) return 0;
    final l = level - 1;
    return 6 * l * l + 60 * l;
  }

  /// Inverse of [totalXpForLevel]: the level a total XP figure lands you at.
  ///
  /// Solving 6(L-1)^2 + 60(L-1) <= xp for L gives
  ///   L = 1 + floor((-60 + sqrt(3600 + 24*xp)) / 12)
  /// We derive it in closed form and then correct by one step, so a rounding
  /// error can never silently cost the user a level.
  static int levelForXp(int totalXp) {
    if (totalXp <= 0) return 1;
    final discriminant = 3600 + 24 * totalXp;
    var level = 1 + ((-60 + _sqrt(discriminant.toDouble())) / 12).floor();
    if (level < 1) level = 1;
    while (totalXpForLevel(level + 1) <= totalXp) {
      level++;
    }
    while (level > 1 && totalXpForLevel(level) > totalXp) {
      level--;
    }
    return level;
  }

  /// XP accumulated inside the current level.
  static int xpIntoLevel(int totalXp) {
    final level = levelForXp(totalXp);
    return totalXp - totalXpForLevel(level);
  }

  /// 0.0 - 1.0 progress toward the next level.
  static double levelProgress(int totalXp) {
    final level = levelForXp(totalXp);
    final span = xpToNextLevel(level);
    if (span <= 0) return 0;
    return (xpIntoLevel(totalXp) / span).clamp(0.0, 1.0);
  }

  static Rank rankForLevel(int level) {
    for (final r in ranks) {
      if (level >= r.minLevel && level <= r.maxLevel) return r;
    }
    return ranks.first;
  }

  static String rankKeyForLevel(int level) => rankForLevel(level).key;

  /// True when crossing from [before] to [after] enters a new rank band.
  static bool crossedRank(int before, int after) =>
      rankForLevel(before).key != rankForLevel(after).key;

  static double _sqrt(double v) {
    if (v <= 0) return 0;
    // Newton's method - avoids importing dart:math into a pure-logic file that
    // is also exercised from the widget tests.
    var x = v;
    var prev = 0.0;
    while ((x - prev).abs() > 1e-9) {
      prev = x;
      x = 0.5 * (x + v / x);
    }
    return x;
  }
}

/// streak_resilience.multiplier_tiers
abstract final class MultiplierEngine {
  static double forStreak(int streakDays) {
    if (streakDays >= 60) return 1.5;
    if (streakDays >= 30) return 1.35;
    if (streakDays >= 14) return 1.2;
    if (streakDays >= 7) return 1.1;
    return 1.0;
  }

  /// Formatted for display: 1.0x, 1.35x - never "1.3500000000000001x".
  static String format(double m) =>
      m == m.roundToDouble() ? m.toStringAsFixed(1) : m.toStringAsFixed(2);
}

/// core_features.boss_weeks - deterministic, computed from arc_start_date.
class BossWeek {
  const BossWeek({
    required this.arcWeek,
    required this.name,
    required this.targetKey,
    required this.bonusXp,
    required this.kind,
  });

  final int arcWeek;
  final String name;
  final String targetKey;
  final int bonusXp;
  final BossWeekKind kind;
}

enum BossWeekKind {
  /// Complete every scheduled habit for N of 7 days.
  perfectDays,

  /// Hit a specific habit's target all 7 days.
  specificHabitAllWeek,

  /// A perfect 7-day week across every habit.
  perfectWeek,
}

abstract final class BossWeekEngine {
  static const List<BossWeek> schedule = [
    BossWeek(
      arcWeek: 4,
      name: 'The Cold Open',
      targetKey: 'bossColdOpen',
      bonusXp: 300,
      kind: BossWeekKind.perfectDays,
    ),
    BossWeek(
      arcWeek: 8,
      name: 'Iron Lungs',
      targetKey: 'bossIronLungs',
      bonusXp: 400,
      kind: BossWeekKind.specificHabitAllWeek,
    ),
    BossWeek(
      arcWeek: 12,
      name: 'Clean Slate',
      targetKey: 'bossCleanSlate',
      bonusXp: 500,
      kind: BossWeekKind.specificHabitAllWeek,
    ),
    BossWeek(
      arcWeek: 16,
      name: 'The Summit',
      targetKey: 'bossSummit',
      bonusXp: 750,
      kind: BossWeekKind.perfectWeek,
    ),
  ];

  /// Required count for the boss week's target, in days.
  static int requiredDays(BossWeek week) =>
      week.kind == BossWeekKind.perfectDays ? 5 : 7;

  static BossWeek? forArcWeek(int arcWeek) {
    for (final w in schedule) {
      if (w.arcWeek == arcWeek) return w;
    }
    return null;
  }

  /// Total bonus XP available across the arc - used by the recap headline.
  static int get totalBonusXp => schedule.fold(0, (sum, w) => sum + w.bonusXp);

  static int maxDailyXpEstimate(int habitCount, int avgXp) =>
      habitCount *
      avgXp.clamp(AppConstants.minHabitXp, AppConstants.maxHabitXp);
}
