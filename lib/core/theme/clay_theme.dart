import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Every surface state in the design system is a named token. Call sites never
/// assemble a raw `BoxShadow` list - they name a state and the theme resolves
/// it. See ui_ux_design_system.design_principles.
enum ClaySurfaceState {
  raised,
  pressed,
  recessed,
  flat,
  disabled,
  notScheduled,
}

/// A fully resolved surface: the decoration plus the scale/opacity modifiers
/// that belong to the state.
@immutable
class ClaySurfaceStyle {
  const ClaySurfaceStyle({
    required this.decoration,
    required this.scale,
    required this.opacity,
  });

  final BoxDecoration decoration;
  final double scale;
  final double opacity;
}

/// Single source of truth for claymorphic surfaces. Light, dark and
/// high-contrast all swap here and nowhere else.
@immutable
class ClayTheme extends ThemeExtension<ClayTheme> {
  ClayTheme({
    required this.isDark,
    required this.highContrast,
    required this.reduceMotion,
    required this.background,
    required this.surface,
    required this.surfaceBorder,
    required this.accentFrost,
    required this.accentEmber,
    required this.textPrimary,
    required this.textSecondary,
    required this.gridChecked,
    required this.gridCheckedIcon,
    required this.gridMissed,
    required this.gridNotScheduled,
    required this.warningAmber,
    required this.shieldViolet,
  }) : radius = highContrast ? highContrastRadius : cardRadius,
       _cache = <_StyleKey, ClaySurfaceStyle>{};

  /// claymorphic_specs.card_border_radius
  static const double cardRadius = 24;
  static const double highContrastRadius = 12;

  /// claymorphic_specs.press_depth_effect
  static const double pressScale = 0.96;

  final bool isDark;
  final bool highContrast;
  final bool reduceMotion;

  final Color background;
  final Color surface;
  final Color surfaceBorder;
  final Color accentFrost;
  final Color accentEmber;
  final Color textPrimary;
  final Color textSecondary;
  final Color gridChecked;
  final Color gridCheckedIcon;
  final Color gridMissed;
  final Color gridNotScheduled;
  final Color warningAmber;
  final Color shieldViolet;

  final double radius;

  /// Decorations are memoised per (state, surfaceColor, radius). Rebuilding a
  /// two-layer shadow list per cell per frame is the single most likely source
  /// of jank on the 1,464-cell matrix (performance_budget.matrix_grid).
  final Map<_StyleKey, ClaySurfaceStyle> _cache;

  ClaySurfaceStyle styleFor(
    ClaySurfaceState state, {
    Color? color,
    double? radiusOverride,
  }) {
    final key = _StyleKey(state, color ?? surface, radiusOverride ?? radius);
    return _cache[key] ??= _build(state, key.color, key.radius);
  }

  ClaySurfaceStyle _build(ClaySurfaceState state, Color color, double r) {
    final borderRadius = BorderRadius.circular(r);

    if (highContrast) {
      // high_contrast_override: shadows collapse to a single solid border.
      final border = Border.all(color: _contrastBorderColor(state), width: 2);
      return ClaySurfaceStyle(
        decoration: BoxDecoration(
          color: state == ClaySurfaceState.notScheduled
              ? gridNotScheduled
              : color,
          borderRadius: borderRadius,
          border: border,
        ),
        scale: state == ClaySurfaceState.pressed ? pressScale : 1,
        opacity: state == ClaySurfaceState.disabled ? 0.5 : 1,
      );
    }

    switch (state) {
      case ClaySurfaceState.raised:
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            boxShadow: _raisedShadows(),
            // With shadows disabled, a hairline is the only thing that still
            // separates a raised surface from the background behind it.
            border: Border.all(color: surfaceBorder, width: 1),
          ),
          scale: 1,
          opacity: 1,
        );
      case ClaySurfaceState.pressed:
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            boxShadow: _pressedShadows(),
            border: Border.all(color: surfaceBorder, width: 1),
          ),
          scale: pressScale,
          opacity: 1,
        );
      case ClaySurfaceState.recessed:
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: _darken(color, isDark ? 0.16 : 0.05),
            borderRadius: borderRadius,
            boxShadow: _recessedShadows(),
            // A sunken surface reads as depth in light mode, where the inner
            // shadow falls on a bright ground. In dark mode the shadow lands on
            // an already-dark surface and the field's edge disappears, so it
            // gets a soft hairline instead.
            border: Border.all(
              color: isDark
                  ? surfaceBorder.withValues(alpha: 0.85)
                  : surfaceBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          scale: 1,
          opacity: 1,
        );
      case ClaySurfaceState.flat:
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border: Border.all(color: surfaceBorder),
          ),
          scale: 1,
          opacity: 1,
        );
      case ClaySurfaceState.disabled:
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: _desaturate(color),
            borderRadius: borderRadius,
            border: Border.all(color: surfaceBorder),
          ),
          scale: 1,
          opacity: 0.5,
        );
      case ClaySurfaceState.notScheduled:
        // Flat, 40% opacity, dashed border - see ClayDashedBorder, which paints
        // the dashes; the decoration itself stays borderless so the two do not
        // double up.
        return ClaySurfaceStyle(
          decoration: BoxDecoration(
            color: gridNotScheduled,
            borderRadius: borderRadius,
          ),
          scale: 1,
          opacity: 0.4,
        );
    }
  }

  Color _contrastBorderColor(ClaySurfaceState state) => switch (state) {
    ClaySurfaceState.disabled => textSecondary,
    ClaySurfaceState.notScheduled => textSecondary,
    ClaySurfaceState.recessed || ClaySurfaceState.pressed => accentFrost,
    _ => textPrimary,
  };

  // Shadows are disabled for this build: surfaces stay flat everywhere.
  List<BoxShadow> _raisedShadows() => const [];

  List<BoxShadow> _pressedShadows() => const [];

  List<BoxShadow> _recessedShadows() => const [];

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _desaturate(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withSaturation((hsl.saturation * 0.3).clamp(0.0, 1.0)).toColor();
  }

  Color statColor(String stat) => switch (stat) {
    'Discipline' => AppColors.statDiscipline,
    'Vitality' => AppColors.statVitality,
    'Strength' => AppColors.statStrength,
    'Focus' => AppColors.statFocus,
    'Spirit' => AppColors.statSpirit,
    _ => accentFrost,
  };

  factory ClayTheme.dark({
    bool highContrast = false,
    bool reduceMotion = false,
  }) => ClayTheme(
    isDark: true,
    highContrast: highContrast,
    reduceMotion: reduceMotion,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceBorder: AppColors.darkSurfaceBorder,
    accentFrost: AppColors.darkAccentFrost,
    accentEmber: AppColors.darkAccentEmber,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    gridChecked: AppColors.darkGridChecked,
    gridCheckedIcon: AppColors.darkGridCheckedIcon,
    gridMissed: AppColors.darkGridMissed,
    gridNotScheduled: AppColors.darkGridNotScheduled,
    warningAmber: AppColors.darkWarningAmber,
    shieldViolet: AppColors.darkShieldViolet,
  );

  factory ClayTheme.light({
    bool highContrast = false,
    bool reduceMotion = false,
  }) => ClayTheme(
    isDark: false,
    highContrast: highContrast,
    reduceMotion: reduceMotion,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceBorder: AppColors.lightSurfaceBorder,
    accentFrost: AppColors.lightAccentFrost,
    accentEmber: AppColors.lightAccentEmber,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    gridChecked: AppColors.lightGridChecked,
    gridCheckedIcon: AppColors.lightGridCheckedIcon,
    gridMissed: AppColors.lightGridMissed,
    gridNotScheduled: AppColors.lightGridNotScheduled,
    warningAmber: AppColors.lightWarningAmber,
    shieldViolet: AppColors.lightShieldViolet,
  );

  @override
  ClayTheme copyWith({bool? highContrast, bool? reduceMotion}) => ClayTheme(
    isDark: isDark,
    highContrast: highContrast ?? this.highContrast,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    background: background,
    surface: surface,
    surfaceBorder: surfaceBorder,
    accentFrost: accentFrost,
    accentEmber: accentEmber,
    textPrimary: textPrimary,
    textSecondary: textSecondary,
    gridChecked: gridChecked,
    gridCheckedIcon: gridCheckedIcon,
    gridMissed: gridMissed,
    gridNotScheduled: gridNotScheduled,
    warningAmber: warningAmber,
    shieldViolet: shieldViolet,
  );

  @override
  ClayTheme lerp(ThemeExtension<ClayTheme>? other, double t) {
    if (other is! ClayTheme) return this;
    return t < 0.5 ? this : other;
  }
}

@immutable
class _StyleKey {
  const _StyleKey(this.state, this.color, this.radius);
  final ClaySurfaceState state;
  final Color color;
  final double radius;

  @override
  bool operator ==(Object other) =>
      other is _StyleKey &&
      other.state == state &&
      other.color == color &&
      other.radius == radius;

  @override
  int get hashCode => Object.hash(state, color, radius);
}

/// Convenience accessor so widgets read `context.clay` instead of a long
/// `Theme.of(context).extension<ClayTheme>()!` chain.
extension ClayThemeContext on BuildContext {
  ClayTheme get clay => Theme.of(this).extension<ClayTheme>()!;
}
