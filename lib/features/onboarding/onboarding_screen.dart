import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/habit_presets.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/app_settings.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';
import '../../ui/components/clay_segmented_control.dart';

/// core_features.onboarding_identity
///
/// Captures identity, arc length and a starter habit pack, then *primes* the
/// notification permission with a rationale before the system dialog appears -
/// permissions_matrix.principle.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  final _name = TextEditingController();
  final _nickname = TextEditingController();

  int _index = 0;
  int _arcLength = AppConstants.defaultArcLengthDays;
  String _theme = 'system';

  /// The four daily reminders, editable here rather than being silently
  /// defaulted and only discoverable later in Settings.
  final Map<String, String> _reminders = {...const AppSettings().reminderTimes};
  late final Set<String> _selected = {
    for (final p in HabitPresets.seeds) p.titleKey,
  };
  bool _saving = false;

  static const _steps = 5;

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    _nickname.dispose();
    super.dispose();
  }

  /// Repaints the whole app immediately so the choice is visible, not implied.
  void _applyTheme(String value) {
    setState(() => _theme = value);
    ref.read(themeOverrideProvider.notifier).state = themeModeFor(value);
  }

  // A floor of one keeps the arc meaningful; there is deliberately no ceiling,
  // because capping the list just makes people delete something they wanted.
  bool get _canAdvance => switch (_index) {
    0 => true,
    1 => _name.text.trim().isNotEmpty && _nickname.text.trim().isNotEmpty,
    2 => _arcLength > 0,
    3 => _selected.isNotEmpty,
    _ => true,
  };

  void _next() {
    if (_index == _steps - 1) {
      _finish();
      return;
    }
    setState(() => _index++);
    _page.animateToPage(
      _index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _back() {
    if (_index == 0) return;
    setState(() => _index--);
    _page.animateToPage(
      _index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    final l = AppLocalizations.of(context);
    final tracker = ref.read(trackerServiceProvider);
    final presets = HabitPresets.all
        .where((p) => _selected.contains(p.titleKey))
        .toList();

    try {
      // The arc starts today unless the user is picking up a season already in
      // progress; pre-install days are backfilled as neutral by the tracker.
      await tracker.createInitialArc(
        fullName: _name.text.trim(),
        nickname: _nickname.text.trim(),
        themePreference: _theme,
        startDate: ArcDate.dayOnly(DateTime.now()),
        lengthDays: _arcLength,
        selectedPresets: presets,
      );
      // The times chosen on the last step become the real schedule.
      await ref
          .read(settingsProvider.notifier)
          .mutate(
            (s) => s.copyWith(
              reminderTimes: Map.of(_reminders),
              themePreferenceCache: _theme,
            ),
          );

      await ref.read(arcStateProvider.notifier).refresh();
      // Hand theme control back to the saved profile now that one exists.
      ref.read(themeOverrideProvider.notifier).state = null;
    } catch (e, st) {
      // Without this the flag stays set and Get Started is disabled forever -
      // the user is stranded on the last onboarding step with a dead button and
      // no explanation.
      debugPrint('ArcCore: onboarding failed ($e)\n$st');
      if (!mounted) return;
      showClaySnackBar(
        context,
        message: l.errorGeneric,
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  for (var i = 0; i < _steps; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          height: 5,
                          decoration: BoxDecoration(
                            color: i <= _index
                                ? clay.accentFrost
                                : clay.surfaceBorder,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomeStep(l: l),
                  _IdentityStep(
                    l: l,
                    name: _name,
                    nickname: _nickname,
                    onChanged: () => setState(() {}),
                  ),
                  _ArcStep(
                    l: l,
                    length: _arcLength,
                    onChanged: (v) => setState(() => _arcLength = v),
                  ),
                  _HabitStep(
                    l: l,
                    selected: _selected,
                    onToggle: (key) => setState(() {
                      if (!_selected.remove(key)) _selected.add(key);
                    }),
                  ),
                  _ThemeAndPermissionStep(
                    l: l,
                    theme: _theme,
                    reminders: _reminders,
                    onTheme: _applyTheme,
                    onReminderChanged: (channel, value) =>
                        setState(() => _reminders[channel] = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (_index > 0)
                    ClayButton(label: l.back, compact: true, onPressed: _back),
                  const Spacer(),
                  ClayButton(
                    label: _index == _steps - 1 ? l.getStarted : l.next,
                    primary: true,
                    icon: _index == _steps - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: _canAdvance && !_saving ? _next : null,
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

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.displayMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: clay.textSecondary),
            ),
          ],
          const SizedBox(height: 28),
          child,
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.l});
  final AppLocalizations l;

  /// Greets by time of day so the first screen feels addressed to the person
  /// opening it rather than to nobody in particular.
  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l.welcomeGreetingMorning;
    if (hour < 17) return l.welcomeGreetingAfternoon;
    return l.welcomeGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            _greeting(context),
            style: text.titleMedium?.copyWith(color: clay.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(l.onboardingWelcome, style: text.displayMedium),
          const SizedBox(height: 12),
          Text(
            l.onboardingSubtitle,
            style: text.bodyLarge?.copyWith(color: clay.textSecondary),
          ),
          const SizedBox(height: 36),
          Center(
            child: ClayContainer(
              radius: 44,
              padding: const EdgeInsets.all(26),
              child: Image.asset(
                'assets/brand/logo.png',
                width: 132,
                height: 132,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              l.welcomeTagline,
              textAlign: TextAlign.center,
              style: text.titleMedium?.copyWith(color: clay.accentFrost),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              l.welcomeGetStartedHint,
              textAlign: TextAlign.center,
              style: text.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    required this.l,
    required this.name,
    required this.nickname,
    required this.onChanged,
  });

  final AppLocalizations l;
  final TextEditingController name;
  final TextEditingController nickname;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    title: l.onboardingIdentityTitle,
    subtitle: null,
    child: Column(
      children: [
        ClayInputField(
          label: l.enterFullName,
          controller: name,
          icon: Icons.badge_outlined,
          textInputAction: TextInputAction.next,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 20),
        ClayInputField(
          label: l.enterNickname,
          controller: nickname,
          icon: Icons.face_outlined,
          textInputAction: TextInputAction.done,
          onChanged: (_) => onChanged(),
        ),
      ],
    ),
  );
}

class _ArcStep extends StatelessWidget {
  const _ArcStep({
    required this.l,
    required this.length,
    required this.onChanged,
  });

  final AppLocalizations l;
  final int length;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final isPreset = AppConstants.arcLengthPresets.contains(length);
    return _StepScaffold(
      title: l.onboardingArcTitle,
      subtitle: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClaySegmentedControl<int>(
            segments: {
              90: l.arcLength90,
              122: l.arcLength122,
              -1: l.arcLengthCustom,
            },
            value: isPreset ? length : -1,
            onChanged: (v) => onChanged(v == -1 ? 60 : v),
          ),
          if (!isPreset) ...[
            const SizedBox(height: 26),
            ClayContainer(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    '$length',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(color: clay.accentFrost),
                  ),
                  Slider(
                    value: length.toDouble().clamp(21, 365),
                    min: 21,
                    max: 365,
                    divisions: 344,
                    activeColor: clay.accentFrost,
                    onChanged: (v) => onChanged(v.round()),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 26),
          ClayContainer(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: clay.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    l.arcDayCounter(1, length),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitStep extends StatelessWidget {
  const _HabitStep({
    required this.l,
    required this.selected,
    required this.onToggle,
  });

  final AppLocalizations l;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    title: l.onboardingHabitsTitle,
    subtitle: l.onboardingHabitsSubtitle,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            l.onboardingSelectedCount(selected.length),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: context.clay.accentFrost),
          ),
        ),
        for (final category in HabitCategories.all) ...[
          AppSectionHeader(title: L10nLookup.category(category, l)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in HabitPresets.byCategory(category))
                ClayChip(
                  label: L10nLookup.habitKey(preset.titleKey, l),
                  icon: preset.icon,
                  selected: selected.contains(preset.titleKey),
                  onTap: () => onToggle(preset.titleKey),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    ),
  );
}

class _ThemeAndPermissionStep extends ConsumerWidget {
  const _ThemeAndPermissionStep({
    required this.l,
    required this.theme,
    required this.reminders,
    required this.onTheme,
    required this.onReminderChanged,
  });

  final AppLocalizations l;
  final String theme;
  final Map<String, String> reminders;
  final ValueChanged<String> onTheme;
  final void Function(String channel, String hhmm) onReminderChanged;

  static const _channels = [
    'morning_call',
    'nutrition_reminders',
    'activity_reminders',
    'evening_review',
  ];

  String _label(String channel) => switch (channel) {
    'morning_call' => l.morningAlertTitle,
    'nutrition_reminders' => l.middayAlertTitle,
    'activity_reminders' => l.eveningWorkoutTitle,
    'evening_review' => l.nightReviewTitle,
    _ => channel,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clay = context.clay;
    return _StepScaffold(
      title: l.onboardingThemeTitle,
      subtitle: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tapping repaints the entire app straight away, so the preview is
          // the real thing rather than a swatch.
          ClaySegmentedControl<String>(
            segments: {
              'light': l.settingsThemeLight,
              'dark': l.settingsThemeDark,
              'system': l.settingsThemeSystem,
            },
            value: theme,
            onChanged: onTheme,
          ),
          const SizedBox(height: 32),

          AppSectionHeader(title: l.onboardingPermissionTitle),
          ClayContainer(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: clay.accentFrost,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.permissionNotificationRationale,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClayButton(
                  label: l.permissionAllow,
                  primary: true,
                  compact: true,
                  expand: true,
                  onPressed: () async {
                    final granted = await ref
                        .read(permissionServiceProvider)
                        .requestNotifications();
                    if (!context.mounted) return;
                    showClaySnackBar(
                      context,
                      message: granted
                          ? l.settingsNotifications
                          : l.permissionNotNow,
                      icon: granted
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          AppSectionHeader(title: l.settingsReminderTimes),
          ClayContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                for (final channel in _channels)
                  _ReminderTimeRow(
                    label: _label(channel),
                    value: reminders[channel] ?? '',
                    onChanged: (v) => onReminderChanged(channel, v),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.permissionExactAlarmRationale,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// One editable reminder time. Times are set here, at the moment the user is
/// thinking about their schedule, instead of being defaulted and buried.
class _ReminderTimeRow extends StatelessWidget {
  const _ReminderTimeRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final parsed = ArcDate.parseTimeOfDay(value);
    final time = parsed == null
        ? const TimeOfDay(hour: 7, minute: 0)
        : TimeOfDay(hour: parsed.$1, minute: parsed.$2);

    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onChanged(ArcDate.formatHHmm(picked.hour, picked.minute));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.alarm_outlined, size: 18, color: clay.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              time.format(context),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: clay.accentFrost),
            ),
            const SizedBox(width: 4),
            Icon(Icons.edit_outlined, size: 15, color: clay.textSecondary),
          ],
        ),
      ),
    );
  }
}
