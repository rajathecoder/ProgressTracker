import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/clay_theme.dart';
import '../../core/utils/arc_date.dart';
import '../../domain/arc_state.dart';
import '../../l10n/app_localizations.dart';
import '../home_widgets/widget_bridge.dart';
import '../home_widgets/widget_renderer.dart';
import '../habit_library/habit_library_screen.dart';
import '../matrix/matrix_screen.dart';
import '../recap/recap_screen.dart';
import '../settings/settings_screen.dart';
import 'menu_tab.dart';
import 'protocol_insights_tab.dart';

/// Five-tab shell with a floating clay dock, sized for one-thumb reach.
///
/// Protocol and Insights are merged into one continuous scroll (see
/// [ProtocolInsightsTab]); Focus and Journal live behind the Menu tab as
/// tappable tiles rather than fixed sub-tabs, so a future feature is just
/// another tile (see [MenuTab]).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  bool _servicesStarted = false;
  final _notchController = NotchBottomBarController();

  /// A launch intent is worth exactly one tab change.
  ///
  /// Android leaves the launching intent attached to the Activity, so re-reading
  /// it on every resume replayed the same widget deep link and yanked the user
  /// back to that widget's tab whenever they returned to the app. Taps that
  /// arrive while the app is alive come down `widgetClicked` instead, so
  /// consuming the launch intent loses nothing.
  bool _launchLinkConsumed = false;
  StreamSubscription<int>? _stepSub;
  StreamSubscription<Uri?>? _widgetTapSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startServices();
      _handleLaunchLink();
    });

    // A tap on a widget while the app is already running arrives here rather
    // than as a cold launch, so both paths have to be handled or the second tap
    // silently does nothing.
    _widgetTapSub = ref
        .read(widgetServiceProvider)
        .widgetClicked
        .listen(_openDeepLink);
  }

  @override
  void dispose() {
    _stepSub?.cancel();
    _widgetTapSub?.cancel();
    _notchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Routes a widget's deep link to the tab it belongs to.
  ///
  /// Without this every widget dropped the user on the dashboard regardless of
  /// which one they tapped, and a return trip landed there again - the link was
  /// being delivered and then ignored.
  void _openDeepLink(Uri? uri) {
    if (uri == null || !mounted) return;
    final target = AppConstants.widgetDeepLinkTabs[uri.host];
    if (target == null) return;

    // Any pushed route (Trophy Hall, Widget Gallery, Focus, Journal) has to
    // come off first, or the tab change happens underneath a screen the user
    // is still looking at.
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(shellTabProvider.notifier).state = target.tab;
    // The Menu tab (2) is a list, not a switcher: `sub` says which tile to
    // push straight through to, same as tapping it would.
    if (target.tab == 2 && target.sub != null) {
      if (target.sub == 0) {
        openFocusTab(context);
      } else {
        openJournalTab(context, ref);
      }
    }
  }

  Future<void> _handleLaunchLink() async {
    if (_launchLinkConsumed) return;
    // Claimed before the await so a resume landing mid-read cannot double-apply.
    _launchLinkConsumed = true;
    final uri = await ref
        .read(widgetServiceProvider)
        .initiallyLaunchedFromWidget();
    _openDeepLink(uri);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // edge_case_handling.device_reboot: belt-and-braces reschedule on every
      // foreground, because Android silently drops alarms on reboot.
      unawaited(_rescheduleNotifications());
      unawaited(ref.read(arcStateProvider.notifier).refresh());
      unawaited(_handleLaunchLink());
    }
  }

  /// Startup is a chain of plugin calls, any of which can outlive the widget
  /// if the user navigates away mid-launch. Every await is followed by a
  /// mounted check so a disposed shell can never touch `ref`.
  Future<void> _startServices() async {
    if (_servicesStarted || !mounted) return;
    _servicesStarted = true;

    final arc = ref.read(arcProvider);
    if (arc == null) return;

    await ref.read(widgetServiceProvider).init();
    if (!mounted) return;

    await ref.read(backgroundServiceProvider).init();
    if (!mounted) return;

    await ref.read(backgroundServiceProvider).schedulePeriodic();
    if (!mounted) return;

    ref.read(notificationServiceProvider).onAction = _handleNotificationAction;
    await _rescheduleNotifications();
    if (!mounted) return;

    await _startPedometer(arc);
    if (!mounted) return;

    await _pushWidgetData(arc);
  }

  Future<void> _rescheduleNotifications() async {
    if (!mounted) return;
    final arc = ref.read(arcProvider);
    if (arc == null) return;
    final l = AppLocalizations.of(context);
    final report = await ref
        .read(notificationServiceProvider)
        .rescheduleAll(
          settings: ref.read(settingsProvider),
          l10n: l,
          habits: arc.activeHabits,
          arcStart: arc.arc.startDate,
          locale: Localizations.localeOf(context).languageCode,
        );
    if (!mounted) return;

    // Surfacing this is the whole point: an unhealthy report is the difference
    // between "my alarms stopped" being a mystery and being a one-tap fix.
    ref.read(reminderHealthProvider.notifier).state = report;

    await ref
        .read(settingsProvider.notifier)
        .mutate((s) => s.copyWith(lastBootRescheduleAt: DateTime.now()));
  }

  /// core_features.actionable_notifications - log without opening the app.
  Future<void> _handleNotificationAction(String action, String? input) async {
    final arc = ref.read(arcProvider);
    if (arc == null) return;
    final tracker = ref.read(trackerServiceProvider);

    switch (action) {
      case NotifAction.wakeDone:
        final habit = _findByTitleKey(arc, 'habitEarlyWake');
        if (habit != null) {
          await tracker.toggleHabit(state: arc, habit: habit, day: arc.today);
        }
      case NotifAction.snooze:
        await ref
            .read(notificationServiceProvider)
            .snooze(const Duration(minutes: 15));
      case NotifAction.logWorkout:
        final habit = _findByTitleKey(arc, 'habitGymWorkout');
        if (habit != null) {
          await tracker.toggleHabit(state: arc, habit: habit, day: arc.today);
        }
      case NotifAction.restDay:
        break;
      case NotifAction.openDebrief:
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ref.read(shellTabProvider.notifier).state = 2;
          openJournalTab(context, ref);
        }
      case NotifAction.quickGratitude:
        if (input != null && input.trim().isNotEmpty) {
          await tracker.saveJournal(
            state: arc,
            day: arc.today,
            gratitude: input.trim(),
          );
        }
    }
    await ref.read(arcStateProvider.notifier).refresh();
  }

  static dynamic _findByTitleKey(ArcState arc, String key) {
    for (final h in arc.activeHabits) {
      if (h.titleKey == key) return h;
    }
    return null;
  }

  Future<void> _startPedometer(ArcState arc) async {
    final settings = ref.read(settingsProvider);
    final usesSteps = arc.activeHabits.any(
      (h) => h.titleKey == 'habitStepsGoal',
    );
    if (!usesSteps) return;

    final permissions = ref.read(permissionServiceProvider);
    if (!await permissions.activityRecognitionGranted()) return;
    if (!mounted) return;

    final pedometer = ref.read(pedometerServiceProvider);
    final available = await pedometer.probe();
    if (!mounted) return;
    if (!available) {
      // edge_case_handling.pedometer_unavailable: fall back to manual entry
      // rather than showing a permanently zeroed card.
      await ref
          .read(settingsProvider.notifier)
          .mutate((s) => s.copyWith(pedometerAvailable: false));
      return;
    }
    if (!settings.pedometerAvailable) {
      await ref
          .read(settingsProvider.notifier)
          .mutate((s) => s.copyWith(pedometerAvailable: true));
    }

    await pedometer.start(arc.todayKey);
    if (!mounted) return;
    _stepSub = pedometer.todaySteps.listen((steps) async {
      if (!mounted) return;
      final current = ref.read(arcProvider);
      if (current == null) return;
      await ref
          .read(trackerServiceProvider)
          .saveStepCount(state: current, day: current.today, steps: steps);
    });
  }

  Future<void> _pushWidgetData(ArcState arc) async {
    if (!mounted) return;
    // The PNGs are rendered here, in the foreground, because
    // renderFlutterWidget needs a rendering surface the background isolate does
    // not have. The scalar push below is what keeps the native text fallback
    // current when only the background task runs.
    final dark = Theme.of(context).brightness == Brightness.dark;
    final widgets = ref.read(widgetServiceProvider);
    // Deferred to the next frame: rendering during the build that triggered it
    // rasterises a layer that has not painted yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        WidgetRenderer.renderAll(service: widgets, arc: arc, dark: dark),
      );
    });
    if (!mounted) return;
    // One publisher for the whole widget surface - the app, the background task
    // and the widget's own callback all write the same shape, so the native
    // layouts never have to guess which of them ran last.
    await pushWidgetState(arc, ref.read(settingsProvider));
    await ref.read(widgetServiceProvider).update();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final clay = context.clay;
    final arc = ref.watch(arcProvider);

    ref.listen(arcStateProvider, (_, next) {
      final value = next.valueOrNull;
      if (value != null) unawaited(_pushWidgetData(value));
    });

    final index = ref.watch(shellTabProvider);

    // core_features.multi_arc: on the last day the app enters a Recap state.
    if (arc != null && arc.arcComplete) return const RecapScreen();

    // The notch bar's controller is plain ChangeNotifier state, so an
    // out-of-band tab change (a widget deep link, a notification action) has
    // to be pushed into it manually - a user tap already syncs itself via the
    // bar's own onTap.
    if (_notchController.index != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _notchController.index != index) {
          _notchController.jumpTo(index);
        }
      });
    }

    final tabs = <Widget>[
      const ProtocolInsightsTab(),
      const MatrixScreen(),
      const MenuTab(),
      const HabitLibraryScreen(),
      const SettingsScreen(),
    ];

    final destinations = <_Dest>[
      _Dest(
        Icons.shield_moon_outlined,
        Icons.shield_moon,
        l.dashboardTitle,
        lottieAsset: 'assets/lottie/protocol.json',
      ),
      _Dest(
        Icons.grid_on_outlined,
        Icons.grid_on,
        l.matrixTitle,
        lottieAsset: 'assets/lottie/matrix.json',
      ),
      _Dest(
        Icons.apps_outlined,
        Icons.apps_rounded,
        l.menuTitle,
        lottieAsset: 'assets/lottie/menu.json',
      ),
      _Dest(
        Icons.tune_outlined,
        Icons.tune,
        l.habitLibraryTitle,
        lottieAsset: 'assets/lottie/library.json',
      ),
      _Dest(
        Icons.settings_outlined,
        Icons.settings,
        l.settingsTitle,
        lottieAsset: 'assets/lottie/settings.json',
      ),
    ];

    // The bar is filled with the app's primary (accentFrost), so icons and
    // labels need the theme's computed on-primary color rather than the
    // usual clay text tokens, which assume a neutral surface behind them.
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      // Not extendBody: with it, each tab's own scrollable content (habit
      // rows, the matrix grid, the habit list) rendered behind the notch bar
      // and showed through its unpainted corner margins, making the bar read
      // as partly transparent on Protocol, Matrix and Habit Library.
      body: IndexedStack(index: index, children: tabs),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedNotchBottomBar(
          notchBottomBarController: _notchController,
          color: clay.accentFrost,
          notchColor: clay.accentFrost,
          showShadow: false,
          showLabel: true,
          itemLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9.5,
            color: onPrimary.withValues(alpha: 0.75),
          ),
          textOverflow: TextOverflow.ellipsis,
          maxLine: 1,
          kBottomRadius: 26,
          kIconSize: 21,
          bottomBarHeight: 56,
          elevation: 0,
          durationInMilliSeconds: 250,
          bottomBarItems: [
            for (final d in destinations)
              BottomBarItem(
                itemLabel: d.label,
                // No fallback Material icons for a tab with a Lottie: at
                // rest it's the same file frozen on its first frame: at
                // selection, the same file plays its "hover-pinch" cycle
                // once (it's authored as a single play-through, not a loop).
                inActiveItem: d.lottieAsset == null
                    ? Icon(d.inactive, color: onPrimary.withValues(alpha: 0.7))
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          onPrimary.withValues(alpha: 0.7),
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset(
                          d.lottieAsset!,
                          animate: false,
                          repeat: false,
                        ),
                      ),
                activeItem: d.lottieAsset == null
                    ? Icon(d.active, color: onPrimary)
                    : ColorFiltered(
                        // The source files are single-tone line icons baked
                        // in a dark navy; this retints them to match every
                        // other icon on the (colored) bar.
                        colorFilter: ColorFilter.mode(
                          onPrimary,
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset(d.lottieAsset!, repeat: false),
                      ),
              ),
          ],
          onTap: (i) => ref.read(shellTabProvider.notifier).state = i,
        ),
      ),
    );
  }
}

class _Dest {
  const _Dest(this.inactive, this.active, this.label, {this.lottieAsset});
  final IconData inactive;
  final IconData active;
  final String label;
  final String? lottieAsset;
}

/// Used by screens that need "today" without reaching for DateTime.now().
DateTime todayFor(ArcState arc) => ArcDate.dayOnly(arc.today);
