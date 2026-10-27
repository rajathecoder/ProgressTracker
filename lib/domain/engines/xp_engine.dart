import '../../core/constants/app_constants.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_entry.dart';

/// The result of logging one habit on one day.
class XpAward {
  const XpAward({
    required this.ratio,
    required this.isComplete,
    required this.baseXp,
    required this.awardedXp,
  });

  final double ratio;
  final bool isComplete;
  final int baseXp;
  final int awardedXp;
}

/// core_features.metric_logging.partial_credit_rules
///
///   awarded_xp = value >= target
///       ? xp_reward
///       : (ratio >= threshold ? round(xp_reward * ratio) : 0)
///
/// 8,400 steps is not a failure. But only a full completion (ratio >= 1.0)
/// counts toward streaks and the matrix "complete" state.
abstract final class XpEngine {
  static XpAward evaluate({
    required Habit habit,
    required double value,
    required double multiplier,
    required bool partialCreditEnabled,
  }) {
    final target = habit.targetMetric <= 0
        ? 1.0
        : habit.targetMetric.toDouble();
    final rawRatio = value <= 0 ? 0.0 : value / target;
    final ratio = rawRatio.clamp(0.0, 1.0);
    final isComplete = rawRatio >= 1.0;
    final base = habit.clampedXp;

    int earned;
    if (isComplete) {
      earned = base;
    } else if (!partialCreditEnabled) {
      earned = 0;
    } else if (ratio >= AppConstants.partialCreditThreshold) {
      earned = (base * ratio).round();
    } else {
      earned = 0;
    }

    // The multiplier is applied once, at award time, and the result is stored.
    // It is never recomputed on read, so tuning the tiers later cannot rewrite
    // a user's history (edge_case_handling.habit_edited_mid_arc).
    final awarded = (earned * multiplier).round();

    return XpAward(
      ratio: ratio,
      isComplete: isComplete,
      baseXp: base,
      awardedXp: awarded,
    );
  }

  static HabitEntry buildEntry({
    required Habit habit,
    required double value,
    required double multiplier,
    required bool partialCreditEnabled,
    required bool loggedLate,
    DateTime? loggedAt,
  }) {
    final award = evaluate(
      habit: habit,
      value: value,
      multiplier: multiplier,
      partialCreditEnabled: partialCreditEnabled,
    );
    return HabitEntry.create(
      habitId: habit.id,
      habitVersion: habit.version,
      value: value,
      targetAtTime: habit.targetMetric.toDouble(),
      completionRatio: award.ratio,
      isComplete: award.isComplete,
      awardedXp: award.awardedXp,
      loggedLate: loggedLate,
      loggedAt: loggedAt,
    );
  }

  /// Max XP a habit can yield on one scheduled day, before multipliers. Used
  /// as the denominator in stat normalisation.
  static int maxXpFor(Habit habit) => habit.clampedXp;
}
