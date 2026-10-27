import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';

abstract final class AppLockScope {
  static const journal = 'journal';
  static const app = 'app';
}

/// data_models.AppSettings - shared_preferences backed, deliberately outside
/// Isar and outside XP logic.
@immutable
class AppSettings {
  const AppSettings({
    this.dayRolloverHour = AppConstants.defaultDayRolloverHour,
    this.retroLoggingDays = AppConstants.defaultRetroLoggingDays,
    this.hardcoreMode = false,
    this.partialCreditEnabled = true,
    this.reduceMotion = false,
    this.highContrast = false,
    this.soundEnabled = false,
    this.hapticsEnabled = true,
    this.appLockEnabled = false,
    this.appLockScope = AppLockScope.journal,
    this.localeOverride,
    this.lastBackupAt,
    this.lastBootRescheduleAt,
    this.notificationsEnabled = true,
    this.reminderTimes = const {
      'morning_call': '05:30',
      'nutrition_reminders': '12:30',
      'activity_reminders': '17:30',
      'evening_review': '21:30',
    },
    this.batteryPrimerShown = false,
    this.pedometerAvailable = true,
    this.themePreferenceCache = 'system',
  });

  final int dayRolloverHour;
  final int retroLoggingDays;
  final bool hardcoreMode;
  final bool partialCreditEnabled;
  final bool reduceMotion;
  final bool highContrast;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool appLockEnabled;
  final String appLockScope;
  final String? localeOverride;
  final DateTime? lastBackupAt;
  final DateTime? lastBootRescheduleAt;
  final bool notificationsEnabled;
  final Map<String, String> reminderTimes;
  final bool batteryPrimerShown;
  final bool pedometerAvailable;

  /// Mirrors [UserProfile.themePreference] so the very first frame can pick
  /// the right theme synchronously. AppSettings loads before `runApp`; the
  /// profile it actually mirrors lives in Isar and resolves a beat later, so
  /// without this cache the boot skeleton briefly renders `ThemeMode.system`
  /// - a visible flash to dark on any device with system dark mode on, even
  /// when the user picked light inside the app.
  final String themePreferenceCache;

  /// Hardcore Mode disables both shields and backfill
  /// (streak_resilience.shield_rules.disabled_by).
  bool get shieldsEnabled => !hardcoreMode;
  int get effectiveRetroDays => hardcoreMode ? 0 : retroLoggingDays;

  AppSettings copyWith({
    int? dayRolloverHour,
    int? retroLoggingDays,
    bool? hardcoreMode,
    bool? partialCreditEnabled,
    bool? reduceMotion,
    bool? highContrast,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? appLockEnabled,
    String? appLockScope,
    String? localeOverride,
    bool clearLocaleOverride = false,
    DateTime? lastBackupAt,
    DateTime? lastBootRescheduleAt,
    bool? notificationsEnabled,
    Map<String, String>? reminderTimes,
    bool? batteryPrimerShown,
    bool? pedometerAvailable,
    String? themePreferenceCache,
  }) => AppSettings(
    dayRolloverHour: dayRolloverHour ?? this.dayRolloverHour,
    retroLoggingDays: retroLoggingDays ?? this.retroLoggingDays,
    hardcoreMode: hardcoreMode ?? this.hardcoreMode,
    partialCreditEnabled: partialCreditEnabled ?? this.partialCreditEnabled,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    highContrast: highContrast ?? this.highContrast,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    appLockScope: appLockScope ?? this.appLockScope,
    localeOverride: clearLocaleOverride
        ? null
        : (localeOverride ?? this.localeOverride),
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    lastBootRescheduleAt: lastBootRescheduleAt ?? this.lastBootRescheduleAt,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    reminderTimes: reminderTimes ?? this.reminderTimes,
    batteryPrimerShown: batteryPrimerShown ?? this.batteryPrimerShown,
    pedometerAvailable: pedometerAvailable ?? this.pedometerAvailable,
    themePreferenceCache: themePreferenceCache ?? this.themePreferenceCache,
  );

  Map<String, dynamic> toJson() => {
    'day_rollover_hour': dayRolloverHour,
    'retro_logging_days': retroLoggingDays,
    'hardcore_mode': hardcoreMode,
    'partial_credit_enabled': partialCreditEnabled,
    'reduce_motion': reduceMotion,
    'high_contrast': highContrast,
    'sound_enabled': soundEnabled,
    'haptics_enabled': hapticsEnabled,
    'app_lock_enabled': appLockEnabled,
    'app_lock_scope': appLockScope,
    'locale_override': localeOverride,
    'last_backup_at': lastBackupAt?.toIso8601String(),
    'last_boot_reschedule_at': lastBootRescheduleAt?.toIso8601String(),
    'notifications_enabled': notificationsEnabled,
    'reminder_times': reminderTimes,
    'battery_primer_shown': batteryPrimerShown,
    'pedometer_available': pedometerAvailable,
    'theme_preference_cache': themePreferenceCache,
  };

  static AppSettings fromJson(Map<String, dynamic> j) => AppSettings(
    dayRolloverHour:
        (j['day_rollover_hour'] as num?)?.toInt() ??
        AppConstants.defaultDayRolloverHour,
    retroLoggingDays:
        (j['retro_logging_days'] as num?)?.toInt() ??
        AppConstants.defaultRetroLoggingDays,
    hardcoreMode: j['hardcore_mode'] as bool? ?? false,
    partialCreditEnabled: j['partial_credit_enabled'] as bool? ?? true,
    reduceMotion: j['reduce_motion'] as bool? ?? false,
    highContrast: j['high_contrast'] as bool? ?? false,
    soundEnabled: j['sound_enabled'] as bool? ?? false,
    hapticsEnabled: j['haptics_enabled'] as bool? ?? true,
    appLockEnabled: j['app_lock_enabled'] as bool? ?? false,
    appLockScope: j['app_lock_scope'] as String? ?? AppLockScope.journal,
    localeOverride: j['locale_override'] as String?,
    lastBackupAt: j['last_backup_at'] == null
        ? null
        : DateTime.tryParse(j['last_backup_at'] as String),
    lastBootRescheduleAt: j['last_boot_reschedule_at'] == null
        ? null
        : DateTime.tryParse(j['last_boot_reschedule_at'] as String),
    notificationsEnabled: j['notifications_enabled'] as bool? ?? true,
    reminderTimes: j['reminder_times'] == null
        ? const {
            'morning_call': '05:30',
            'nutrition_reminders': '12:30',
            'activity_reminders': '17:30',
            'evening_review': '21:30',
          }
        : Map<String, String>.from(j['reminder_times'] as Map),
    batteryPrimerShown: j['battery_primer_shown'] as bool? ?? false,
    pedometerAvailable: j['pedometer_available'] as bool? ?? true,
    themePreferenceCache: j['theme_preference_cache'] as String? ?? 'system',
  );
}
