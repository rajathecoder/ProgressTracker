@Tags(['isar'])
library;

import 'dart:io';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/constants/habit_presets.dart';
import 'package:arccore/core/utils/arc_date.dart';
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

/// End-to-end writes through the real orchestration layer.
///
/// This is the suite that catches integration-shaped bugs the pure-engine tests
/// cannot see - for example that Isar hands back *fixed-length* lists for
/// embedded collections, so mutating `DailyLog.entries` in place throws.
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
    dir = await Directory.systemTemp.createTemp('arccore_tracker');
    isar = await Isar.open(
      IsarService.schemas,
      directory: dir.path,
      name: 'tracker${counter++}',
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

  Future<void> onboard({List<HabitPreset>? presets}) =>
      tracker.createInitialArc(
        fullName: 'Arc Runner',
        nickname: 'Runner',
        themePreference: 'dark',
        startDate: DateTime.now(),
        lengthDays: AppConstants.defaultArcLengthDays,
        selectedPresets: presets ?? HabitPresets.seeds,
      );

  test('onboarding creates an arc, habits and a profile', () async {
    await onboard();
    final state = await tracker.load(settings);

    expect(state, isNotNull);
    expect(state!.profile.nickname, 'Runner');
    expect(state.arc.lengthDays, 122);
    expect(state.activeHabits.length, HabitPresets.seeds.length);
    expect(state.arcDayNumber, 1);
    expect(state.todayLog, isNotNull, reason: 'today is materialised');
    expect(state.todayScheduledCount, greaterThan(0));
  });

  test('toggling a boolean habit awards XP and survives a reload', () async {
    await onboard();
    var state = (await tracker.load(settings))!;
    final wake = state.activeHabits.firstWhere(
      (h) => h.titleKey == 'habitEarlyWake',
    );

    final outcome = await tracker.toggleHabit(
      state: state,
      habit: wake,
      day: state.today,
    );
    expect(outcome.isComplete, isTrue);
    expect(outcome.awardedXp, 15);
    expect(outcome.xpSuppressed, isFalse);

    state = (await tracker.load(settings))!;
    expect(state.profile.totalXp, 15);
    expect(state.todayLog!.entryFor(wake.id)!.isComplete, isTrue);
    expect(state.stats['Discipline'], greaterThan(0));
  });

  test(
    'a second write on the same habit replaces rather than appends',
    () async {
      // Regression: Isar returns fixed-length lists for embedded collections, so
      // an in-place removeWhite on `entries` throws "Cannot remove from a
      // fixed-length list" on the *second* write of a day.
      await onboard();
      var state = (await tracker.load(settings))!;
      final wake = state.activeHabits.firstWhere(
        (h) => h.titleKey == 'habitEarlyWake',
      );

      await tracker.toggleHabit(state: state, habit: wake, day: state.today);

      // Reload so `entries` comes back from storage as a fixed-length list.
      state = (await tracker.load(settings))!;
      expect(state.todayLog!.entries.length, 1);

      await tracker.toggleHabit(state: state, habit: wake, day: state.today);

      state = (await tracker.load(settings))!;
      expect(
        state.todayLog!.entries.where((e) => e.habitId == wake.id),
        isEmpty,
        reason: 'toggling off removes the entry',
      );
      expect(state.profile.totalXp, 0, reason: 'XP follows the entries');
    },
  );

  test('a metric habit records a partial value and proportional XP', () async {
    await onboard();
    var state = (await tracker.load(settings))!;
    final steps = state.activeHabits.firstWhere(
      (h) => h.titleKey == 'habitStepsGoal',
    );

    final outcome = await tracker.logHabit(
      state: state,
      habit: steps,
      day: state.today,
      value: 8400,
    );
    expect(outcome.isComplete, isFalse);
    expect(outcome.ratio, closeTo(0.84, 1e-9));
    expect(outcome.awardedXp, (15 * 0.84).round());

    state = (await tracker.load(settings))!;
    final entry = state.todayLog!.entryFor(steps.id)!;
    expect(entry.value, 8400);
    expect(entry.targetAtTime, 10000);
    expect(
      state.todayCompleted,
      0,
      reason: 'partial does not count toward completion',
    );
  });

  test('logging outside the retro window is refused', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    final wake = state.activeHabits.first;

    final outcome = await tracker.logHabit(
      state: state,
      habit: wake,
      day: state.today.subtract(const Duration(days: 30)),
      value: 1,
    );
    expect(outcome.awardedXp, 0);
    expect(outcome.isComplete, isFalse);
  });

  test('Hardcore Mode collapses the backfill window to zero', () async {
    await onboard();
    const hardcore = AppSettings(hardcoreMode: true);
    final state = (await tracker.load(hardcore))!;
    expect(state.canLog(state.today), isTrue);
    expect(
      state.canLog(state.today.subtract(const Duration(days: 1))),
      isFalse,
    );
  });

  test('achievements unlock from a write and persist', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    final wake = state.activeHabits.first;

    final outcome = await tracker.toggleHabit(
      state: state,
      habit: wake,
      day: state.today,
    );
    expect(outcome.newAchievementKeys, contains('first_blood'));

    final reloaded = (await tracker.load(settings))!;
    expect(reloaded.achievementsByKey['first_blood']!.isUnlocked, isTrue);
  });

  test('the journal round-trips through the same day row', () async {
    await onboard();
    var state = (await tracker.load(settings))!;

    await tracker.saveJournal(
      state: state,
      day: state.today,
      gratitude: 'the cold morning',
      notes: 'held the line',
      mood: 4,
      tags: ['winter', 'focus'],
    );

    state = (await tracker.load(settings))!;
    final log = state.todayLog!;
    expect(log.gratitudeText, 'the cold morning');
    expect(log.mood, 4);
    expect(log.tags, ['winter', 'focus']);

    // A journal save followed by a habit log must not clobber either.
    await tracker.toggleHabit(
      state: state,
      habit: state.activeHabits.first,
      day: state.today,
    );
    state = (await tracker.load(settings))!;
    expect(state.todayLog!.gratitudeText, 'the cold morning');
    expect(state.todayLog!.entries, isNotEmpty);
  });

  test(
    'starting a new arc archives the old one and can carry habits',
    () async {
      await onboard();
      final state = (await tracker.load(settings))!;
      final habitCount = state.activeHabits.length;

      final newArcId = await tracker.startNewArc(
        state: state,
        lengthDays: 90,
        carryHabits: true,
        carryStats: false,
      );

      final next = (await tracker.load(settings))!;
      expect(next.arc.id, newArcId);
      expect(next.arc.lengthDays, 90);
      expect(next.activeHabits.length, habitCount, reason: 'habits carried');
      expect(next.profile.totalXp, 0, reason: 'stats reset');

      final arcs = await ArcRepository(isar).all();
      expect(arcs.length, 2);
      expect(arcs.where((a) => a.status == 'completed').length, 1);
    },
  );

  test('recomputeAfterImport rebuilds achievements from logs alone', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    await tracker.toggleHabit(
      state: state,
      habit: state.activeHabits.first,
      day: state.today,
    );

    await tracker.recomputeAfterImport(settings);

    final reloaded = (await tracker.load(settings))!;
    expect(reloaded.achievementsByKey['first_blood']!.isUnlocked, isTrue);
  });

  test('a focus session is logged additively', () async {
    await onboard();
    var state = (await tracker.load(settings))!;

    await tracker.addFocusSession(state: state, day: state.today, minutes: 25);
    state = (await tracker.load(settings))!;
    expect(state.todayLog!.focusMinutes, 25);
    expect(state.todayLog!.focusSessions, 1);

    // A second session sums rather than replacing.
    await tracker.addFocusSession(state: state, day: state.today, minutes: 15);
    state = (await tracker.load(settings))!;
    expect(state.todayLog!.focusMinutes, 40);
    expect(state.todayLog!.focusSessions, 2);

    // A zero-length session is not a session.
    await tracker.addFocusSession(state: state, day: state.today, minutes: 0);
    state = (await tracker.load(settings))!;
    expect(state.todayLog!.focusSessions, 2);
  });

  test('a gratitude entry advances the gratitude achievement', () async {
    // Regression: saveJournal used to write the log without running the
    // evaluator, so gratitude_100 could never move no matter how many entries
    // were written.
    await onboard();
    var state = (await tracker.load(settings))!;

    await tracker.saveJournal(
      state: state,
      day: state.today,
      gratitude: 'the cold morning',
    );

    state = (await tracker.load(settings))!;
    final record = state.achievementsByKey['gratitude_100'];
    expect(record, isNotNull);
    expect(record!.progressCurrent, 1);
  });

  test('the day snapshot honours frequency', () async {
    await onboard();
    final state = (await tracker.load(settings))!;
    final gym = state.activeHabits.firstWhere(
      (h) => h.titleKey == 'habitGymWorkout',
    );
    expect(gym.frequencyType, FrequencyTypes.weeklyTarget);
    expect(gym.frequencyValue, 4);

    final scheduled = state.todayLog!.scheduledHabitIds;
    expect(scheduled, isNotEmpty);
    // Every id in the snapshot must resolve to a real, active habit.
    for (final id in scheduled) {
      expect(state.habitsById[id], isNotNull);
    }
    expect(
      ArcDate.keyOf(state.today),
      state.todayLog!.dateKey,
      reason: 'the day key is resolved through ArcDate, not DateTime.now()',
    );
  });
}
