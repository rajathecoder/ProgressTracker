import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Form Atom - numeric entry for metric habits (steps, litres, minutes, hours)
/// with -/+ clay buttons and a draggable slider.
///
/// This is what replaces the binary toggle for non-boolean habits, which is the
/// whole point of core_features.metric_logging: 8,400 steps is not a failure.
class ClayStepper extends StatelessWidget {
  const ClayStepper({
    super.key,
    required this.value,
    required this.target,
    required this.onChanged,
    required this.unitLabel,
    this.step,
    this.max,
  });

  final double value;
  final double target;
  final ValueChanged<double> onChanged;
  final String unitLabel;
  final double? step;
  final double? max;

  double get _step => step ?? (target >= 1000 ? 500 : (target >= 60 ? 5 : 1));
  double get _max => max ?? (target <= 0 ? 10 : target * 1.5);

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final text = Theme.of(context).textTheme;
    final ratio = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StepButton(
              icon: Icons.remove_rounded,
              onTap: value <= 0
                  ? null
                  : () => onChanged((value - _step).clamp(0, _max)),
              semanticLabel: '-${_step.toStringAsFixed(0)}',
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    _format(value),
                    style: text.displayMedium?.copyWith(
                      color: ratio >= 1
                          ? clay.gridCheckedIcon
                          : clay.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text('${_format(target)} $unitLabel', style: text.bodySmall),
                ],
              ),
            ),
            _StepButton(
              icon: Icons.add_rounded,
              onTap: () => onChanged((value + _step).clamp(0, _max)),
              semanticLabel: '+${_step.toStringAsFixed(0)}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: clay.accentFrost,
            inactiveTrackColor: clay.isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFD6E0EA),
            thumbColor: clay.accentFrost,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value.clamp(0, _max),
            max: _max,
            divisions: (_max / _step).round().clamp(1, 200),
            label: _format(value),
            onChanged: (v) => onChanged(v.roundToDouble()),
          ),
        ),
      ],
    );
  }

  static String _format(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: ClayContainer(
            state: onTap == null
                ? ClaySurfaceState.disabled
                : ClaySurfaceState.raised,
            radius: 18,
            width: 52,
            height: 52,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: onTap == null ? clay.textSecondary : clay.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
