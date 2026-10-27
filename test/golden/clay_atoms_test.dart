@Tags(['golden'])
library;

import 'package:arccore/core/theme/clay_theme.dart';
import 'package:arccore/ui/components/clay_button.dart';
import 'package:arccore/ui/components/clay_chip.dart';
import 'package:arccore/ui/components/clay_container.dart';
import 'package:arccore/ui/components/clay_matrix_cell.dart';
import 'package:arccore/ui/components/clay_progress_ring.dart';
import 'package:arccore/ui/components/clay_segmented_control.dart';
import 'package:arccore/ui/components/clay_stat_card.dart';
import 'package:arccore/ui/components/clay_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// testing_strategy.golden:
/// "Every Clay atom across light/dark x raised/pressed/recessed/disabled/
/// notScheduled" and "matrix row rendering for all four cell states."
///
/// Run/refresh with: flutter test test/golden --update-goldens
void _noop(bool _) {}

void main() {
  Widget surfaces() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final state in ClaySurfaceState.values)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ClayContainer(
            state: state,
            height: 44,
            alignment: Alignment.center,
            child: Text(state.name),
          ),
        ),
    ],
  );

  Widget matrixRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      for (final state in MatrixCellState.values)
        ClayMatrixCell(
          state: state,
          ratio: 0.6,
          semanticLabel: state.name,
          isToday: state == MatrixCellState.incomplete,
        ),
    ],
  );

  Widget interactive() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClayButton(label: 'Primary', primary: true, onPressed: () {}),
      const SizedBox(height: 10),
      ClayButton(label: 'Secondary', onPressed: () {}),
      const SizedBox(height: 10),
      const ClayButton(label: 'Disabled'),
      const SizedBox(height: 14),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClayToggle(value: true, onChanged: _noop),
          SizedBox(width: 16),
          ClayToggle(value: false, onChanged: _noop),
        ],
      ),
      const SizedBox(height: 14),
      ClaySegmentedControl<int>(
        segments: const {0: 'Week', 1: 'Month', 2: 'Arc'},
        value: 1,
        onChanged: (_) {},
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        children: [
          ClayChip(label: 'Selected', selected: true, onTap: () {}),
          ClayChip(label: 'Unselected', onTap: () {}),
        ],
      ),
    ],
  );

  Widget metrics() => const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClayProgressRing(progress: 0.68, animate: false),
      SizedBox(height: 16),
      ClayStatCard(
        title: 'Discipline',
        score: 72,
        rawXp: 1830,
        color: Color(0xFF4ECCE8),
        icon: Icons.gavel_rounded,
      ),
    ],
  );

  final cases = <String, Widget Function()>{
    'surfaces': surfaces,
    'matrix_row': matrixRow,
    'interactive': interactive,
    'metrics': metrics,
  };

  for (final entry in cases.entries) {
    for (final dark in [false, true]) {
      testWidgets('${entry.key} - ${dark ? 'dark' : 'light'}', (tester) async {
        await tester.pumpWidget(
          clayHarness(
            child: entry.value(),
            dark: dark,
            size: const Size(420, 560),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/${entry.key}_${dark ? 'dark' : 'light'}.png',
          ),
        );
      });
    }
  }

  testWidgets('surfaces - high contrast collapses to solid borders', (
    tester,
  ) async {
    await tester.pumpWidget(
      clayHarness(
        child: surfaces(),
        dark: true,
        highContrast: true,
        size: const Size(420, 560),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/surfaces_high_contrast.png'),
    );
  });

  testWidgets('metrics at 200% text scale do not overflow', (tester) async {
    await tester.pumpWidget(
      clayHarness(child: metrics(), textScale: 2.0, size: const Size(420, 700)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/metrics_text_scale_200.png'),
    );
  });
}
