import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../domain/engines/analytics_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_progress_ring.dart';
import '../../ui/components/clay_trophy_medal.dart';

/// Insights content: the Analytics & Insights Lab, as a standalone [Column]
/// (no Scaffold/AppBar) so it composes into the merged Protocol/Insights
/// screen rather than living behind its own tab.
///
/// Everything is derived on-device in a single pass over the arc's logs.
/// analytics_lab.guard: insight cards are suppressed until 7 days of data
/// exist; correlation cards need 14.
class InsightsContent extends ConsumerWidget {
  const InsightsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    final report = AnalyticsEngine.compute(
      arcStart: arc.arc.startDate,
      arcDays: arc.arcDays,
      logsByKey: arc.logsByKey,
      habitsById: arc.habitsById,
      today: arc.today,
      arcLengthDays: arc.arc.lengthDays,
    );

    // Nothing at all to describe yet - a genuinely empty arc.
    if (report.loggedDays == 0) {
      return ClayEmptyState(
        title: l.analyticsTitle,
        message: l.analyticsNotEnoughData,
        icon: Icons.query_stats_rounded,
      );
    }

    // Before the 7-day mark the screen used to be a single "come back later"
    // wall, which reads as broken rather than as waiting. The charts that are
    // already meaningful on day one are shown immediately; only the ones that
    // are statistically fragile on a short sample stay gated, and the banner
    // says exactly how far off they are.
    return Column(
      children: [
        if (!report.hasEnoughData) ...[
          _BuildingBanner(report: report),
          const SizedBox(height: 18),
        ],
        _SummaryCard(arc: arc, report: report),
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsHeatmap),
        _Heatmap(report: report),
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsWeekday),
        _WeekdayChart(report: report),
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsStatProgression),
        _StatProgressionChart(report: report),
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsWeekly),
        _WeeklyChart(report: report),
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsTimeOfDay),
        _HourChart(report: report),
        if (report.hasEnoughData) ...[
          const SizedBox(height: 20),
          AppSectionHeader(title: l.analyticsProjectionTitle),
          _ProjectionCard(arc: arc, report: report),
        ],
        const SizedBox(height: 20),
        AppSectionHeader(title: l.analyticsCorrelationTitle),
        _Correlations(arc: arc, report: report),
      ],
    );
  }
}

/// Progress toward a full-strength report, so the wait is visible rather than
/// looking like a dead screen.
class _BuildingBanner extends StatelessWidget {
  const _BuildingBanner({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final progress = (report.loggedDays / AppConstants.analyticsMinDays).clamp(
      0.0,
      1.0,
    );

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClayProgressRing(
            progress: progress,
            size: 56,
            thickness: 7,
            animate: false,
            center: Text(
              '${report.loggedDays}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.insightsEarlyTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l.insightsPartial(
                    report.loggedDays,
                    AppConstants.analyticsMinDays,
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: clay.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Completion rate and best/worst weekday - both meaningful from the first day.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.arc, required this.report});
  final ArcState arc;
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();

    return ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClayProgressRing(
            progress: report.completionRate,
            size: 104,
            thickness: 12,
            semanticLabel: l.recapCompletionRate,
            center: Text(
              '${(report.completionRate * 100).round()}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.recapCompletionRate,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l.insightsPartial(report.loggedDays, arc.arc.lengthDays),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (report.bestWeekday != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    l.analyticsBestDay(
                      ArcDate.formatWeekdayFull(report.bestWeekday!, locale),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: clay.gridCheckedIcon,
                    ),
                  ),
                ],
                if (report.worstWeekday != null &&
                    report.worstWeekday != report.bestWeekday) ...[
                  const SizedBox(height: 4),
                  Text(
                    l.analyticsWeakestDay(
                      ArcDate.formatWeekdayFull(report.worstWeekday!, locale),
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: clay.accentEmber),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionCard extends StatelessWidget {
  const _ProjectionCard({required this.arc, required this.report});
  final ArcState arc;
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();

    return ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClayProgressRing(
            progress: report.projection.trendWeightedProjection,
            size: 104,
            thickness: 12,
            semanticLabel: l.analyticsProjectionTitle,
            center: Text(
              '${(report.projection.trendWeightedProjection * 100).round()}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.analyticsProjectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l.analyticsProjection(
                    (report.projection.linearProjection * 100).round(),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (report.bestWeekday != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    l.analyticsBestDay(
                      ArcDate.formatWeekdayFull(report.bestWeekday!, locale),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: clay.gridCheckedIcon,
                    ),
                  ),
                ],
                if (report.worstWeekday != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l.analyticsWeakestDay(
                      ArcDate.formatWeekdayFull(report.worstWeekday!, locale),
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: clay.accentEmber),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final day in report.heatmap)
            ClayHeatmapCell(
              intensity: day.intensity,
              counted: day.counted,
              semanticLabel:
                  '${ArcDate.formatMedium(day.date, locale)}: '
                  '${(day.ratio * 100).round()}%',
            ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return ClayContainer(
      padding: const EdgeInsets.fromLTRB(10, 20, 16, 10),
      child: SizedBox(
        height: 190,
        child: BarChart(
          BarChartData(
            maxY: 1,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: clay.surfaceBorder, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: 0.5,
                  getTitlesWidget: (v, _) => Text(
                    '${(v * 100).round()}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (v, _) => Text(
                    '${v.toInt()}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
            ),
            barGroups: [
              for (final w in report.weekly)
                BarChartGroupData(
                  x: w.arcWeek,
                  barRods: [
                    BarChartRodData(
                      toY: w.rate,
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                      color: clay.accentFrost,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatProgressionChart extends StatelessWidget {
  const _StatProgressionChart({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final l = AppLocalizations.of(context);

    return ClayContainer(
      padding: const EdgeInsets.fromLTRB(10, 20, 16, 10),
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: clay.surfaceBorder, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 50,
                      getTitlesWidget: (v, _) => Text(
                        '${v.round()}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  bottomTitles: const AxisTitles(),
                ),
                lineBarsData: [
                  for (final stat in StatKeys.all)
                    LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0.2,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      color: clay.statColor(stat),
                      spots: [
                        for (
                          var i = 0;
                          i < (report.statProgression[stat]?.length ?? 0);
                          i++
                        )
                          FlSpot(
                            i.toDouble(),
                            report.statProgression[stat]![i],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final stat in StatKeys.all)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: clay.statColor(stat),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nLookup.stat(stat, l),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekdayChart extends StatelessWidget {
  const _WeekdayChart({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();

    return ClayContainer(
      padding: const EdgeInsets.fromLTRB(10, 20, 16, 10),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: 1,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: clay.surfaceBorder, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: 0.5,
                  getTitlesWidget: (v, _) => Text(
                    '${(v * 100).round()}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (v, _) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      ArcDate.formatWeekdayFull(
                        v.toInt(),
                        locale,
                      ).substring(0, 2),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
            barGroups: [
              for (final w in report.weekday)
                BarChartGroupData(
                  x: w.weekday,
                  barRods: [
                    BarChartRodData(
                      toY: w.rate,
                      width: 18,
                      borderRadius: BorderRadius.circular(5),
                      color: w.weekday == report.bestWeekday
                          ? clay.gridCheckedIcon
                          : w.weekday == report.worstWeekday
                          ? clay.accentEmber
                          : clay.accentFrost,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HourChart extends StatelessWidget {
  const _HourChart({required this.report});
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();
    final maxCount = report.hourHistogram.isEmpty
        ? 1
        : report.hourHistogram.reduce((a, b) => a > b ? a : b);

    return ClayContainer(
      padding: const EdgeInsets.fromLTRB(10, 20, 16, 10),
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            maxY: (maxCount == 0 ? 1 : maxCount).toDouble(),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 6,
                  reservedSize: 24,
                  // BarChart's x-axis is categorical, so unlike LineChart it
                  // calls getTitlesWidget for every bar regardless of
                  // `interval` - without this filter all 24 hour labels are
                  // drawn and collide into an unreadable smear.
                  getTitlesWidget: (v, _) {
                    final hour = v.round();
                    if (hour % 6 != 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        ArcDate.formatHourLabel(hour, locale),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: [
              for (var h = 0; h < 24; h++)
                BarChartGroupData(
                  x: h,
                  barRods: [
                    BarChartRodData(
                      toY: report.hourHistogram[h].toDouble(),
                      width: 7,
                      borderRadius: BorderRadius.circular(3),
                      color: clay.accentFrost.withValues(alpha: 0.8),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Correlations extends StatelessWidget {
  const _Correlations({required this.arc, required this.report});
  final ArcState arc;
  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    if (!report.hasCorrelationData || report.correlations.isEmpty) {
      return ClayContainer(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: clay.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                report.hasCorrelationData
                    ? l.analyticsNoCorrelations
                    : l.analyticsNotEnoughData,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final c in report.correlations.take(4))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClayContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.link_rounded, color: clay.accentFrost, size: 20),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l.analyticsCorrelation(
                        arc.habitsById[c.habitId] == null
                            ? '#${c.habitId}'
                            : L10nLookup.habitTitle(
                                arc.habitsById[c.habitId]!,
                                l,
                              ),
                        c.ratio.toStringAsFixed(1),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
