@Tags(['isar'])
library;

import 'dart:io';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/achievement.dart';
import 'package:arccore/data/models/arc.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/data/models/habit_entry.dart';
import 'package:arccore/data/models/user_profile.dart';
import 'package:arccore/data/repositories/achievement_repository.dart';
import 'package:arccore/data/repositories/arc_repository.dart';
import 'package:arccore/data/repositories/daily_log_repository.dart';
import 'package:arccore/data/repositories/habit_repository.dart';
import 'package:arccore/data/repositories/isar_service.dart';
import 'package:arccore/data/repositories/profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

/// integration: "Isar CRUD against a temp directory, including the
/// v1.2 -> v1.3 migration."
///
/// Run with: flutter test test/integration --tags isar
/// These need the native Isar library, which `flutter test` downloads on first
/// use via Isar.initializeIsarCore.
void main() {
  late Directory dir;
  late Isar isar;
  var counter = 0;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('arccore_test');
    isar = await Isar.open(
      IsarService.schemas,
      directory: dir.path,
      name: 'test${counter++}',
      inspector: false,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  group('habit repository', () {
    test('round-trips a habit and clamps XP on write', () async {
      final repo = HabitRepository(isar);
      final habit = Habit.create(
        titleKey: 'habitEarlyWake',
        xpReward: 999,
        arcId: 1,
      );
      final id = await repo.save(habit);

      final loaded = await repo.byId(id);
      expect(loaded, isNotNull);
      expect(loaded!.titleKey, 'habitEarlyWake');
      expect(loaded.xpReward, AppConstants.maxHabitXp);
    });

    test('archiving keeps the row and stamps archivedAt', () async {
      final repo = HabitRepository(isar);
      final habit = Habit.create(titleKey: 'habitWaterOnly', arcId: 1);
      await repo.save(habit);

      await repo.setArchived(habit, true);
      final all = await repo.forArc(1);
      expect(all.length, 1, reason: 'archiving never deletes');
      expect(all.first.isArchived, isTrue);
      expect(all.first.archivedAt, isNotNull);

      final active = await repo.activeForArc(1);
      expect(active, isEmpty);
    });

    test('saveEdit bumps the version so history stays pinned', () async {
      final repo = HabitRepository(isar);
      final habit = Habit.create(titleKey: 'habitStepsGoal', arcId: 1);
      await repo.save(habit);
      expect(habit.version, 1);

      habit.targetMetric = 12000;
      await repo.saveEdit(habit);
      expect((await repo.byId(habit.id))!.version, 2);
    });

    test('reorder rewrites sortOrder in list order', () async {
      final repo = HabitRepository(isar);
      final a = Habit.create(titleKey: 'a', arcId: 1, sortOrder: 0);
      final b = Habit.create(titleKey: 'b', arcId: 1, sortOrder: 1);
      final c = Habit.create(titleKey: 'c', arcId: 1, sortOrder: 2);
      await repo.saveAll([a, b, c]);

      await repo.reorder([c, a, b]);
      final ordered = await repo.forArc(1);
      expect(ordered.map((h) => h.titleKey), ['c', 'a', 'b']);
    });
  });

  group('daily log repository', () {
    test('upserts by date key rather than appending', () async {
      final repo = DailyLogRepository(isar);
      final day = DateTime(2026, 9, 1);

      final first = DailyLog.create(
        dateKey: ArcDate.keyOf(day),
        date: day,
        arcId: 1,
      )..totalXpEarned = 10;
      await repo.save(first);

      final second = await repo.byKey(ArcDate.keyOf(day), 1);
      second!.totalXpEarned = 25;
      await repo.save(second);

      final all = await repo.forArc(1);
      expect(all.length, 1, reason: 'one row per calendar day');
      expect(all.first.totalXpEarned, 25);
    });

    test('embedded HabitEntry survives a write/read cycle intact', () async {
      final repo = DailyLogRepository(isar);
      final day = DateTime(2026, 9, 2);
      final log =
          DailyLog.create(
              dateKey: ArcDate.keyOf(day),
              date: day,
              arcId: 1,
              scheduledHabitIds: [7],
            )
            ..entries = [
              HabitEntry.create(
                habitId: 7,
                habitVersion: 3,
                value: 8400,
                targetAtTime: 10000,
                completionRatio: 0.84,
                isComplete: false,
                awardedXp: 13,
                loggedLate: true,
              ),
            ];
      await repo.save(log);

      final loaded = (await repo.byKey(ArcDate.keyOf(day), 1))!;
      final entry = loaded.entryFor(7)!;
      expect(entry.value, 8400);
      expect(entry.targetAtTime, 10000);
      expect(entry.completionRatio, closeTo(0.84, 1e-9));
      expect(entry.awardedXp, 13);
      expect(entry.loggedLate, isTrue);
      expect(entry.isComplete, isFalse);
    });

    test('inRange returns only the requested window', () async {
      final repo = DailyLogRepository(isar);
      for (var i = 0; i < 10; i++) {
        final day = DateTime(2026, 9, 1).add(Duration(days: i));
        await repo.save(
          DailyLog.create(dateKey: ArcDate.keyOf(day), date: day, arcId: 1),
        );
      }
      final window = await repo.inRange(
        1,
        DateTime(2026, 9, 3),
        DateTime(2026, 9, 6),
      );
      expect(window.length, 4);
      expect(window.first.dateKey, '2026-09-03');
      expect(window.last.dateKey, '2026-09-06');
    });

    test('search matches gratitude, notes and tags', () async {
      final repo = DailyLogRepository(isar);
      final day = DateTime(2026, 9, 4);
      await repo.save(
        DailyLog.create(dateKey: ArcDate.keyOf(day), date: day, arcId: 1)
          ..gratitudeText = 'Grateful for the cold morning'
          ..tags = ['winter'],
      );
      expect((await repo.search(1, 'cold')).length, 1);
      expect((await repo.search(1, 'winter')).length, 1);
      expect((await repo.search(1, 'summer')), isEmpty);
    });
  });

  group('profile and arc', () {
    test('the profile is a singleton row', () async {
      final repo = ProfileRepository(isar);
      final a = await repo.getOrCreate()
        ..nickname = 'Arc';
      await repo.save(a);
      final b = await repo.getOrCreate()
        ..nickname = 'Core';
      await repo.save(b);

      expect(await isar.userProfiles.count(), 1);
      expect((await repo.get())!.nickname, 'Core');
    });

    test('stat scores round-trip as an embedded object', () async {
      final repo = ProfileRepository(isar);
      final profile = await repo.getOrCreate();
      profile.statScores.add('Vitality', 120);
      profile.statScores.add('Spirit', 45);
      await repo.save(profile);

      final loaded = (await repo.get())!;
      expect(loaded.statScores.vitality, 120);
      expect(loaded.statScores.spirit, 45);
      expect(loaded.statScores['Vitality'], 120);
    });

    test('the active arc is found by status', () async {
      final repo = ArcRepository(isar);
      await repo.save(
        Arc.create(
          name: 'Old',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 4, 1),
          lengthDays: 90,
          status: ArcStatus.completed,
        ),
      );
      await repo.save(
        Arc.create(
          name: 'Winter Arc 2026',
          startDate: DateTime(2026, 9, 1),
          endDate: DateTime(2026, 12, 31),
          lengthDays: 122,
        ),
      );
      expect((await repo.active())!.name, 'Winter Arc 2026');
      expect((await repo.all()).length, 2);
    });
  });

  group('achievements', () {
    test('the stable string key is unique and upserts', () async {
      final repo = AchievementRepository(isar);
      await repo.saveAll([
        AchievementRecord.create(key: 'first_blood', progressTarget: 1),
      ]);
      await repo.saveAll([
        AchievementRecord.create(
          key: 'first_blood',
          progressTarget: 1,
          progressCurrent: 1,
          unlockedAt: DateTime(2026, 9, 1),
        ),
      ]);

      final all = await repo.all();
      expect(all.length, 1, reason: 'keyed by the stable string id');
      expect(all.first.isUnlocked, isTrue);
    });
  });
}
