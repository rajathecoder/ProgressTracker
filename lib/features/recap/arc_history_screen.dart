import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../data/models/arc.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';

/// multi_arc.carry_options.archive_only - "Past arc remains readable in a
/// read-only history view."
class ArcHistoryScreen extends ConsumerWidget {
  const ArcHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final clay = context.clay;
    final current = ref.watch(arcProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.arcHistoryTitle)),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<Arc>>(
          future: ref.read(arcRepositoryProvider).all(),
          builder: (context, snapshot) {
            final arcs = snapshot.data;
            if (arcs == null) {
              return const Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    ClaySkeleton(height: 96, radius: 24),
                    SizedBox(height: 12),
                    ClaySkeleton(height: 96, radius: 24),
                  ],
                ),
              );
            }
            if (arcs.isEmpty) {
              return ClayEmptyState(
                title: l.arcHistoryTitle,
                message: l.analyticsNotEnoughData,
                icon: Icons.history_rounded,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
              itemCount: arcs.length,
              itemBuilder: (context, i) {
                final arc = arcs[i];
                final isCurrent = arc.id == current?.arc.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClayContainer(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                arc.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (isCurrent)
                              Icon(
                                Icons.play_circle_outline_rounded,
                                color: clay.accentFrost,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${ArcDate.formatMedium(arc.startDate, locale)} - '
                          '${ArcDate.formatMedium(arc.endDate, locale)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _Stat(
                              label: l.arcDayCounter(
                                arc.lengthDays,
                                arc.lengthDays,
                              ),
                            ),
                            if (arc.finalCompletionRate != null)
                              _Stat(
                                label:
                                    '${l.recapCompletionRate}: '
                                    '${(arc.finalCompletionRate! * 100).round()}%',
                              ),
                            if (arc.finalLevel != null)
                              _Stat(label: l.levelUpTitle(arc.finalLevel!)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: context.clay.accentFrost),
  );
}
