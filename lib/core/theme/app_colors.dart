import 'package:flutter/material.dart';

/// Raw palette from arccore_spec_v1.3.0 -> ui_ux_design_system.colors.
///
/// One deliberate deviation from the spec document: the light-mode
/// [lightTextSecondary] is #5A6678 rather than #718096. The spec's own
/// `contrast_audit_required` note flags #718096 on #F0F5FA at ~4.0:1 as a
/// WCAG AA failure for body text and instructs darkening it before ship.
abstract final class AppColors {
  // ---------------------------------------------------------------- dark mode
  static const darkBackground = Color(0xFF0A0D14);
  static const darkSurface = Color(0xFF131822);
  static const darkSurfaceBorder = Color(0xFF212A3B);
  static const darkAccentFrost = Color(0xFF4ECCE8);
  static const darkAccentEmber = Color(0xFFFF6B4A);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF8A94A6);
  static const darkGridChecked = Color(0xFF1F3B34);
  static const darkGridCheckedIcon = Color(0xFF2ECC71);
  static const darkGridMissed = Color(0xFF1A1D24);
  static const darkGridNotScheduled = Color(0xFF101420);
  static const darkWarningAmber = Color(0xFFF5A623);
  static const darkShieldViolet = Color(0xFF9B7BE8);

  // --------------------------------------------------------------- light mode
  static const lightBackground = Color(0xFFE8F0F8);
  static const lightSurface = Color(0xFFF0F5FA);
  static const lightSurfaceBorder = Color(0xFFD1DDE8);
  static const lightAccentFrost = Color(0xFF0288D1);
  static const lightAccentEmber = Color(0xFFE64A19);
  static const lightTextPrimary = Color(0xFF1A202C);
  static const lightTextSecondary = Color(0xFF5A6678); // audit fix
  static const lightGridChecked = Color(0xFFC8E6C9);
  static const lightGridCheckedIcon = Color(0xFF2E7D32);
  static const lightGridMissed = Color(0xFFDDE5ED);
  static const lightGridNotScheduled = Color(0xFFE3EAF2);
  static const lightWarningAmber = Color(0xFFC77700);
  static const lightShieldViolet = Color(0xFF6B4FBB);

  // ------------------------------------------------------------- stat accents
  static const statDiscipline = Color(0xFF4ECCE8);
  static const statVitality = Color(0xFF2ECC71);
  static const statStrength = Color(0xFFFF6B4A);
  static const statFocus = Color(0xFFF5A623);
  static const statSpirit = Color(0xFF9B7BE8);
}
