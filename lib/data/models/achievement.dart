import 'package:isar_community/isar.dart';

part 'achievement.g.dart';

/// data_models.Achievement
///
/// [key] is the stable string id from the spec ('first_blood', ...) so it
/// survives reinstall and import. The Isar Id is an implementation detail.
///
/// Unlock state is *never* the source of truth: the evaluator recomputes it
/// from logs after every write and after every restore
/// (gamification_engine.achievement_evaluation).
@collection
class AchievementRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String key = '';

  DateTime? unlockedAt;

  int progressCurrent = 0;
  int progressTarget = 1;

  int? arcId;

  AchievementRecord();

  AchievementRecord.create({
    required this.key,
    required this.progressTarget,
    this.progressCurrent = 0,
    this.unlockedAt,
    this.arcId,
  });

  @ignore
  bool get isUnlocked => unlockedAt != null;

  @ignore
  double get progressRatio => progressTarget <= 0
      ? 0
      : (progressCurrent / progressTarget).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
    'key': key,
    'unlocked_at': unlockedAt?.toIso8601String(),
    'progress_current': progressCurrent,
    'progress_target': progressTarget,
    'arc_id': arcId,
  };

  static AchievementRecord fromJson(Map<String, dynamic> j) =>
      AchievementRecord()
        ..key = j['key'] as String? ?? ''
        ..unlockedAt = j['unlocked_at'] == null
            ? null
            : DateTime.tryParse(j['unlocked_at'] as String)
        ..progressCurrent = (j['progress_current'] as num?)?.toInt() ?? 0
        ..progressTarget = (j['progress_target'] as num?)?.toInt() ?? 1
        ..arcId = (j['arc_id'] as num?)?.toInt();
}
