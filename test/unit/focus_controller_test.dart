import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/features/focus/focus_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// The concentration timer's state machine.
void main() {
  late FocusController controller;

  setUp(() => controller = FocusController());
  tearDown(() => controller.dispose());

  test('starts idle at the default session length', () {
    expect(controller.value.isIdle, isTrue);
    expect(
      controller.value.total,
      const Duration(minutes: AppConstants.defaultFocusMinutes),
    );
    expect(controller.value.remaining, controller.value.total);
    expect(controller.value.progress, 0);
  });

  test('setDuration clamps to the supported range', () {
    controller.setDuration(const Duration(minutes: 1));
    expect(controller.value.total.inMinutes, AppConstants.minFocusMinutes);

    controller.setDuration(const Duration(minutes: 999));
    expect(controller.value.total.inMinutes, AppConstants.maxFocusMinutes);

    controller.setDuration(const Duration(minutes: 45));
    expect(controller.value.total.inMinutes, 45);
  });

  test('start moves to running and pause banks the elapsed time', () async {
    controller.setDuration(const Duration(minutes: 10));
    controller.start();
    expect(controller.value.isRunning, isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 350));
    controller.pause();

    expect(controller.value.isPaused, isTrue);
    expect(controller.value.elapsed, greaterThan(Duration.zero));
    final banked = controller.value.elapsed;

    // Time passing while paused must not count.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(controller.value.elapsed, banked);
  });

  test(
    'resume continues from the banked time rather than restarting',
    () async {
      controller.setDuration(const Duration(minutes: 10));
      controller.start();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      controller.pause();
      final banked = controller.value.elapsed;

      controller.resume();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(controller.value.elapsed, greaterThan(banked));
    },
  );

  test('reset returns to idle and keeps the chosen length', () async {
    controller.setDuration(const Duration(minutes: 30));
    controller.start();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    controller.reset();

    expect(controller.value.isIdle, isTrue);
    expect(controller.value.elapsed, Duration.zero);
    expect(controller.value.total.inMinutes, 30);
  });

  test('a finished session fires onCompleted once with whole minutes', () async {
    // The shortest session the clamp allows is 5 minutes, so the completion
    // path is driven by shortening the total after the run has started - which
    // is exactly the wall-clock branch the ticker takes.
    var completions = 0;
    var reported = 0;
    controller.onCompleted = (minutes) {
      completions++;
      reported = minutes;
    };

    controller.setDuration(const Duration(minutes: 5));
    controller.start();
    // Force the elapsed comparison to pass on the next tick.
    controller.value = controller.value.copyWith(
      total: const Duration(milliseconds: 120),
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));
    expect(completions, 1, reason: 'fires exactly once');
    expect(controller.value.isCompleted, isTrue);
    expect(controller.value.remaining, Duration.zero);
    expect(controller.value.progress, 1.0);
    expect(reported, controller.value.total.inMinutes);
  });

  test('setDuration is ignored while a session is active', () {
    controller.setDuration(const Duration(minutes: 25));
    controller.start();
    controller.setDuration(const Duration(minutes: 60));
    expect(controller.value.total.inMinutes, 25);
  });

  group('countdown formatting', () {
    test('is zero-padded mm:ss', () {
      expect(formatCountdown(const Duration(minutes: 25)), '25:00');
      expect(formatCountdown(const Duration(seconds: 65)), '01:05');
      expect(formatCountdown(Duration.zero), '00:00');
      expect(formatCountdown(const Duration(minutes: 120)), '120:00');
    });
  });
}
