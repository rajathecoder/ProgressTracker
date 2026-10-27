import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_icons.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../domain/engines/achievement_evaluator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_progress_ring.dart';
import '../../ui/components/clay_trophy_medal.dart';
import '../share/share_actions.dart';

/// Trophy Hall (Achievements).
class TrophyHallScreen extends ConsumerStatefulWidget {
  const TrophyHallScreen({super.key});

  @override
  ConsumerState<TrophyHallScreen> createState() => _TrophyHallScreenState();
}

class _TrophyHallScreenState extends ConsumerState<TrophyHallScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();

    final byKey = arc.achievementsByKey;
    final defs = AchievementEvaluator.catalogue
        .where((d) => _category == null || d.category == _category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trophyHallTitle),
        actions: [
          IconButton(
            tooltip: l.shareCard,
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => shareArcCard(context, ref, arc),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
          children: [
            _RankCard(arc: arc),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ClayChip(
                    label: l.filterAll,
                    selected: _category == null,
                    onTap: () => setState(() => _category = null),
                  ),
                  const SizedBox(width: 8),
                  for (final c in const [
                    AchievementEvaluator.catStreak,
                    AchievementEvaluator.catMilestone,
                    AchievementEvaluator.catHabit,
                    AchievementEvaluator.catComeback,
                    AchievementEvaluator.catMeta,
                  ]) ...[
                    ClayChip(
                      label: c,
                      selected: _category == c,
                      onTap: () =>
                          setState(() => _category = _category == c ? null : c),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (arc.unlockedAchievementCount == 0 && _category == null)
              ClayEmptyState(
                title: l.emptyTrophyTitle,
                message: l.emptyTrophyBody,
                icon: Icons.emoji_events_outlined,
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: defs.length,
                itemBuilder: (context, i) {
                  final def = defs[i];
                  final record = byKey[def.id];
                  final unlocked = record?.isUnlocked ?? false;
                  return ClayTrophyMedal(
                    title: L10nLookup.achievementName(def.nameKey, l),
                    icon: AppIcons.forAchievement(def.id),
                    unlocked: unlocked,
                    progress: record?.progressRatio ?? 0,
                    subtitle: unlocked
                        ? null
                        : l.achievementProgress(
                            record?.progressCurrent ?? 0,
                            def.target,
                          ),
                    onTap: () => _showDetail(context, def, arc),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDetail(
    BuildContext context,
    AchievementDef def,
    ArcState arc,
  ) {
    final l = AppLocalizations.of(context);
    final record = arc.achievementsByKey[def.id];
    final locale = Localizations.localeOf(context).toString();

    return showClayBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayContainer(
              state: record?.isUnlocked ?? false
                  ? ClaySurfaceState.raised
                  : ClaySurfaceState.disabled,
              radius: 26,
              width: 76,
              height: 76,
              alignment: Alignment.center,
              child: Icon(
                AppIcons.forAchievement(def.id),
                size: 34,
                color: context.clay.accentFrost,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              L10nLookup.achievementName(def.nameKey, l),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              L10nLookup.achievementDesc(def.descKey, l),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            if (record?.isUnlocked ?? false)
              Text(
                l.trophyUnlockedOn(
                  ArcDate.formatMedium(record!.unlockedAt!, locale),
                ),
                style: Theme.of(context).textTheme.labelMedium,
              )
            else
              Column(
                children: [
                  Text(
                    l.achievementProgress(
                      record?.progressCurrent ?? 0,
                      def.target,
                    ),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: record?.progressRatio ?? 0,
                      minHeight: 7,
                      backgroundColor: context.clay.surfaceBorder,
                      valueColor: AlwaysStoppedAnimation(
                        context.clay.accentFrost,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClayProgressRing(
            progress: arc.levelProgress,
            size: 96,
            thickness: 11,
            semanticLabel: l.levelUpTitle(arc.level),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${arc.level}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('LVL', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nLookup.rank(arc.rankKey, l),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: clay.accentFrost),
                ),
                const SizedBox(height: 6),
                Text(
                  l.xpToNextLevel(arc.xpIntoLevel, arc.xpForLevel),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  '${arc.unlockedAchievementCount} / '
                  '${AchievementEvaluator.catalogue.length}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
