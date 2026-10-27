import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Metric Molecule - localized stat title, dynamic progress bar, XP count and
/// a 3D emblem.
///
/// The bar plots the *normalised* consistency score, not raw XP - see
/// gamification_engine.stat_normalization.
class ClayStatCard extends StatelessWidget {
  const ClayStatCard({
    super.key,
    required this.title,
    required this.score,
    required this.rawXp,
    required this.color,
    required this.icon,
    this.compact = false,
  });

  final String title;

  /// 0-100 normalised consistency.
  final double score;
  final int rawXp;
  final Color color;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final text = Theme.of(context).textTheme;

    return Semantics(
      label: '$title, ${score.round()} / 100, $rawXp XP',
      child: ExcludeSemantics(
        child: ClayContainer(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Row(
            children: [
              ClayContainer(
                state: ClaySurfaceState.recessed,
                radius: 14,
                width: compact ? 38 : 46,
                height: compact ? 38 : 46,
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: compact ? 19 : 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: text.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${score.round()}',
                          style: text.titleMedium?.copyWith(
                            color: color,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _StatBar(value: score / 100, color: color),
                    const SizedBox(height: 6),
                    Text(
                      '$rawXp XP',
                      style: text.labelSmall?.copyWith(
                        color: clay.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return ClayContainer(
      state: ClaySurfaceState.recessed,
      radius: 6,
      height: 10,
      padding: const EdgeInsets.all(2),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: AnimatedContainer(
            duration: clay.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
