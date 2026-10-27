import 'package:flutter/material.dart';

import '../../core/theme/clay_theme.dart';
import 'clay_container.dart';

/// Form Atom - recessed (sunken clay) text input with a floating label.
class ClayInputField extends StatelessWidget {
  const ClayInputField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.icon,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.obscureText = false,
    this.showClear = true,
    this.semanticLabel,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? icon;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool obscureText;
  final bool showClear;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 6, bottom: 8),
          child: Text(label, style: text.labelMedium),
        ),
        ClayContainer(
          state: ClaySurfaceState.recessed,
          radius: 18,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: clay.textSecondary),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: obscureText ? 1 : maxLines,
                  minLines: minLines,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  textInputAction: textInputAction,
                  autofocus: autofocus,
                  obscureText: obscureText,
                  style: text.bodyLarge,
                  cursorColor: clay.accentFrost,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: text.bodyMedium?.copyWith(
                      color: clay.textSecondary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (showClear && controller != null)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller!,
                  builder: (context, value, _) => value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).deleteButtonTooltip,
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: clay.textSecondary,
                          ),
                          onPressed: () {
                            controller!.clear();
                            onChanged?.call('');
                          },
                        ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
