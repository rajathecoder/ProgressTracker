import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/widget_service.dart';
import '../../data/models/app_settings.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/arc_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/isar_service.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/arc_state.dart';
import '../../domain/engines/level_engine.dart';
import '../../domain/tracker_service.dart';
import '../focus/focus_session_store.dart';

/// Entry point for taps on an interactive widget.
///
/// Android hands the tap to a broadcast receiver, which spins up a *fresh*
/// Dart isolate and calls this. Nothing from the running app is available here
/// - no Riverpod graph, no open database - so it opens its own handles, makes
/// one small change, pushes the result back to the widget, and closes up.
///
/// It must be a top-level function marked `vm:entry-point` or the tree-shaker
/// removes it and the widget silently does nothing in release builds.
@pragma('vm:entry-point')
Future<void> widgetInteractionCallback(Uri? uri) async {
  if (uri == null) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  try {
    switch (uri.host) {
      case WidgetActions.toggleHabit:
        final id = int.tryParse(uri.queryParameters['id'] ?? '');
        if (id != null) await _toggleHabit(id);
      case WidgetActions.focus:
        await _focusAction(uri.queryParameters['action'] ?? 'toggle');
      default:
        break;
    }
  } catch (e, st) {
    debugPrint('Happy Days: widget action failed ($e)\n$st');
  }
}

abstract final class WidgetActions {
  static const scheme = 'happydays';
  static const toggleHabit = 'toggle';
  static const focus = 'focus';

  static Uri toggle(int habitId) =>
      Uri.parse('$scheme://$toggleHabit?id=$habitId');
  static Uri focusToggle() => Uri.parse('$scheme://$focus?action=toggle');
}

// ----------------------------------------------------------------- habits

Future<void> _toggleHabit(int habitId) async {
  final preExisting = IsarService.instanceOrNull;
  IsarService? isarService;
  try {
    final settingsRepo = await SettingsRepository.open();
    final settings = settingsRepo.load();
    isarService = await IsarService.open();
    final isar = isarService.isar;

    final tracker = TrackerService(
      habits: HabitRepository(isar),
      logs: DailyLogRepository(isar),
      profiles: ProfileRepository(isar),
      arcs: ArcRepository(isar),
      achievements: AchievementRepository(isar),
      settingsRepo: settingsRepo,
    );

    final state = await tracker.load(settings);
    if (state == null) return;

    final habit = state.habitsById[habitId];
    if (habit == null) return;

    // Only boolean habits can be completed from a widget - anything with a
    // target needs a value, so those deep-link into the app instead.
    if (!habit.isBoolean) return;

    await tracker.toggleHabit(state: state, habit: habit, day: state.today);

    final refreshed = await tracker.load(settings);
    if (refreshed != null) await pushWidgetState(refreshed, settings);
  } finally {
    if (preExisting == null) await isarService?.close();
  }
}

// ------------------------------------------------------------------ focus

Future<void> _focusAction(String action) async {
  final now = DateTime.now();
  var snapshot = await FocusSessionStore.load();

  snapshot = switch (action) {
    'start' => FocusSessionStore.start(snapshot, now),
    'pause' => FocusSessionStore.pause(snapshot, now),
    // Stop banks whatever was completed before clearing, so a session the user
    // ends early still counts the minutes they actually did.
    'stop' || 'reset' => await _stopAndBank(snapshot, now),
    _ => FocusSessionStore.toggle(snapshot, now),
  };

  // A session that ran to completion while only the widget was on screen still
  // has to be banked, or the minutes are simply lost.
  if (snapshot.isCompleteAt(now)) {
    final minutes = snapshot.totalSeconds ~/ 60;
    await _logFocusMinutes(minutes);
    snapshot = FocusSessionStore.reset(snapshot);
  }

  await FocusSessionStore.save(snapshot);
  await _pushFocus(snapshot);
  await WidgetService().update();
}

/// Ends a session and credits the whole minutes already served.
Future<FocusSnapshot> _stopAndBank(FocusSnapshot s, DateTime now) async {
  final minutes = s.elapsedSecondsAt(now) ~/ 60;
  if (minutes > 0) await _logFocusMinutes(minutes);
  return FocusSessionStore.reset(s);
}

Future<void> _logFocusMinutes(int minutes) async {
  if (minutes <= 0) return;
  final preExisting = IsarService.instanceOrNull;
  IsarService? isarService;
  try {
    final settingsRepo = await SettingsRepository.open();
    final settings = settingsRepo.load();
    isarService = await IsarService.open();
    final isar = isarService.isar;

    final tracker = TrackerService(
      habits: HabitRepository(isar),
      logs: DailyLogRepository(isar),
      profiles: ProfileRepository(isar),
      arcs: ArcRepository(isar),
      achievements: AchievementRepository(isar),
      settingsRepo: settingsRepo,
    );
    final state = await tracker.load(settings);
    if (state == null) return;
    await tracker.addFocusSession(
      state: state,
      day: state.today,
      minutes: minutes,
    );
  } finally {
    if (preExisting == null) await isarService?.close();
  }
}

// ------------------------------------------------------- shared data push

/// Everything the native widget layouts read.
///
/// Kept in one function so the app, the background task and the widget
/// callback all publish exactly the same shape.
Future<void> pushWidgetState(ArcState arc, AppSettings settings) async {
  final log = arc.todayLog;
  final scheduled = arc.scheduledToday();

  await HomeWidget.saveWidgetData<int>('arc_day', arc.arcDayNumber);
  await HomeWidget.saveWidgetData<int>('arc_length', arc.arc.lengthDays);
  await HomeWidget.saveWidgetData<int>('completed', arc.todayCompleted);
  await HomeWidget.saveWidgetData<int>('scheduled', arc.todayScheduledCount);
  await HomeWidget.saveWidgetData<int>('streak', arc.streak.currentStreak);
  await HomeWidget.saveWidgetData<int>('level', arc.level);
  await HomeWidget.saveWidgetData<String>(
    'rank',
    LevelEngine.rankKeyForLevel(arc.level),
  );
  await HomeWidget.saveWidgetData<String>('nickname', arc.profile.nickname);

  // The Today widget is drawn natively from these rows so each one can carry
  // its own tap target - an image cannot.
  final rows = scheduled.take(AppConstants.widgetTodayRows).toList();
  await HomeWidget.saveWidgetData<int>('today_count', rows.length);
  await HomeWidget.saveWidgetData<int>(
    'today_remaining',
    arc.todayScheduledCount - arc.todayCompleted,
  );
  for (var i = 0; i < AppConstants.widgetTodayRows; i++) {
    final habit = i < rows.length ? rows[i] : null;
    await HomeWidget.saveWidgetData<int>('today_${i}_id', habit?.id ?? -1);
    await HomeWidget.saveWidgetData<String>(
      'today_${i}_title',
      habit == null ? '' : widgetHabitTitle(habit.titleKey, habit.customTitle),
    );
    await HomeWidget.saveWidgetData<bool>(
      'today_${i}_done',
      habit != null && (log?.entryFor(habit.id)?.isComplete ?? false),
    );
    await HomeWidget.saveWidgetData<bool>(
      'today_${i}_metric',
      habit != null && !habit.isBoolean,
    );
  }

  await _pushFocus(await FocusSessionStore.load());
}

Future<void> _pushFocus(FocusSnapshot snapshot) async {
  final now = DateTime.now();
  await HomeWidget.saveWidgetData<int>(
    'focus_remaining_seconds',
    snapshot.remainingSecondsAt(now),
  );
  await HomeWidget.saveWidgetData<bool>('focus_running', snapshot.isRunning);
  await HomeWidget.saveWidgetData<int>(
    'focus_total_minutes',
    snapshot.totalSeconds ~/ 60,
  );
}

/// The widget renders outside any Localizations scope, so a preset habit's ARB
/// key is turned into something readable rather than shown raw.
String widgetHabitTitle(String? titleKey, String? customTitle) {
  if (customTitle != null && customTitle.trim().isNotEmpty) return customTitle;
  if (titleKey == null) return 'Habit';
  final stripped = titleKey.startsWith('habit')
      ? titleKey.substring(5)
      : titleKey;
  final buffer = StringBuffer();
  for (var i = 0; i < stripped.length; i++) {
    final c = stripped[i];
    if (i > 0 && c.toUpperCase() == c && c.toLowerCase() != c) {
      buffer.write(' ');
    }
    buffer.write(i == 0 ? c.toUpperCase() : c);
  }
  return buffer.toString();
}
