import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/arc_date.dart';
import 'package:arccore/data/models/daily_log.dart';
import 'package:arccore/data/models/habit.dart';
import 'package:arccore/data/models/habit_entry.dart';

int _nextId = 1;

Habit habit({
  String? titleKey,
  String stat = StatKeys.discipline,
  int xp = 15,
  String unit = MetricUnits.boolean,
  int target = 1,
  String frequencyType = FrequencyTypes.daily,
  int frequencyValue = 1,
  List<int> weekdays = const [1, 2, 3, 4, 5, 6, 7],
  DateTime? createdAt,
  bool archived = false,
  DateTime? archivedAt,
  int? id,
}) {
  final h = Habit.create(
    titleKey: titleKey,
    statAttribute: stat,
    xpReward: xp,
    metricUnit: unit,
    targetMetric: target,
    frequencyType: frequencyType,
    frequencyValue: frequencyValue,
    activeWeekdays: weekdays,
    createdAt: createdAt ?? DateTime(2020),
    isArchived: archived,
    archivedAt: archivedAt,
  );
  h.id = id ?? _nextId++;
  return h;
}

DailyLog log(
  DateTime day, {
  List<int> scheduled = const [],
  Map<int, double> values = const {},
  Map<int, double> targets = const {},
  bool preInstall = false,
  int steps = 0,
  String gratitude = '',
}) {
  final l = DailyLog.create(
    dateKey: ArcDate.keyOf(day),
    date: ArcDate.dayOnly(day),
    arcId: 1,
    isPreInstall: preInstall,
    scheduledHabitIds: List<int>.from(scheduled),
  );
  l.stepCount = steps;
  l.gratitudeText = gratitude;
  values.forEach((habitId, value) {
    final target = targets[habitId] ?? 1;
    final ratio = (value / target).clamp(0.0, 1.0);
    l.entries.add(
      HabitEntry.create(
        habitId: habitId,
        habitVersion: 1,
        value: value,
        targetAtTime: target,
        completionRatio: ratio,
        isComplete: value >= target,
        awardedXp: value >= target ? 15 : 0,
        loggedLate: false,
        loggedAt: DateTime(day.year, day.month, day.day, 9).toUtc(),
      ),
    );
  });
  return l;
}

Map<String, DailyLog> byKey(List<DailyLog> logs) => {
  for (final l in logs) l.dateKey: l,
};
