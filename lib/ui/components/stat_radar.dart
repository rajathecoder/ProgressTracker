import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/engines/stat_engine.dart';
import '../../l10n/app_localizations.dart';
import 'clay_container.dart';

/// The pentagon character sheet.
///
/// It plots *normalised consistency*, not raw XP. Under raw XP the pentagon is
/// permanently stretched toward Vitality no matter how the user behaves, which
/// makes the chart decorative rather than informative
/// (gamification_engine.stat_normalization).
///
/// accessibility_standards requires a semantic summary plus a tabular fallback,
/// both of which are built in here rather than left to each screen.
class StatRadar extends StatefulWidget {
  const StatRadar({
    super.key,
    required this.snapshot,
    this.overlay,
    this.size = 260,
    this.showFallbackToggle = true,
  });

  final StatSnapshot snapshot;

  /// Optional second series, e.g. the day-1 radar on the recap screen.
  final StatSnapshot? overlay;
  final double size;
  final bool showFallbackToggle;

  @override
  State<StatRadar> createState() => _StatRadarState();
}

class _StatRadarState extends State<StatRadar> {
  bool _tabular = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    final summary = StatKeys.all
        .map(
          (s) => l.statScoreLabel(
            L10nLookup.stat(s, l),
            widget.snapshot[s].round(),
          ),
        )
        .join('. ');

    if (_tabular) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final s in StatKeys.all)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: clay.statColor(s),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      L10nLookup.stat(s, l),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${widget.snapshot[s].round()} / 100',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.showFallbackToggle)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => setState(() => _tabular = false),
                child: Text(l.close),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        Semantics(
          label: l.radarSemanticSummary(summary),
          image: true,
          child: ExcludeSemantics(
            child: RepaintBoundary(
              child: SizedBox(
                height: widget.size,
                // fl_chart animates the polygon between old and new stat
                // values on every data change (i.e. every time a habit log
                // updates the stats), and mid-transition it can briefly paint
                // past its own box - without a clip that overshoot bleeds
                // into whatever sits right below the radar.
                child: ClipRect(
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      radarBackgroundColor: Colors.transparent,
                      radarBorderData: BorderSide(
                        color: clay.surfaceBorder,
                        width: 1.5,
                      ),
                      gridBorderData: BorderSide(
                        color: clay.surfaceBorder,
                        width: 1,
                      ),
                      tickBorderData: BorderSide(
                        color: clay.surfaceBorder.withValues(alpha: 0.5),
                      ),
                      ticksTextStyle: const TextStyle(
                        color: Colors.transparent,
                        fontSize: 0,
                      ),
                      tickCount: 4,
                      titlePositionPercentageOffset: 0.16,
                      getTitle: (index, angle) => RadarChartTitle(
                        text: L10nLookup.stat(StatKeys.all[index], l),
                        angle: 0,
                      ),
                      titleTextStyle: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      dataSets: [
                        if (widget.overlay != null)
                          RadarDataSet(
                            fillColor: clay.textSecondary.withValues(
                              alpha: 0.12,
                            ),
                            borderColor: clay.textSecondary,
                            borderWidth: 1.5,
                            entryRadius: 2,
                            dataEntries: [
                              for (final s in StatKeys.all)
                                RadarEntry(value: widget.overlay![s]),
                            ],
                          ),
                        RadarDataSet(
                          fillColor: clay.accentFrost.withValues(alpha: 0.28),
                          borderColor: clay.accentFrost,
                          borderWidth: 2.5,
                          entryRadius: 3,
                          dataEntries: [
                            for (final s in StatKeys.all)
                              RadarEntry(value: widget.snapshot[s]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.showFallbackToggle)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () => setState(() => _tabular = true),
              icon: const Icon(Icons.table_rows_rounded, size: 16),
              label: Text(l.tabularFallback),
              style: TextButton.styleFrom(foregroundColor: clay.textSecondary),
            ),
          ),
      ],
    );
  }
}

/// A compact, non-interactive radar for cards and share images.
class StatRadarMini extends StatelessWidget {
  const StatRadarMini({
    super.key,
    required this.snapshot,
    this.size = 150,
    this.accent,
  });

  final StatSnapshot snapshot;
  final double size;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final color = accent ?? clay.accentFrost;
    return ClayContainer(
      state: ClaySurfaceState.flat,
      color: Colors.transparent,
      radius: 0,
      height: size,
      // Same fl_chart quirk as StatRadar: the polygon can overshoot its box
      // mid-animation on a data change, so this needs clipping too.
      clip: true,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBackgroundColor: Colors.transparent,
          radarBorderData: BorderSide(color: clay.surfaceBorder),
          gridBorderData: BorderSide(color: clay.surfaceBorder),
          tickBorderData: const BorderSide(color: Colors.transparent),
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 0,
          ),
          tickCount: 3,
          getTitle: (index, angle) => const RadarChartTitle(text: ''),
          dataSets: [
            RadarDataSet(
              fillColor: color.withValues(alpha: 0.3),
              borderColor: color,
              borderWidth: 2,
              entryRadius: 2,
              dataEntries: [
                for (final s in StatKeys.all) RadarEntry(value: snapshot[s]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
