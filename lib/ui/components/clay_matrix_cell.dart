import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// The four states a matrix cell can be in
/// (core_features.matrix_grid + claymorphic_specs).
enum MatrixCellState {
  /// Scheduled, not yet done - raised clay.
  incomplete,

  /// Logged something, short of target - half-filled.
  partial,

  /// Done - recessed with a checkmark.
  complete,

  /// Scheduled, day is over, not done - desaturated recessed, no icon.
  missed,

  /// Not due today - flat, 40% opacity, dashed border.
  notScheduled,
}

/// Grid Molecule.
///
/// const-constructible and RepaintBoundary-wrapped, with the decoration
/// resolved from the memoised ClayTheme map rather than assembled per frame -
/// the single most important perf rule for a 1,464-cell grid.
///
/// Accessibility: the completion state is carried by the glyph and the depth as
/// well as the colour, and every cell exposes
/// '{habitTitle}, {date}, {state}' as its semantic label.
class ClayMatrixCell extends StatelessWidget {
  const ClayMatrixCell({
    super.key,
    required this.state,
    required this.semanticLabel,
    this.onTap,
    this.onLongPress,
    this.ratio = 0,
    this.size = AppConstants.matrixCellSize,
    this.isToday = false,
  });

  final MatrixCellState state;
  final String semanticLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double ratio;
  final double size;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;

    final surfaceState = switch (state) {
      MatrixCellState.incomplete => ClaySurfaceState.raised,
      MatrixCellState.partial => ClaySurfaceState.recessed,
      MatrixCellState.complete => ClaySurfaceState.recessed,
      MatrixCellState.missed => ClaySurfaceState.recessed,
      MatrixCellState.notScheduled => ClaySurfaceState.notScheduled,
    };

    final color = switch (state) {
      MatrixCellState.complete => clay.gridChecked,
      MatrixCellState.partial => clay.gridChecked,
      MatrixCellState.missed => clay.gridMissed,
      MatrixCellState.notScheduled => clay.gridNotScheduled,
      MatrixCellState.incomplete => clay.surface,
    };

    Widget? glyph;
    switch (state) {
      case MatrixCellState.complete:
        glyph = Icon(
          Icons.check_rounded,
          size: size * 0.5,
          color: clay.gridCheckedIcon,
        );
      case MatrixCellState.partial:
        glyph = Icon(
          Icons.change_history_rounded,
          size: size * 0.42,
          color: clay.warningAmber,
        );
      case MatrixCellState.missed:
        // No icon - the recessed desaturated surface carries the state, and it
        // must be distinguishable from 'complete' without relying on colour.
        glyph = Icon(
          Icons.remove_rounded,
          size: size * 0.34,
          color: clay.textSecondary.withValues(alpha: 0.6),
        );
      case MatrixCellState.notScheduled:
      case MatrixCellState.incomplete:
        glyph = null;
    }

    // The visual cell is smaller than the 48dp minimum target, so the tappable
    // area is padded out around it (accessibility_standards).
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: AppConstants.matrixHitTarget,
          child: Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              onLongPress: onLongPress,
              child: RepaintBoundary(
                child: ClayContainer(
                  state: surfaceState,
                  color: color,
                  radius: 12,
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state == MatrixCellState.partial)
                        FractionallySizedBox(
                          heightFactor: ratio.clamp(0.08, 1.0),
                          widthFactor: 1,
                          alignment: Alignment.bottomCenter,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: clay.gridCheckedIcon.withValues(
                                alpha: 0.22,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(11),
                              ),
                            ),
                          ),
                        ),
                      ?glyph,
                      if (isToday)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: clay.accentFrost,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
