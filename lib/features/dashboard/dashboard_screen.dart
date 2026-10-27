import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../domain/engines/level_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_progress_ring.dart';
import '../../ui/components/clay_stat_card.dart';
import '../../ui/components/stat_radar.dart';
import '../trophy_hall/trophy_hall_screen.dart';

/// Protocol content: greeting, arc/streak status, boss week, XP progress and
/// the character sheet (stat radar + stat cards). No checklist here - habits
/// are checked off from the Matrix tab; this is a standalone [Column], not a
/// scrollable, so it composes into the merged Protocol/Insights screen.
class ProtocolContent extends ConsumerWidget {
  const ProtocolContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    return Column(
      children: [
        _Header(arc: arc),
        const SizedBox(height: 18),
        const _ReminderWarning(),
        _ArcBanner(arc: arc),
        if (arc.bossWeek != null) ...[
          const SizedBox(height: 14),
          _BossWeekBanner(arc: arc),
        ],
        const SizedBox(height: 18),
        _TodayCard(arc: arc),
        const SizedBox(height: 18),
        AppSectionHeader(
          title: l.characterSheet,
          actionLabel: l.trophyHallTitle,
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const TrophyHallScreen()),
          ),
        ),
        ClayContainer(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 8),
          child: StatRadar(snapshot: arc.stats),
        ),
        const SizedBox(height: 14),
        for (final stat in StatKeys.all)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ClayStatCard(
              title: L10nLookup.stat(stat, l),
              score: arc.stats[stat],
              rawXp: arc.profile.statScores[stat],
              color: context.clay.statColor(stat),
              icon: _statIcon(stat),
              compact: true,
            ),
          ),
      ],
    );
  }

  static IconData _statIcon(String stat) => switch (stat) {
    StatKeys.discipline => Icons.gavel_rounded,
    StatKeys.vitality => Icons.favorite_rounded,
    StatKeys.strength => Icons.fitness_center_rounded,
    StatKeys.focus => Icons.center_focus_strong_rounded,
    StatKeys.spirit => Icons.auto_awesome_rounded,
    _ => Icons.circle,
  };
}

class _Header extends ConsumerWidget {
  const _Header({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.dashboardGreeting(arc.profile.nickname),
                style: text.headlineMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.military_tech_outlined,
                    size: 15,
                    color: clay.accentFrost,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      '${l.levelUpTitle(arc.level)} · '
                      '${L10nLookup.rank(arc.rankKey, l)}',
                      style: text.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: l.trophyHallTitle,
          icon: const Icon(Icons.emoji_events_outlined),
          // Settings now lives in its own tab, so this slot is free for a
          // direct shortcut into Trophy Hall instead.
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const TrophyHallScreen()),
          ),
        ),
      ],
    );
  }
}

/// edge_case_handling.aggressive_oem_battery_management + the permission
/// matrix: when reminders are not actually armed, say so here rather than
/// letting the user discover it by missing a week of them.
class _ReminderWarning extends ConsumerWidget {
  const _ReminderWarning();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(reminderHealthProvider);
    if (report.healthy || report == ScheduleReport.none) {
      return const SizedBox.shrink();
    }

    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final message = !report.notificationsPermitted
        ? l.remindersBlocked
        : l.remindersNoneArmed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => ref.read(shellTabProvider.notifier).state = 4,
        child: ClayContainer(
          padding: const EdgeInsets.all(14),
          color: Color.alphaBlend(
            clay.warningAmber.withValues(alpha: 0.12),
            clay.surface,
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 20,
                color: clay.warningAmber,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: clay.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArcBanner extends StatelessWidget {
  const _ArcBanner({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final text = Theme.of(context).textTheme;

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arc.arcNotStarted
                      ? l.arcNotStarted(arc.daysUntilStart)
                      : l.arcDayCounter(arc.arcDayNumber, arc.arc.lengthDays),
                  style: text.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(
                      icon: Icons.local_fire_department_rounded,
                      label: l.streakCount(arc.streak.currentStreak),
                      color: clay.accentEmber,
                    ),
                    _Pill(
                      icon: Icons.shield_outlined,
                      label: l.shieldCount(arc.streak.shieldsHeld),
                      color: clay.shieldViolet,
                    ),
                    if (arc.multiplier > 1)
                      _Pill(
                        icon: Icons.bolt_rounded,
                        label: l.multiplierActive(
                          MultiplierEngine.format(arc.multiplier),
                        ),
                        color: clay.warningAmber,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClayProgressRing(
            progress: arc.todayRatio,
            size: 92,
            thickness: 11,
            semanticLabel: l.todayComplete(
              arc.todayCompleted,
              arc.todayScheduledCount,
            ),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${arc.todayCompleted}',
                  style: text.titleLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text('/ ${arc.todayScheduledCount}', style: text.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => ClayContainer(
    state: ClaySurfaceState.recessed,
    radius: 12,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    ),
  );
}

class _BossWeekBanner extends StatelessWidget {
  const _BossWeekBanner({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final boss = arc.bossWeek!;
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      color: Color.alphaBlend(
        clay.accentEmber.withValues(alpha: 0.12),
        clay.surface,
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: clay.accentEmber,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.bossWeekTitle(boss.week.name),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${l.bossWeekProgress(boss.completed, boss.required_)} · '
                  '${l.bossWeekReward(boss.week.bonusXp)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: boss.ratio,
                    minHeight: 6,
                    backgroundColor: clay.surfaceBorder,
                    valueColor: AlwaysStoppedAnimation(clay.accentEmber),
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

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final clay = context.clay;

    return ClayContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.xpToNextLevel(arc.xpIntoLevel, arc.xpForLevel),
                  style: text.labelMedium,
                ),
              ),
              Text(
                '${arc.profile.totalXp} XP',
                style: text.labelLarge?.copyWith(color: clay.accentFrost),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: arc.levelProgress,
              minHeight: 9,
              backgroundColor: clay.surfaceBorder,
              valueColor: AlwaysStoppedAnimation(clay.accentFrost),
            ),
          ),
        ],
      ),
    );
  }
}

