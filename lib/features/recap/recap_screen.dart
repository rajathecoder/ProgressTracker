import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../domain/engines/achievement_evaluator.dart';
import '../../domain/engines/stat_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_toggle.dart';
import '../../ui/components/clay_trophy_medal.dart';
import '../../ui/components/stat_radar.dart';
import '../share/share_actions.dart';

/// Arc Recap & Graduation.
///
/// core_features.multi_arc: "As written, ArcCore becomes a dead app on
/// 31 December 2026. This turns a one-off challenge into a repeatable seasonal
/// ritual."
class RecapScreen extends ConsumerStatefulWidget {
  const RecapScreen({super.key});

  @override
  ConsumerState<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends ConsumerState<RecapScreen> {
  bool _carryHabits = true;
  bool _carryStats = false;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    final unlocked = arc.achievements.where((a) => a.isUnlocked).toList()
      ..sort(AchievementEvaluator.compareByUnlock);

    // Day-1 radar, from the snapshot taken when the arc opened.
    final opening = StatSnapshot(
      {
        for (var i = 0; i < StatKeys.all.length; i++)
          StatKeys.all[i]: i < arc.arc.openingStatSnapshot.length
              ? arc.arc.openingStatSnapshot[i].toDouble()
              : 0.0,
      },
      {for (final s in StatKeys.all) s: 0},
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text(
              l.arcCompleteTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l.arcCompleteSubtitle(arc.arc.lengthDays),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.clay.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            ClayContainer(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 8),
              child: Column(
                children: [
                  StatRadar(snapshot: arc.stats, overlay: opening),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendDot(
                        color: context.clay.textSecondary,
                        label: l.recapDay1,
                      ),
                      const SizedBox(width: 18),
                      _LegendDot(
                        color: context.clay.accentFrost,
                        label: l.recapFinal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _Headline(
                  value: '${arc.profile.totalXp}',
                  label: l.recapTotalXp,
                ),
                const SizedBox(width: 12),
                _Headline(
                  value: '${arc.streak.bestStreak}',
                  label: l.recapBestStreak,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Headline(
                  value: '${(arc.completionRate * 100).round()}%',
                  label: l.recapCompletionRate,
                ),
                const SizedBox(width: 12),
                _Headline(
                  value: '${arc.streak.perfectDays}',
                  label: l.recapPerfectDays,
                ),
              ],
            ),

            const SizedBox(height: 24),
            AppSectionHeader(
              title: l.trophyHallTitle,
              badge: '${unlocked.length}',
            ),
            if (unlocked.isEmpty)
              Text(
                l.emptyTrophyBody,
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: unlocked.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final def = AchievementEvaluator.defFor(unlocked[i].key);
                    if (def == null) return const SizedBox.shrink();
                    return SizedBox(
                      width: 106,
                      child: ClayTrophyMedal(
                        title: L10nLookup.achievementName(def.nameKey, l),
                        icon: AppIcons.forAchievement(def.id),
                        unlocked: true,
                        progress: 1,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),
            ClayButton(
              label: l.shareCard,
              icon: Icons.ios_share_rounded,
              expand: true,
              onPressed: () => shareArcCard(
                context,
                ref,
                arc,
                headline: l.arcCompleteTitle,
                subline: l.arcCompleteSubtitle(arc.arc.lengthDays),
              ),
            ),

            const SizedBox(height: 26),
            AppSectionHeader(title: l.startNewArc),
            ClayContainer(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _CarryRow(
                    label: l.carryHabits,
                    value: _carryHabits,
                    onChanged: (v) => setState(() => _carryHabits = v),
                  ),
                  const SizedBox(height: 14),
                  _CarryRow(
                    label: l.carryStats,
                    value: _carryStats,
                    onChanged: (v) => setState(() => _carryStats = v),
                  ),
                  const SizedBox(height: 20),
                  ClayButton(
                    label: l.startNewArc,
                    primary: true,
                    expand: true,
                    icon: Icons.play_arrow_rounded,
                    onPressed: _busy ? null : () => _startNewArc(arc),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startNewArc(ArcState arc) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showClayDialog(
      context: context,
      title: l.startNewArc,
      message: _carryStats ? l.carryStats : l.arcCompleteTitle,
      confirmLabel: l.confirm,
      cancelLabel: l.cancel,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    await ref
        .read(trackerServiceProvider)
        .startNewArc(
          state: arc,
          lengthDays: arc.arc.lengthDays,
          carryHabits: _carryHabits,
          carryStats: _carryStats,
        );
    await ref.read(arcStateProvider.notifier).refresh();
    if (mounted) setState(() => _busy = false);
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: context.clay.accentFrost,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ],
  );
}

class _CarryRow extends StatelessWidget {
  const _CarryRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(label, style: Theme.of(context).textTheme.titleMedium),
      ),
      ClayToggle(value: value, onChanged: onChanged, semanticLabel: label),
    ],
  );
}
