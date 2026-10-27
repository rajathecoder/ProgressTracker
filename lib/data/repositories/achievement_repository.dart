import 'package:isar_community/isar.dart';

import '../models/achievement.dart';

class AchievementRepository {
  AchievementRepository(this._isar);
  final Isar _isar;

  Stream<List<AchievementRecord>> watchAll() =>
      _isar.achievementRecords.where().watch(fireImmediately: true);

  Future<List<AchievementRecord>> all() =>
      _isar.achievementRecords.where().findAll();

  Future<Map<String, AchievementRecord>> byKey() async {
    final all = await this.all();
    return {for (final a in all) a.key: a};
  }

  Future<void> saveAll(List<AchievementRecord> records) =>
      _isar.writeTxn(() async {
        // putByIndex on the unique `key` index keeps stable string ids stable
        // across reinstall and import.
        for (final r in records) {
          final existing = await _isar.achievementRecords
              .filter()
              .keyEqualTo(r.key)
              .findFirst();
          if (existing != null) r.id = existing.id;
        }
        await _isar.achievementRecords.putAll(records);
      });

  Future<void> deleteAll() =>
      _isar.writeTxn(() => _isar.achievementRecords.where().deleteAll());
}
