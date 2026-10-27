import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_icons.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/habit.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_matrix_cell.dart';
import '../dashboard/habit_log_sheet.dart';
import 'matrix_screen.dart';

/// accessibility_standards:
///
/// "The horizontally scrolling matrix must expose a linear alternative for
/// screen readers - a per-habit list view reachable from the same screen."
///
/// This is that view. It carries the same data and the same actions, laid out
/// as a vertical list of habits, each expanding into its own day list, so focus
/// order follows reading order and nothing depends on a two-axis gesture.
class MatrixLinearView extends ConsumerWidget {
  const MatrixLinearView({
    super.key,
    required this.arc,
    required this.habits,
    required this.days,
  });

  final ArcState arc;
  final List<Habit> habits;
  final List<DateTime> days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();

    // Newest first: the days a user can still act on come first.
    final ordered = days.reversed
        .where((d) => !d.isAfter(arc.today))
        .toList(growable: false);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      itemCount: habits.length,
      itemBuilder: (context, i) {
        final habit = habits[i];
        final rate = habitCompletionRate(arc, habit);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClayContainer(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.only(bottom: 8),
                leading: ClayContainer(
                  state: ClaySurfaceState.recessed,
                  radius: 12,
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    AppIcons.resolve(habit.iconCodePoint),
                    size: 18,
                    color: clay.textSecondary,
                  ),
                ),
                title: Text(
                  L10nLookup.habitTitle(habit, l),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  '${l.habitCompletionRate((rate * 100).round())} · '
                  '${L10nLookup.frequency(habit, l)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  for (final day in ordered.take(45))
                    _DayRow(arc: arc, habit: habit, day: day, locale: locale),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DayRow extends ConsumerWidget {
  const _DayRow({
    required this.arc,
    required this.habit,
    required this.day,
    required this.locale,
  });

  final ArcState arc;
  final Habit habit;
  final DateTime day;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final log = arc.logsByKey[ArcDate.keyOf(day)];
    final state = cellStateFor(arc, habit, day, log);
    final entry = log?.entryFor(habit.id);

    final label = switch (state) {
      MatrixCellState.complete => l.cellStateComplete,
      MatrixCellState.partial => l.cellStatePartial,
      MatrixCellState.missed => l.cellStateMissed,
      MatrixCellState.notScheduled => l.cellStateNotScheduled,
      MatrixCellState.incomplete => l.cellStateIncomplete,
    };

    final canAct = state != MatrixCellState.notScheduled && arc.canLog(day);

    return Semantics(
      button: canAct,
      label: l.cellSemanticLabel(
        L10nLookup.habitTitle(habit, l),
        ArcDate.formatMedium(day, locale),
        label,
      ),
      child: ExcludeSemantics(
        child: InkWell(
          onTap: canAct ? () => _log(context, ref) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 118,
                  child: Text(
                    ArcDate.formatMedium(day, locale),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: switch (state) {
                        MatrixCellState.complete => clay.gridCheckedIcon,
                        MatrixCellState.partial => clay.warningAmber,
                        MatrixCellState.missed => clay.textSecondary,
                        _ => clay.textSecondary,
                      },
                    ),
                  ),
                ),
                if (entry != null && !habit.isBoolean)
                  Text(
                    '${entry.value.round()}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                const SizedBox(width: 8),
                Icon(
                  switch (state) {
                    MatrixCellState.complete => Icons.check_circle_rounded,
                    MatrixCellState.partial => Icons.change_history_rounded,
                    MatrixCellState.missed => Icons.remove_circle_outline,
                    MatrixCellState.notScheduled => Icons.remove_rounded,
                    MatrixCellState.incomplete =>
                      Icons.radio_button_unchecked_rounded,
                  },
                  size: 18,
                  color: state == MatrixCellState.complete
                      ? clay.gridCheckedIcon
                      : clay.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _log(BuildContext context, WidgetRef ref) async {
    if (!habit.isBoolean) {
      await showClayBottomSheet<void>(
        context: context,
        builder: (_) => HabitLogSheet(habit: habit, day: day, arc: arc),
      );
      return;
    }
    final outcome = await ref
        .read(trackerServiceProvider)
        .toggleHabit(state: arc, habit: habit, day: day);
    if (!context.mounted) return;
    await reactToOutcome(context, ref, outcome);
  }
}
