import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

/// data_models.AppSettings is shared_preferences backed and deliberately
/// outside Isar - it never participates in XP logic, so it must never be able
/// to corrupt a write transaction.
class SettingsRepository {
  SettingsRepository(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'arccore.settings';

  static Future<SettingsRepository> open() async =>
      SettingsRepository(await SharedPreferences.getInstance());

  AppSettings load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const AppSettings();
    try {
      return AppSettings.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      // A corrupt settings blob must never brick the app - fall back to
      // defaults and let the user reconfigure.
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) =>
      _prefs.setString(_key, jsonEncode(settings.toJson()));

  int get schemaVersion => _prefs.getInt('arccore.schema_version') ?? 0;

  Future<void> setSchemaVersion(int v) =>
      _prefs.setInt('arccore.schema_version', v);

  /// Anti-tamper watermark: the highest wall-clock time we have ever observed.
  /// If time moves backwards by more than an hour we stop awarding XP for that
  /// write (edge_case_handling.clock_tampering).
  DateTime? get maxObservedTime {
    final ms = _prefs.getInt('arccore.max_observed_time');
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setMaxObservedTime(DateTime t) =>
      _prefs.setInt('arccore.max_observed_time', t.millisecondsSinceEpoch);

  /// Pedometer daily baseline: the platform counter is cumulative since boot,
  /// so today's steps = current - baseline
  /// (edge_case_handling.pedometer_daily_reset).
  int? stepBaselineFor(String dateKey) =>
      _prefs.getInt('arccore.step_baseline.$dateKey');

  Future<void> setStepBaseline(String dateKey, int value) =>
      _prefs.setInt('arccore.step_baseline.$dateKey', value);

  Future<void> clearStepBaselinesExcept(String dateKey) async {
    for (final k in _prefs.getKeys()) {
      if (k.startsWith('arccore.step_baseline.') &&
          k != 'arccore.step_baseline.$dateKey') {
        await _prefs.remove(k);
      }
    }
  }

  bool get onboardingComplete =>
      _prefs.getBool('arccore.onboarding_complete') ?? false;

  Future<void> setOnboardingComplete(bool v) =>
      _prefs.setBool('arccore.onboarding_complete', v);

  Future<void> clear() async {
    for (final k in _prefs.getKeys().where((k) => k.startsWith('arccore.'))) {
      await _prefs.remove(k);
    }
  }
}
