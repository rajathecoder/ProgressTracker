import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_languages.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';

/// A searchable language list.
///
/// Indian languages are grouped first and every entry is shown in its own
/// script, because someone looking for their language scans for the shape of
/// it, not for its English name.
class LanguagePickerSheet extends ConsumerStatefulWidget {
  const LanguagePickerSheet({super.key});

  @override
  ConsumerState<LanguagePickerSheet> createState() =>
      _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends ConsumerState<LanguagePickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(AppLanguage lang) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return lang.englishName.toLowerCase().contains(q) ||
        lang.nativeName.toLowerCase().contains(q) ||
        lang.code.toLowerCase() == q;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final current = ref.watch(settingsProvider).localeOverride;

    final indian = AppLanguages.indian.where(_matches).toList();
    final world = AppLanguages.world.where(_matches).toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.settingsLanguage,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                ClayInputField(
                  label: l.languageSearchHint,
                  controller: _search,
                  icon: Icons.search_rounded,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              children: [
                _SystemRow(selected: current == null, onTap: _clear),
                if (indian.isNotEmpty) ...[
                  _GroupHeader(title: l.languageIndian),
                  for (final lang in indian)
                    _LanguageRow(
                      language: lang,
                      selected: current == lang.code,
                      translatedLabel: l.languageTranslated,
                      onTap: () => _select(lang),
                    ),
                ],
                if (world.isNotEmpty) ...[
                  _GroupHeader(title: l.languageWorld),
                  for (final lang in world)
                    _LanguageRow(
                      language: lang,
                      selected: current == lang.code,
                      translatedLabel: l.languageTranslated,
                      onTap: () => _select(lang),
                    ),
                ],
                const SizedBox(height: 18),
                Text(
                  l.languageFallbackNote,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: clay.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clear() async {
    await ref
        .read(settingsProvider.notifier)
        .mutate((s) => s.copyWith(clearLocaleOverride: true));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _select(AppLanguage lang) async {
    await ref
        .read(settingsProvider.notifier)
        .mutate((s) => s.copyWith(localeOverride: lang.code));
    if (!mounted) return;
    Navigator.of(context).pop();
    showClaySnackBar(
      context,
      message: lang.nativeName,
      icon: Icons.translate_rounded,
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 4, top: 22, bottom: 10),
    child: Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.3,
        fontWeight: FontWeight.w800,
        color: context.clay.textSecondary,
      ),
    ),
  );
}

class _SystemRow extends StatelessWidget {
  const _SystemRow({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _Row(
      title: l.settingsLanguageSystem,
      subtitle: null,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.translatedLabel,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final String translatedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Row(
    title: language.nativeName,
    subtitle: language.englishName,
    badge: language.isTranslated ? translatedLabel : null,
    selected: selected,
    onTap: onTap,
  );
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final clay = context.clay;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClayContainer(
          state: selected ? ClaySurfaceState.recessed : ClaySurfaceState.raised,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selected ? clay.accentFrost : clay.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  margin: const EdgeInsetsDirectional.only(end: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: clay.gridCheckedIcon.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: clay.gridCheckedIcon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: clay.accentFrost,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
