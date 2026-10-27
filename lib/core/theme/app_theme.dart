import 'package:flutter/material.dart';

import 'clay_theme.dart';

abstract final class AppTheme {
  /// typography: Inter for prose, JetBrains Mono for numerics.
  /// Neither font is bundled, so we name them and let the platform fall back
  /// to its own UI face. Drop the .ttf files into assets/fonts and declare
  /// them in pubspec.yaml to pin the exact faces.
  static const String fontFamily = 'Inter';
  static const String monoFamily = 'JetBrainsMono';

  static ThemeData build({
    required bool dark,
    required bool highContrast,
    required bool reduceMotion,
  }) {
    final clay = dark
        ? ClayTheme.dark(highContrast: highContrast, reduceMotion: reduceMotion)
        : ClayTheme.light(
            highContrast: highContrast,
            reduceMotion: reduceMotion,
          );

    final scheme =
        ColorScheme.fromSeed(
          seedColor: clay.accentFrost,
          brightness: dark ? Brightness.dark : Brightness.light,
        ).copyWith(
          surface: clay.surface,
          primary: clay.accentFrost,
          secondary: clay.accentEmber,
          onSurface: clay.textPrimary,
        );

    final base = dark ? ThemeData.dark() : ThemeData.light();

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: clay.background,
      canvasColor: clay.background,
      splashFactory: reduceMotion
          ? NoSplash.splashFactory
          : InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[clay],
      textTheme: _textTheme(clay),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final p in TargetPlatform.values)
            p: reduceMotion
                ? const _NoAnimationPageTransitionsBuilder()
                : const FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: clay.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: clay.textPrimary,
        ),
        iconTheme: IconThemeData(color: clay.textPrimary),
      ),
      dividerTheme: DividerThemeData(color: clay.surfaceBorder, thickness: 1),
      // Belt-and-braces for the same reason as dialogTheme below: without an
      // explicit shape/elevation here, Material 3's own BottomSheetThemeData
      // defaults can win over showClayBottomSheet's own styling and render a
      // sheet that looks like a floating card instead of one flush with the
      // screen edges and bottom.
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shape: RoundedRectangleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: clay.surface,
        contentTextStyle: TextStyle(color: clay.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(clay.radius),
        ),
      ),
      // Native pickers (showTimePicker) are the only popups that don't go
      // through clay_feedback.dart's shared helpers, so without this they
      // render as stock Material dialogs next to otherwise-claymorphic UI.
      dialogTheme: DialogThemeData(
        backgroundColor: clay.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(clay.radius),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: clay.surface,
        dialBackgroundColor: clay.background,
        dialHandColor: clay.accentFrost,
        entryModeIconColor: clay.textSecondary,
        hourMinuteColor: clay.background,
        hourMinuteTextColor: clay.textPrimary,
        dayPeriodColor: clay.background,
        dayPeriodTextColor: clay.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(clay.radius),
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        helpTextStyle: TextStyle(color: clay.textSecondary),
      ),
    );
  }

  static TextTheme _textTheme(ClayTheme clay) {
    TextStyle s(double size, FontWeight w, Color c, {double? h, String? f}) =>
        TextStyle(
          fontFamily: f ?? fontFamily,
          fontSize: size,
          fontWeight: w,
          color: c,
          height: h,
        );
    return TextTheme(
      displayLarge: s(40, FontWeight.w800, clay.textPrimary, h: 1.1),
      displayMedium: s(32, FontWeight.w800, clay.textPrimary, h: 1.15),
      headlineLarge: s(28, FontWeight.w700, clay.textPrimary, h: 1.2),
      headlineMedium: s(24, FontWeight.w700, clay.textPrimary, h: 1.2),
      headlineSmall: s(20, FontWeight.w700, clay.textPrimary, h: 1.25),
      titleLarge: s(18, FontWeight.w700, clay.textPrimary),
      titleMedium: s(16, FontWeight.w600, clay.textPrimary),
      titleSmall: s(14, FontWeight.w600, clay.textSecondary),
      bodyLarge: s(16, FontWeight.w400, clay.textPrimary, h: 1.45),
      bodyMedium: s(14, FontWeight.w400, clay.textPrimary, h: 1.45),
      bodySmall: s(12, FontWeight.w400, clay.textSecondary, h: 1.4),
      labelLarge: s(14, FontWeight.w600, clay.textPrimary),
      labelMedium: s(12, FontWeight.w600, clay.textSecondary),
      labelSmall: s(11, FontWeight.w500, clay.textSecondary),
    );
  }
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}
