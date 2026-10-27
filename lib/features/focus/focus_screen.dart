import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/feedback_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/components/celebration_overlay.dart';
import '../../ui/components/clay_button.dart';
import '../../ui/components/clay_chip.dart';
import '../../ui/components/clay_container.dart';
import '../../ui/components/clay_feedback.dart';
import '../../ui/components/clay_progress_ring.dart';
import '../home_widgets/widget_bridge.dart';
import 'focus_controller.dart';

/// The concentration timer.
///
/// Pick a length, run it, pause and resume as needed. A finished session is
/// written to the day's log, so focus minutes sit alongside habits and steps
/// rather than in a separate silo.
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen>
    with WidgetsBindingObserver {
  final _controller = FocusController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.onCompleted = _onCompleted;
    _controller.addListener(_publishPhase);
    // A session may already be running from the home-screen widget.
    unawaited(_controller.adoptSharedSession());
  }

  /// Mirrors app-side transitions out to the widget.
  ///
  /// Only on a *phase* change - pushing on every tick would hammer the widget
  /// four times a second for a number the Chronometer is already counting on
  /// its own.
  FocusPhase? _publishedPhase;
  void _publishPhase() {
    final phase = _controller.value.phase;
    if (phase == _publishedPhase) return;
    _publishedPhase = phase;
    unawaited(_pushFocusToWidget());
  }

  Future<void> _pushFocusToWidget() async {
    final arc = ref.read(arcProvider);
    if (arc == null || !mounted) return;
    await pushWidgetState(arc, ref.read(settingsProvider));
    await ref.read(widgetServiceProvider).update();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_publishPhase);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A session may have been started, paused or finished from the widget
    // while the app was away, so the shared store wins on resume.
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.adoptSharedSession());
    }
  }

  Future<void> _onCompleted(int minutes) async {
    final arc = ref.read(arcProvider);
    if (arc == null || !mounted) return;

    final l = AppLocalizations.of(context);
    await ref.read(feedbackServiceProvider).fire(FeedbackEvent.dayComplete);
    await ref
        .read(trackerServiceProvider)
        .addFocusSession(state: arc, day: arc.today, minutes: minutes);
    await ref.read(arcStateProvider.notifier).refresh();

    if (!mounted) return;
    await showCelebration(
      context,
      title: l.focusDone,
      subtitle: l.focusDoneBody(minutes),
      icon: Icons.self_improvement_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final arc = ref.watch(arcProvider);
    if (arc == null) return const SizedBox.shrink();

    return Scaffold(
      // Reached only by pushing from the Menu tab (or a deep link doing the
      // same), so the default back arrow is correct here, unlike the true
      // root tabs which override it away.
      appBar: AppBar(title: Text(l.focusTitle)),
      body: SafeArea(
        top: false,
        child: ValueListenableBuilder<FocusState>(
          valueListenable: _controller,
          builder: (context, state, _) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              _TimerCard(state: state),
              const SizedBox(height: 20),
              _Controls(
                state: state,
                onStart: _controller.start,
                onPause: _controller.pause,
                onResume: _controller.resume,
                onReset: () => _confirmReset(state),
              ),
              const SizedBox(height: 26),
              if (!state.isActive) ...[
                AppSectionHeader(title: l.focusPickPreset),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final minutes in AppConstants.focusPresetMinutes)
                      ClayChip(
                        label: l.focusMinutesShort(minutes),
                        selected: state.total.inMinutes == minutes,
                        onTap: () =>
                            _controller.setDuration(Duration(minutes: minutes)),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                AppSectionHeader(title: l.focusSetDuration),
                ClayContainer(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
                  child: Column(
                    children: [
                      Text(
                        l.focusMinutesShort(state.total.inMinutes),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: clay.accentFrost),
                      ),
                      Slider(
                        value: state.total.inMinutes.toDouble().clamp(
                          AppConstants.minFocusMinutes.toDouble(),
                          AppConstants.maxFocusMinutes.toDouble(),
                        ),
                        min: AppConstants.minFocusMinutes.toDouble(),
                        max: AppConstants.maxFocusMinutes.toDouble(),
                        divisions:
                            (AppConstants.maxFocusMinutes -
                                AppConstants.minFocusMinutes) ~/
                            5,
                        activeColor: clay.accentFrost,
                        onChanged: (v) => _controller.setDuration(
                          Duration(minutes: v.round()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _TodayCard(arc: arc),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(FocusState state) async {
    if (!state.isActive || state.elapsed < const Duration(minutes: 1)) {
      _controller.reset();
      return;
    }
    final l = AppLocalizations.of(context);
    final confirmed = await showClayDialog(
      context: context,
      title: l.focusAbandon,
      message: l.focusAbandonBody,
      confirmLabel: l.confirm,
      cancelLabel: l.cancel,
      destructive: true,
    );
    if (confirmed) _controller.reset();
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({required this.state});
  final FocusState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;

    return ClayContainer(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          ClayProgressRing(
            progress: state.progress,
            size: 232,
            thickness: 18,
            animate: false,
            color: state.isPaused ? clay.warningAmber : clay.accentFrost,
            semanticLabel: l.focusTitle,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatCountdown(state.remaining),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.isRunning
                      ? l.focusRunning
                      : state.isPaused
                      ? l.focusPause
                      : l.focusMinutesShort(state.total.inMinutes),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
  });

  final FocusState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ClayButton(
            label: state.isRunning
                ? l.focusPause
                : state.isPaused
                ? l.focusResume
                : l.focusStart,
            icon: state.isRunning
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            primary: true,
            expand: true,
            onPressed: state.isRunning
                ? onPause
                : state.isPaused
                ? onResume
                : onStart,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClayButton(
            label: l.focusReset,
            icon: Icons.stop_rounded,
            expand: true,
            onPressed: state.isIdle && state.elapsed == Duration.zero
                ? null
                : onReset,
          ),
        ),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.arc});
  final ArcState arc;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final log = arc.todayLog;

    return ClayContainer(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClayContainer(
            state: ClaySurfaceState.recessed,
            radius: 16,
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Icon(
              Icons.self_improvement_rounded,
              color: clay.accentFrost,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.focusTodayTotal(log?.focusMinutes ?? 0),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l.focusSessions(log?.focusSessions ?? 0),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
