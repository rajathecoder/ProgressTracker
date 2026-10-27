import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../../data/models/daily_log.dart';
import '../../data/models/habit_entry.dart';
import '../../data/repositories/settings_repository.dart';
import '../constants/app_constants.dart';

/// data_integrity.schema_migration
///
/// "Store a schema_version int in shared_preferences. On app start, if the
/// stored version is behind the current, run ordered migration steps inside a
/// single Isar write transaction before the first read."
///
/// Silently dropping a user's 40 days of logs mid-arc ends the relationship with
/// the app, so every step is additive and every step has a test.
class MigrationService {
  MigrationService(this._isar, this._settings);

  final Isar _isar;
  final SettingsRepository _settings;

  /// Ordered steps. Key is the version being migrated *to*.
  late final Map<int, Future<void> Function()> _steps = {
    3: _v2ToV3,
    4: _v3ToV4,
  };

  Future<int> run() async {
    final from = _settings.schemaVersion;
    if (from >= AppConstants.schemaVersion) return from;

    // A fresh install has nothing to migrate - stamp and move on.
    final isEmpty = await _isar.dailyLogs.count() == 0;
    if (from == 0 && isEmpty) {
      await _settings.setSchemaVersion(AppConstants.schemaVersion);
      return AppConstants.schemaVersion;
    }

    final versions = _steps.keys.where((v) => v > from).toList()..sort();
    for (final v in versions) {
      debugPrint('ArcCore: migrating schema to v$v');
      await _steps[v]!();
      await _settings.setSchemaVersion(v);
    }
    await _settings.setSchemaVersion(AppConstants.schemaVersion);
    return AppConstants.schemaVersion;
  }

  /// v1.2 -> v1.3: `DailyLog.completed_habits` (`List<int>`) becomes
  /// `List<HabitEntry>` with value=1 and ratio=1.0.
  ///
  /// v1.2 rows can only be present if a v1.2 build ever shipped. The Isar
  /// schema no longer declares `completedHabits`, so the old column is not
  /// readable through the typed API. What we can do, and what matters, is
  /// guarantee that a row which has scheduled ids but no entries is repaired
  /// rather than silently counted as a total miss.
  Future<void> _v2ToV3() async {
    final logs = await _isar.dailyLogs.where().findAll();
    final repaired = <DailyLog>[];

    for (final log in logs) {
      if (log.entries.isNotEmpty) continue;
      if (log.scheduledHabitIds.isEmpty) continue;
      if (log.totalXpEarned <= 0) continue;

      // The row recorded XP but carries no entries: it came from the flat
      // list-of-ids era. Reconstruct one complete entry per scheduled habit
      // and spread the recorded XP across them.
      final share = (log.totalXpEarned / log.scheduledHabitIds.length).round();
      log.entries = [
        for (final id in log.scheduledHabitIds)
          HabitEntry.create(
            habitId: id,
            habitVersion: 1,
            value: 1,
            targetAtTime: 1,
            completionRatio: 1,
            isComplete: true,
            awardedXp: share,
            loggedLate: false,
            loggedAt: log.date.toUtc(),
          ),
      ];
      repaired.add(log);
    }

    if (repaired.isEmpty) return;
    await _isar.writeTxn(() => _isar.dailyLogs.putAll(repaired));
    debugPrint('ArcCore: migrated ${repaired.length} legacy day(s)');
  }

  /// v1.3 -> v1.4: DailyLog gains focusMinutes / focusSessions.
  ///
  /// Isar materialises new scalar properties with their default value on read,
  /// so there is nothing to rewrite. The step exists to move the stored version
  /// forward and to keep the ordered chain complete, so a device that skipped a
  /// release still walks every step in order.
  Future<void> _v3ToV4() async {}
}
