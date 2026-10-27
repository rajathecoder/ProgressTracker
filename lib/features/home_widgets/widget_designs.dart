import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The home-screen widget surfaces.
///
/// These are ordinary Flutter widgets, rendered off-screen to a PNG that the
/// native providers simply blit. That is the spec's key call
/// (home_screen_widgets.implementation_note): the claymorphic styling exists
/// once, here, instead of being reimplemented in Jetpack Glance and SwiftUI and
/// drifting apart from the app three releases later.
///
/// Everything is sized in logical pixels against a fixed canvas, because the
/// render target has no parent to lay it out against.

/// Per-day state in the little weekday strip.
enum WidgetDayState { done, missed, skipped, partial, today, upcoming }

class WidgetDay {
  const WidgetDay(this.label, this.state, {this.progress = 0});
  final String label;
  final WidgetDayState state;
  final double progress;
}

abstract final class WidgetPalette {
  static const card = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF131822);
  static const ink = Color(0xFF1A202C);
  static const inkDark = Color(0xFFFFFFFF);
  static const muted = Color(0xFF8A94A6);
  static const green = Color(0xFF34C77B);
  static const greenSoft = Color(0xFF8BE0AE);
  static const red = Color(0xFFF3705A);
  static const blue = Color(0xFF3B6BF0);
  static const track = Color(0xFFEDF1F5);
  static const trackDark = Color(0xFF1E2634);
}

class _WidgetCard extends StatelessWidget {
  const _WidgetCard({
    required this.child,
    required this.dark,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final bool dark;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: dark ? WidgetPalette.cardDark : WidgetPalette.card,
      borderRadius: BorderRadius.circular(26),
    ),
    padding: padding,
    child: child,
  );
}

/// The weekday strip: done / missed / skipped / partial / today / upcoming.
class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.days, required this.dark, this.dotSize = 22});

  final List<WidgetDay> days;
  final bool dark;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final day in days)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                day.label,
                style: TextStyle(
                  fontSize: dotSize * 0.5,
                  height: 1.1,
                  color: day.state == WidgetDayState.today
                      ? WidgetPalette.green
                      : WidgetPalette.muted,
                  fontWeight: day.state == WidgetDayState.today
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
              SizedBox(height: dotSize * 0.28),
              _Dot(
                state: day.state,
                size: dotSize,
                progress: day.progress,
                dark: dark,
                ink: ink,
              ),
            ],
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.state,
    required this.size,
    required this.progress,
    required this.dark,
    required this.ink,
  });

  final WidgetDayState state;
  final double size;
  final double progress;
  final bool dark;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case WidgetDayState.done:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: WidgetPalette.green,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: size * 0.62, color: Colors.white),
        );
      case WidgetDayState.missed:
        return SizedBox(
          width: size,
          height: size,
          child: Icon(Icons.close, size: size * 0.72, color: WidgetPalette.red),
        );
      case WidgetDayState.skipped:
        // Hatched: "not scheduled" must not read as either done or missed.
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _HatchPainter(
              color: dark ? WidgetPalette.trackDark : const Color(0xFFD8DEE6),
            ),
          ),
        );
      case WidgetDayState.partial:
      case WidgetDayState.today:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: state == WidgetDayState.today
                  ? math.max(progress, 0.08)
                  : progress,
              track: dark ? WidgetPalette.trackDark : WidgetPalette.track,
              color: WidgetPalette.green,
              stroke: size * 0.14,
            ),
          ),
        );
      case WidgetDayState.upcoming:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dark
                ? WidgetPalette.trackDark
                : WidgetPalette.greenSoft.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
        );
    }
  }
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 1.4;
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    for (var x = -size.width; x < size.width * 2; x += 5) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HatchPainter old) => old.color != color;
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.color,
    required this.stroke,
  });

  final double progress;
  final Color track;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - stroke) / 2;
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (progress <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

/// Small: a gauge over the habit's streak, with the week underneath.
class HabitRingWidget extends StatelessWidget {
  const HabitRingWidget({
    super.key,
    required this.title,
    required this.streakDays,
    required this.progress,
    required this.icon,
    required this.days,
    this.dark = false,
  });

  final String title;
  final int streakDays;
  final double progress;
  final IconData icon;
  final List<WidgetDay> days;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return _WidgetCard(
      dark: dark,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox.square(
            dimension: 104,
            child: CustomPaint(
              painter: _GaugePainter(
                progress: progress,
                track: dark
                    ? WidgetPalette.trackDark
                    : WidgetPalette.greenSoft.withValues(alpha: 0.4),
                color: WidgetPalette.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: WidgetPalette.greenSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ink,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    '$streakDays Days',
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: WidgetPalette.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          _DayStrip(days: days, dark: dark, dotSize: 18),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.progress,
    required this.track,
    required this.color,
  });

  final double progress;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    // Sized off the *shortest* side: keying the arc to width alone let it draw
    // outside a non-square box and collide with whatever sat underneath.
    final extent = size.shortestSide - stroke;
    final rect = Rect.fromLTWH(
      (size.width - extent) / 2,
      (size.height - extent) / 2,
      extent,
      extent,
    );
    // A 250-degree arc, open at the bottom, like the reference.
    const start = math.pi * 0.72;
    const sweep = math.pi * 1.56;
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      start,
      sweep * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}

/// Small: the concentration timer, ready to start.
class FocusTimerWidget extends StatelessWidget {
  const FocusTimerWidget({
    super.key,
    required this.title,
    required this.time,
    this.dark = false,
  });

  final String title;
  final String time;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return _WidgetCard(
      dark: dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: WidgetPalette.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.self_improvement,
                  size: 15,
                  color: WidgetPalette.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: ink),
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 44,
              height: 1,
              fontWeight: FontWeight.w700,
              color: ink,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: WidgetPalette.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small: the two longest-running streaks.
class StreakListWidget extends StatelessWidget {
  const StreakListWidget({super.key, required this.entries, this.dark = false});

  /// (title, icon, days)
  final List<(String, IconData, int)> entries;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return _WidgetCard(
      dark: dark,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final (title, icon, days) in entries.take(2))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: dark ? WidgetPalette.trackDark : const Color(0xFFF2F5F8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: WidgetPalette.blue.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, size: 18, color: WidgetPalette.blue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                        ),
                        Text(
                          '$days Days',
                          style: const TextStyle(
                            fontSize: 12,
                            color: WidgetPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Small: today's checklist.
class TodayListWidget extends StatelessWidget {
  const TodayListWidget({
    super.key,
    required this.title,
    required this.remaining,
    required this.items,
    this.dark = false,
  });

  final String title;
  final int remaining;

  /// (label, done)
  final List<(String, bool)> items;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return _WidgetCard(
      dark: dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: WidgetPalette.green,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$remaining',
                style: const TextStyle(
                  fontSize: 16,
                  color: WidgetPalette.muted,
                ),
              ),
              const Spacer(),
              const Icon(Icons.add, size: 20, color: WidgetPalette.muted),
            ],
          ),
          const SizedBox(height: 4),
          for (final (label, done) in items.take(4))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: done ? WidgetPalette.green : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: done
                            ? WidgetPalette.green
                            : WidgetPalette.muted.withValues(alpha: 0.6),
                        width: 1.6,
                      ),
                    ),
                    child: done
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: done ? WidgetPalette.muted : ink,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Medium: a metric habit's day, with the week underneath.
class MetricProgressWidget extends StatelessWidget {
  const MetricProgressWidget({
    super.key,
    required this.title,
    required this.streakDays,
    required this.valueLabel,
    required this.icon,
    required this.days,
    this.dark = false,
  });

  final String title;
  final int streakDays;
  final String valueLabel;
  final IconData icon;
  final List<WidgetDay> days;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? WidgetPalette.inkDark : WidgetPalette.ink;
    return _WidgetCard(
      dark: dark,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // spaceBetween rather than a Spacer: a flexible child makes this
        // subtree relayout after its first paint, which trips the
        // render-to-image boundary's `!debugNeedsPaint` assertion.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streakDays Days',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: WidgetPalette.blue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      valueLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: WidgetPalette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: WidgetPalette.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
            ],
          ),
          _DayStrip(days: days, dark: dark, dotSize: 30),
        ],
      ),
    );
  }
}
