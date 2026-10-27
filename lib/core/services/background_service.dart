import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';
import 'background_worker.dart';

/// tech_stack.new_dependencies_v1_3.workmanager
///
/// "Periodic background task to refresh home widget data, run auto-backup, and
/// reconcile pedometer daily totals."
///
/// Must be a top-level function annotated `vm:entry-point`, because the OS
/// re-enters the Dart VM here from a fresh isolate. All the actual work lives
/// in [BackgroundWorker] so it can also be run from the foreground.
@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) => BackgroundWorker.run(task));
}

class BackgroundService {
  BackgroundService();

  bool get supported => Platform.isAndroid || Platform.isIOS;

  Future<void> init() async {
    if (!supported) return;
    try {
      await Workmanager().initialize(backgroundCallbackDispatcher);
    } catch (e) {
      debugPrint('ArcCore: workmanager init failed ($e)');
    }
  }

  Future<void> schedulePeriodic() async {
    if (!supported) return;
    try {
      // Android's minimum periodic interval is 15 minutes and it batches
      // aggressively; these are best-effort refreshes, never the only path.
      await Workmanager().registerPeriodicTask(
        AppConstants.taskRefreshWidget,
        AppConstants.taskRefreshWidget,
        frequency: const Duration(hours: 1),
        initialDelay: const Duration(minutes: 15),
        constraints: Constraints(networkType: NetworkType.notRequired),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
      await Workmanager().registerPeriodicTask(
        AppConstants.taskAutoBackup,
        AppConstants.taskAutoBackup,
        frequency: const Duration(hours: 24),
        initialDelay: const Duration(hours: 1),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresCharging: false,
          requiresBatteryNotLow: true,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
      await Workmanager().registerPeriodicTask(
        AppConstants.taskReconcileSteps,
        AppConstants.taskReconcileSteps,
        frequency: const Duration(hours: 6),
        initialDelay: const Duration(hours: 1),
        constraints: Constraints(networkType: NetworkType.notRequired),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    } catch (e) {
      debugPrint('ArcCore: workmanager schedule failed ($e)');
    }
  }

  /// Runs a task immediately in the foreground isolate.
  ///
  /// Background execution is a best-effort favour from the OS - on an
  /// aggressive OEM it may simply never happen. Every task is therefore also
  /// reachable synchronously, which is what actually keeps the widget and the
  /// backups current for those users.
  Future<bool> runNow(String task) => BackgroundWorker.run(task);

  /// Fires a task through workmanager once, to verify the plumbing end to end.
  Future<void> requestOneOff(String task) async {
    if (!supported) return;
    try {
      await Workmanager().registerOneOffTask(
        '$task.oneoff',
        task,
        initialDelay: const Duration(seconds: 5),
        constraints: Constraints(networkType: NetworkType.notRequired),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (e) {
      debugPrint('ArcCore: one-off $task failed ($e)');
    }
  }

  Future<void> cancelAll() async {
    if (!supported) return;
    try {
      await Workmanager().cancelAll();
    } catch (_) {}
  }
}
