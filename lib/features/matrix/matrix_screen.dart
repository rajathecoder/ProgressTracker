import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_matrix_cell.dart';
import '../../ui/components/clay_segmented_control.dart';
import '../dashboard/habit_log_sheet.dart';
import 'matrix_linear_view.dart';

enum MatrixZoom { week, month, arc }

/// The Spreadsheet Matrix View.
///
/// performance_budget.matrix_grid: the sticky habit column and the day grid are
/// two synchronised lazy builders. Columns are built on demand with a two-screen
/// cacheExtent - never all 122 eagerly - and each cell is a const-constructible,
/// RepaintBoundary-wrapped [ClayMatrixCell] whose decoration comes from the
/// memoised ClayTheme map.
class MatrixScreen extends ConsumerStatefulWidget {
  const MatrixScreen({super.key});

  @override
  ConsumerState<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends ConsumerState<MatrixScreen> {
  final _horizontal = ScrollController();
  final _headerHorizontal = ScrollController();
  MatrixZoom _zoom = MatrixZoom.month;
  String? _categoryFilter;
  bool _linear = false;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _horizontal.addListener(_syncHeader);
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToToday());
  }

  @override
  void dispose() {
    _horizontal.removeListener(_syncHeader);
    _horizontal.dispose();
    _headerHorizontal.dispose();
    super.dispose();
  }

  void _syncHeader() {
    if (_syncing || !_headerHorizontal.hasClients) return;
    _syncing = true;
    _headerHorizontal.jumpTo(_horizontal.offset);
    _syncing = false;
  }

  double get _cellExtent => AppConstants.matrixHitTarget;

  void _jumpToToday({bool animate = false}) {
    final arc = ref.read(arcProvider);
    if (arc == null || !_horizontal.hasClients) return;
    final days = _visibleDays(arc);
    final index = days.indexWhere((d) => ArcDate.isSameDay(d, arc.today));
    if (index < 0) return;

    final viewport = _horizontal.position.viewportDimension;
    final target = (index * _cellExtent - viewport / 2 + _cellExtent / 2).clamp(
      0.0,
      _horizontal.position.maxScrollExtent,
    );
    if (animate) {
      _horizontal.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _horizontal.jumpTo(target);
    }
  }

  List<DateTime> _visibleDays(ArcState arc) {
    switch (_zoom) {
      case MatrixZoom.week:
        final monday = ArcDate.startOfIsoWeek(arc.today);
        return ArcDate.daysInRange(monday, monday.add(const Duration(days: 6)));
      case MatrixZoom.month:
        final start = arc.today.subtract(const Duration(days: 20));
        final clamped = start.isBefore(arc.arc.startDate)
            ? arc.arc.startDate
            : start;
        final end = clamped.add(const Duration(days: 34));
        return ArcDate.daysInRange(
          clamped,
          end.isAfter(arc.arc.endDate) ? arc.arc.endDate : end,
        );
      case MatrixZoom.arc:
        return arc.arcDays;
    }
  }

  List<Habit> _visibleHabits(ArcState arc) {
    final habits = arc.habits.where((h) => !h.isArchived).toList();
    if (_categoryFilter == null) return habits;
    return habits.where((h) => h.category == _categoryFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    final habits = _visibleHabits(arc);
    final days = _visibleDays(arc);

    return Scaffold(
      appBar: AppBar(
        // A root tab has nothing to pop back to; the implied arrow was
        // both misleading and, once a deep link pushed a route, wrong.
        automaticallyImplyLeading: false,
        title: Text(l.matrixTitle),
        actions: [
          IconButton(
            tooltip: _linear ? l.matrixGridView : l.matrixLinearView,
            icon: Icon(
              _linear ? Icons.grid_on_rounded : Icons.view_list_rounded,
            ),
            onPressed: () => setState(() => _linear = !_linear),
          ),
        ],
      ),
      floatingActionButton: _linear
          ? null
          : FloatingActionButton.extended(
              // Tabs live side by side in an IndexedStack, so every FAB needs its
              // own hero tag or they fight over the default one.
              heroTag: 'matrix_today_fab',
              onPressed: () => _jumpToToday(animate: true),
              icon: const Icon(Icons.today_rounded),
              label: Text(l.jumpToToday),
              backgroundColor: context.clay.surface,
              foregroundColor: context.clay.accentFrost,
            ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: ClaySegmentedControl<MatrixZoom>(
                segments: {
                  MatrixZoom.week: l.matrixZoomWeek,
                  MatrixZoom.month: l.matrixZoomMonth,
                  MatrixZoom.arc: l.matrixZoomArc,
                },
                value: _zoom,
                onChanged: (v) {
                  setState(() => _zoom = v);
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _jumpToToday(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ClayChip(
                    label: l.filterAll,
                    selected: _categoryFilter == null,
                    onTap: () => setState(() => _categoryFilter = null),
                  ),
                  const SizedBox(width: 8),
                  for (final c in HabitCategories.all) ...[
                    ClayChip(
                      label: L10nLookup.category(c, l),
                      selected: _categoryFilter == c,
                      onTap: () => setState(
                        () => _categoryFilter = _categoryFilter == c ? null : c,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: habits.isEmpty
                  ? ClayEmptyState(
                      title: l.emptyHabitsTitle,
                      message: l.emptyHabitsBody,
                      icon: Icons.grid_off_rounded,
                    )
                  : _linear
                  ? MatrixLinearView(arc: arc, habits: habits, days: days)
                  : _buildGrid(context, arc, habits, days),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    ArcState arc,
    List<Habit> habits,
    List<DateTime> days,
  ) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();

    return Column(
      children: [
        // Sticky date header, scroll-synced with the grid below.
        SizedBox(
          height: 46,
          child: Row(
            children: [
              const SizedBox(width: AppConstants.matrixLabelWidth),
              Expanded(
                child: ListView.builder(
                  controller: _headerHorizontal,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  itemExtent: _cellExtent,
                  itemBuilder: (context, i) {
                    final day = days[i];
                    final isToday = ArcDate.isSameDay(day, arc.today);
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ArcDate.formatWeekdayShort(day, locale),
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(fontSize: 9),
                          ),
                          Text(
                            '${day.day}',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: isToday
                                      ? clay.accentFrost
                                      : clay.textSecondary,
                                  fontWeight: isToday
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 96),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sticky first column - habit titles with 3D icons.
                SizedBox(
                  width: AppConstants.matrixLabelWidth,
                  child: Column(
                    children: [
                      for (final habit in habits)
                        SizedBox(
                          height: AppConstants.matrixRowHeight,
                          child: _HabitLabel(habit: habit, arc: arc),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: habits.length * AppConstants.matrixRowHeight,
                    // Lazy on the expensive axis: one item per *day*, so the
                    // 122 columns are built on demand with a ~20-column cache
                    // extent rather than eagerly.
                    child: ListView.builder(
                      controller: _horizontal,
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemExtent: _cellExtent,
                      cacheExtent: _cellExtent * 20,
                      itemBuilder: (context, i) => Column(
                        children: [
                          for (final habit in habits)
                            SizedBox(
                              height: AppConstants.matrixRowHeight,
                              child: Center(
                                child: _buildCell(
                                  context,
                                  arc,
                                  habit,
                                  days[i],
                                  l,
                                  locale,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    ArcState arc,
    Habit habit,
    DateTime day,
    AppLocalizations l,
    String locale,
  ) {
    final log = arc.logsByKey[ArcDate.keyOf(day)];
    final state = cellStateFor(arc, habit, day, log);
    final entry = log?.entryFor(habit.id);

    return ClayMatrixCell(
      state: state,
      ratio: entry?.completionRatio ?? 0,
      isToday: ArcDate.isSameDay(day, arc.today),
      semanticLabel: l.cellSemanticLabel(
        L10nLookup.habitTitle(habit, l),
        ArcDate.formatMedium(day, locale),
        _stateLabel(state, l),
      ),
      onTap: () => _onCellTap(context, arc, habit, day, state),
      onLongPress: () => _onCellTap(context, arc, habit, day, state),
    );
  }

  static String _stateLabel(MatrixCellState s, AppLocalizations l) =>
      switch (s) {
        MatrixCellState.complete => l.cellStateComplete,
        MatrixCellState.partial => l.cellStatePartial,
        MatrixCellState.missed => l.cellStateMissed,
        MatrixCellState.notScheduled => l.cellStateNotScheduled,
        MatrixCellState.incomplete => l.cellStateIncomplete,
      };

  Future<void> _onCellTap(
    BuildContext context,
    ArcState arc,
    Habit habit,
    DateTime day,
    MatrixCellState state,
  ) async {
    final l = AppLocalizations.of(context);

    if (state == MatrixCellState.notScheduled) {
      showClaySnackBar(
        context,
        message: l.notScheduledToday,
        icon: Icons.event_busy_rounded,
      );
      return;
    }
    if (!arc.canLog(day)) {
      showClaySnackBar(
        context,
        message: l.backfillWindowClosed,
        icon: Icons.lock_clock_rounded,
      );
      return;
    }

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

class _HabitLabel extends StatelessWidget {
  const _HabitLabel({required this.habit, required this.arc});

  final Habit habit;
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final rate = habitCompletionRate(arc, habit);

    return SizedBox(
      width: AppConstants.matrixLabelWidth,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
        child: Row(
          children: [
            Icon(
              AppIcons.resolve(habit.iconCodePoint),
              size: 17,
              color: clay.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10nLookup.habitTitle(habit, l),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: clay.textPrimary),
                  ),
                  Text(
                    l.habitCompletionRate((rate * 100).round()),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Resolves the four cell states from a day's snapshot.
///
/// The key rule: a habit that was not due that day is `notScheduled`, and is
/// excluded from both the numerator and the denominator - which is what makes
/// "Gym 4-5 days a week" stop reading as a 57% completion rate.
MatrixCellState cellStateFor(
  ArcState arc,
  Habit habit,
  DateTime day,
  DailyLog? log,
) {
  if (log == null || log.isPreInstall) return MatrixCellState.notScheduled;
  if (!log.scheduledHabitIds.contains(habit.id)) {
    return MatrixCellState.notScheduled;
  }

  final entry = log.entryFor(habit.id);
  if (entry != null && entry.isComplete) return MatrixCellState.complete;
  if (entry != null && entry.completionRatio > 0) {
    return MatrixCellState.partial;
  }

  final isPast = ArcDate.dayOnly(day).isBefore(arc.today);
  return isPast ? MatrixCellState.missed : MatrixCellState.incomplete;
}

double habitCompletionRate(ArcState arc, Habit habit) {
  var completed = 0, scheduled = 0;
  for (final log in arc.logsByKey.values) {
    if (log.isPreInstall) continue;
    if (!log.scheduledHabitIds.contains(habit.id)) continue;
    scheduled++;
    if (log.entryFor(habit.id)?.isComplete ?? false) completed++;
  }
  return scheduled == 0 ? 0 : completed / scheduled;
}
