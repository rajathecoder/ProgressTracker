import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';

/// Base Atom.
///
/// The only widget in the app allowed to paint a clay surface. Everything else
/// composes this, so light/dark/high-contrast and reduce-motion are handled in
/// exactly one place (widget_conventions).
class ClayContainer extends StatelessWidget {
  const ClayContainer({
    super.key,
    required this.child,
    this.state = ClaySurfaceState.raised,
    this.color,
    this.radius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.semanticLabel,
    this.dashed = false,
    this.clip = false,
    this.alignment,
    this.constraints,
  });

  final Widget child;
  final ClaySurfaceState state;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final String? semanticLabel;

  /// notScheduled surfaces are drawn with a 1px dashed border.
  final bool dashed;
  final bool clip;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final style = clay.styleFor(state, color: color, radiusOverride: radius);
    final r = radius ?? clay.radius;

    Widget surface = Container(
      width: width,
      height: height,
      alignment: alignment,
      constraints: constraints,
      padding: padding,
      decoration: style.decoration,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );

    if ((dashed || state == ClaySurfaceState.notScheduled) &&
        !clay.highContrast) {
      surface = CustomPaint(
        painter: _DashedBorderPainter(
          color: clay.textSecondary.withValues(alpha: 0.6),
          radius: r,
        ),
        child: surface,
      );
    }

    if (style.opacity < 1) {
      surface = Opacity(opacity: style.opacity, child: surface);
    }
    if (margin != null) {
      surface = Padding(padding: margin!, child: surface);
    }
    if (semanticLabel != null) {
      surface = Semantics(
        label: semanticLabel,
        container: true,
        child: surface,
      );
    }
    return surface;
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
          Radius.circular(radius),
        ),
      );

    const dash = 4.0;
    const gap = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
