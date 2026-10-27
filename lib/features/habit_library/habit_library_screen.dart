import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/habit_presets.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/habit.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import 'habit_editor_sheet.dart';

/// Habit Library & Editor.
///
/// Archiving preserves every historical record and only removes the habit from
/// future days - the one behaviour that lets a 122-day arc adapt instead of
/// being abandoned on day 30.
class HabitLibraryScreen extends ConsumerStatefulWidget {
  const HabitLibraryScreen({super.key});

  @override
  ConsumerState<HabitLibraryScreen> createState() => _HabitLibraryScreenState();
}

class _HabitLibraryScreenState extends ConsumerState<HabitLibraryScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    final active = arc.habits.where((h) => !h.isArchived).toList();
    final archived = arc.habits.where((h) => h.isArchived).toList();
    final list = _showArchived ? archived : active;

    return Scaffold(
      appBar: AppBar(
        // A root tab has nothing to pop back to; the implied arrow was
        // both misleading and, once a deep link pushed a route, wrong.
        automaticallyImplyLeading: false,
        title: Text(l.habitLibraryTitle),
        actions: [
          IconButton(
            tooltip: l.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            // Settings is the shell's last tab (index 4), not a pushed route.
            onPressed: () => ref.read(shellTabProvider.notifier).state = 4,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'habit_library_add_fab',
        onPressed: () => _openEditor(arc, null),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.createCustomHabit),
        backgroundColor: context.clay.surface,
        foregroundColor: context.clay.accentFrost,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Row(
                children: [
                  ClayChip(
                    label: '${l.activeHabits} (${active.length})',
                    selected: !_showArchived,
                    onTap: () => setState(() => _showArchived = false),
                  ),
                  const SizedBox(width: 8),
                  ClayChip(
                    label: '${l.archivedHabits} (${archived.length})',
                    selected: _showArchived,
                    onTap: () => setState(() => _showArchived = true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? ClayEmptyState(
                      title: l.emptyHabitsTitle,
                      message: l.emptyHabitsBody,
                      icon: Icons.list_alt_rounded,
                      actionLabel: _showArchived ? null : l.createCustomHabit,
                      onAction: _showArchived
                          ? null
                          : () => _openEditor(arc, null),
                    )
                  : _showArchived
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      children: [
                        for (final habit in list)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _HabitTile(
                              habit: habit,
                              arc: arc,
                              onEdit: () => _openEditor(arc, habit),
                              onArchiveToggle: () => _toggleArchive(habit),
                            ),
                          ),
                      ],
                    )
                  : ReorderableListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      onReorder: (oldIndex, newIndex) =>
                          _reorder(list, oldIndex, newIndex),
                      children: [
                        for (final habit in list)
                          Padding(
                            key: ValueKey(habit.id),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.5,
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => _openEditor(arc, habit),
                                    icon: Icons.edit_outlined,
                                    label: l.editHabit,
                                    backgroundColor: context.clay.surface,
                                    foregroundColor: context.clay.accentFrost,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  SlidableAction(
                                    onPressed: (_) => _toggleArchive(habit),
                                    icon: Icons.archive_outlined,
                                    label: l.archiveHabit,
                                    backgroundColor: context.clay.surface,
                                    foregroundColor: context.clay.accentEmber,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ],
                              ),
                              child: _HabitTile(
                                habit: habit,
                                arc: arc,
                                onEdit: () => _openEditor(arc, habit),
                                onArchiveToggle: () => _toggleArchive(habit),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            if (!_showArchived) _PresetStrip(arc: arc),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(ArcState arc, Habit? habit) => showClayBottomSheet(
    context: context,
    builder: (_) => HabitEditorSheet(habit: habit, arcId: arc.arc.id),
  );

  Future<void> _reorder(List<Habit> list, int oldIndex, int newIndex) async {
    final reordered = List<Habit>.from(list);
    if (newIndex > oldIndex) newIndex -= 1;
    reordered.insert(newIndex, reordered.removeAt(oldIndex));
    await ref.read(habitRepositoryProvider).reorder(reordered);
    await ref.read(arcStateProvider.notifier).refresh();
  }

  Future<void> _toggleArchive(Habit habit) async {
    final l = AppLocalizations.of(context);
    if (!habit.isArchived) {
      final confirmed = await showClayDialog(
        context: context,
        title: l.archiveHabit,
        message: l.archiveHabitWarning,
        confirmLabel: l.confirm,
        cancelLabel: l.cancel,
        destructive: true,
      );
      if (!confirmed) return;
    }
    await ref
        .read(habitRepositoryProvider)
        .setArchived(habit, !habit.isArchived);
    await ref.read(arcStateProvider.notifier).refresh();
    if (!mounted) return;
    showClaySnackBar(
      context,
      message: habit.isArchived ? l.archiveHabit : l.unarchiveHabit,
      icon: Icons.archive_outlined,
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.habit,
    required this.arc,
    required this.onEdit,
    required this.onArchiveToggle,
  });

  final Habit habit;
  final ArcState arc;
  final VoidCallback onEdit;
  final VoidCallback onArchiveToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return GestureDetector(
      onTap: onEdit,
      child: ClayContainer(
        state: habit.isArchived
            ? ClaySurfaceState.disabled
            : ClaySurfaceState.raised,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            ClayContainer(
              state: ClaySurfaceState.recessed,
              radius: 12,
              width: 44,
              height: 44,
              alignment: Alignment.center,
              child: Icon(
                AppIcons.resolve(habit.iconCodePoint),
                size: 20,
                color: clay.statColor(habit.statAttribute),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10nLookup.habitTitle(habit, l),
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${L10nLookup.stat(habit.statAttribute, l)} · '
                    '+${habit.clampedXp} XP · '
                    '${L10nLookup.frequency(habit, l)}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (habit.reminderTime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.alarm_outlined,
                          size: 12,
                          color: clay.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          habit.reminderTime!,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: habit.isArchived ? l.unarchiveHabit : l.archiveHabit,
              icon: Icon(
                habit.isArchived
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
                size: 20,
              ),
              onPressed: onArchiveToggle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Preset catalogue, grouped by category, for one-tap adding.
class _PresetStrip extends ConsumerWidget {
  const _PresetStrip({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final used = arc.habits.map((h) => h.titleKey).toSet();
    final available = HabitPresets.all
        .where((p) => !used.contains(p.titleKey))
        .toList();
    if (available.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.clay.surfaceBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.habitLibraryTitle,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: available.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final preset = available[i];
                return ClayChip(
                  label: L10nLookup.habitKey(preset.titleKey, l),
                  icon: preset.icon,
                  onTap: () => _add(context, ref, preset),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    HabitPreset preset,
  ) async {
    final l = AppLocalizations.of(context);
    final nextOrder = arc.habits.length;
    final habit = preset.toHabit(sortOrder: nextOrder, arcId: arc.arc.id);
    await ref.read(habitRepositoryProvider).save(habit);
    await ref.read(arcStateProvider.notifier).refresh();
    if (!context.mounted) return;
    showClaySnackBar(
      context,
      message: L10nLookup.habitKey(preset.titleKey, l),
      icon: Icons.add_circle_outline_rounded,
    );
  }
}

/// Guards against a preset list that would exceed the XP clamp when summed.
int estimateMaxDailyXp(List<Habit> habits) => habits
    .where((h) => !h.isArchived && h.frequencyType == FrequencyTypes.daily)
    .fold(0, (sum, h) => sum + h.clampedXp);
