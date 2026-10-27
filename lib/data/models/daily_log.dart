import 'package:isar_community/isar.dart';

import 'habit_entry.dart';

part 'daily_log.g.dart';

/// data_models.DailyLog
///
/// One row per local calendar day, keyed by [dateKey]. The key is a string,
/// not a DateTime, because it has to survive timezone travel and DST
/// (edge_case_handling.timezone_travel_and_dst).
@collection
class DailyLog {
  Id id = Isar.autoIncrement;

  /// 'yyyy-MM-dd' in the user's local calendar, resolved through
  /// effectiveDateKey() - never DateTime.now().day inline.
  @Index(unique: true, replace: true, composite: [CompositeIndex('arcId')])
  String dateKey = '';

  /// Normalised to midnight local. Kept for range queries and charts.
  @Index()
  DateTime date = DateTime.now();

  @Index()
  int arcId = 0;

  /// Isar returns fixed-length lists for embedded collections, so anything that
  /// mutates this must assign a fresh growable list rather than editing it in
  /// place. See TrackerService.logHabit.
  List<HabitEntry> entries = [];

  /// Snapshot of which habits were actually due that day. Without this the
  /// completion-rate denominator is a guess (analytics_engine).
  List<int> scheduledHabitIds = [];

  int stepCount = 0;

  /// Minutes of completed concentration sessions on this day.
  int focusMinutes = 0;

  /// How many sessions produced those minutes - two 25s read very differently
  /// from one 50, so both are kept.
  int focusSessions = 0;

  String gratitudeText = '';

  String progressNotes = '';

  /// 1-5, null when not answered.
  int? mood;

  List<String> tags = [];

  /// Local file paths only. Nothing is ever uploaded.
  List<String> photoPaths = [];

  int totalXpEarned = 0;

  double multiplierApplied = 1.0;

  bool shieldConsumed = false;

  /// Day fell before the app was installed - rendered neutral and excluded
  /// from every rate (edge_case_handling.arc_started_before_install).
  bool isPreInstall = false;

  DailyLog();

  DailyLog.create({
    required this.dateKey,
    required this.date,
    required this.arcId,
    this.isPreInstall = false,
    List<int>? scheduledHabitIds,
  }) : scheduledHabitIds = scheduledHabitIds ?? [];

  HabitEntry? entryFor(int habitId) {
    for (final e in entries) {
      if (e.habitId == habitId) return e;
    }
    return null;
  }

  @ignore
  int get completedCount => entries.where((e) => e.isComplete).length;

  @ignore
  bool get hasJournalContent =>
      gratitudeText.trim().isNotEmpty ||
      progressNotes.trim().isNotEmpty ||
      mood != null ||
      photoPaths.isNotEmpty;

  /// A perfect day: every scheduled habit complete, and at least one was due.
  @ignore
  bool get isPerfectDay {
    if (isPreInstall || scheduledHabitIds.isEmpty) return false;
    for (final id in scheduledHabitIds) {
      final e = entryFor(id);
      if (e == null || !e.isComplete) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date_key': dateKey,
    'date': date.toIso8601String(),
    'arc_id': arcId,
    'entries': entries.map((e) => e.toJson()).toList(),
    'scheduled_habit_ids': scheduledHabitIds,
    'step_count': stepCount,
    'focus_minutes': focusMinutes,
    'focus_sessions': focusSessions,
    'gratitude_text': gratitudeText,
    'progress_notes': progressNotes,
    'mood': mood,
    'tags': tags,
    'photo_paths': photoPaths,
    'total_xp_earned': totalXpEarned,
    'multiplier_applied': multiplierApplied,
    'shield_consumed': shieldConsumed,
    'is_pre_install': isPreInstall,
  };

  static DailyLog fromJson(Map<String, dynamic> j) => DailyLog()
    ..id = (j['id'] as num?)?.toInt() ?? Isar.autoIncrement
    ..dateKey = j['date_key'] as String? ?? ''
    ..date = DateTime.tryParse(j['date'] as String? ?? '') ?? DateTime.now()
    ..arcId = (j['arc_id'] as num?)?.toInt() ?? 0
    ..entries =
        (j['entries'] as List?)
            ?.map(
              (e) => HabitEntry.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList() ??
        []
    ..scheduledHabitIds =
        (j['scheduled_habit_ids'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        []
    ..stepCount = (j['step_count'] as num?)?.toInt() ?? 0
    ..focusMinutes = (j['focus_minutes'] as num?)?.toInt() ?? 0
    ..focusSessions = (j['focus_sessions'] as num?)?.toInt() ?? 0
    ..gratitudeText = j['gratitude_text'] as String? ?? ''
    ..progressNotes = j['progress_notes'] as String? ?? ''
    ..mood = (j['mood'] as num?)?.toInt()
    ..tags = (j['tags'] as List?)?.map((e) => e as String).toList() ?? []
    ..photoPaths =
        (j['photo_paths'] as List?)?.map((e) => e as String).toList() ?? []
    ..totalXpEarned = (j['total_xp_earned'] as num?)?.toInt() ?? 0
    ..multiplierApplied = (j['multiplier_applied'] as num?)?.toDouble() ?? 1.0
    ..shieldConsumed = j['shield_consumed'] as bool? ?? false
    ..isPreInstall = j['is_pre_install'] as bool? ?? false;
}
