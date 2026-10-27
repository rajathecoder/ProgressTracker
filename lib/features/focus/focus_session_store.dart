import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/constants/app_constants.dart';

/// The one place a focus session lives.
///
/// The session has to be readable and writable from three places that share no
/// memory: the app, the widget's background isolate, and the native widget
/// provider. So it is persisted as plain scalars in the home-widget shared
/// container - which Kotlin can read directly - rather than held in a Dart
/// object that only the app can see.
///
/// Elapsed time is derived from a wall-clock anchor rather than accumulated, so
/// a session keeps running correctly while the app is closed and the widget is
/// the only thing on screen.
@immutable
class FocusSnapshot {
  const FocusSnapshot({
    required this.totalSeconds,
    required this.bankedSeconds,
    required this.startedAtMs,
  });

  /// Length of the session the user chose.
  final int totalSeconds;

  /// Seconds completed before the current run began.
  final int bankedSeconds;

  /// Wall-clock anchor for the current run; 0 when paused or idle.
  final int startedAtMs;

  bool get isRunning => startedAtMs > 0;

  int elapsedSecondsAt(DateTime now) {
    if (!isRunning) return bankedSeconds;
    final ran = (now.millisecondsSinceEpoch - startedAtMs) ~/ 1000;
    return bankedSeconds + (ran < 0 ? 0 : ran);
  }

  int remainingSecondsAt(DateTime now) {
    final left = totalSeconds - elapsedSecondsAt(now);
    return left < 0 ? 0 : left;
  }

  bool isCompleteAt(DateTime now) =>
      totalSeconds > 0 && elapsedSecondsAt(now) >= totalSeconds;

  bool get isIdle => !isRunning && bankedSeconds == 0;

  FocusSnapshot copyWith({
    int? totalSeconds,
    int? bankedSeconds,
    int? startedAtMs,
  }) => FocusSnapshot(
    totalSeconds: totalSeconds ?? this.totalSeconds,
    bankedSeconds: bankedSeconds ?? this.bankedSeconds,
    startedAtMs: startedAtMs ?? this.startedAtMs,
  );

  static const initial = FocusSnapshot(
    totalSeconds: AppConstants.defaultFocusMinutes * 60,
    bankedSeconds: 0,
    startedAtMs: 0,
  );
}

abstract final class FocusSessionStore {
  static const _total = 'focus_total_seconds';
  static const _banked = 'focus_banked_seconds';
  static const _startedAt = 'focus_started_at_ms';

  static Future<FocusSnapshot> load() async {
    try {
      final total = await HomeWidget.getWidgetData<int>(_total);
      final banked = await HomeWidget.getWidgetData<int>(_banked);
      final startedAt = await HomeWidget.getWidgetData<int>(_startedAt);
      return FocusSnapshot(
        totalSeconds: total ?? FocusSnapshot.initial.totalSeconds,
        bankedSeconds: banked ?? 0,
        startedAtMs: startedAt ?? 0,
      );
    } catch (e) {
      debugPrint('Happy Days: could not read focus session ($e)');
      return FocusSnapshot.initial;
    }
  }

  static Future<void> save(FocusSnapshot snapshot) async {
    try {
      await HomeWidget.saveWidgetData<int>(_total, snapshot.totalSeconds);
      await HomeWidget.saveWidgetData<int>(_banked, snapshot.bankedSeconds);
      await HomeWidget.saveWidgetData<int>(_startedAt, snapshot.startedAtMs);
    } catch (e) {
      debugPrint('Happy Days: could not persist focus session ($e)');
    }
  }

  // ------------------------------------------------------------- transitions

  static FocusSnapshot start(FocusSnapshot s, DateTime now) =>
      s.copyWith(startedAtMs: now.millisecondsSinceEpoch);

  static FocusSnapshot pause(FocusSnapshot s, DateTime now) => FocusSnapshot(
    totalSeconds: s.totalSeconds,
    bankedSeconds: s.elapsedSecondsAt(now),
    startedAtMs: 0,
  );

  static FocusSnapshot reset(FocusSnapshot s) => FocusSnapshot(
    totalSeconds: s.totalSeconds,
    bankedSeconds: 0,
    startedAtMs: 0,
  );

  static FocusSnapshot setTotal(FocusSnapshot s, int seconds) =>
      FocusSnapshot(totalSeconds: seconds, bankedSeconds: 0, startedAtMs: 0);

  /// Toggles run/pause - what the widget's single button does.
  static FocusSnapshot toggle(FocusSnapshot s, DateTime now) =>
      s.isRunning ? pause(s, now) : start(s, now);
}
