import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_feedback.dart';
import '../analytics/analytics_screen.dart';
import '../dashboard/dashboard_screen.dart';

/// Protocol and Insights merged into one continuous scroll - no sub-tabs.
/// [ProtocolContent] and [InsightsContent] are both plain [Column]s, so they
/// sit in a single outer [ListView] rather than nesting two scrollables.
class ProtocolInsightsTab extends ConsumerWidget {
  const ProtocolInsightsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.read(arcStateProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              const ProtocolContent(),
              const SizedBox(height: 24),
              AppSectionHeader(title: l.analyticsTitle),
              const InsightsContent(),
            ],
          ),
        ),
      ),
    );
  }
}
