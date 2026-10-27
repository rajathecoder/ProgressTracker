import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/app_providers.dart';
import '../../core/services/photo_store.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../core/utils/l10n_lookup.dart';
import '../../data/models/daily_log.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';

/// Evening Debrief & Gratitude Screen + core_features.daily_journal.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _gratitude = TextEditingController();
  final _notes = TextEditingController();
  final _search = TextEditingController();
  final _tag = TextEditingController();

  int? _mood;
  List<String> _tags = [];
  List<String> _photos = [];
  String _query = '';
  bool _dirty = false;

  /// The day currently loaded into the editor. Lets the user open a past entry
  /// and edit it, instead of the journal being a today-only write surface.
  DateTime? _editingDay;

  /// Identity of the log the fields were filled from. A single `_loaded` flag
  /// meant the editor never refreshed - so a gratitude line captured from a
  /// notification, or the day rolling over at 4am, left stale text on screen
  /// that the next save would write straight back over the newer value.
  String? _hydratedFrom;

  @override
  void dispose() {
    _gratitude.dispose();
    _notes.dispose();
    _search.dispose();
    _tag.dispose();
    super.dispose();
  }

  DateTime _dayFor(ArcState arc) => _editingDay ?? arc.today;

  /// Fills the editor from storage, but never on top of unsaved edits.
  void _hydrate(ArcState arc) {
    final day = _dayFor(arc);
    final log = arc.logsByKey[ArcDate.keyOf(day)];
    final signature = _signatureOf(ArcDate.keyOf(day), log);
    if (_hydratedFrom == signature) return;
    if (_dirty && _hydratedFrom != null) return;

    _gratitude.text = log?.gratitudeText ?? '';
    _notes.text = log?.progressNotes ?? '';
    _mood = log?.mood;
    _tags = List<String>.from(log?.tags ?? const []);
    _photos = List<String>.from(log?.photoPaths ?? const []);
    _hydratedFrom = signature;
  }

  static String _signatureOf(String dateKey, DailyLog? log) =>
      '$dateKey|${log?.gratitudeText.hashCode}|${log?.progressNotes.hashCode}'
      '|${log?.mood}|${log?.tags.join(',')}|${log?.photoPaths.length}';

  void _openDay(ArcState arc, DateTime day) {
    setState(() {
      _editingDay = ArcDate.isSameDay(day, arc.today)
          ? null
          : ArcDate.dayOnly(day);
      _dirty = false;
      _hydratedFrom = null;
    });
  }

  Future<void> _save(ArcState arc) async {
    final day = _dayFor(arc);
    await ref
        .read(trackerServiceProvider)
        .saveJournal(
          state: arc,
          day: day,
          gratitude: _gratitude.text,
          notes: _notes.text,
          mood: _mood,
          tags: _tags,
          photoPaths: _photos,
        );
    if (!mounted) return;
    setState(() {
      _dirty = false;
      // Force the next build to re-read what was actually persisted.
      _hydratedFrom = null;
    });
    showClaySnackBar(
      context,
      message: AppLocalizations.of(context).journalSaved,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  Future<void> _addPhoto() async {
    // Photos stay local and are never uploaded - but the picker's own path
    // lives in the OS cache, which gets purged, so the file is copied into the
    // app's documents directory before the path is stored.
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 82,
    );
    if (picked == null) return;
    final stored = await PhotoStore.persist(picked.path);
    if (stored == null || !mounted) return;
    setState(() {
      _photos = [..._photos, stored];
      _dirty = true;
    });
  }

  Future<void> _removePhoto(String path) async {
    setState(() {
      _photos = _photos.where((p) => p != path).toList();
      _dirty = true;
    });
    await PhotoStore.remove(path);
  }

  @override
  Widget build(BuildContext context) {
    final arc = ref.watch(arcProvider);
    final l = AppLocalizations.of(context);
    if (arc == null) return const SizedBox.shrink();
    _hydrate(arc);

    final locale = Localizations.localeOf(context).toString();
    final past =
        arc.logsByKey.values
            .where(
              (log) => log.hasJournalContent && log.dateKey != arc.todayKey,
            )
            .where((log) => _matches(log, _query))
            .toList()
          ..sort((a, b) => b.dateKey.compareTo(a.dateKey));

    return Scaffold(
      // Reached only by pushing from the Menu tab (or a deep link doing the
      // same), so the default back arrow is correct here, unlike the true
      // root tabs which override it away.
      appBar: AppBar(
        title: Text(l.journalTitle),
        actions: [
          if (_dirty)
            IconButton(
              tooltip: l.save,
              icon: const Icon(Icons.save_outlined),
              onPressed: () => _save(arc),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
          children: [
            ClayContainer(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ArcDate.formatMedium(_dayFor(arc), locale),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (_dirty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: Text(
                            l.journalUnsaved,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: context.clay.warningAmber),
                          ),
                        ),
                      if (_editingDay != null)
                        TextButton(
                          onPressed: () => _openDay(arc, arc.today),
                          child: Text(l.journalToday),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l.journalMoodPrompt,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  _MoodSelector(
                    value: _mood,
                    onChanged: (v) => setState(() {
                      _mood = v;
                      _dirty = true;
                    }),
                  ),
                  const SizedBox(height: 20),
                  ClayInputField(
                    label: l.journalGratitudeLabel,
                    controller: _gratitude,
                    icon: Icons.favorite_outline_rounded,
                    maxLines: 3,
                    minLines: 2,
                    onChanged: (_) => setState(() => _dirty = true),
                  ),
                  const SizedBox(height: 18),
                  ClayInputField(
                    label: l.journalNotesLabel,
                    controller: _notes,
                    icon: Icons.notes_rounded,
                    maxLines: 6,
                    minLines: 3,
                    onChanged: (_) => setState(() => _dirty = true),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l.journalTagsLabel,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in _tags)
                        ClayChip(
                          label: tag,
                          selected: true,
                          onDeleted: () => setState(() {
                            _tags = _tags.where((t) => t != tag).toList();
                            _dirty = true;
                          }),
                        ),
                      ClayChip(
                        label: l.journalTagsLabel,
                        icon: Icons.add_rounded,
                        onTap: _promptTag,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ClayButton(
                        label: l.journalAddPhoto,
                        icon: Icons.add_a_photo_outlined,
                        compact: true,
                        onPressed: _addPhoto,
                      ),
                      const Spacer(),
                      ClayButton(
                        label: l.save,
                        primary: true,
                        compact: true,
                        onPressed: () => _save(arc),
                      ),
                    ],
                  ),
                  if (_photos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 84,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _photos.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, i) => Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(_photos[i]),
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const SizedBox(
                                  width: 84,
                                  height: 84,
                                  child: Icon(Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              top: 2,
                              end: 2,
                              child: GestureDetector(
                                onTap: () => _removePhoto(_photos[i]),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.55),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            ClayInputField(
              label: l.journalSearchHint,
              controller: _search,
              icon: Icons.search_rounded,
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 18),
            AppSectionHeader(title: l.journalPast, badge: '${past.length}'),
            if (past.isEmpty)
              ClayEmptyState(
                title: l.emptyJournalTitle,
                message: l.emptyJournalBody,
                icon: Icons.menu_book_outlined,
              )
            else
              for (final log in past)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _JournalEntryCard(
                    log: log,
                    locale: locale,
                    onTap: () => _openDay(arc, log.date),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  bool _matches(DailyLog log, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return log.gratitudeText.toLowerCase().contains(q) ||
        log.progressNotes.toLowerCase().contains(q) ||
        log.tags.any((t) => t.toLowerCase().contains(q));
  }

  Future<void> _promptTag() async {
    _tag.clear();
    final l = AppLocalizations.of(context);
    await showClayBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayInputField(
              label: l.journalTagsLabel,
              controller: _tag,
              autofocus: true,
              onSubmitted: (_) => Navigator.of(sheetContext).pop(),
            ),
            const SizedBox(height: 18),
            ClayButton(
              label: l.save,
              primary: true,
              expand: true,
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
    final value = _tag.text.trim();
    if (value.isEmpty || _tags.contains(value)) return;
    setState(() {
      _tags = [..._tags, value];
      _dirty = true;
    });
  }
}

class _MoodSelector extends StatelessWidget {
  const _MoodSelector({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int> onChanged;

  static const _icons = [
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Semantics(
                selected: value == i,
                button: true,
                label: L10nLookup.mood(i, l),
                child: ExcludeSemantics(
                  child: GestureDetector(
                    onTap: () => onChanged(i),
                    child: ClayContainer(
                      state: value == i
                          ? ClaySurfaceState.recessed
                          : ClaySurfaceState.raised,
                      radius: 14,
                      height: 54,
                      alignment: Alignment.center,
                      child: Icon(
                        _icons[i - 1],
                        color: value == i
                            ? clay.accentFrost
                            : clay.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({
    required this.log,
    required this.locale,
    this.onTap,
  });

  final DailyLog log;
  final String locale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return GestureDetector(
      onTap: onTap,
      child: ClayContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ArcDate.formatMedium(log.date, locale),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                if (log.mood != null)
                  Text(
                    L10nLookup.mood(log.mood!, l),
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: clay.accentFrost),
                  ),
              ],
            ),
            if (log.gratitudeText.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: clay.accentEmber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      log.gratitudeText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            if (log.progressNotes.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                log.progressNotes,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: clay.textSecondary),
              ),
            ],
            if (log.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final t in log.tags) ClayChip(label: t)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
