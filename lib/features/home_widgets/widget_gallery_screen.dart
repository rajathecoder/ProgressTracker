import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_icons.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../focus/focus_controller.dart';
import 'widget_designs.dart';

/// A live preview of every home-screen widget.
///
/// Widgets are added from the launcher, not from inside an app, so without this
/// the feature is invisible: nobody long-presses their home screen on the off
/// chance. Each card is the real widget, rendered from real data.
class WidgetGalleryScreen extends ConsumerWidget {
  const WidgetGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final arc = ref.watch(arcProvider);
    if (arc == null) return const SizedBox.shrink();

    final dark = Theme.of(context).brightness == Brightness.dark;
    final days = _week(arc);
    final habit = arc.scheduledToday().isEmpty
        ? null
        : arc.scheduledToday().first;
    final metric = arc
        .scheduledToday()
        .where((h) => !h.isBoolean)
        .cast<dynamic>()
        .firstOrNull;
    final log = arc.todayLog;

    return Scaffold(
      appBar: AppBar(title: Text(l.widgetPreviewTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
          children: [
            ClayContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.widgets_outlined, color: context.clay.accentFrost),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.widgetPreviewSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            AppSectionHeader(title: l.widgetRingTitle),
            _Preview(
              size: const Size(180, 180),
              child: HabitRingWidget(
                title: habit == null
                    ? l.appName
                    : L10nLookup.habitTitle(habit, l),
                streakDays: arc.streak.currentStreak,
                progress: arc.todayRatio,
                icon: habit == null
                    ? Icons.check_circle_outline
                    : AppIcons.resolve(habit.iconCodePoint),
                days: days,
                dark: dark,
              ),
            ),

            const SizedBox(height: 22),
            AppSectionHeader(title: l.widgetTimerTitle),
            _Preview(
              size: const Size(180, 180),
              child: FocusTimerWidget(
                title: l.focusTitle,
                time: formatCountdown(
                  const Duration(minutes: AppConstants.defaultFocusMinutes),
                ),
                dark: dark,
              ),
            ),

            const SizedBox(height: 22),
            AppSectionHeader(title: l.widgetStreakTitle),
            _Preview(
              size: const Size(180, 180),
              child: StreakListWidget(
                entries: [
                  for (final h in arc.activeHabits.take(2))
                    (
                      L10nLookup.habitTitle(h, l),
                      AppIcons.resolve(h.iconCodePoint),
                      _completions(arc, h.id),
                    ),
                ],
                dark: dark,
              ),
            ),

            const SizedBox(height: 22),
            AppSectionHeader(title: l.widgetTodayTitle),
            _Preview(
              size: const Size(180, 180),
              child: TodayListWidget(
                title: l.widgetTodayTitle,
                remaining: arc.todayScheduledCount - arc.todayCompleted,
                items: [
                  for (final h in arc.scheduledToday().take(4))
                    (
                      L10nLookup.habitTitle(h, l),
                      log?.entryFor(h.id)?.isComplete ?? false,
                    ),
                ],
                dark: dark,
              ),
            ),

            if (metric != null) ...[
              const SizedBox(height: 22),
              AppSectionHeader(title: l.widgetWaterTitle),
              _Preview(
                size: const Size(360, 180),
                child: MetricProgressWidget(
                  title: L10nLookup.habitTitle(metric, l),
                  streakDays: arc.streak.currentStreak,
                  valueLabel:
                      '${(log?.entryFor(metric.id)?.value ?? 0).round()}'
                      '/${metric.targetMetric} '
                      '${L10nLookup.unit(metric.metricUnit, l)}',
                  icon: AppIcons.resolve(metric.iconCodePoint),
                  days: days,
                  dark: dark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static int _completions(ArcState arc, int habitId) {
    var n = 0;
    for (final log in arc.logsByKey.values) {
      if (log.entryFor(habitId)?.isComplete ?? false) n++;
    }
    return n;
  }

  static List<WidgetDay> _week(ArcState arc) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final monday = ArcDate.startOfIsoWeek(arc.today);
    final habits = arc.scheduledToday();
    final habitId = habits.isEmpty ? -1 : habits.first.id;

    return [
      for (var i = 0; i < 7; i++)
        () {
          final day = monday.add(Duration(days: i));
          final log = arc.logsByKey[ArcDate.keyOf(day)];
          if (day.isAfter(arc.today)) {
            return WidgetDay(labels[i], WidgetDayState.upcoming);
          }
          if (log == null || !log.scheduledHabitIds.contains(habitId)) {
            return WidgetDay(labels[i], WidgetDayState.skipped);
          }
          final entry = log.entryFor(habitId);
          if (entry?.isComplete ?? false) {
            return WidgetDay(labels[i], WidgetDayState.done);
          }
          if (ArcDate.isSameDay(day, arc.today)) {
            return WidgetDay(
              labels[i],
              WidgetDayState.today,
              progress: entry?.completionRatio ?? 0,
            );
          }
          return WidgetDay(labels[i], WidgetDayState.missed);
        }(),
    ];
  }
}

/// Shows a widget at its true size on the app's own background, so the preview
/// matches what lands on the home screen.
class _Preview extends StatelessWidget {
  const _Preview({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(width: size.width, height: size.height, child: child),
  );
}
