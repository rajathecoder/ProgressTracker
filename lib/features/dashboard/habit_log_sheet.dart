import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/services/feedback_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/habit.dart';
import '../../domain/arc_state.dart';
import '../../domain/tracker_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/celebration_overlay.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_stepper.dart';

/// core_features.metric_logging
///
/// Habits with a non-boolean metric open this sheet instead of toggling, so a
/// partial value is recorded rather than discarded.
class HabitLogSheet extends ConsumerStatefulWidget {
  const HabitLogSheet({
    super.key,
    required this.habit,
    required this.day,
    required this.arc,
  });

  final Habit habit;
  final DateTime day;
  final ArcState arc;

  @override
  ConsumerState<HabitLogSheet> createState() => _HabitLogSheetState();
}

class _HabitLogSheetState extends ConsumerState<HabitLogSheet> {
  late double _value =
      widget.arc.logsByKey[ArcDate.keyOf(widget.day)]
          ?.entryFor(widget.habit.id)
          ?.value ??
      0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final locale = Localizations.localeOf(context).toString();
    final target = widget.habit.targetMetric.toDouble();
    final ratio = target <= 0 ? 0.0 : (_value / target).clamp(0.0, 1.0);
    final partial = ratio > 0 && ratio < 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            L10nLookup.habitTitle(widget.habit, l),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            ArcDate.formatMedium(widget.day, locale),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ClayStepper(
            value: _value,
            target: target,
            unitLabel: L10nLookup.unit(widget.habit.metricUnit, l),
            onChanged: (v) => setState(() => _value = v),
          ),
          const SizedBox(height: 12),
          if (partial && widget.arc.settings.partialCreditEnabled)
            Text(
              l.partialCredit((ratio * 100).round()),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: clay.warningAmber),
            ),
          const SizedBox(height: 20),
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
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final outcome = await ref
        .read(trackerServiceProvider)
        .logHabit(
          state: widget.arc,
          habit: widget.habit,
          day: widget.day,
          value: _value,
        );
    navigator.pop();
    if (!mounted) return;
    await reactToOutcome(context, ref, outcome);
  }
}

/// Shared reaction to a write: haptics, sound, snackbar and celebration.
///
/// Kept in one place so the dashboard, the matrix and the notification actions
/// all give identical feedback for identical events.
Future<void> reactToOutcome(
  BuildContext context,
  WidgetRef ref,
  LogOutcome outcome,
) async {
  if (!context.mounted) return;
  final l = AppLocalizations.of(context);
  final feedback = ref.read(feedbackServiceProvider);

  if (outcome.xpSuppressed) {
    showClaySnackBar(
      context,
      message: l.errorGeneric,
      icon: Icons.schedule_rounded,
    );
    return;
  }

  if (outcome.isComplete) {
    await feedback.fire(FeedbackEvent.habitToggleOn);
  } else {
    await feedback.fire(FeedbackEvent.habitToggleOff);
  }

  if (outcome.dayCompleted) await feedback.fire(FeedbackEvent.dayComplete);

  if (!context.mounted) return;

  if (outcome.awardedXp > 0) {
    showClaySnackBar(
      context,
      message: outcome.isComplete
          ? l.xpEarned(outcome.awardedXp)
          : l.partialCredit((outcome.ratio * 100).round()),
      icon: Icons.bolt_rounded,
    );
  }

  if (outcome.leveledUp) {
    await feedback.fire(FeedbackEvent.statLevelUp);
    if (!context.mounted) return;
    await showCelebration(
      context,
      title: l.levelUpTitle(outcome.newLevel),
      subtitle: outcome.rankUnlockedKey != null
          ? l.rankUnlocked(L10nLookup.rank(outcome.rankUnlockedKey!, l))
          : l.perfectDay,
      icon: Icons.military_tech_rounded,
    );
  }

  if (outcome.newAchievementKeys.isNotEmpty && context.mounted) {
    await feedback.fire(FeedbackEvent.achievementUnlock);
    if (!context.mounted) return;
    final first = outcome.newAchievementKeys.first;
    await showCelebration(
      context,
      title: l.achievementUnlocked,
      subtitle: _achievementName(first, l),
      icon: Icons.emoji_events_rounded,
      lottieAsset: 'assets/lottie/badge.json',
    );
  }
}

String _achievementName(String id, AppLocalizations l) {
  final def = _defFor(id);
  return def == null ? id : L10nLookup.achievementName(def, l);
}

String? _defFor(String id) {
  for (final d in AchievementNames.entries) {
    if (d.key == id) return d.value;
  }
  return null;
}

/// id -> ARB name key, so the celebration can title itself without pulling the
/// whole evaluator into the widget layer.
abstract final class AchievementNames {
  static const Map<String, String> map = {
    'first_blood': 'achFirstBlood',
    'perfect_day': 'achPerfectDay',
    'streak_3': 'achStreak3',
    'streak_7': 'achStreak7',
    'streak_14': 'achStreak14',
    'streak_30': 'achStreak30',
    'streak_60': 'achStreak60',
    'streak_100': 'achStreak100',
    'perfect_arc': 'achPerfectArc',
    'ten_perfect_days': 'achTenPerfectDays',
    'early_riser_30': 'achEarlyRiser30',
    'gym_50': 'achGym50',
    'steps_500k': 'achSteps500k',
    'gratitude_100': 'achGratitude100',
    'clean_30': 'achClean30',
    'hydrated_60': 'achHydrated60',
    'level_10': 'achLevel10',
    'level_25': 'achLevel25',
    'level_50': 'achLevel50',
    'balanced': 'achBalanced',
    'phoenix': 'achPhoenix',
    'no_shields_30': 'achNoShields30',
    'first_backup': 'achFirstBackup',
    'architect': 'achArchitect',
  };

  static Iterable<MapEntry<String, String>> get entries => map.entries;
}
