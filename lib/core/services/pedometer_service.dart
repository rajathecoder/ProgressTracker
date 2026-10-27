import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';

import '../../data/repositories/settings_repository.dart';

/// edge_case_handling.pedometer_daily_reset
///
/// The platform step counter is cumulative since boot, not per-day. We store a
/// baseline at the first read after rollover; today's steps = current -
/// baseline. If the counter comes back *lower* than the baseline the device
/// rebooted, so the baseline resets.
class PedometerService {
  PedometerService(this._settings);

  final SettingsRepository _settings;

  StreamSubscription<StepCount>? _sub;
  final _controller = StreamController<int>.broadcast();

  Stream<int> get todaySteps => _controller.stream;

  bool _available = true;
  bool get available => _available;

  /// edge_case_handling.pedometer_unavailable: feature-detect on first run.
  /// If there is no hardware counter, the steps habit falls back to manual
  /// ClayStepper entry rather than showing a permanently zeroed card.
  Future<bool> probe() async {
    try {
      await Pedometer.stepCountStream.first.timeout(const Duration(seconds: 4));
      _available = true;
    } catch (_) {
      _available = false;
    }
    return _available;
  }

  Future<void> start(String dateKey) async {
    await stop();
    try {
      _sub = Pedometer.stepCountStream.listen(
        (event) => _onCount(dateKey, event.steps),
        onError: (Object e) {
          _available = false;
          debugPrint('ArcCore: pedometer unavailable ($e)');
        },
        cancelOnError: false,
      );
    } catch (e) {
      _available = false;
      debugPrint('ArcCore: pedometer start failed ($e)');
    }
  }

  Future<void> _onCount(String dateKey, int cumulative) async {
    var baseline = _settings.stepBaselineFor(dateKey);
    if (baseline == null || cumulative < baseline) {
      baseline = cumulative;
      await _settings.setStepBaseline(dateKey, baseline);
      await _settings.clearStepBaselinesExcept(dateKey);
    }
    final today = cumulative - baseline;
    if (!_controller.isClosed) _controller.add(today < 0 ? 0 : today);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }
}
