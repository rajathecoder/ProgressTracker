import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/features/focus/focus_session_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// The session shape the app, the widget and the background isolate all share.
///
/// Elapsed time is derived from a wall-clock anchor rather than accumulated,
/// which is what lets a session started on the home screen keep running while
/// nothing is on screen at all.
void main() {
  final t0 = DateTime(2026, 9, 3, 10, 0, 0);
  DateTime at(int seconds) => t0.add(Duration(seconds: seconds));

  test('starts idle at the default length', () {
    const s = FocusSnapshot.initial;
    expect(s.isIdle, isTrue);
    expect(s.isRunning, isFalse);
    expect(s.totalSeconds, AppConstants.defaultFocusMinutes * 60);
    expect(s.remainingSecondsAt(t0), s.totalSeconds);
  });

  test('running elapsed is measured against the clock, not ticks', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    expect(started.isRunning, isTrue);
    expect(started.elapsedSecondsAt(t0), 0);
    expect(started.elapsedSecondsAt(at(90)), 90);
    expect(started.remainingSecondsAt(at(90)), 25 * 60 - 90);
  });

  test('pause banks the elapsed time and stops the clock', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    final paused = FocusSessionStore.pause(started, at(120));

    expect(paused.isRunning, isFalse);
    expect(paused.bankedSeconds, 120);
    // Time passing while paused must not count.
    expect(paused.elapsedSecondsAt(at(600)), 120);
  });

  test('resuming continues from the banked time', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    final paused = FocusSessionStore.pause(started, at(120));
    final resumed = FocusSessionStore.start(paused, at(300));

    expect(resumed.elapsedSecondsAt(at(300)), 120);
    expect(resumed.elapsedSecondsAt(at(360)), 180);
  });

  test('toggle flips between running and paused', () {
    var s = FocusSnapshot.initial;
    s = FocusSessionStore.toggle(s, t0);
    expect(s.isRunning, isTrue);
    s = FocusSessionStore.toggle(s, at(30));
    expect(s.isRunning, isFalse);
    expect(s.bankedSeconds, 30);
  });

  test('completion is detected from the clock alone', () {
    final started = FocusSessionStore.start(
      FocusSessionStore.setTotal(FocusSnapshot.initial, 60),
      t0,
    );
    expect(started.isCompleteAt(at(59)), isFalse);
    expect(started.isCompleteAt(at(60)), isTrue);
    expect(started.remainingSecondsAt(at(120)), 0, reason: 'never negative');
  });

  test('reset clears progress but keeps the chosen length', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    final paused = FocusSessionStore.pause(started, at(200));
    final reset = FocusSessionStore.reset(paused);

    expect(reset.isIdle, isTrue);
    expect(reset.bankedSeconds, 0);
    expect(reset.totalSeconds, FocusSnapshot.initial.totalSeconds);
  });

  test('setTotal restarts the session at the new length', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    final changed = FocusSessionStore.setTotal(started, 45 * 60);

    expect(changed.totalSeconds, 45 * 60);
    expect(changed.isRunning, isFalse);
    expect(changed.bankedSeconds, 0);
  });

  test('a clock that moves backwards cannot produce negative elapsed', () {
    final started = FocusSessionStore.start(FocusSnapshot.initial, t0);
    expect(
      started.elapsedSecondsAt(t0.subtract(const Duration(minutes: 5))),
      0,
    );
  });
}
