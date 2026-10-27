@Tags(['isar'])
library;

import 'dart:io';

import 'package:arccore/core/services/backup_service.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/achievement.dart';
import 'package:arccore/data/models/app_settings.dart';
import 'package:arccore/data/models/arc.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/data/models/habit_entry.dart';
import 'package:arccore/data/repositories/achievement_repository.dart';
import 'package:arccore/data/repositories/arc_repository.dart';
import 'package:arccore/data/repositories/daily_log_repository.dart';
import 'package:arccore/data/repositories/habit_repository.dart';
import 'package:arccore/data/repositories/isar_service.dart';
import 'package:arccore/data/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

/// integration: "Full backup -> wipe -> restore round trip asserting
/// record-level equality."
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Isar isar;
  late BackupService service;
  late HabitRepository habits;
  late DailyLogRepository logs;
  late ProfileRepository profiles;
  late ArcRepository arcs;
  late AchievementRepository achievements;
  var counter = 0;

  const settings = AppSettings();

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('arccore_backup');
    isar = await Isar.open(
      IsarService.schemas,
      directory: dir.path,
      name: 'backup${counter++}',
      inspector: false,
    );
    habits = HabitRepository(isar);
    logs = DailyLogRepository(isar);
    profiles = ProfileRepository(isar);
    arcs = ArcRepository(isar);
    achievements = AchievementRepository(isar);
    service = BackupService(
      habits: habits,
      logs: logs,
      profiles: profiles,
      arcs: arcs,
      achievements: achievements,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> seed() async {
    final arcId = await arcs.save(
      Arc.create(
        name: 'Winter Arc 2026',
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 12, 31),
        lengthDays: 122,
      ),
    );

    final wake = Habit.create(
      titleKey: 'habitEarlyWake',
      xpReward: 15,
      arcId: arcId,
    );
    final steps = Habit.create(
      titleKey: 'habitStepsGoal',
      xpReward: 15,
      metricUnit: 'steps',
      targetMetric: 10000,
      arcId: arcId,
    );
    await habits.saveAll([wake, steps]);

    for (var i = 0; i < 12; i++) {
      final day = DateTime(2026, 9, 1).add(Duration(days: i));
      await logs.save(
        DailyLog.create(
            dateKey: ArcDate.keyOf(day),
            date: day,
            arcId: arcId,
            scheduledHabitIds: [wake.id, steps.id],
          )
          ..gratitudeText = i.isEven ? 'day $i' : ''
          ..stepCount = 6000 + i * 400
          ..totalXpEarned = 28
          ..entries = [
            HabitEntry.create(
              habitId: wake.id,
              habitVersion: 1,
              value: 1,
              targetAtTime: 1,
              completionRatio: 1,
              isComplete: true,
              awardedXp: 15,
              loggedLate: false,
            ),
            HabitEntry.create(
              habitId: steps.id,
              habitVersion: 1,
              value: 8400,
              targetAtTime: 10000,
              completionRatio: 0.84,
              isComplete: false,
              awardedXp: 13,
              loggedLate: false,
            ),
          ],
      );
    }

    final profile = await profiles.getOrCreate()
      ..fullName = 'Test Runner'
      ..nickname = 'Runner'
      ..currentArcId = arcId
      ..totalXp = 336
      ..onboardingComplete = true;
    await profiles.save(profile);

    await achievements.saveAll([
      AchievementRecord.create(
        key: 'first_blood',
        progressTarget: 1,
        progressCurrent: 1,
        unlockedAt: DateTime(2026, 9, 1),
      ),
    ]);
  }

  Future<void> wipe() async {
    await logs.deleteAll();
    await habits.deleteAll();
    await arcs.deleteAll();
    await achievements.deleteAll();
    await profiles.deleteAll();
  }

  test('a plain round trip restores every record', () async {
    await seed();
    final before = await service.buildPayload(settings);
    final file = await service.exportJson(settings: settings, directory: dir);
    expect(file.existsSync(), isTrue);

    await wipe();
    expect(await isar.dailyLogs.count(), 0);

    final error = await service.restore(
      file,
      replace: true,
      settings: settings,
      snapshotDirectory: dir,
    );
    expect(error, RestoreError.none);

    final after = await service.buildPayload(settings);
    expect(
      (after['daily_logs'] as List).length,
      (before['daily_logs'] as List).length,
    );
    expect((after['habits'] as List).length, (before['habits'] as List).length);
    expect((after['arcs'] as List).length, (before['arcs'] as List).length);

    final restoredLogs = await logs.forArc(1);
    final steps = restoredLogs.first.entries.firstWhere((e) => e.value == 8400);
    expect(steps.targetAtTime, 10000);
    expect(steps.completionRatio, closeTo(0.84, 1e-9));
    expect(steps.awardedXp, 13);
    expect((await profiles.get())!.nickname, 'Runner');
  });

  test('inspect reports an honest dry-run diff before writing', () async {
    await seed();
    final file = await service.exportJson(settings: settings, directory: dir);
    final result = await service.inspect(file);

    expect(result.ok, isTrue);
    expect(result.preview!.days, 12);
    expect(result.preview!.habits, 2);
    expect(
      result.preview!.journals,
      6,
      reason: 'only even days wrote gratitude',
    );
    expect(result.preview!.encrypted, isFalse);
  });

  test('a tampered payload fails the checksum guard', () async {
    await seed();
    final file = await service.exportJson(settings: settings, directory: dir);
    final raw = await file.readAsString();
    await file.writeAsString(raw.replaceFirst('"Runner"', '"Tampered"'));

    final result = await service.inspect(file);
    expect(result.ok, isFalse);
    expect(result.error, RestoreError.checksumMismatch);
  });

  test('a backup from a newer schema is refused', () async {
    await seed();
    final file = await service.exportJson(settings: settings, directory: dir);
    final raw = await file.readAsString();
    await file.writeAsString(
      raw.replaceFirst(
        RegExp(r'"schema_version": \d+'),
        '"schema_version": 999',
      ),
    );

    final result = await service.inspect(file);
    expect(result.error, RestoreError.schemaTooNew);
  });

  group('encrypted exports', () {
    test('round-trip with the correct passphrase', () async {
      await seed();
      final file = await service.exportJson(
        settings: settings,
        passphrase: 'winter-arc',
        directory: dir,
      );
      expect(
        await file.readAsString(),
        isNot(contains('habitEarlyWake')),
        reason: 'the payload is encrypted at rest',
      );

      final result = await service.inspect(file, passphrase: 'winter-arc');
      expect(result.ok, isTrue);
      expect(result.preview!.encrypted, isTrue);

      await wipe();
      final error = await service.restore(
        file,
        replace: true,
        settings: settings,
        passphrase: 'winter-arc',
        snapshotDirectory: dir,
      );
      expect(error, RestoreError.none);
      expect((await logs.forArc(1)).length, 12);
    });

    test('a wrong passphrase is rejected, not silently ignored', () async {
      await seed();
      final file = await service.exportJson(
        settings: settings,
        passphrase: 'winter-arc',
        directory: dir,
      );
      final result = await service.inspect(file, passphrase: 'wrong');
      expect(result.error, RestoreError.badPassphrase);
    });

    test('no passphrase at all is reported as such', () async {
      await seed();
      final file = await service.exportJson(
        settings: settings,
        passphrase: 'winter-arc',
        directory: dir,
      );
      expect((await service.inspect(file)).error, RestoreError.badPassphrase);
    });
  });

  test(
    'restore writes a pre-restore snapshot before touching anything',
    () async {
      await seed();
      final file = await service.exportJson(settings: settings, directory: dir);
      final before = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('arccore_backup_'))
          .length;
      expect(before, 1);

      await service.restore(
        file,
        replace: true,
        settings: settings,
        snapshotDirectory: dir,
      );

      final after = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('arccore_backup_'))
          .length;
      expect(after, before + 1, reason: 'a bad restore stays undoable');
      expect(file.existsSync(), isTrue);
    },
  );

  test('CSV export emits one row per day plus a header', () async {
    await seed();
    final habitList = await habits.forArc(1);
    final csv = await service.exportCsv(
      arcId: 1,
      habitList: habitList,
      directory: dir,
    );
    final lines = (await csv.readAsString()).trim().split('\r\n');
    expect(lines.length, 13, reason: '12 days + header');
    expect(lines.first, contains('completion_rate'));
    expect(lines.first, contains('habitEarlyWake'));
  });
}
