@Tags(['isar'])
library;

import 'dart:io';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/constants/habit_presets.dart';
import 'package:arccore/core/services/background_worker.dart';
import 'package:arccore/data/models/app_settings.dart';
import 'package:arccore/data/repositories/achievement_repository.dart';
import 'package:arccore/data/repositories/arc_repository.dart';
import 'package:arccore/data/repositories/daily_log_repository.dart';
import 'package:arccore/data/repositories/habit_repository.dart';
import 'package:arccore/data/repositories/isar_service.dart';
import 'package:arccore/data/repositories/profile_repository.dart';
import 'package:arccore/data/repositories/settings_repository.dart';
import 'package:arccore/domain/tracker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The workmanager tasks themselves, exercised without workmanager.
///
/// The dispatcher is a one-line delegation to [BackgroundWorker], so the work
/// is testable in-process; what cannot be tested here is whether the OS ever
/// chooses to run it, which is exactly why every task is also reachable from
/// the foreground.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory dir;
  late Isar isar;
  late TrackerService tracker;
  late SettingsRepository settingsRepo;
  var counter = 0;

  const settings = AppSettings();

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('arccore_bg');
    isar = await Isar.open(
      IsarService.schemas,
      directory: dir.path,
      name: 'bg${counter++}',
      inspector: false,
    );
    SharedPreferences.setMockInitialValues({});
    settingsRepo = await SettingsRepository.open();
    tracker = TrackerService(
      habits: HabitRepository(isar),
      logs: DailyLogRepository(isar),
      profiles: ProfileRepository(isar),
      arcs: ArcRepository(isar),
      achievements: AchievementRepository(isar),
      settingsRepo: settingsRepo,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> onboard() => tracker.createInitialArc(
    fullName: 'Arc Runner',
    nickname: 'Runner',
    themePreference: 'dark',
    startDate: DateTime.now(),
    lengthDays: AppConstants.defaultArcLengthDays,
    selectedPresets: HabitPresets.seeds,
  );

  test(
    'reconcileSteps folds the pedometer total into the steps habit',
    () async {
      await onboard();
      var state = (await tracker.load(settings))!;
      final steps = state.activeHabits.firstWhere(
        (h) => h.titleKey == 'habitStepsGoal',
      );

      // A day of walking recorded by the sensor but never logged against the
      // habit, because the app was not opened.
      await tracker.saveStepCount(state: state, day: state.today, steps: 11500);
      state = (await tracker.load(settings))!;
      expect(state.todayLog!.entryFor(steps.id), isNull);

      await BackgroundWorker.reconcileSteps(tracker: tracker, state: state);

      state = (await tracker.load(settings))!;
      final entry = state.todayLog!.entryFor(steps.id)!;
      expect(entry.value, 11500);
      expect(entry.isComplete, isTrue, reason: '11,500 clears the 10k target');
      expect(state.profile.totalXp, greaterThan(0));
    },
  );

  test('reconcileSteps never lowers an already-higher manual entry', () async {
    await onboard();
    var state = (await tracker.load(settings))!;
    final steps = state.activeHabits.firstWhere(
      (h) => h.titleKey == 'habitStepsGoal',
    );

    await tracker.logHabit(
      state: state,
      habit: steps,
      day: state.today,
      value: 14000,
    );
    state = (await tracker.load(settings))!;
    await tracker.saveStepCount(state: state, day: state.today, steps: 9000);
    state = (await tracker.load(settings))!;

    await BackgroundWorker.reconcileSteps(tracker: tracker, state: state);

    state = (await tracker.load(settings))!;
    expect(state.todayLog!.entryFor(steps.id)!.value, 14000);
  });

  test('reconcileSteps is a no-op with no sensor data', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    await BackgroundWorker.reconcileSteps(tracker: tracker, state: state);

    final after = (await tracker.load(settings))!;
    expect(after.todayLog!.entries, isEmpty);
  });

  test(
    'autoBackup writes a snapshot and stamps lastBackupAt',
    () async {
      await onboard();
      final state = (await tracker.load(settings))!;
      final service = IsarServiceHandle(isar);

      await BackgroundWorker.autoBackup(
        state: state,
        settingsRepo: settingsRepo,
        settings: settings,
        isar: service,
      );

      expect(settingsRepo.load().lastBackupAt, isNotNull);
    },
    skip: 'needs path_provider; covered by the backup round-trip suite',
  );

  test('autoBackup skips when a snapshot is already recent', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    final recent = settings.copyWith(
      lastBackupAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    // No path_provider binding in a unit test, so if this tried to write it
    // would throw. Completing quietly is the assertion.
    await BackgroundWorker.autoBackup(
      state: state,
      settingsRepo: settingsRepo,
      settings: recent,
      isar: IsarServiceHandle(isar),
    );
    expect(settingsRepo.load().lastBackupAt, isNull);
  });
}

/// Test seam: [BackgroundWorker.autoBackup] takes an [IsarService], which owns
/// its own opening. Wrapping the already-open test instance keeps the
/// production signature honest instead of loosening it for tests.
class IsarServiceHandle implements IsarService {
  IsarServiceHandle(this.isar);

  @override
  final Isar isar;

  @override
  Future<void> close({bool deleteFromDisk = false}) async {}

  @override
  Future<void> clearAll() => isar.writeTxn(() async => isar.clear());
}
