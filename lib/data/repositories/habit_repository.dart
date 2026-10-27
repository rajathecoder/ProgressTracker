import 'package:isar_community/isar.dart';

import '../../core/constants/app_constants.dart';
import '../models/habit.dart';

class HabitRepository {
  HabitRepository(this._isar);
  final Isar _isar;

  Stream<List<Habit>> watchForArc(int arcId) => _isar.habits
      .filter()
      .arcIdEqualTo(arcId)
      .watch(fireImmediately: true)
      .map(_sorted);

  Future<List<Habit>> forArc(int arcId) async =>
      _sorted(await _isar.habits.filter().arcIdEqualTo(arcId).findAll());

  Future<List<Habit>> activeForArc(int arcId) async => _sorted(
    await _isar.habits
        .filter()
        .arcIdEqualTo(arcId)
        .and()
        .isArchivedEqualTo(false)
        .findAll(),
  );

  Future<Habit?> byId(int id) => _isar.habits.get(id);

  Future<int> save(Habit habit) async {
    habit.xpReward = habit.xpReward.clamp(
      AppConstants.minHabitXp,
      AppConstants.maxHabitXp,
    );
    return _isar.writeTxn(() => _isar.habits.put(habit));
  }

  /// A semantic edit bumps [Habit.version] so historical entries stay pinned to
  /// the definition they were awarded under
  /// (edge_case_handling.habit_edited_mid_arc).
  Future<void> saveEdit(Habit habit) async {
    habit.version += 1;
    await save(habit);
  }

  Future<void> saveAll(List<Habit> habits) => _isar.writeTxn(() async {
    for (final h in habits) {
      h.xpReward = h.xpReward.clamp(
        AppConstants.minHabitXp,
        AppConstants.maxHabitXp,
      );
    }
    await _isar.habits.putAll(habits);
  });

  /// Archiving preserves every historical record - it only removes the habit
  /// from future days (core_features.habit_library).
  Future<void> setArchived(Habit habit, bool archived) async {
    habit.isArchived = archived;
    habit.archivedAt = archived ? DateTime.now() : null;
    await save(habit);
  }

  Future<void> reorder(List<Habit> ordered) async {
    for (var i = 0; i < ordered.length; i++) {
      ordered[i].sortOrder = i;
    }
    await saveAll(ordered);
  }

  Future<void> delete(int id) => _isar.writeTxn(() => _isar.habits.delete(id));

  Future<void> deleteAll() =>
      _isar.writeTxn(() => _isar.habits.where().deleteAll());

  static List<Habit> _sorted(List<Habit> habits) {
    final list = List<Habit>.from(habits);
    list.sort((a, b) {
      if (a.isArchived != b.isArchived) return a.isArchived ? 1 : -1;
      final c = a.sortOrder.compareTo(b.sortOrder);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return list;
  }
}
