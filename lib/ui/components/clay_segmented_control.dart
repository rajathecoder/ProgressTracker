import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Interactive Atom - recessed track with a raised sliding indicator.
/// Powers the matrix Week/Month/Arc zoom and the analytics range picker.
class ClaySegmentedControl<T> extends StatelessWidget {
  const ClaySegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.expand = true,
  });

  final Map<T, String> segments;
  final T value;
  final ValueChanged<T> onChanged;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final entries = segments.entries.toList();

    return ClayContainer(
      state: ClaySurfaceState.recessed,
      radius: 18,
      padding: const EdgeInsets.all(4),
      width: expand ? double.infinity : null,
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          for (final e in entries)
            Expanded(
              flex: expand ? 1 : 0,
              child: Semantics(
                selected: e.key == value,
                button: true,
                label: e.value,
                child: ExcludeSemantics(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(e.key),
                    child: AnimatedContainer(
                      duration: clay.reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      constraints: const BoxConstraints(minHeight: 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: e.key == value
                          ? clay
                                .styleFor(
                                  ClaySurfaceState.raised,
                                  radiusOverride: 14,
                                )
                                .decoration
                          : const BoxDecoration(),
                      child: Text(
                        e.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: e.key == value
                              ? clay.accentFrost
                              : clay.textSecondary,
                          fontWeight: e.key == value
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
