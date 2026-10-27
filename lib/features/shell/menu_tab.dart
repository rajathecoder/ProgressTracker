import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../data/models/app_settings.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../focus/focus_screen.dart';
import '../journal/journal_screen.dart';
import 'app_lock_gate.dart';

/// Menu: a grid of secondary features, each one tap away.
///
/// Deliberately a grid rather than a fixed two-way switcher - Focus and
/// Journal are the first two entries, but adding a future feature is just
/// another [_MenuTile], not a redesign.
class MenuTab extends ConsumerWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        // A root tab has nothing to pop back to; the implied arrow was
        // both misleading and, once a deep link pushed a route, wrong.
        automaticallyImplyLeading: false,
        title: Text(l.menuTitle),
      ),
      body: SafeArea(
        top: false,
        child: GridView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.92,
          ),
          children: [
            _MenuTile(
              icon: Icons.self_improvement_outlined,
              title: l.focusTitle,
              subtitle: l.focusSubtitle,
              onTap: () => openFocusTab(context),
            ),
            _MenuTile(
              icon: Icons.menu_book_outlined,
              title: l.journalTitle,
              subtitle: l.journalOnThisDay,
              onTap: () => openJournalTab(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
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
  Widget build(BuildContext context) {
    final clay = context.clay;
    return GestureDetector(
      onTap: onTap,
      child: ClayContainer(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClayContainer(
              state: ClaySurfaceState.recessed,
              radius: 16,
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: clay.accentFrost),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pushed from the Menu tile and from a `happydays://focus` deep link alike,
/// so both paths land on the exact same route.
void openFocusTab(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => const FocusScreen()),
);

/// App lock is scoped to the Journal tab by default, so the pushed route has
/// to carry the same [AppLockGate] the embedded tab used to.
void openJournalTab(BuildContext context, WidgetRef ref) {
  final settings = ref.read(settingsProvider);
  final journal =
      settings.appLockEnabled && settings.appLockScope == AppLockScope.journal
      ? const AppLockGate(child: JournalScreen())
      : const JournalScreen();
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => journal));
}
