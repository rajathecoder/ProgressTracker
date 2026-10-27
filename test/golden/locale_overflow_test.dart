@Tags(['golden'])
library;

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/utils/l10n_lookup.dart';
import 'package:arccore/l10n/app_localizations.dart';
import 'package:arccore/ui/components/clay_button.dart';
import 'package:arccore/ui/components/clay_chip.dart';
import 'package:arccore/ui/components/clay_segmented_control.dart';
import 'package:arccore/ui/components/clay_stat_card.dart';
import 'package:arccore/ui/components/clay_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// localization_engine.formatting_rules:
/// "Tamil and Hindi strings run 30-60% longer than English. Every text
/// container must wrap or ellipsize, and a golden test per locale catches
/// overflow before it ships."
void main() {
  Widget densePanel() => Builder(
    builder: (context) {
      final l = AppLocalizations.of(context);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.dashboardGreeting('Rajesh'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(l.arcDayCounter(37, 122)),
          const SizedBox(height: 6),
          Text(l.streakCount(14)),
          Text(l.shieldCount(2)),
          Text(l.multiplierActive('1.2')),
          const SizedBox(height: 12),
          ClaySegmentedControl<int>(
            segments: {
              0: l.matrixZoomWeek,
              1: l.matrixZoomMonth,
              2: l.matrixZoomArc,
            },
            value: 1,
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in HabitCategories.all)
                ClayChip(label: L10nLookup.category(c, l), onTap: () {}),
            ],
          ),
          const SizedBox(height: 12),
          for (final stat in StatKeys.all.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ClayStatCard(
                title: L10nLookup.stat(stat, l),
                score: 64,
                rawXp: 1830,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.gavel_rounded,
                compact: true,
              ),
            ),
          Row(
            children: [
              Expanded(child: Text(l.settingsHardcoreModeDesc)),
              const SizedBox(width: 12),
              ClayToggle(value: true, onChanged: (_) {}),
            ],
          ),
          const SizedBox(height: 12),
          ClayButton(
            label: l.getStarted,
            primary: true,
            expand: true,
            onPressed: () {},
          ),
        ],
      );
    },
  );

  for (final code in ['en', 'ta', 'es', 'hi']) {
    testWidgets('$code renders without overflow', (tester) async {
      // A phone-sized surface tall enough to hold the whole panel, so the only
      // thing that can overflow is the horizontal axis.
      tester.view.physicalSize = const Size(390 * 3, 1100 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        clayHarness(
          child: densePanel(),
          locale: Locale(code),
          dark: true,
          size: const Size(390, 1100),
        ),
      );
      await tester.pumpAndSettle();

      // A RenderFlex overflow throws during paint in a test binding, so an
      // empty exception queue is the actual assertion here.
      expect(
        tester.takeException(),
        isNull,
        reason: 'text overflow in locale $code',
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/locale_$code.png'),
      );
    });
  }
}
