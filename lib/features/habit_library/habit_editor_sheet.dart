import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/habit_presets.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/habit.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';
import '../../ui/components/clay_segmented_control.dart';

/// Custom Habit Builder - title, icon, category, stat, XP (clamped 5-30),
/// metric, frequency and reminder.
class HabitEditorSheet extends ConsumerStatefulWidget {
  const HabitEditorSheet({super.key, this.habit, required this.arcId});

  final Habit? habit;
  final int arcId;

  @override
  ConsumerState<HabitEditorSheet> createState() => _HabitEditorSheetState();
}

class _HabitEditorSheetState extends ConsumerState<HabitEditorSheet> {
  late final _title = TextEditingController(
    text: widget.habit?.customTitle ?? '',
  );

  late String _category = widget.habit?.category ?? HabitCategories.body;
  late String _stat = widget.habit?.statAttribute ?? StatKeys.discipline;
  late int _xp = widget.habit?.xpReward ?? 15;
  late String _unit = widget.habit?.metricUnit ?? MetricUnits.boolean;
  late int _target = widget.habit?.targetMetric ?? 1;
  late int _icon =
      widget.habit?.iconCodePoint ?? HabitPresets.iconChoices.first;
  late String _frequencyType =
      widget.habit?.frequencyType ?? FrequencyTypes.daily;
  late int _frequencyValue = widget.habit?.frequencyValue ?? 1;
  late final Set<int> _weekdays = {
    ...(widget.habit?.activeWeekdays ?? const [1, 2, 3, 4, 5, 6, 7]),
  };
  late TimeOfDay? _reminder = _parseReminder(widget.habit?.reminderTime);

  static TimeOfDay? _parseReminder(String? hhmm) {
    if (hhmm == null) return null;
    final parsed = ArcDate.parseTimeOfDay(hhmm);
    return parsed == null
        ? null
        : TimeOfDay(hour: parsed.$1, minute: parsed.$2);
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.habit != null;

  bool get _valid => _isEdit ? true : _title.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit ? l.editHabit : l.createCustomHabit,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 22),

          if (!_isEdit || widget.habit!.isCustom)
            ClayInputField(
              label: l.habitTitleLabel,
              controller: _title,
              icon: Icons.title_rounded,
              onChanged: (_) => setState(() {}),
            )
          else
            ClayContainer(
              state: ClaySurfaceState.recessed,
              padding: const EdgeInsets.all(16),
              radius: 18,
              child: Text(
                L10nLookup.habitTitle(widget.habit!, l),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

          const SizedBox(height: 22),
          _Label(l.habitIconLabel),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HabitPresets.iconChoices.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final code = HabitPresets.iconChoices[i];
                return GestureDetector(
                  onTap: () => setState(() => _icon = code),
                  child: ClayContainer(
                    state: _icon == code
                        ? ClaySurfaceState.recessed
                        : ClaySurfaceState.raised,
                    radius: 14,
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.resolve(code),
                      size: 20,
                      color: _icon == code
                          ? clay.accentFrost
                          : clay.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),
          _Label(l.habitCategoryLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in HabitCategories.all)
                ClayChip(
                  label: L10nLookup.category(c, l),
                  selected: _category == c,
                  onTap: () => setState(() => _category = c),
                ),
            ],
          ),

          const SizedBox(height: 22),
          _Label(l.habitStatLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in StatKeys.all)
                ClayChip(
                  label: L10nLookup.stat(s, l),
                  selected: _stat == s,
                  color: clay.statColor(s),
                  onTap: () => setState(() => _stat = s),
                ),
            ],
          ),

          const SizedBox(height: 22),
          _Label('${l.habitXpLabel}: $_xp'),
          Slider(
            value: _xp.toDouble(),
            min: AppConstants.minHabitXp.toDouble(),
            max: AppConstants.maxHabitXp.toDouble(),
            divisions: AppConstants.maxHabitXp - AppConstants.minHabitXp,
            label: '$_xp',
            activeColor: clay.accentFrost,
            onChanged: (v) => setState(() => _xp = v.round()),
          ),

          const SizedBox(height: 10),
          _Label(l.habitMetricLabel),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final u in MetricUnits.all)
                ClayChip(
                  label: L10nLookup.unit(u, l),
                  selected: _unit == u,
                  onTap: () => setState(() {
                    _unit = u;
                    if (u == MetricUnits.boolean) _target = 1;
                  }),
                ),
            ],
          ),

          if (_unit != MetricUnits.boolean) ...[
            const SizedBox(height: 22),
            _Label('${l.habitTargetLabel}: $_target'),
            Slider(
              value: _target.toDouble().clamp(1, _maxTarget),
              min: 1,
              max: _maxTarget,
              divisions: 60,
              label: '$_target',
              activeColor: clay.accentFrost,
              onChanged: (v) => setState(() => _target = v.round()),
            ),
          ],

          const SizedBox(height: 16),
          _Label(l.habitFrequencyLabel),
          ClaySegmentedControl<String>(
            segments: {
              FrequencyTypes.daily: l.habitFrequencyDaily,
              FrequencyTypes.weeklyTarget: l.habitFrequencyWeekly(
                _frequencyValue,
              ),
              FrequencyTypes.specificDays: l.habitFrequencyCustom,
              FrequencyTypes.interval: l.habitFrequencyInterval(
                _frequencyValue,
              ),
            },
            value: _frequencyType,
            onChanged: (v) => setState(() {
              _frequencyType = v;
              if (v == FrequencyTypes.daily) _frequencyValue = 1;
              if (v == FrequencyTypes.weeklyTarget && _frequencyValue > 7) {
                _frequencyValue = 4;
              }
            }),
          ),

          if (_frequencyType == FrequencyTypes.weeklyTarget ||
              _frequencyType == FrequencyTypes.interval) ...[
            const SizedBox(height: 16),
            Slider(
              value: _frequencyValue.toDouble().clamp(
                1,
                _frequencyType == FrequencyTypes.weeklyTarget ? 7 : 30,
              ),
              min: 1,
              max: _frequencyType == FrequencyTypes.weeklyTarget ? 7 : 30,
              divisions: _frequencyType == FrequencyTypes.weeklyTarget ? 6 : 29,
              label: '$_frequencyValue',
              activeColor: clay.accentFrost,
              onChanged: (v) => setState(() => _frequencyValue = v.round()),
            ),
          ],

          if (_frequencyType == FrequencyTypes.specificDays) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var d = 1; d <= 7; d++)
                  ClayChip(
                    label: ArcDate.formatWeekdayFull(
                      d,
                      Localizations.localeOf(context).toString(),
                    ).substring(0, 3),
                    selected: _weekdays.contains(d),
                    onTap: () => setState(() {
                      if (_weekdays.contains(d)) {
                        if (_weekdays.length > 1) _weekdays.remove(d);
                      } else {
                        _weekdays.add(d);
                      }
                    }),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 22),
          _Label(l.habitReminderLabel),
          Row(
            children: [
              Expanded(
                child: ClayButton(
                  label: _reminder == null
                      ? l.noReminder
                      : _reminder!.format(context),
                  icon: Icons.alarm_outlined,
                  compact: true,
                  expand: true,
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime:
                          _reminder ?? const TimeOfDay(hour: 7, minute: 0),
                    );
                    if (picked != null) setState(() => _reminder = picked);
                  },
                ),
              ),
              if (_reminder != null) ...[
                const SizedBox(width: 10),
                IconButton(
                  tooltip: l.delete,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _reminder = null),
                ),
              ],
            ],
          ),

          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: ClayButton(
                  label: l.cancel,
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClayButton(
                  label: l.save,
                  primary: true,
                  expand: true,
                  onPressed: _valid ? _save : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get _maxTarget => switch (_unit) {
    MetricUnits.steps => 30000,
    MetricUnits.minutes => 240,
    MetricUnits.hours => 12,
    MetricUnits.liters => 8,
    _ => 60,
  };

  Future<void> _save() async {
    final repo = ref.read(habitRepositoryProvider);
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messengerContext = context;

    final habit = widget.habit ?? Habit.create(arcId: widget.arcId);
    if (widget.habit == null || widget.habit!.isCustom) {
      habit.customTitle = _title.text.trim();
      habit.isCustom = true;
    }
    habit
      ..iconCodePoint = _icon
      ..category = _category
      ..statAttribute = _stat
      ..xpReward = _xp
      ..metricUnit = _unit
      ..targetMetric = _unit == MetricUnits.boolean ? 1 : _target
      ..frequencyType = _frequencyType
      ..frequencyValue = _frequencyValue
      ..activeWeekdays = (_weekdays.toList()..sort())
      ..reminderTime = _reminder == null
          ? null
          : ArcDate.formatHHmm(_reminder!.hour, _reminder!.minute)
      ..arcId = widget.arcId;

    // A semantic edit bumps the version so historical entries keep the
    // definition they were awarded under.
    if (widget.habit != null) {
      await repo.saveEdit(habit);
    } else {
      await repo.save(habit);
    }

    await ref.read(arcStateProvider.notifier).refresh();
    navigator.pop();
    if (!messengerContext.mounted) return;
    showClaySnackBar(
      messengerContext,
      message: l.journalSaved,
      icon: Icons.check_circle_outline_rounded,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 4, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.labelMedium),
  );
}
