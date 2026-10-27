import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../data/models/app_settings.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/arc_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/isar_service.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/arc_state.dart';
import '../../domain/tracker_service.dart';
import '../constants/app_constants.dart';
import '../../features/home_widgets/widget_bridge.dart';
import 'backup_service.dart';
import 'widget_service.dart';

/// The work the periodic background tasks actually do.
///
/// This runs in workmanager's own isolate, which shares nothing with the app:
/// no Riverpod graph, no open Isar handle, no registered plugins. So it opens
/// its own handles, does one small idempotent job, and closes them again -
/// OEM battery managers kill anything that lingers.
///
/// The same entry points are callable from the foreground (see
/// BackgroundService.runNow), which is what makes them testable and what keeps
/// the app working on devices where background execution never runs at all.
abstract final class BackgroundWorker {
  /// Dispatches one task by name. Returns false only for a real failure, so
  /// workmanager retries rather than silently giving up.
  static Future<bool> run(String task) async {
    // The isolate starts with no plugins bound; without this, path_provider,
    // shared_preferences and home_widget all throw MissingPluginException.
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    // When this runs in the foreground (BackgroundService.runNow) the app
    // already owns the Isar handle, and closing it here would pull the database
    // out from under the running UI. Only close what we opened.
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
      if (state == null) {
        // Onboarding is not finished - nothing to do, and nothing is wrong.
        return true;
      }

      switch (task) {
        case AppConstants.taskRefreshWidget:
          await refreshWidget(state);
        case AppConstants.taskAutoBackup:
          await autoBackup(
            state: state,
            settingsRepo: settingsRepo,
            settings: settings,
            isar: isarService,
          );
        case AppConstants.taskReconcileSteps:
          await reconcileSteps(tracker: tracker, state: state);
        default:
          debugPrint('ArcCore: unknown background task "$task"');
      }
      return true;
    } catch (e, st) {
      debugPrint('ArcCore: background task $task failed ($e)\n$st');
      return false;
    } finally {
      // Leaving the handle open in a short-lived isolate keeps a file lock the
      // foreground app may need - but never close a handle we did not open.
      if (preExisting == null) await isarService?.close();
    }
  }

  // ------------------------------------------------------------- the tasks

  /// Pushes today's numbers into the shared container so the home-screen
  /// widget is current without the app being opened.
  ///
  /// Only scalars: `renderFlutterWidget` needs a rendering surface this isolate
  /// does not have, so the PNG is refreshed on the next foreground and the
  /// native provider falls back to its text layout until then.
  static Future<void> refreshWidget(ArcState state) async {
    final widgets = WidgetService();
    await widgets.init();
    await pushWidgetState(state, state.settings);
    await widgets.update();
  }

  /// offline_strategy.auto_backup - "silent daily JSON snapshot to app
  /// documents; rolling retention of the last 7".
  ///
  /// Skips if a snapshot was already written today, so a workmanager retry
  /// storm cannot churn through the retention window.
  static Future<void> autoBackup({
    required ArcState state,
    required SettingsRepository settingsRepo,
    required AppSettings settings,
    required IsarService isar,
  }) async {
    final last = settings.lastBackupAt;
    if (last != null && DateTime.now().difference(last) < _backupInterval) {
      return;
    }

    final service = BackupService(
      habits: HabitRepository(isar.isar),
      logs: DailyLogRepository(isar.isar),
      profiles: ProfileRepository(isar.isar),
      arcs: ArcRepository(isar.isar),
      achievements: AchievementRepository(isar.isar),
    );

    // Auto-backups are never encrypted: the passphrase is only ever held in the
    // user's head, and a background task cannot ask for it.
    await service.autoBackup(settings);
    await settingsRepo.save(settings.copyWith(lastBackupAt: DateTime.now()));
  }

  static const _backupInterval = Duration(hours: 20);

  /// edge_case_handling.pedometer_daily_reset - fold the day's steps into the
  /// steps habit so a full day of walking is not lost because the app was never
  /// opened.
  static Future<void> reconcileSteps({
    required TrackerService tracker,
    required ArcState state,
  }) async {
    final log = state.todayLog;
    if (log == null || log.stepCount <= 0) return;

    final steps = state.activeHabits
        .where((h) => h.titleKey == 'habitStepsGoal')
        .firstOrNull;
    if (steps == null) return;

    final entry = log.entryFor(steps.id);
    if ((entry?.value ?? 0) >= log.stepCount) return;

    await tracker.logHabit(
      state: state,
      habit: steps,
      day: state.today,
      value: log.stepCount.toDouble(),
    );
  }
}
