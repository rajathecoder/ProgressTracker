import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_languages.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/backup_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/app_settings.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';
import '../../ui/components/clay_segmented_control.dart';
import '../../ui/components/clay_toggle.dart';
import '../home_widgets/widget_gallery_screen.dart';
import '../recap/arc_history_screen.dart';
import 'language_picker_sheet.dart';
import 'profile_editor_sheet.dart';
import 'reminder_status_panel.dart';

/// Sections that are built and working but deliberately not surfaced yet.
///
/// Flipping one of these back to `true` is the whole re-enable: the widgets,
/// the services and their tests all stay in the build, so nothing rots while
/// they are out of sight.
abstract final class SettingsVisibility {
  static const showAppLock = false;
  static const showDataSection = false;
  static const showBackgroundRefresh = false;
}

/// Settings & Reminders Configuration.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arc = ref.watch(arcProvider);
    final settings = ref.watch(settingsProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        // A root tab has nothing to pop back to; the implied arrow was
        // both misleading and, once a deep link pushed a route, wrong.
        automaticallyImplyLeading: false,
        title: Text(l.settingsTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
          children: [
            _ProfileCard(arc: arc),
            const SizedBox(height: 22),

            _Section(title: l.settingsSectionAppearance),
            _ThemeRow(arc: arc),
            const SizedBox(height: 12),
            _LanguageRow(settings: settings),

            const SizedBox(height: 22),
            _Section(title: l.settingsSectionReminders),
            const ReminderStatusPanel(),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsNotifications,
              value: settings.notificationsEnabled,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(notificationsEnabled: v)),
            ),
            const SizedBox(height: 12),
            _ReminderTimes(settings: settings),
            const SizedBox(height: 12),
            _ExactAlarmsRow(),
            const SizedBox(height: 12),
            _BatteryPrimer(),
            if (SettingsVisibility.showBackgroundRefresh) ...[
              const SizedBox(height: 12),
              const BackgroundRefreshRow(),
            ],

            const SizedBox(height: 22),
            _Section(title: l.settingsSectionArc),
            _RolloverRow(settings: settings),
            const SizedBox(height: 12),
            _RetroWindowRow(settings: settings),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsHardcoreMode,
              subtitle: l.settingsHardcoreModeDesc,
              value: settings.hardcoreMode,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(hardcoreMode: v)),
            ),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsPartialCredit,
              subtitle: l.settingsPartialCreditDesc,
              value: settings.partialCreditEnabled,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(partialCreditEnabled: v)),
            ),
            const SizedBox(height: 12),
            _NavRow(
              icon: Icons.widgets_outlined,
              title: l.widgetPreviewTitle,
              subtitle: l.widgetPreviewSubtitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const WidgetGalleryScreen(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _NavRow(
              icon: Icons.history_rounded,
              title: l.arcHistoryTitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ArcHistoryScreen(),
                ),
              ),
            ),

            const SizedBox(height: 22),
            _Section(title: l.settingsSectionAccessibility),
            _ToggleRow(
              title: l.settingsReduceMotion,
              value: settings.reduceMotion,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(reduceMotion: v)),
            ),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsHighContrast,
              value: settings.highContrast,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(highContrast: v)),
            ),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsHaptics,
              value: settings.hapticsEnabled,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(hapticsEnabled: v)),
            ),
            const SizedBox(height: 12),
            _ToggleRow(
              title: l.settingsSound,
              value: settings.soundEnabled,
              onChanged: (v) => ref
                  .read(settingsProvider.notifier)
                  .mutate((s) => s.copyWith(soundEnabled: v)),
            ),

            if (SettingsVisibility.showAppLock) ...[
              const SizedBox(height: 22),
              _Section(title: l.settingsSectionPrivacy),
              _AppLockRow(settings: settings),
            ],

            if (SettingsVisibility.showDataSection) ...[
              const SizedBox(height: 22),
              _Section(title: l.settingsSectionData),
              _BackupPanel(arc: arc),
            ],

            const SizedBox(height: 30),
            Center(
              child: Text(
                '${l.appName} ${AppConstants.appVersion}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 4, bottom: 12),
    child: Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.4,
        fontWeight: FontWeight.w800,
        color: context.clay.textSecondary,
      ),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClayContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: child,
    ),
  );
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => _Row(
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        const SizedBox(width: 14),
        ClayToggle(value: value, onChanged: onChanged, semanticLabel: title),
      ],
    ),
  );
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Row(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, size: 20, color: context.clay.textSecondary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: context.clay.textSecondary),
      ],
    ),
  );
}

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClayContainer(
            state: ClaySurfaceState.recessed,
            radius: 22,
            width: 58,
            height: 58,
            alignment: Alignment.center,
            child: Text(
              arc.profile.nickname.isEmpty
                  ? '?'
                  : arc.profile.nickname.characters.first.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: clay.accentFrost),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arc.profile.nickname,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  l.settingsProfileName(arc.profile.fullName),
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${L10nLookup.rank(arc.rankKey, l)} · '
                  '${l.levelUpTitle(arc.level)}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: clay.accentFrost),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.editProfile,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => showClayBottomSheet<void>(
              context: context,
              builder: (_) => ProfileEditorSheet(arc: arc),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeRow extends ConsumerWidget {
  const _ThemeRow({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return ClaySegmentedControl<String>(
      segments: {
        'light': l.settingsThemeLight,
        'dark': l.settingsThemeDark,
        'system': l.settingsThemeSystem,
      },
      value: arc.profile.themePreference,
      onChanged: (v) async {
        arc.profile.themePreference = v;
        await ref.read(profileRepositoryProvider).save(arc.profile);
        // Mirrored into AppSettings (loaded synchronously at boot) so the
        // next cold start doesn't flash the wrong theme while the profile -
        // the actual source of truth - is still loading from Isar.
        await ref
            .read(settingsProvider.notifier)
            .mutate((s) => s.copyWith(themePreferenceCache: v));
        await ref.read(arcStateProvider.notifier).refresh();
      },
    );
  }
}

class _LanguageRow extends ConsumerWidget {
  const _LanguageRow({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selected = AppLanguages.byCode(settings.localeOverride);

    return _NavRow(
      icon: Icons.translate_rounded,
      title: l.settingsLanguage,
      subtitle: selected == null
          ? l.settingsLanguageSystem
          : '${selected.nativeName} · ${selected.englishName}',
      onTap: () => showClayBottomSheet<void>(
        context: context,
        builder: (_) => const LanguagePickerSheet(),
      ),
    );
  }
}

class _ReminderTimes extends ConsumerWidget {
  const _ReminderTimes({required this.settings});
  final AppSettings settings;

  static const _labels = {
    'morning_call': 'morningAlertTitle',
    'nutrition_reminders': 'middayAlertTitle',
    'activity_reminders': 'eveningWorkoutTitle',
    'evening_review': 'nightReviewTitle',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.settingsReminderTimes,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final entry in settings.reminderTimes.entries)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                _label(entry.key, l),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Text(
                entry.value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.clay.accentFrost,
                ),
              ),
              onTap: () => _pick(context, ref, entry.key, entry.value),
            ),
        ],
      ),
    );
  }

  static String _label(String channel, AppLocalizations l) =>
      switch (_labels[channel]) {
        'morningAlertTitle' => l.morningAlertTitle,
        'middayAlertTitle' => l.middayAlertTitle,
        'eveningWorkoutTitle' => l.eveningWorkoutTitle,
        'nightReviewTitle' => l.nightReviewTitle,
        _ => channel,
      };

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    String channel,
    String current,
  ) async {
    final parsed = ArcDate.parseTimeOfDay(current);
    final picked = await showTimePicker(
      context: context,
      initialTime: parsed == null
          ? const TimeOfDay(hour: 7, minute: 0)
          : TimeOfDay(hour: parsed.$1, minute: parsed.$2),
    );
    if (picked == null) return;
    final next = Map<String, String>.from(settings.reminderTimes)
      ..[channel] = ArcDate.formatHHmm(picked.hour, picked.minute);
    await ref
        .read(settingsProvider.notifier)
        .mutate((s) => s.copyWith(reminderTimes: next));
  }
}

class _ExactAlarmsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return _NavRow(
      icon: Icons.alarm_on_rounded,
      title: l.settingsExactAlarms,
      subtitle: l.settingsExactAlarmsDesc,
      onTap: () async {
        final granted = await ref
            .read(notificationServiceProvider)
            .requestExactAlarms();
        if (!context.mounted) return;
        showClaySnackBar(
          context,
          message: granted ? l.done : l.permissionExactAlarmRationale,
          icon: granted
              ? Icons.check_circle_outline_rounded
              : Icons.info_outline_rounded,
        );
      },
    );
  }
}

/// edge_case_handling.aggressive_oem_battery_management - a one-time primer
/// naming the actual manufacturer, plus a deep link to the settings screen.
class _BatteryPrimer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<String?>(
      future: ref.read(permissionServiceProvider).aggressiveOemName(),
      builder: (context, snapshot) {
        final oem = snapshot.data;
        if (oem == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _NavRow(
            icon: Icons.battery_alert_rounded,
            title: oem,
            subtitle: l.settingsBatteryWarning,
            onTap: () async {
              await ref
                  .read(permissionServiceProvider)
                  .requestIgnoreBatteryOptimizations();
            },
          ),
        );
      },
    );
  }
}

class _RolloverRow extends ConsumerWidget {
  const _RolloverRow({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.settingsDayRollover,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                ArcDate.formatHourLabel(settings.dayRolloverHour, locale),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.clay.accentFrost,
                ),
              ),
            ],
          ),
          Slider(
            value: settings.dayRolloverHour.toDouble(),
            max: 8,
            divisions: 8,
            activeColor: context.clay.accentFrost,
            onChanged: (v) => ref
                .read(settingsProvider.notifier)
                .mutate((s) => s.copyWith(dayRolloverHour: v.round())),
          ),
        ],
      ),
    );
  }
}

class _RetroWindowRow extends ConsumerWidget {
  const _RetroWindowRow({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.settingsRetroWindow(settings.retroLoggingDays),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: settings.retroLoggingDays.toDouble(),
            max: AppConstants.maxRetroLoggingDays.toDouble(),
            divisions: AppConstants.maxRetroLoggingDays,
            activeColor: context.clay.accentFrost,
            onChanged: settings.hardcoreMode
                ? null
                : (v) => ref
                      .read(settingsProvider.notifier)
                      .mutate((s) => s.copyWith(retroLoggingDays: v.round())),
          ),
        ],
      ),
    );
  }
}

class _AppLockRow extends ConsumerWidget {
  const _AppLockRow({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        _ToggleRow(
          title: l.settingsAppLock,
          value: settings.appLockEnabled,
          onChanged: (v) async {
            if (v) {
              final pin = await _promptPin(context, l);
              if (pin == null) return;
              await ref.read(appLockServiceProvider).setPin(pin);
            } else {
              await ref.read(appLockServiceProvider).clearPin();
            }
            await ref
                .read(settingsProvider.notifier)
                .mutate((s) => s.copyWith(appLockEnabled: v));
          },
        ),
        if (settings.appLockEnabled) ...[
          const SizedBox(height: 12),
          ClaySegmentedControl<String>(
            segments: {
              AppLockScope.journal: l.settingsAppLockScopeJournal,
              AppLockScope.app: l.settingsAppLockScopeApp,
            },
            value: settings.appLockScope,
            onChanged: (v) => ref
                .read(settingsProvider.notifier)
                .mutate((s) => s.copyWith(appLockScope: v)),
          ),
        ],
      ],
    );
  }

  Future<String?> _promptPin(BuildContext context, AppLocalizations l) async {
    final controller = TextEditingController();
    final result = await showClayBottomSheet<String>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayInputField(
              label: l.appLockSetPin,
              controller: controller,
              obscureText: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              icon: Icons.pin_outlined,
            ),
            const SizedBox(height: 18),
            ClayButton(
              label: l.save,
              primary: true,
              expand: true,
              onPressed: () =>
                  Navigator.of(sheetContext).pop(controller.text.trim()),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return (result == null || result.isEmpty) ? null : result;
  }
}

/// data_integrity.backup / restore
class _BackupPanel extends ConsumerStatefulWidget {
  const _BackupPanel({required this.arc});
  final ArcState arc;

  @override
  ConsumerState<_BackupPanel> createState() => _BackupPanelState();
}

class _BackupPanelState extends ConsumerState<_BackupPanel> {
  bool _encrypt = false;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final locale = Localizations.localeOf(context).toString();

    return _Row(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.backupTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            settings.lastBackupAt == null
                ? l.backupNever
                : l.backupLast(
                    ArcDate.formatTimestamp(settings.lastBackupAt!, locale),
                  ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.backupEncrypt,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ClayToggle(
                value: _encrypt,
                semanticLabel: l.backupEncrypt,
                onChanged: (v) => setState(() => _encrypt = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ClayButton(
                label: l.backupExportJson,
                icon: Icons.file_download_outlined,
                compact: true,
                onPressed: _busy ? null : _exportJson,
              ),
              ClayButton(
                label: l.backupExportCsv,
                icon: Icons.table_chart_outlined,
                compact: true,
                onPressed: _busy ? null : _exportCsv,
              ),
              ClayButton(
                label: l.backupRestore,
                icon: Icons.restore_rounded,
                compact: true,
                onPressed: _busy ? null : _restore,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _promptPassphrase(AppLocalizations l) async {
    final controller = TextEditingController();
    final value = await showClayBottomSheet<String>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayInputField(
              label: l.passphrasePrompt,
              controller: controller,
              obscureText: true,
              autofocus: true,
              icon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 18),
            ClayButton(
              label: l.confirm,
              primary: true,
              expand: true,
              onPressed: () =>
                  Navigator.of(sheetContext).pop(controller.text.trim()),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return (value == null || value.isEmpty) ? null : value;
  }

  Future<void> _exportJson() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      String? passphrase;
      if (_encrypt) {
        passphrase = await _promptPassphrase(l);
        if (passphrase == null) return;
      }
      final file = await ref
          .read(backupServiceProvider)
          .exportJson(
            settings: ref.read(settingsProvider),
            passphrase: passphrase,
          );
      await ref
          .read(settingsProvider.notifier)
          .mutate((s) => s.copyWith(lastBackupAt: DateTime.now()));
      // first_backup achievement is a pure function of settings.lastBackupAt.
      await ref
          .read(trackerServiceProvider)
          .recompute(ref.read(settingsProvider));
      await ref.read(arcStateProvider.notifier).refresh();
      if (!mounted) return;
      await ref.read(shareServiceProvider).shareFiles([file]);
      if (!mounted) return;
      showClaySnackBar(
        context,
        message: file.path.split(Platform.pathSeparator).last,
        icon: Icons.check_circle_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await ref
          .read(backupServiceProvider)
          .exportCsv(
            arcId: widget.arc.arc.id,
            habitList: widget.arc.habits,
            titleResolver: (h) => L10nLookup.habitTitle(h, l),
          );
      if (!mounted) return;
      await ref.read(shareServiceProvider).shareFiles([file]);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = picked.isEmpty ? null : picked.first.path;
    if (path == null || !mounted) return;

    setState(() => _busy = true);
    try {
      final service = ref.read(backupServiceProvider);
      var file = File(path);
      var check = await service.inspect(file);
      String? passphrase;

      if (check.error == RestoreError.badPassphrase) {
        if (!mounted) return;
        passphrase = await _promptPassphrase(l);
        if (passphrase == null) return;
        check = await service.inspect(file, passphrase: passphrase);
      }

      if (!check.ok) {
        if (!mounted) return;
        showClaySnackBar(
          context,
          message: switch (check.error) {
            RestoreError.checksumMismatch => l.restoreChecksumFailed,
            RestoreError.schemaTooNew => l.restoreVersionMismatch,
            RestoreError.badPassphrase => l.appLockWrongPin,
            _ => l.errorGeneric,
          },
          icon: Icons.error_outline_rounded,
        );
        return;
      }

      final preview = check.preview!;
      if (!mounted) return;
      final replace = await showClayDialog(
        context: context,
        title: l.restoreConfirm,
        message: l.restoreDryRun(
          preview.days,
          preview.habits,
          preview.journals,
        ),
        confirmLabel: l.restoreReplace,
        cancelLabel: l.restoreMerge,
        destructive: true,
      );

      final error = await service.restore(
        file,
        replace: replace,
        settings: ref.read(settingsProvider),
        passphrase: passphrase,
      );

      if (error == RestoreError.none) {
        // Derived state is never trusted from an import - recompute it.
        await ref
            .read(trackerServiceProvider)
            .recomputeAfterImport(ref.read(settingsProvider));
        await ref.read(arcStateProvider.notifier).refresh();
      }

      if (!mounted) return;
      showClaySnackBar(
        context,
        message: error == RestoreError.none ? l.restoreSuccess : l.errorGeneric,
        icon: error == RestoreError.none
            ? Icons.check_circle_outline_rounded
            : Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
