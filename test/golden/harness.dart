import 'package:arccore/core/theme/app_theme.dart';
import 'package:arccore/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Wraps a widget in the smallest shell that still gives it the real theme,
/// the real localizations and a deterministic size.
Widget clayHarness({
  required Widget child,
  bool dark = false,
  bool highContrast = false,
  bool reduceMotion = true,
  Locale locale = const Locale('en'),
  double textScale = 1.0,
  Size size = const Size(420, 320),
}) {
  final theme = AppTheme.build(
    dark: dark,
    highContrast: highContrast,
    reduceMotion: reduceMotion,
  );
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        // reduce-motion is forced on in goldens so no animation can make an
        // image flake.
        data: MediaQuery.of(context).copyWith(
          disableAnimations: true,
          textScaler: TextScaler.linear(textScale),
        ),
        child: Scaffold(
          // Real screens scroll vertically, so the harness does too. That keeps
          // the assertion focused on *horizontal* overflow, which is what long
          // Tamil and Hindi strings actually cause.
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: size.width,
                child: Padding(padding: const EdgeInsets.all(16), child: child),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
