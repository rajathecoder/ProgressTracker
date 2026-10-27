import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/fallback_delegates.dart';
import 'core/providers/app_providers.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/app_shell.dart';
import 'l10n/app_localizations.dart';
import 'ui/components/clay_feedback.dart';

class ArcCoreApp extends ConsumerWidget {
  const ArcCoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Happy Days',
      debugShowCheckedModeBanner: false,
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
      localizationsDelegates: appLocalizationDelegates,
      supportedLocales: appSupportedLocales,
      builder: (context, child) {
        // accessibility_standards: honour MediaQuery.disableAnimations as well
        // as the manual reduce_motion setting, and support text scale to 200%.
        final media = MediaQuery.of(context);
        final effectiveReduceMotion =
            settings.reduceMotion || media.disableAnimations;
        return MediaQuery(
          data: media.copyWith(
            disableAnimations: effectiveReduceMotion,
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 2.0,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(arcStateProvider);

    // Once we have a resolved state we never fall back to the skeleton, even
    // while a recompute is in flight - a mid-session reload must not blank the
    // app the user is looking at.
    if (state.hasValue) {
      return state.value == null ? const OnboardingScreen() : const AppShell();
    }
    if (state.hasError) return _BootError(message: '${state.error}');

    // performance_budget.startup: paint ClaySkeleton first rather than a
    // spinner, so the very first frame already has the app's shape.
    return const _BootSkeleton();
  }
}

class _BootSkeleton extends StatelessWidget {
  const _BootSkeleton();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ClaySkeleton(height: 28, width: 190),
            const SizedBox(height: 20),
            const ClaySkeleton(height: 92, radius: 24),
            const SizedBox(height: 16),
            const ClaySkeleton(height: 240, radius: 24),
            const SizedBox(height: 16),
            for (var i = 0; i < 3; i++) ...[
              const ClaySkeleton(height: 64, radius: 20),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ),
  );
}

class _BootError extends StatelessWidget {
  const _BootError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ClayEmptyState(
        title: l.errorGeneric,
        message: message,
        icon: Icons.warning_amber_rounded,
      ),
    );
  }
}
