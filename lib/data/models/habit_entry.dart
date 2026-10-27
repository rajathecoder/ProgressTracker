import 'package:isar_community/isar.dart';

part 'habit_entry.g.dart';

/// data_models.HabitEntry - embedded inside DailyLog.
///
/// This model is the v1.3 fix for the "numeric habits could only be a boolean"
/// gap. It records the value that was actually logged, the target that was
/// active at the time, and the XP that was actually awarded. Nothing here is
/// ever recomputed on read: history is immutable.
@embedded
class HabitEntry {
  int habitId = 0;
  int habitVersion = 1;

  /// Actual logged value; 1 for a completed boolean habit.
  double value = 0;

  /// Snapshot of Habit.targetMetric at write time.
  double targetAtTime = 1;

  /// 0.0 - 1.0
  double completionRatio = 0;

  bool isComplete = false;

  /// Post-multiplier, stored as awarded.
  int awardedXp = 0;

  /// UTC timestamp of the write.
  DateTime loggedAt = DateTime.now().toUtc();

  /// True when backfilled outside the day it belongs to.
  bool loggedLate = false;

  HabitEntry();

  HabitEntry.create({
    required this.habitId,
    required this.habitVersion,
    required this.value,
    required this.targetAtTime,
    required this.completionRatio,
    required this.isComplete,
    required this.awardedXp,
    required this.loggedLate,
    DateTime? loggedAt,
  }) : loggedAt = loggedAt ?? DateTime.now().toUtc();

  /// Partial means "logged something, but short of target".
  @ignore
  bool get isPartial => !isComplete && completionRatio > 0;

  Map<String, dynamic> toJson() => {
    'habit_id': habitId,
    'habit_version': habitVersion,
    'value': value,
    'target_at_time': targetAtTime,
    'completion_ratio': completionRatio,
    'is_complete': isComplete,
    'awarded_xp': awardedXp,
    'logged_at': loggedAt.toIso8601String(),
    'logged_late': loggedLate,
  };

  static HabitEntry fromJson(Map<String, dynamic> j) => HabitEntry()
    ..habitId = (j['habit_id'] as num).toInt()
    ..habitVersion = (j['habit_version'] as num?)?.toInt() ?? 1
    ..value = (j['value'] as num?)?.toDouble() ?? 0
    ..targetAtTime = (j['target_at_time'] as num?)?.toDouble() ?? 1
    ..completionRatio = (j['completion_ratio'] as num?)?.toDouble() ?? 0
    ..isComplete = j['is_complete'] as bool? ?? false
    ..awardedXp = (j['awarded_xp'] as num?)?.toInt() ?? 0
    ..loggedAt =
        DateTime.tryParse(j['logged_at'] as String? ?? '')?.toUtc() ??
        DateTime.now().toUtc()
    ..loggedLate = j['logged_late'] as bool? ?? false;
}
