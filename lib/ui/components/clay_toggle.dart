import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Interactive Atom - a sliding puck that depresses into a recessed track.
class ClayToggle extends StatelessWidget {
  const ClayToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final enabled = onChanged != null;

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: enabled ? () => onChanged!(!value) : null,
          child: ClayContainer(
            state: ClaySurfaceState.recessed,
            radius: 18,
            width: 58,
            height: 34,
            padding: const EdgeInsets.all(3),
            child: AnimatedAlign(
              duration: clay.reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              alignment: value
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: ClayContainer(
                state: ClaySurfaceState.raised,
                radius: 14,
                width: 28,
                height: 28,
                color: value ? clay.accentFrost : clay.surface,
                child: value
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: clay.isDark ? clay.background : Colors.white,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
