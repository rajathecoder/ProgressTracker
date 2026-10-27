import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/clay_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_input_field.dart';

/// core_features.app_lock
///
/// Biometric gate with a hashed-PIN fallback. Wraps whatever it is given, so
/// the same widget serves both the journal-only and whole-app scopes.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  bool _unlocked = false;
  bool _pinMode = false;
  bool _error = false;
  bool _attempted = false;
  final _pin = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _tryBiometric() async {
    if (_attempted) return;
    _attempted = true;
    final service = ref.read(appLockServiceProvider);
    if (!await service.biometricsAvailable()) {
      if (mounted) setState(() => _pinMode = true);
      return;
    }
    if (!mounted) return;
    final ok = await service.authenticate(
      AppLocalizations.of(context).appLockTitle,
    );
    if (mounted) setState(() => _unlocked = ok);
  }

  Future<void> _verifyPin() async {
    final ok = await ref.read(appLockServiceProvider).verifyPin(_pin.text);
    if (!mounted) return;
    setState(() {
      _unlocked = ok;
      _error = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) return widget.child;
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClayContainer(
                  radius: 34,
                  padding: const EdgeInsets.all(28),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 52,
                    color: clay.accentFrost,
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  l.appLockTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 26),
                if (_pinMode) ...[
                  ClayInputField(
                    label: l.appLockEnterPin,
                    controller: _pin,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    icon: Icons.pin_outlined,
                    onSubmitted: (_) => _verifyPin(),
                  ),
                  if (_error)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        l.appLockWrongPin,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: clay.accentEmber,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ClayButton(
                    label: l.appLockUnlock,
                    primary: true,
                    expand: true,
                    onPressed: _verifyPin,
                  ),
                ] else ...[
                  ClayButton(
                    label: l.appLockUnlock,
                    primary: true,
                    icon: Icons.fingerprint_rounded,
                    onPressed: () {
                      _attempted = false;
                      _tryBiometric();
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _pinMode = true),
                    child: Text(l.appLockPinFallback),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
