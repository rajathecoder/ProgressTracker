import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Level-up / achievement celebration.
///
/// design_principles: "Motion is decorative, never load-bearing." Under
/// reduce-motion the confetti is skipped entirely and the card appears
/// instantly - the information is identical either way.
class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.accent,
    this.lottieAsset,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color? accent;

  /// When set, replaces the static [icon] with this animation, played once.
  /// Kept full-color (the source badge/trophy art already carries its own
  /// gold/red accents) rather than retinted like the bottom-bar icons.
  final String? lottieAsset;

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !context.clay.reduceMotion) _confetti.play();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final accent = widget.accent ?? clay.accentFrost;
    final text = Theme.of(context).textTheme;

    final card = ClayContainer(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClayContainer(
            state: ClaySurfaceState.recessed,
            radius: 30,
            width: 88,
            height: 88,
            alignment: Alignment.center,
            color: Color.alphaBlend(
              accent.withValues(alpha: 0.16),
              clay.surface,
            ),
            child: widget.lottieAsset == null
                ? Icon(widget.icon, size: 40, color: accent)
                : Lottie.asset(
                    widget.lottieAsset!,
                    width: 56,
                    height: 56,
                    repeat: false,
                    animate: !clay.reduceMotion,
                  ),
          ),
          const SizedBox(height: 22),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: text.headlineMedium?.copyWith(color: accent),
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: clay.textSecondary),
          ),
        ],
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Semantics(
          liveRegion: true,
          label: '${widget.title}. ${widget.subtitle}',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: clay.reduceMotion
                ? card
                : TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.85, end: 1),
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutBack,
                    builder: (_, v, child) =>
                        Transform.scale(scale: v, child: child),
                    child: card,
                  ),
          ),
        ),
        if (!clay.reduceMotion)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 18,
              maxBlastForce: 18,
              minBlastForce: 8,
              gravity: 0.25,
              shouldLoop: false,
              colors: [accent, clay.accentEmber, clay.gridCheckedIcon],
            ),
          ),
      ],
    );
  }
}

/// Shows a celebration as a dismissible dialog.
Future<void> showCelebration(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  Color? accent,
  String? lottieAsset,
}) => showDialog<void>(
  context: context,
  barrierColor: Colors.black.withValues(alpha: 0.6),
  builder: (context) => GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Material(
      color: Colors.transparent,
      child: CelebrationOverlay(
        title: title,
        subtitle: subtitle,
        icon: icon,
        accent: accent,
        lottieAsset: lottieAsset,
      ),
    ),
  ),
);
