import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_input_field.dart';

/// Lets the name and nickname be corrected after onboarding.
///
/// Both are typed once, in a hurry, on the second screen the user ever sees -
/// so a typo used to be permanent, and the nickname is on the dashboard every
/// single day.
class ProfileEditorSheet extends ConsumerStatefulWidget {
  const ProfileEditorSheet({super.key, required this.arc});

  final ArcState arc;

  @override
  ConsumerState<ProfileEditorSheet> createState() => _ProfileEditorSheetState();
}

class _ProfileEditorSheetState extends ConsumerState<ProfileEditorSheet> {
  late final _name = TextEditingController(text: widget.arc.profile.fullName);
  late final _nickname = TextEditingController(
    text: widget.arc.profile.nickname,
  );

  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _nickname.dispose();
    super.dispose();
  }

  bool get _valid =>
      _name.text.trim().isNotEmpty && _nickname.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.editProfile, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 22),
          ClayInputField(
            label: l.enterFullName,
            controller: _name,
            icon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          ClayInputField(
            label: l.enterNickname,
            controller: _nickname,
            icon: Icons.face_outlined,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _valid ? _save() : null,
          ),
          const SizedBox(height: 26),
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
                  onPressed: _valid && !_busy ? _save : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messengerContext = context;
    try {
      final profile = widget.arc.profile
        ..fullName = _name.text.trim()
        ..nickname = _nickname.text.trim();
      await ref.read(profileRepositoryProvider).save(profile);
      await ref.read(arcStateProvider.notifier).refresh();
      navigator.pop();
      if (!messengerContext.mounted) return;
      showClaySnackBar(
        messengerContext,
        message: l.profileSaved,
        icon: Icons.check_circle_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
