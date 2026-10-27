import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Interactive Atom - compact pill for tags, categories and filters.
/// Raised when unselected, recessed with accent fill when selected.
class ClayChip extends StatelessWidget {
  const ClayChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.color,
    this.onDeleted,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final accent = color ?? clay.accentFrost;
    final fg = selected ? accent : clay.textSecondary;

    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: ClayContainer(
            state: selected
                ? ClaySurfaceState.recessed
                : ClaySurfaceState.raised,
            radius: 14,
            color: selected && !clay.highContrast
                ? Color.alphaBlend(accent.withValues(alpha: 0.16), clay.surface)
                : null,
            padding: const EdgeInsetsDirectional.only(
              start: 12,
              end: 12,
              top: 8,
              bottom: 8,
            ),
            constraints: const BoxConstraints(minHeight: 36),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 15, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (onDeleted != null) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onDeleted,
                    child: Icon(Icons.close_rounded, size: 14, color: fg),
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
