import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Metric Molecule - achievement emblem.
/// Locked: flat grey, silhouette. Unlocked: raised, full colour, with an
/// optional progress ring on partially-earned trophies.
class ClayTrophyMedal extends StatelessWidget {
  const ClayTrophyMedal({
    super.key,
    required this.title,
    required this.icon,
    required this.unlocked,
    required this.progress,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final bool unlocked;
  final double progress;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final text = Theme.of(context).textTheme;
    final accent = unlocked ? clay.accentFrost : clay.textSecondary;

    return Semantics(
      label: unlocked
          ? '$title, unlocked'
          : '$title, locked, ${(progress * 100).round()}%',
      button: onTap != null,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: ClayContainer(
            state: unlocked
                ? ClaySurfaceState.raised
                : ClaySurfaceState.disabled,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 62,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!unlocked && progress > 0)
                        SizedBox.square(
                          dimension: 62,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            backgroundColor: clay.surfaceBorder,
                            valueColor: AlwaysStoppedAnimation(
                              clay.accentFrost.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ClayContainer(
                        state: unlocked
                            ? ClaySurfaceState.raised
                            : ClaySurfaceState.flat,
                        radius: 22,
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        color: unlocked
                            ? Color.alphaBlend(
                                clay.accentFrost.withValues(alpha: 0.18),
                                clay.surface,
                              )
                            : null,
                        child: Icon(icon, color: accent, size: 24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium?.copyWith(
                    color: unlocked ? clay.textPrimary : clay.textSecondary,
                    fontWeight: unlocked ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid Atom - small rounded cell with 5 intensity levels, driven by daily
/// completion ratio. Powers the analytics contribution heatmap.
class ClayHeatmapCell extends StatelessWidget {
  const ClayHeatmapCell({
    super.key,
    required this.intensity,
    required this.semanticLabel,
    this.size = 13,
    this.counted = true,
    this.onTap,
  });

  /// 0-4
  final int intensity;
  final String semanticLabel;
  final double size;
  final bool counted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final base = clay.gridCheckedIcon;
    final color = !counted
        ? clay.gridNotScheduled
        : switch (intensity) {
            0 => clay.gridMissed,
            1 => base.withValues(alpha: 0.22),
            2 => base.withValues(alpha: 0.42),
            3 => base.withValues(alpha: 0.68),
            _ => base,
          };

    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              border: clay.highContrast
                  ? Border.all(color: clay.textPrimary, width: 0.5)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
