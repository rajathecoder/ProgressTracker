import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../../data/models/achievement.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/arc.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/arc_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/arc_state.dart';
import '../../domain/tracker_service.dart';
import '../services/app_lock_service.dart';
import '../services/backup_service.dart';
import '../services/background_service.dart';
import '../services/feedback_service.dart';
import '../services/migration_service.dart';
import '../services/notification_service.dart';
import '../services/pedometer_service.dart';
import '../services/permission_service.dart';
import '../services/share_service.dart';
import '../services/widget_service.dart';
import '../theme/app_theme.dart';

/// Everything resolved during startup, injected once so the widget tree never
/// awaits a plugin.
class AppBootstrap {
  const AppBootstrap({
    required this.isar,
    required this.settingsRepo,
    required this.settings,
    required this.schemaVersion,
  });

  final Isar isar;
  final SettingsRepository settingsRepo;
  final AppSettings settings;
  final int schemaVersion;
}

/// Overridden in main() once startup completes.
final bootstrapProvider = Provider<AppBootstrap>(
  (ref) => throw UnimplementedError('bootstrapProvider must be overridden'),
);

final isarProvider = Provider<Isar>((ref) => ref.watch(bootstrapProvider).isar);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => ref.watch(bootstrapProvider).settingsRepo,
);

// ------------------------------------------------------------- repositories

final habitRepositoryProvider = Provider(
  (ref) => HabitRepository(ref.watch(isarProvider)),
);
final dailyLogRepositoryProvider = Provider(
  (ref) => DailyLogRepository(ref.watch(isarProvider)),
);
final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.watch(isarProvider)),
);
final arcRepositoryProvider = Provider(
  (ref) => ArcRepository(ref.watch(isarProvider)),
);
final achievementRepositoryProvider = Provider(
  (ref) => AchievementRepository(ref.watch(isarProvider)),
);

// ----------------------------------------------------------------- services

final notificationServiceProvider = Provider(
  (ref) => NotificationService.instance(),
);
final permissionServiceProvider = Provider((ref) => PermissionService());
final appLockServiceProvider = Provider((ref) => AppLockService());
final shareServiceProvider = Provider((ref) => ShareService());
final widgetServiceProvider = Provider((ref) => WidgetService());
final backgroundServiceProvider = Provider((ref) => BackgroundService());

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  final service = FeedbackService();
  final settings = ref.watch(settingsProvider);
  service.configure(
    haptics: settings.hapticsEnabled,
    sound: settings.soundEnabled,
  );
  ref.onDispose(service.dispose);
  return service;
});

final pedometerServiceProvider = Provider<PedometerService>((ref) {
  final service = PedometerService(ref.watch(settingsRepositoryProvider));
  ref.onDispose(service.dispose);
  return service;
});

final backupServiceProvider = Provider(
  (ref) => BackupService(
    habits: ref.watch(habitRepositoryProvider),
    logs: ref.watch(dailyLogRepositoryProvider),
    profiles: ref.watch(profileRepositoryProvider),
    arcs: ref.watch(arcRepositoryProvider),
    achievements: ref.watch(achievementRepositoryProvider),
  ),
);

final migrationServiceProvider = Provider(
  (ref) => MigrationService(
    ref.watch(isarProvider),
    ref.watch(settingsRepositoryProvider),
  ),
);

final trackerServiceProvider = Provider(
  (ref) => TrackerService(
    habits: ref.watch(habitRepositoryProvider),
    logs: ref.watch(dailyLogRepositoryProvider),
    profiles: ref.watch(profileRepositoryProvider),
    arcs: ref.watch(arcRepositoryProvider),
    achievements: ref.watch(achievementRepositoryProvider),
    settingsRepo: ref.watch(settingsRepositoryProvider),
  ),
);

// ----------------------------------------------------------------- settings

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._repo) : super(_repo.load());

  final SettingsRepository _repo;

  Future<void> update(AppSettings next) async {
    state = next;
    await _repo.save(next);
  }

  Future<void> mutate(AppSettings Function(AppSettings) f) => update(f(state));
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.watch(settingsRepositoryProvider)),
);

// -------------------------------------------------------------------- theme

/// Set while the user is still choosing a theme in onboarding, where there is
/// no profile to read from yet. Letting the whole app repaint as they tap is
/// the only way to actually see what they are picking.
final themeOverrideProvider = StateProvider<ThemeMode?>((ref) => null);

final themeModeProvider = Provider<ThemeMode>((ref) {
  final override = ref.watch(themeOverrideProvider);
  if (override != null) return override;
  final arc = ref.watch(arcStateProvider).valueOrNull;
  // The profile (source of truth for themePreference) lives in Isar and
  // resolves a beat after the very first frame; until it does, fall back to
  // the cache in AppSettings - loaded synchronously before runApp - rather
  // than ThemeMode.system, which flashed dark on the boot skeleton for
  // anyone with system dark mode on but the app set to light.
  final preference =
      arc?.profile.themePreference ??
      ref.watch(settingsProvider).themePreferenceCache;
  return themeModeFor(preference);
});

ThemeMode themeModeFor(String preference) => switch (preference) {
  'light' => ThemeMode.light,
  'dark' => ThemeMode.dark,
  _ => ThemeMode.system,
};

final lightThemeProvider = Provider<ThemeData>((ref) {
  final s = ref.watch(settingsProvider);
  return AppTheme.build(
    dark: false,
    highContrast: s.highContrast,
    reduceMotion: s.reduceMotion,
  );
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final s = ref.watch(settingsProvider);
  return AppTheme.build(
    dark: true,
    highContrast: s.highContrast,
    reduceMotion: s.reduceMotion,
  );
});

final localeProvider = Provider<Locale?>((ref) {
  final code = ref.watch(settingsProvider).localeOverride;
  return code == null ? null : Locale(code);
});

/// Which tab the shell is showing.
///
/// Deliberately not widget State: tapping a home-screen widget can restart the
/// Activity, which rebuilds the shell and would reset an in-State index back to
/// the dashboard - so a deep link appeared to work and then snapped back.
final shellTabProvider = StateProvider<int>((ref) => 0);

/// The last reschedule outcome, so the dashboard can warn the user when their
/// reminders are silently not armed rather than letting them find out by
/// missing a week of them.
final reminderHealthProvider = StateProvider<ScheduleReport>(
  (ref) => ScheduleReport.none,
);

// ---------------------------------------------------------------- arc state

/// The one derived state every screen reads.
///
/// It re-resolves whenever Isar signals a change to habits, logs, the profile
/// or achievements, so a write anywhere refreshes everything consistently.
class ArcStateNotifier extends StateNotifier<AsyncValue<ArcState?>> {
  ArcStateNotifier(this._ref) : super(const AsyncValue.loading()) {
    _listen();
    refresh();
  }

  final Ref _ref;
  final _subs = <void Function()>[];

  void _listen() {
    final isar = _ref.read(isarProvider);
    for (final stream in [
      isar.habits.watchLazy(),
      isar.dailyLogs.watchLazy(),
      isar.userProfiles.watchLazy(),
      isar.achievementRecords.watchLazy(),
      isar.arcs.watchLazy(),
    ]) {
      final sub = stream.listen((_) => refresh());
      _subs.add(sub.cancel);
    }

    // Settings are *listened* to rather than watched, so that changing a rule
    // recomputes the arc in place. Watching would dispose and rebuild this
    // notifier, which would drop the state back to `loading` and flash the boot
    // skeleton over the whole app on every settings write.
    _ref.listen<AppSettings>(settingsProvider, (previous, next) {
      if (previous == null || _rulesChanged(previous, next)) refresh();
    });
  }

  /// Only settings that actually alter derived numbers force a recompute.
  static bool _rulesChanged(AppSettings a, AppSettings b) =>
      a.dayRolloverHour != b.dayRolloverHour ||
      a.retroLoggingDays != b.retroLoggingDays ||
      a.hardcoreMode != b.hardcoreMode ||
      a.partialCreditEnabled != b.partialCreditEnabled ||
      a.lastBackupAt != b.lastBackupAt;

  bool _refreshing = false;
  bool _queued = false;

  Future<void> refresh() async {
    if (_refreshing) {
      _queued = true;
      return;
    }
    _refreshing = true;
    try {
      final tracker = _ref.read(trackerServiceProvider);
      final settings = _ref.read(settingsProvider);
      final next = await tracker.load(settings);
      if (mounted) state = AsyncValue.data(next);
    } catch (e, st) {
      // Keep the last good state on screen rather than blanking the app; the
      // error still surfaces on a cold start, where there is nothing to keep.
      if (mounted) {
        state = state.hasValue
            ? AsyncValue<ArcState?>.data(state.value).copyWithPrevious(state)
            : AsyncValue.error(e, st);
      }
    } finally {
      _refreshing = false;
      if (_queued) {
        _queued = false;
        await refresh();
      }
    }
  }

  @override
  void dispose() {
    for (final cancel in _subs) {
      cancel();
    }
    super.dispose();
  }
}

final arcStateProvider =
    StateNotifierProvider<ArcStateNotifier, AsyncValue<ArcState?>>(
      ArcStateNotifier.new,
    );

/// Convenience: the resolved state, or null while loading / pre-onboarding.
final arcProvider = Provider<ArcState?>(
  (ref) => ref.watch(arcStateProvider).valueOrNull,
);

final onboardingCompleteProvider = Provider<bool>((ref) {
  final async = ref.watch(arcStateProvider);
  return async.valueOrNull != null;
});
