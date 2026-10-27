import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// ui_ux_design_system.sound_and_haptics_design
///
/// "Every reward tier has a distinct, escalating signature. Sound is off by
/// default; haptics are on by default. Both fully mutable."
enum FeedbackEvent {
  habitToggleOn,
  habitToggleOff,
  dayComplete,
  statLevelUp,
  achievementUnlock,
  shieldConsumed,
}

class FeedbackService {
  FeedbackService({AudioPlayer? player})
    : _player = player ?? AudioPlayer(playerId: 'arccore_sfx');

  final AudioPlayer _player;

  bool haptics = true;
  bool sound = false;

  void configure({required bool haptics, required bool sound}) {
    this.haptics = haptics;
    this.sound = sound;
  }

  Future<void> fire(FeedbackEvent event) async {
    if (haptics) await _haptic(event);
    if (sound) await _sound(event);
  }

  Future<void> _haptic(FeedbackEvent event) async {
    try {
      switch (event) {
        case FeedbackEvent.habitToggleOn:
          await HapticFeedback.lightImpact();
        case FeedbackEvent.habitToggleOff:
          await HapticFeedback.selectionClick();
        case FeedbackEvent.dayComplete:
          // Double pulse. The spec reaches for flutter_vibrate here, but its own
          // dependency_notes say to prefer the built-in HapticFeedback where a
          // pattern can be expressed as a short sequence - zero extra weight.
          await HapticFeedback.mediumImpact();
          await Future<void>.delayed(const Duration(milliseconds: 90));
          await HapticFeedback.mediumImpact();
        case FeedbackEvent.statLevelUp:
          await HapticFeedback.mediumImpact();
        case FeedbackEvent.achievementUnlock:
          for (var i = 0; i < 3; i++) {
            await HapticFeedback.mediumImpact();
            await Future<void>.delayed(const Duration(milliseconds: 80));
          }
        case FeedbackEvent.shieldConsumed:
          await HapticFeedback.heavyImpact();
      }
    } catch (_) {
      // Haptics are decorative. A device without a vibrator must not throw.
    }
  }

  static const Map<FeedbackEvent, String> _assets = {
    FeedbackEvent.habitToggleOn: 'audio/soft_clay_press.wav',
    FeedbackEvent.dayComplete: 'audio/chime_ascend.wav',
    FeedbackEvent.statLevelUp: 'audio/stat_up.wav',
    FeedbackEvent.achievementUnlock: 'audio/trophy.wav',
    FeedbackEvent.shieldConsumed: 'audio/shield_crack.wav',
  };

  Future<void> _sound(FeedbackEvent event) async {
    final asset = _assets[event];
    if (asset == null) return;
    try {
      await _player.play(AssetSource(asset), volume: 0.6);
    } catch (e) {
      // asset_budget: the wav pack ships under 400KB. If a file is missing
      // (e.g. a slimmed build) the interaction must still complete.
      debugPrint('ArcCore: sound asset missing $asset ($e)');
    }
  }

  Future<void> dispose() => _player.dispose();
}
