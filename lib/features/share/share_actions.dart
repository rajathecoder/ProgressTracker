import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/fallback_delegates.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/share_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_share_card.dart';

/// core_features.share_cards - render a clay card off-screen and hand the PNG
/// to the OS share sheet. Nothing leaves the device unless the user picks a
/// target in that sheet.
Future<void> shareArcCard(
  BuildContext context,
  WidgetRef ref,
  ArcState arc, {
  String? headline,
  String? subline,
}) async {
  final l = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context);
  final settings = ref.read(settingsProvider);
  final share = ref.read(shareServiceProvider);

  // The card is rendered off-screen via `screenshot`'s captureFromWidget,
  // which attaches its own render tree with no real View ancestor. MaterialApp
  // used to wrap this, but MaterialApp always builds a ScaffoldMessenger, and
  // ScaffoldMessenger needs MediaQuery - which comes from a View in modern
  // Flutter, so that crashed with "No MediaQuery widget ancestor found" the
  // moment share was tapped. ClayShareCard needs only Directionality, Theme
  // and Localizations, plus a MediaQuery supplying the fixed card size, so
  // those are provided directly instead of the whole WidgetsApp machinery.
  final card = MediaQuery(
    data: const MediaQueryData(
      size: Size(ShareService.cardWidth, ShareService.cardHeight),
      devicePixelRatio: 1,
    ),
    child: Localizations(
      locale: locale,
      delegates: appLocalizationDelegates,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Theme(
          data: AppTheme.build(
            dark: Theme.of(context).brightness == Brightness.dark,
            highContrast: settings.highContrast,
            reduceMotion: true,
          ),
          child: ClayShareCard(
            nickname: arc.profile.nickname,
            headline: headline ?? l.dashboardGreeting(arc.profile.nickname),
            subline:
                subline ??
                '${L10nLookup.rank(arc.rankKey, l)} · '
                    '${l.streakCount(arc.streak.currentStreak)}',
            snapshot: arc.stats,
            level: arc.level,
            rankKey: arc.rankKey,
            streak: arc.streak.bestStreak,
            completionRate: arc.completionRate,
            totalXp: arc.profile.totalXp,
            arcDay: arc.arcDayNumber,
            arcLength: arc.arc.lengthDays,
          ),
        ),
      ),
    ),
  );

  final messengerContext = context;
  await share.shareWidget(card, 'happy_days_card', text: l.appTitle);
  if (!messengerContext.mounted) return;
  showClaySnackBar(
    messengerContext,
    message: l.shareCard,
    icon: Icons.ios_share_rounded,
  );
}
