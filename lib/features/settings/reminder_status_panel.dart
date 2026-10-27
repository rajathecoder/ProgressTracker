import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';

/// Makes the reminder subsystem legible.
///
/// "My alarms stopped" is almost never one bug - it is notifications being
/// blocked, or exact-alarm access revoked, or an OEM battery manager quietly
/// killing the scheduler, and the app looking identical in all three cases.
/// This panel reports which of those is actually true and offers a real test
/// notification to prove it end to end.
class ReminderStatusPanel extends ConsumerStatefulWidget {
  const ReminderStatusPanel({super.key});

  @override
  ConsumerState<ReminderStatusPanel> createState() =>
      _ReminderStatusPanelState();
}

class _ReminderStatusPanelState extends ConsumerState<ReminderStatusPanel> {
  ReminderStatus _status = ReminderStatus.unknown;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    final status = await ref.read(notificationServiceProvider).status();
    if (!mounted) return;
    setState(() {
      _status = status;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    final ok = _status.healthy;
    final headline = !_status.permitted
        ? l.remindersBlocked
        : _status.pending == 0
        ? l.remindersNoneArmed
        : l.remindersHealthy(_status.pending);

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _loading
                    ? Icons.hourglass_empty_rounded
                    : ok
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                size: 20,
                color: _loading
                    ? clay.textSecondary
                    : ok
                    ? clay.gridCheckedIcon
                    : clay.accentEmber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.remindersStatusTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l.retry,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                onPressed: _loading ? null : _refresh,
              ),
            ],
          ),
          if (!_loading) ...[
            const SizedBox(height: 8),
            Text(
              headline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ok ? clay.textPrimary : clay.accentEmber,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _status.exactAlarms ? l.remindersExactOn : l.remindersExactOff,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_status.timezone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                l.remindersTimezone(_status.timezone),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (!_status.permitted)
                  ClayButton(
                    label: l.remindersFixPermission,
                    icon: Icons.notifications_active_outlined,
                    primary: true,
                    compact: true,
                    onPressed: _busy ? null : _requestPermission,
                  ),
                ClayButton(
                  label: l.sendTestReminder,
                  icon: Icons.notifications_none_rounded,
                  compact: true,
                  onPressed: _busy ? null : _sendTest,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() => _busy = true);
    try {
      await ref.read(permissionServiceProvider).requestNotifications();
      // A newly granted permission is worthless until the alarms are re-laid,
      // because everything scheduled while blocked is still silent.
      await _reschedule();
      await _refresh();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reschedule() async {
    final arc = ref.read(arcProvider);
    if (arc == null || !mounted) return;
    await ref
        .read(notificationServiceProvider)
        .rescheduleAll(
          settings: ref.read(settingsProvider),
          l10n: AppLocalizations.of(context),
          habits: arc.activeHabits,
          arcStart: arc.arc.startDate,
          locale: Localizations.localeOf(context).languageCode,
        );
  }

  Future<void> _sendTest() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final ok = await ref
          .read(notificationServiceProvider)
          .sendTestReminder(
            title: l.testReminderTitle,
            body: l.testReminderBody,
          );
      if (!mounted) return;
      showClaySnackBar(
        context,
        message: ok ? l.testReminderQueued : l.testReminderFailed,
        icon: ok ? Icons.schedule_send_rounded : Icons.error_outline_rounded,
      );
      await _refresh();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// The background-refresh row: what workmanager is for, plus a manual trigger
/// for the many devices where the OS simply never runs it.
class BackgroundRefreshRow extends ConsumerStatefulWidget {
  const BackgroundRefreshRow({super.key});

  @override
  ConsumerState<BackgroundRefreshRow> createState() =>
      _BackgroundRefreshRowState();
}

class _BackgroundRefreshRowState extends ConsumerState<BackgroundRefreshRow> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.backgroundRefresh,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l.backgroundRefreshDesc,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClayButton(
            label: l.backgroundRunNow,
            compact: true,
            onPressed: _busy ? null : _runNow,
          ),
        ],
      ),
    );
  }

  Future<void> _runNow() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final background = ref.read(backgroundServiceProvider);
      await background.runNow(AppConstants.taskRefreshWidget);
      await background.runNow(AppConstants.taskAutoBackup);
      await ref.read(arcStateProvider.notifier).refresh();
      if (!mounted) return;
      showClaySnackBar(
        context,
        message: l.backgroundRanNow,
        icon: Icons.check_circle_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
