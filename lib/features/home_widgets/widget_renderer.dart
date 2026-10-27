import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_icons.dart';
import '../../core/services/widget_service.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import '../../domain/arc_state.dart';
import '../focus/focus_controller.dart';
import 'widget_designs.dart';

/// Turns the live arc into the PNGs the home-screen widgets display.
///
/// Each surface has its own key so the native providers can pick one, and each
/// is rendered at the logical size its layout expects.
abstract final class WidgetRenderer {
  static const keyRing = 'w_ring';
  static const keyFocus = 'w_focus';
  static const keyStreaks = 'w_streaks';
  static const keyToday = 'w_today';
  static const keyMetric = 'w_metric';

  static const _small = Size(170, 170);
  static const _medium = Size(360, 184);

  static Future<void> renderAll({
    required WidgetService service,
    required ArcState arc,
    required bool dark,
  }) async {
    await service.init();

    final week = _weekFor(arc);
    final surfaces = <String, (Widget, Size)>{};

    final headline = _headlineHabit(arc);
    if (headline != null) {
      surfaces[keyRing] = (
        _wrap(
          HabitRingWidget(
            title: _title(headline, arc),
            streakDays: arc.streak.currentStreak,
            progress: arc.todayRatio,
            icon: AppIcons.resolve(headline.iconCodePoint),
            days: _daysFor(arc, headline, week),
            dark: dark,
          ),
          dark,
        ),
        _small,
      );
    }

    surfaces[keyFocus] = (
      _wrap(
        FocusTimerWidget(
          title: 'Focus',
          time: formatCountdown(
            const Duration(minutes: AppConstants.defaultFocusMinutes),
          ),
          dark: dark,
        ),
        dark,
      ),
      _small,
    );

    surfaces[keyStreaks] = (
      _wrap(StreakListWidget(entries: _streaks(arc), dark: dark), dark),
      _small,
    );

    surfaces[keyToday] = (
      _wrap(
        TodayListWidget(
          title: 'Today',
          remaining: arc.todayScheduledCount - arc.todayCompleted,
          items: _todayItems(arc),
          dark: dark,
        ),
        dark,
      ),
      _small,
    );

    final metric = _metricHabit(arc);
    if (metric != null) {
      final entry = arc.todayLog?.entryFor(metric.id);
      surfaces[keyMetric] = (
        _wrap(
          MetricProgressWidget(
            title: _title(metric, arc),
            streakDays: arc.streak.currentStreak,
            valueLabel:
                '${(entry?.value ?? 0).round()}/${metric.targetMetric} '
                '${metric.metricUnit}',
            icon: AppIcons.resolve(metric.iconCodePoint),
            days: _daysFor(arc, metric, week),
            dark: dark,
          ),
          dark,
        ),
        _medium,
      );
    }

    await service.renderBatch(surfaces);
  }

  /// The render target needs its own Directionality and text scale - it has no
  /// MaterialApp above it.
  static Widget _wrap(Widget child, bool dark) => MediaQuery(
    data: const MediaQueryData(textScaler: TextScaler.linear(1)),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(
          color: dark ? WidgetPalette.inkDark : WidgetPalette.ink,
          fontFamily: 'Inter',
        ),
        child: child,
      ),
    ),
  );

  static List<DateTime> _weekFor(ArcState arc) {
    final monday = ArcDate.startOfIsoWeek(arc.today);
    return [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
  }

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  static List<WidgetDay> _daysFor(
    ArcState arc,
    Habit habit,
    List<DateTime> week,
  ) => [
    for (var i = 0; i < week.length; i++)
      _dayState(arc, habit, week[i], _weekdayLabels[i]),
  ];

  static WidgetDay _dayState(
    ArcState arc,
    Habit habit,
    DateTime day,
    String label,
  ) {
    final DailyLog? log = arc.logsByKey[ArcDate.keyOf(day)];
    final isToday = ArcDate.isSameDay(day, arc.today);

    if (day.isAfter(arc.today)) {
      return WidgetDay(label, WidgetDayState.upcoming);
    }
    if (log == null ||
        log.isPreInstall ||
        !log.scheduledHabitIds.contains(habit.id)) {
      return WidgetDay(label, WidgetDayState.skipped);
    }
    final entry = log.entryFor(habit.id);
    if (entry != null && entry.isComplete) {
      return WidgetDay(label, WidgetDayState.done);
    }
    if (isToday) {
      return WidgetDay(
        label,
        WidgetDayState.today,
        progress: entry?.completionRatio ?? 0,
      );
    }
    if (entry != null && entry.completionRatio > 0) {
      return WidgetDay(
        label,
        WidgetDayState.partial,
        progress: entry.completionRatio,
      );
    }
    return WidgetDay(label, WidgetDayState.missed);
  }

  /// The habit the ring should feature: the first one still outstanding today,
  /// falling back to the first scheduled one.
  static Habit? _headlineHabit(ArcState arc) {
    final scheduled = arc.scheduledToday();
    if (scheduled.isEmpty) return null;
    final log = arc.todayLog;
    for (final habit in scheduled) {
      if (!(log?.entryFor(habit.id)?.isComplete ?? false)) return habit;
    }
    return scheduled.first;
  }

  static Habit? _metricHabit(ArcState arc) {
    for (final habit in arc.scheduledToday()) {
      if (!habit.isBoolean) return habit;
    }
    return null;
  }

  static List<(String, IconData, int)> _streaks(ArcState arc) {
    final habits = arc.activeHabits.take(2).toList();
    return [
      for (final h in habits)
        (
          _title(h, arc),
          AppIcons.resolve(h.iconCodePoint),
          _completionsFor(arc, h),
        ),
    ];
  }

  static int _completionsFor(ArcState arc, Habit habit) {
    var n = 0;
    for (final log in arc.logsByKey.values) {
      if (log.entryFor(habit.id)?.isComplete ?? false) n++;
    }
    return n;
  }

  static List<(String, bool)> _todayItems(ArcState arc) {
    final log = arc.todayLog;
    return [
      for (final habit in arc.scheduledToday().take(4))
        (_title(habit, arc), log?.entryFor(habit.id)?.isComplete ?? false),
    ];
  }

  /// The widget renders outside any Localizations scope, so preset habits fall
  /// back to a readable form of their key rather than crashing on lookup.
  static String _title(Habit habit, ArcState arc) {
    final custom = habit.customTitle;
    if (custom != null && custom.trim().isNotEmpty) return custom;
    final key = habit.titleKey;
    if (key == null) return 'Habit';
    return _humanise(key);
  }

  static String _humanise(String key) {
    final stripped = key.startsWith('habit') ? key.substring(5) : key;
    final buffer = StringBuffer();
    for (var i = 0; i < stripped.length; i++) {
      final c = stripped[i];
      if (i > 0 && c.toUpperCase() == c && c.toLowerCase() != c) {
        buffer.write(' ');
      }
      buffer.write(i == 0 ? c.toUpperCase() : c);
    }
    return buffer.toString();
  }
}
