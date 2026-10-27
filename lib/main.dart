import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:home_widget/home_widget.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/providers/app_providers.dart';
import 'core/services/migration_service.dart';
import 'data/repositories/isar_service.dart';
import 'data/repositories/settings_repository.dart';
import 'features/home_widgets/widget_bridge.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // performance_budget.frame_targets.android_high_refresh:
  // Android does not grant Flutter apps 90/120Hz by default, so the "120 FPS"
  // design goal is unreachable without opting in explicitly.
  if (!kIsWeb && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (e) {
      debugPrint('ArcCore: high refresh rate unavailable ($e)');
    }
  }

  // Taps on an interactive widget wake a background isolate and call this.
  // Registering it before the first frame means a widget tapped while the app
  // was closed still does the right thing.
  try {
    await HomeWidget.setAppGroupId(AppConstants.appGroupId);
    await HomeWidget.registerInteractivityCallback(widgetInteractionCallback);
  } catch (e) {
    debugPrint('Happy Days: widget interactivity unavailable ($e)');
  }

  final settingsRepo = await SettingsRepository.open();
  final isarService = await IsarService.open();

  // data_integrity.schema_migration: migrations run inside a write transaction
  // before the first read, never after the UI has started rendering stale rows.
  final schemaVersion = await MigrationService(
    isarService.isar,
    settingsRepo,
  ).run();

  runApp(
    ProviderScope(
      overrides: [
        bootstrapProvider.overrideWithValue(
          AppBootstrap(
            isar: isarService.isar,
            settingsRepo: settingsRepo,
            settings: settingsRepo.load(),
            schemaVersion: schemaVersion,
          ),
        ),
      ],
      child: const ArcCoreApp(),
    ),
  );

  assert(() {
    debugPrint('ArcCore ${AppConstants.appVersion} - schema v$schemaVersion');
    return true;
  }());
}
