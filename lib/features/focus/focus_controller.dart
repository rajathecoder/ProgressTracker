import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import 'focus_session_store.dart';

enum FocusPhase { idle, running, paused, completed }

/// A concentration session.
///
/// Time is derived from the wall clock, not from counting ticks: a timer that
/// accumulates on every tick drifts, and stops entirely when the OS suspends
/// the isolate or the screen sleeps. Here the ticker only decides how often to
/// repaint - remaining time is always `total - elapsed` measured against
/// DateTime.now(), so a session survives the screen going off, the app being
/// backgrounded, and a dropped frame.
@immutable
class FocusState {
  const FocusState({
    required this.phase,
    required this.total,
    required this.elapsed,
  });

  final FocusPhase phase;
  final Duration total;
  final Duration elapsed;

  Duration get remaining {
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  double get progress => total.inMilliseconds == 0
      ? 0
      : (elapsed.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

  bool get isRunning => phase == FocusPhase.running;
  bool get isPaused => phase == FocusPhase.paused;
  bool get isIdle => phase == FocusPhase.idle;
  bool get isCompleted => phase == FocusPhase.completed;

  /// True once the user has committed to a session, so leaving should warn.
  bool get isActive => isRunning || isPaused;

  /// Whole minutes actually concentrated - what gets logged.
  int get completedMinutes => elapsed.inMinutes;

  FocusState copyWith({
    FocusPhase? phase,
    Duration? total,
    Duration? elapsed,
  }) => FocusState(
    phase: phase ?? this.phase,
    total: total ?? this.total,
    elapsed: elapsed ?? this.elapsed,
  );

  static const initial = FocusState(
    phase: FocusPhase.idle,
    total: Duration(minutes: AppConstants.defaultFocusMinutes),
    elapsed: Duration.zero,
  );
}

class FocusController extends ValueNotifier<FocusState> {
  FocusController() : super(FocusState.initial);

  Timer? _ticker;

  /// Mirrors every transition into the shared store, so a session started in
  /// the app can be paused from the widget and vice versa. Without this the two
  /// surfaces would each run their own timer and disagree.
  bool _syncing = false;

  /// Wall-clock anchor for the current run, and the time banked before it.
  DateTime? _resumedAt;
  Duration _banked = Duration.zero;

  /// Fired once when a session runs to completion.
  void Function(int minutes)? onCompleted;

  void setDuration(Duration duration) {
    if (value.isActive) return;
    final clamped = Duration(
      minutes: duration.inMinutes.clamp(
        AppConstants.minFocusMinutes,
        AppConstants.maxFocusMinutes,
      ),
    );
    value = FocusState(
      phase: FocusPhase.idle,
      total: clamped,
      elapsed: Duration.zero,
    );
    _persist();
  }

  void start() {
    if (value.isRunning) return;
    _banked = value.isPaused ? value.elapsed : Duration.zero;
    _resumedAt = DateTime.now();
    value = value.copyWith(phase: FocusPhase.running, elapsed: _banked);
    _startTicker();
    _persist();
  }

  void pause() {
    if (!value.isRunning) return;
    _stopTicker();
    _banked = _elapsedNow();
    _resumedAt = null;
    value = value.copyWith(phase: FocusPhase.paused, elapsed: _banked);
    _persist();
  }

  void resume() => start();

  void reset() {
    _stopTicker();
    _banked = Duration.zero;
    _resumedAt = null;
    value = FocusState(
      phase: FocusPhase.idle,
      total: value.total,
      elapsed: Duration.zero,
    );
    _persist();
  }

  /// Recomputes from the clock - call on app resume so a session that ran while
  /// backgrounded shows the right time immediately rather than after a tick.
  void sync() {
    if (value.isRunning) _tick();
  }

  /// Adopts whatever the shared store says, which is how a session started or
  /// paused from the home-screen widget shows up correctly in the app.
  Future<void> adoptSharedSession() async {
    final snapshot = await FocusSessionStore.load();
    final now = DateTime.now();

    _syncing = true;
    try {
      _banked = Duration(seconds: snapshot.bankedSeconds);
      if (snapshot.isRunning) {
        _resumedAt = DateTime.fromMillisecondsSinceEpoch(snapshot.startedAtMs);
        value = FocusState(
          phase: FocusPhase.running,
          total: Duration(seconds: snapshot.totalSeconds),
          elapsed: Duration(seconds: snapshot.elapsedSecondsAt(now)),
        );
        _startTicker();
      } else {
        _resumedAt = null;
        value = FocusState(
          phase: snapshot.bankedSeconds > 0
              ? FocusPhase.paused
              : FocusPhase.idle,
          total: Duration(seconds: snapshot.totalSeconds),
          elapsed: _banked,
        );
        _stopTicker();
      }
    } finally {
      _syncing = false;
    }
  }

  void _persist() {
    if (_syncing) return;
    unawaited(
      FocusSessionStore.save(
        FocusSnapshot(
          totalSeconds: value.total.inSeconds,
          bankedSeconds: value.isRunning
              ? _banked.inSeconds
              : value.elapsed.inSeconds,
          startedAtMs: value.isRunning
              ? (_resumedAt?.millisecondsSinceEpoch ?? 0)
              : 0,
        ),
      ),
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Duration _elapsedNow() {
    final resumed = _resumedAt;
    if (resumed == null) return _banked;
    return _banked + DateTime.now().difference(resumed);
  }

  void _tick() {
    final elapsed = _elapsedNow();
    if (elapsed >= value.total) {
      _stopTicker();
      _resumedAt = null;
      _banked = value.total;
      value = value.copyWith(phase: FocusPhase.completed, elapsed: value.total);
      unawaited(
        FocusSessionStore.save(
          FocusSessionStore.reset(
            FocusSnapshot(
              totalSeconds: value.total.inSeconds,
              bankedSeconds: 0,
              startedAtMs: 0,
            ),
          ),
        ),
      );
      onCompleted?.call(value.total.inMinutes);
      return;
    }
    value = value.copyWith(elapsed: elapsed);
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}

String formatCountdown(Duration d) {
  final total = d.inSeconds;
  final m = (total ~/ 60).toString().padLeft(2, '0');
  final s = (total % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
