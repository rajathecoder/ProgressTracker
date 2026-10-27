import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';

/// Metric Atom - recessed track with a raised gradient arc.
/// Reused on the dashboard, the home-screen widget and stat cards.
class ClayProgressRing extends StatelessWidget {
  const ClayProgressRing({
    super.key,
    required this.progress,
    this.size = 132,
    this.thickness = 14,
    this.center,
    this.color,
    this.semanticLabel,
    this.animate = true,
  });

  final double progress;
  final double size;
  final double thickness;
  final Widget? center;
  final Color? color;
  final String? semanticLabel;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final accent = color ?? clay.accentFrost;
    final value = progress.clamp(0.0, 1.0);

    Widget ring(double v) => CustomPaint(
      painter: _RingPainter(
        progress: v,
        thickness: thickness,
        trackColor: clay.isDark
            ? Colors.black.withValues(alpha: 0.35)
            : const Color(0xFFD6E0EA),
        startColor: accent,
        endColor: Color.lerp(accent, clay.accentEmber, 0.45)!,
        highContrast: clay.highContrast,
        borderColor: clay.textPrimary,
      ),
      size: Size.square(size),
    );

    final body = RepaintBoundary(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (animate && !clay.reduceMotion)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (_, v, _) => ring(v),
              )
            else
              ring(value),
            ?center,
          ],
        ),
      ),
    );

    return semanticLabel == null
        ? body
        : Semantics(
            label: semanticLabel,
            value: '${(value * 100).round()}%',
            child: ExcludeSemantics(child: body),
          );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.thickness,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
    required this.highContrast,
    required this.borderColor,
  });

  final double progress;
  final double thickness;
  final Color trackColor;
  final Color startColor;
  final Color endColor;
  final bool highContrast;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - thickness) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    if (highContrast) {
      arc.color = borderColor;
    } else {
      arc.shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi,
        colors: [startColor, endColor, startColor],
      ).createShader(arcRect);
    }

    canvas.drawArc(arcRect, -math.pi / 2, 2 * math.pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.thickness != thickness ||
      old.startColor != startColor ||
      old.highContrast != highContrast;
}
