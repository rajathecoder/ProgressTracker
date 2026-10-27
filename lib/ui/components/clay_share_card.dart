import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/engines/stat_engine.dart';
import '../../l10n/app_localizations.dart';
import 'clay_container.dart';
import 'stat_radar.dart';

/// Composite Organism - the fixed 1080x1350 render target.
///
/// Composed of the same Clay atoms as the rest of the app, so the shared image
/// and the screen can never drift apart. Rendered off-screen to PNG via the
/// screenshot package for sharing and for the home-screen widget.
class ClayShareCard extends StatelessWidget {
  const ClayShareCard({
    super.key,
    required this.nickname,
    required this.headline,
    required this.subline,
    required this.snapshot,
    required this.level,
    required this.rankKey,
    required this.streak,
    required this.completionRate,
    required this.totalXp,
    required this.arcDay,
    required this.arcLength,
  });

  final String nickname;
  final String headline;
  final String subline;
  final StatSnapshot snapshot;
  final int level;
  final String rankKey;
  final int streak;
  final double completionRate;
  final int totalXp;
  final int arcDay;
  final int arcLength;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    final l = AppLocalizations.of(context);

    return Container(
      width: 1080,
      height: 1350,
      color: clay.background,
      padding: const EdgeInsets.all(72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.ac_unit_rounded, size: 48, color: clay.accentFrost),
              const SizedBox(width: 16),
              Text(
                l.appName.toUpperCase(),
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: clay.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                l.arcDayCounter(arcDay, arcLength),
                style: TextStyle(fontSize: 30, color: clay.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            headline,
            style: TextStyle(
              fontSize: 82,
              height: 1.05,
              fontWeight: FontWeight.w900,
              color: clay.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subline,
            style: TextStyle(fontSize: 34, color: clay.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ClayContainer(
              padding: const EdgeInsets.all(36),
              radius: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: StatRadarMini(snapshot: snapshot, size: 380),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final s in StatKeys.all)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: clay.statColor(s),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    L10nLookup.stat(s, l),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: clay.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${snapshot[s].round()}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: clay.statColor(s),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              _Metric(
                label: l.levelUpTitle(level),
                value: L10nLookup.rank(rankKey, l),
              ),
              _Metric(label: l.recapBestStreak, value: '$streak'),
              _Metric(
                label: l.recapCompletionRate,
                value: '${(completionRate * 100).round()}%',
              ),
              _Metric(label: l.recapTotalXp, value: '$totalXp'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: clay.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 26, color: clay.textSecondary),
          ),
        ],
      ),
    );
  }
}
