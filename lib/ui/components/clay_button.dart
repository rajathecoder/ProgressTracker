import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Interactive Atom - tactile clay pill with a scale bounce on tap.
///
/// Motion is decorative, never load-bearing: under reduce-motion the bounce
/// becomes an instant state change and the pressed depth still reads.
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    this.primary = false,
    this.destructive = false,
    this.compact = false,
    this.semanticLabel,
    this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool primary;
  final bool destructive;
  final bool compact;
  final String? semanticLabel;
  final Widget? child;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final enabled = widget.onPressed != null;
    final accent = widget.destructive ? clay.accentEmber : clay.accentFrost;

    final state = !enabled
        ? ClaySurfaceState.disabled
        : _pressed
        ? ClaySurfaceState.pressed
        : ClaySurfaceState.raised;

    final fg = widget.primary && enabled
        ? (clay.isDark ? clay.background : Colors.white)
        : enabled
        ? clay.textPrimary
        : clay.textSecondary;

    final content =
        widget.child ??
        Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 18, color: fg),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

    final scale = _pressed && !clay.reduceMotion ? ClayTheme.pressScale : 1.0;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: scale,
            duration: clay.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 110),
            curve: Curves.easeOutBack,
            child: ClayContainer(
              state: state,
              color: widget.primary && enabled ? accent : null,
              radius: widget.compact ? 16 : 20,
              constraints: BoxConstraints(minHeight: widget.compact ? 40 : 52),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 14 : 22,
                vertical: widget.compact ? 8 : 14,
              ),
              width: widget.expand ? double.infinity : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
