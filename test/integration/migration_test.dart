@Tags(['isar'])
library;

import 'dart:io';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/services/migration_service.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/data/models/habit_entry.dart';
import 'package:arccore/data/repositories/isar_service.dart';
import 'package:arccore/data/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// data_integrity.schema_migration.test_requirement:
/// "Every migration gets a test that seeds the old schema, runs the migration,
/// and asserts no record loss."
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Isar isar;
  late SettingsRepository settings;
  var counter = 0;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('arccore_migration');
    isar = await Isar.open(
      IsarService.schemas,
      directory: dir.path,
      name: 'migration${counter++}',
      inspector: false,
    );
    SharedPreferences.setMockInitialValues({});
    settings = await SettingsRepository.open();
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  DailyLog seedLegacyDay(DateTime day, List<int> habitIds, int xp) =>
      DailyLog.create(
        dateKey: ArcDate.keyOf(day),
        date: day,
        arcId: 1,
        scheduledHabitIds: habitIds,
      )..totalXpEarned = xp;

  test(
    'a fresh install stamps the current version without migrating',
    () async {
      final version = await MigrationService(isar, settings).run();
      expect(version, AppConstants.schemaVersion);
      expect(settings.schemaVersion, AppConstants.schemaVersion);
    },
  );

  test('v1.2 rows with XP but no entries are rebuilt, not dropped', () async {
    // Seed the old shape: the flat completed_habits era recorded XP on the day
    // but had no embedded entries.
    await settings.setSchemaVersion(2);
    final days = [
      seedLegacyDay(DateTime(2026, 9, 1), [1, 2, 3], 45),
      seedLegacyDay(DateTime(2026, 9, 2), [1, 2], 30),
      seedLegacyDay(DateTime(2026, 9, 3), [1, 2, 3], 45),
    ];
    await isar.writeTxn(() => isar.dailyLogs.putAll(days));
    expect(await isar.dailyLogs.count(), 3);

    await MigrationService(isar, settings).run();

    final migrated = await isar.dailyLogs.where().findAll();
    expect(migrated.length, 3, reason: 'no record loss');
    for (final log in migrated) {
      expect(
        log.entries.length,
        log.scheduledHabitIds.length,
        reason: 'one entry per scheduled habit for ${log.dateKey}',
      );
      for (final entry in log.entries) {
        expect(entry.isComplete, isTrue);
        expect(entry.value, 1);
        expect(entry.completionRatio, 1.0);
      }
      expect(
        log.entries.fold<int>(0, (s, e) => s + e.awardedXp),
        closeTo(log.totalXpEarned, log.scheduledHabitIds.length.toDouble()),
        reason: 'the recorded XP is spread across the rebuilt entries',
      );
    }
    expect(settings.schemaVersion, AppConstants.schemaVersion);
  });

  test('rows that already carry entries are left untouched', () async {
    await settings.setSchemaVersion(2);
    final day = DateTime(2026, 9, 4);
    final log =
        DailyLog.create(
            dateKey: ArcDate.keyOf(day),
            date: day,
            arcId: 1,
            scheduledHabitIds: [1, 2],
          )
          ..totalXpEarned = 28
          ..entries = [
            HabitEntry.create(
              habitId: 1,
              habitVersion: 1,
              value: 8400,
              targetAtTime: 10000,
              completionRatio: 0.84,
              isComplete: false,
              awardedXp: 13,
              loggedLate: false,
            ),
          ];
    await isar.writeTxn(() => isar.dailyLogs.put(log));

    await MigrationService(isar, settings).run();

    final after = (await isar.dailyLogs.where().findAll()).single;
    expect(after.entries.length, 1, reason: 'the partial entry is preserved');
    expect(after.entries.first.value, 8400);
    expect(after.entries.first.isComplete, isFalse);
  });

  test('rows with no XP and no entries are left alone', () async {
    await settings.setSchemaVersion(2);
    final day = DateTime(2026, 9, 5);
    await isar.writeTxn(
      () => isar.dailyLogs.put(seedLegacyDay(day, [1, 2], 0)),
    );

    await MigrationService(isar, settings).run();

    final after = (await isar.dailyLogs.where().findAll()).single;
    expect(after.entries, isEmpty, reason: 'a genuinely empty day stays empty');
  });

  test('running twice is a no-op the second time', () async {
    await settings.setSchemaVersion(2);
    await isar.writeTxn(
      () => isar.dailyLogs.put(seedLegacyDay(DateTime(2026, 9, 6), [1], 15)),
    );

    await MigrationService(isar, settings).run();
    final first = (await isar.dailyLogs.where().findAll()).single;
    final firstCount = first.entries.length;

    await MigrationService(isar, settings).run();
    final second = (await isar.dailyLogs.where().findAll()).single;
    expect(second.entries.length, firstCount);
  });
}
