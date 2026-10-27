import 'package:isar_community/isar.dart';

import '../../core/utils/arc_date.dart';
import '../models/daily_log.dart';

class DailyLogRepository {
  DailyLogRepository(this._isar);
  final Isar _isar;

  Stream<List<DailyLog>> watchForArc(int arcId) => _isar.dailyLogs
      .filter()
      .arcIdEqualTo(arcId)
      .watch(fireImmediately: true)
      .map(_sorted);

  Future<List<DailyLog>> forArc(int arcId) async =>
      _sorted(await _isar.dailyLogs.filter().arcIdEqualTo(arcId).findAll());

  /// A date-windowed query for the matrix, per
  /// performance_budget.matrix_grid ("watch a date-windowed Isar query, not the
  /// whole arc; widen the window on scroll").
  Future<List<DailyLog>> inRange(int arcId, DateTime from, DateTime to) async =>
      _sorted(
        await _isar.dailyLogs
            .filter()
            .arcIdEqualTo(arcId)
            .and()
            .dateBetween(ArcDate.dayOnly(from), ArcDate.dayOnly(to))
            .findAll(),
      );

  Future<DailyLog?> byKey(String dateKey, int arcId) => _isar.dailyLogs
      .filter()
      .dateKeyEqualTo(dateKey)
      .and()
      .arcIdEqualTo(arcId)
      .findFirst();

  /// Upsert - never append. Two writes for the same day collapse onto one row,
  /// which is what makes clock tampering unable to farm duplicate XP
  /// (edge_case_handling.clock_tampering).
  Future<int> save(DailyLog log) =>
      _isar.writeTxn(() => _isar.dailyLogs.put(log));

  Future<void> saveAll(List<DailyLog> logs) =>
      _isar.writeTxn(() => _isar.dailyLogs.putAll(logs));

  Future<List<DailyLog>> search(int arcId, String query) async {
    final q = query.trim().toLowerCase();
    final all = await forArc(arcId);
    if (q.isEmpty) return all.where((l) => l.hasJournalContent).toList();
    return all
        .where(
          (l) =>
              l.gratitudeText.toLowerCase().contains(q) ||
              l.progressNotes.toLowerCase().contains(q) ||
              l.tags.any((t) => t.toLowerCase().contains(q)),
        )
        .toList();
  }

  /// journalOnThisDay - the same calendar day in previous years, plus the same
  /// day-of-month in previous months of this arc.
  Future<List<DailyLog>> onThisDay(DateTime day) async {
    final all = await _isar.dailyLogs.where().findAll();
    return all
        .where(
          (l) =>
              l.hasJournalContent &&
              l.date.day == day.day &&
              !(l.date.month == day.month && l.date.year == day.year),
        )
        .toList();
  }

  Future<void> deleteAll() =>
      _isar.writeTxn(() => _isar.dailyLogs.where().deleteAll());

  Future<int> countForArc(int arcId) =>
      _isar.dailyLogs.filter().arcIdEqualTo(arcId).count();

  static List<DailyLog> _sorted(List<DailyLog> logs) {
    final list = List<DailyLog>.from(logs);
    list.sort((a, b) => a.dateKey.compareTo(b.dateKey));
    return list;
  }
}
