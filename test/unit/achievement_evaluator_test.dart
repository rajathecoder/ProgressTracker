import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/achievement.dart';
import 'package:arccore/data/models/app_settings.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/domain/engines/achievement_evaluator.dart';
import 'package:arccore/domain/engines/stat_engine.dart';
import 'package:arccore/domain/engines/streak_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  final start = DateTime(2026, 9, 1);
  DateTime day(int i) => start.add(Duration(days: i));

  Map<String, int> evaluate(
    List<DailyLog> logs,
    Map<int, Habit> habits, {
    int totalXp = 0,
    int arcLength = 122,
    bool hasBackup = false,
    AppSettings settings = const AppSettings(),
  }) {
    final upTo = logs.isEmpty ? start : logs.last.date;
    final arcDays = ArcDate.daysInRange(start, upTo);
    final byKeyMap = byKey(logs);
    final streak = StreakEngine.compute(
      arcDays: arcDays,
      logsByKey: byKeyMap,
      habitsById: habits,
      settings: settings,
      today: upTo,
    );
    final stats = StatEngine.compute(
      days: arcDays,
      logsByKey: byKeyMap,
      habitsById: habits,
    );
    return AchievementEvaluator.evaluate(
      AchievementEvaluator.contextFor(
        logs: logs,
        habitsById: habits,
        streak: streak,
        stats: stats,
        totalXp: totalXp,
        arcLengthDays: arcLength,
        arcId: 1,
        hasBackup: hasBackup,
      ),
    );
  }

  test('the catalogue has the 24 achievements from the spec', () {
    expect(AchievementEvaluator.catalogue.length, 24);
    final ids = AchievementEvaluator.catalogue.map((d) => d.id).toSet();
    expect(ids.length, 24, reason: 'ids are unique');
    expect(
      ids,
      containsAll([
        'first_blood',
        'perfect_day',
        'streak_3',
        'streak_7',
        'streak_14',
        'streak_30',
        'streak_60',
        'streak_100',
        'perfect_arc',
        'ten_perfect_days',
        'early_riser_30',
        'gym_50',
        'steps_500k',
        'gratitude_100',
        'clean_30',
        'hydrated_60',
        'level_10',
        'level_25',
        'level_50',
        'balanced',
        'phoenix',
        'no_shields_30',
        'first_backup',
        'architect',
      ]),
    );
  });

  test('first_blood needs exactly one completion', () {
    final h = {1: habit(id: 1)};
    expect(
      evaluate([
        log(day(0), scheduled: const [1]),
      ], h)['first_blood'],
      0,
    );
    expect(
      evaluate([
        log(day(0), scheduled: const [1], values: const {1: 1.0}),
      ], h)['first_blood'],
      1,
    );
  });

  test('perfect_day requires every scheduled habit, not just one', () {
    final h = {1: habit(id: 1), 2: habit(id: 2)};
    final partial = evaluate([
      log(day(0), scheduled: const [1, 2], values: const {1: 1.0}),
    ], h);
    expect(partial['perfect_day'], 0);

    final full = evaluate([
      log(day(0), scheduled: const [1, 2], values: const {1: 1.0, 2: 1.0}),
    ], h);
    expect(full['perfect_day'], 1);
  });

  test('streak achievements read the best streak', () {
    final h = {1: habit(id: 1)};
    final logs = [
      for (var i = 0; i < 8; i++)
        log(day(i), scheduled: const [1], values: const {1: 1.0}),
    ];
    final p = evaluate(logs, h);
    expect(p['streak_3'], 8);
    expect(p['streak_7'], 8);
    expect(p['streak_14'], 8);
  });

  test('habit-specific counters key off the preset ARB key', () {
    final h = {
      1: habit(id: 1, titleKey: 'habitEarlyWake'),
      2: habit(id: 2, titleKey: 'habitGymWorkout'),
      3: habit(id: 3, titleKey: 'habitNoJunkFood'),
      4: habit(id: 4, titleKey: 'habitWaterOnly'),
    };
    final logs = [
      for (var i = 0; i < 5; i++)
        log(
          day(i),
          scheduled: const [1, 2, 3, 4],
          values: const {1: 1.0, 3: 1.0},
        ),
    ];
    final p = evaluate(logs, h);
    expect(p['early_riser_30'], 5);
    expect(p['gym_50'], 0);
    expect(p['clean_30'], 5);
    expect(p['hydrated_60'], 0);
  });

  test('gratitude_100 counts days with non-empty gratitude', () {
    final h = {1: habit(id: 1)};
    final logs = [
      log(day(0), scheduled: const [1], gratitude: 'coffee'),
      log(day(1), scheduled: const [1], gratitude: '   '),
      log(day(2), scheduled: const [1], gratitude: 'family'),
    ];
    expect(evaluate(logs, h)['gratitude_100'], 2);
  });

  test('steps_500k falls back to logged values without a pedometer', () {
    final h = {
      1: habit(
        id: 1,
        titleKey: 'habitStepsGoal',
        unit: MetricUnits.steps,
        target: 10000,
      ),
    };
    final withSensor = evaluate([
      log(day(0), scheduled: const [1], steps: 12000),
    ], h);
    expect(withSensor['steps_500k'], 12000);

    final manual = evaluate([
      log(
        day(0),
        scheduled: const [1],
        values: const {1: 9000},
        targets: const {1: 10000},
      ),
    ], h);
    expect(manual['steps_500k'], 9000);
  });

  test('meta achievements track backups and custom habits', () {
    final custom = habit(id: 1)..isCustom = true;
    final p = evaluate(const [], {1: custom}, hasBackup: true);
    expect(p['architect'], 1);
    expect(p['first_backup'], 1);

    final q = evaluate(const [], {1: habit(id: 1)});
    expect(q['architect'], 0);
    expect(q['first_backup'], 0);
  });

  test('level achievements read the level derived from total XP', () {
    final p = evaluate(const [], const {}, totalXp: 6 * 81 + 60 * 9);
    expect(p['level_10'], 10);
  });

  group('reconcile', () {
    test('unlocks when progress reaches the target', () {
      final records = AchievementEvaluator.reconcile(
        progress: {'first_blood': 1},
        existing: const {},
        arcId: 1,
        now: DateTime(2026, 9, 5),
      );
      final first = records.firstWhere((r) => r.key == 'first_blood');
      expect(first.isUnlocked, isTrue);
      expect(first.arcId, 1);
    });

    test('never revokes an unlock when the number later drops', () {
      final existing = {
        'streak_7': AchievementRecord.create(
          key: 'streak_7',
          progressTarget: 7,
          progressCurrent: 7,
          unlockedAt: DateTime(2026, 9, 10),
        ),
      };
      final records = AchievementEvaluator.reconcile(
        progress: {'streak_7': 0},
        existing: existing,
        arcId: 1,
        now: DateTime(2026, 9, 20),
      );
      final streak = records.firstWhere((r) => r.key == 'streak_7');
      expect(streak.isUnlocked, isTrue);
      expect(streak.unlockedAt, DateTime(2026, 9, 10));
      expect(streak.progressCurrent, 7, reason: 'high-water mark is kept');
    });

    test('recomputing from scratch after an import unlocks identically', () {
      final h = {1: habit(id: 1)};
      final logs = [
        for (var i = 0; i < 7; i++)
          log(day(i), scheduled: const [1], values: const {1: 1.0}),
      ];
      final progress = evaluate(logs, h);

      // Simulates the post-restore path: no stored records at all.
      final fresh = AchievementEvaluator.reconcile(
        progress: progress,
        existing: const {},
        arcId: 1,
        now: DateTime(2026, 9, 8),
      );
      final unlocked = fresh.where((r) => r.isUnlocked).map((r) => r.key);
      expect(
        unlocked,
        containsAll(['first_blood', 'perfect_day', 'streak_3', 'streak_7']),
      );
      expect(unlocked, isNot(contains('streak_14')));
    });

    test('newlyUnlocked reports only the delta', () {
      final before = {
        'first_blood': AchievementRecord.create(
          key: 'first_blood',
          progressTarget: 1,
          progressCurrent: 1,
          unlockedAt: DateTime(2026, 9, 1),
        ),
      };
      final after = AchievementEvaluator.reconcile(
        progress: {'first_blood': 1, 'perfect_day': 1},
        existing: before,
        arcId: 1,
        now: DateTime(2026, 9, 2),
      );
      expect(AchievementEvaluator.newlyUnlocked(before, after), [
        'perfect_day',
      ]);
    });
  });
}
