import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/app_settings.dart';
import '../../data/models/habit.dart';
import '../../l10n/app_localizations.dart';
import '../constants/notification_copy.dart';
import '../utils/arc_date.dart';

/// Payload actions a notification can send back into the app.
abstract final class NotifAction {
  static const wakeDone = 'wake_done';
  static const snooze = 'snooze_15';
  static const logWorkout = 'log_workout';
  static const restDay = 'rest_day';
  static const openDebrief = 'open_debrief';
  static const quickGratitude = 'quick_gratitude';
  static const inputKey = 'gratitude_input';
}

/// The outcome of a reschedule.
///
/// Scheduling used to swallow every failure into a debugPrint, which is exactly
/// how "my alarms just stopped" happens: the app looks fine and nothing is
/// armed. Every reschedule now reports what actually got scheduled, and the
/// Settings screen surfaces it.
@immutable
class ScheduleReport {
  const ScheduleReport({
    required this.notificationsPermitted,
    required this.exactAlarms,
    required this.scheduled,
    required this.failed,
    required this.timezone,
    required this.skipped,
  });

  final bool notificationsPermitted;
  final bool exactAlarms;
  final int scheduled;
  final int failed;
  final String timezone;

  /// True when the user has reminders switched off - not a failure.
  final bool skipped;

  bool get healthy =>
      skipped || (notificationsPermitted && failed == 0 && scheduled > 0);

  static const none = ScheduleReport(
    notificationsPermitted: false,
    exactAlarms: false,
    scheduled: 0,
    failed: 0,
    timezone: '',
    skipped: false,
  );
}

/// A snapshot of the reminder subsystem, shown in Settings.
@immutable
class ReminderStatus {
  const ReminderStatus({
    required this.permitted,
    required this.exactAlarms,
    required this.pending,
    required this.dailyReminders,
    required this.timezone,
  });

  final bool permitted;
  final bool exactAlarms;
  final int pending;
  final int dailyReminders;
  final String timezone;

  bool get healthy => permitted && pending > 0;

  static const unknown = ReminderStatus(
    permitted: false,
    exactAlarms: false,
    pending: 0,
    dailyReminders: 0,
    timezone: '',
  );
}

/// core_features.local_notifications
///
/// Zero network dependency. Exact alarms via Android AlarmManager and iOS
/// UNUserNotificationCenter, scheduled as TZDateTime so DST shifts cannot drift
/// the 05:30 wake-up (edge_case_handling.timezone_travel_and_dst).
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static final FlutterLocalNotificationsPlugin _shared =
      FlutterLocalNotificationsPlugin();

  factory NotificationService.instance() => NotificationService(_shared);

  bool _tzReady = false;
  bool _initialised = false;

  /// Fired when a notification action comes back. The app layer subscribes.
  void Function(String action, String? input)? onAction;

  /// The bundled reminder tone.
  ///
  /// Android reads it from res/raw (no extension); iOS reads the bundled file
  /// by name. Both are only honoured on the *first* creation of a channel, so
  /// changing the sound later needs a new channel id - hence [_channelSuffix].
  static const _androidSound = RawResourceAndroidNotificationSound(
    'notification',
  );
  static const _iosSound = 'notification.mp3';

  /// Bump when the channel's sound or importance changes; Android ignores
  /// edits to an existing channel, so a new id is the only way to apply them.
  static const _channelSuffix = '_v2';

  static const int _baseId = 1000;
  static const int _testId = 1999;
  static const int _habitBaseId = 5000;

  Future<void> init() async {
    if (_initialised) return;
    await _ensureTimezone();

    const android = AndroidInitializationSettings('@drawable/ic_notification');
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: _darwinCategories(),
    );

    await _plugin.initialize(
      settings: InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: _handleResponse,
    );
    _initialised = true;
  }

  /// The IANA zone the alarms are anchored to, e.g. 'Asia/Kolkata'.
  String get timezoneName => _tzName;
  String _tzName = '';

  /// Re-resolved on every app start so a traveller gets alarms in the zone they
  /// actually woke up in.
  ///
  /// The zone comes from the platform (`flutter_timezone`), not from guessing:
  /// `DateTime.now().timeZoneName` is a *localised abbreviation* that often has
  /// no tz-database entry at all, and matching on UTC offset alone can land on
  /// a zone with different DST rules - which silently shifts every alarm by an
  /// hour for half the year.
  Future<void> _ensureTimezone({bool force = false}) async {
    if (_tzReady && !force) return;
    tzdata.initializeTimeZones();

    tz.Location? resolved;
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      resolved = tz.timeZoneDatabase.locations[name.identifier];
      _tzName = name.identifier;
    } catch (e) {
      debugPrint('ArcCore: platform timezone unavailable ($e)');
    }

    // Fallback: match on offset, preferring a zone whose abbreviation also
    // matches, so at worst the wall-clock time is still right today.
    resolved ??= _resolveByOffset(
      DateTime.now().timeZoneName,
      DateTime.now().timeZoneOffset,
    );

    tz.setLocalLocation(resolved);
    if (_tzName.isEmpty) _tzName = resolved.name;
    _tzReady = true;
  }

  tz.Location _resolveByOffset(String abbreviation, Duration offset) {
    for (final loc in tz.timeZoneDatabase.locations.values) {
      if (loc.currentTimeZone.abbreviation == abbreviation &&
          loc.currentTimeZone.offset == offset) {
        return loc;
      }
    }
    for (final loc in tz.timeZoneDatabase.locations.values) {
      if (loc.currentTimeZone.offset == offset) return loc;
    }
    return tz.UTC;
  }

  void _handleResponse(NotificationResponse response) {
    final action = response.actionId ?? response.payload;
    if (action == null) return;
    onAction?.call(action, response.input);
  }

  // ------------------------------------------------------------ permissions

  Future<bool> requestPermission() async {
    await init();
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  /// Whether the OS will actually display anything we post.
  ///
  /// Scheduling succeeds even when notifications are blocked - the alarm fires
  /// and nothing appears - so this is checked separately and surfaced.
  Future<bool> hasPermission() async {
    await init();
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      try {
        final enabled = await android?.areNotificationsEnabled();
        // A null answer means the channel could not tell us, not that the user
        // said no - defaulting that to `false` produces a false alarm on the
        // dashboard, so fall through to the runtime permission instead.
        if (enabled != null) return enabled;
      } catch (e) {
        debugPrint('ArcCore: areNotificationsEnabled failed ($e)');
      }
      return Permission.notification.isGranted;
    }
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      try {
        final settings = await ios?.checkPermissions();
        if (settings != null) return settings.isEnabled;
      } catch (e) {
        debugPrint('ArcCore: checkPermissions failed ($e)');
      }
      return Permission.notification.isGranted;
    }
    return true;
  }

  /// permissions_matrix.android: API 33+ sends the user to the special-access
  /// settings screen; we degrade to inexact alarms if it is denied.
  Future<bool> requestExactAlarms() async {
    if (!Platform.isAndroid) return true;
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestExactAlarmsPermission() ?? false;
  }

  Future<bool> canScheduleExact() async {
    if (!Platform.isAndroid) return true;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.canScheduleExactNotifications() ?? false;
  }

  // -------------------------------------------------------------- scheduling

  /// Cancels and re-lays the full daily schedule.
  ///
  /// Called on: settings change, app foreground, and boot
  /// (edge_case_handling.device_reboot - "reschedule on every app foreground as
  /// a belt-and-braces fallback").
  Future<ScheduleReport> rescheduleAll({
    required AppSettings settings,
    required AppLocalizations l10n,
    required List<Habit> habits,
    required DateTime arcStart,
    String locale = 'en',
  }) async {
    await init();
    // The zone is re-resolved on every reschedule, not just first init, so a
    // flight across timezones fixes itself on the next foreground.
    await _ensureTimezone(force: true);
    await _cancelManaged();

    final permitted = await hasPermission();

    if (!settings.notificationsEnabled) {
      return ScheduleReport(
        notificationsPermitted: permitted,
        exactAlarms: await canScheduleExact(),
        scheduled: 0,
        failed: 0,
        timezone: _tzName,
        skipped: true,
      );
    }

    final exact = await canScheduleExact();
    final mode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final dayIndex = ArcDate.daysBetween(arcStart, DateTime.now());
    var scheduled = 0;
    var failed = 0;

    var i = 0;
    for (final channel in NotificationCopy.channels) {
      final hhmm = settings.reminderTimes[channel];
      if (hhmm == null) continue;
      final parsed = ArcDate.parseTimeOfDay(hhmm);
      if (parsed == null) continue;

      final ok = await _scheduleDaily(
        id: _baseId + i,
        hour: parsed.$1,
        minute: parsed.$2,
        title: _titleFor(channel, l10n),
        body: NotificationCopy.lineFor(channel, dayIndex, locale: locale),
        channelId: channel,
        channelName: _channelNameFor(channel, l10n),
        actions: _androidActionsFor(channel, l10n),
        darwinCategory: channel,
        mode: mode,
      );
      ok ? scheduled++ : failed++;
      i++;
    }

    // Per-habit reminders (habit_library.custom_habit_fields.reminder_time).
    for (final habit in habits.where((h) => !h.isArchived)) {
      final hhmm = habit.reminderTime;
      if (hhmm == null) continue;
      final parsed = ArcDate.parseTimeOfDay(hhmm);
      if (parsed == null) continue;
      final ok = await _scheduleDaily(
        id: _habitBaseId + habit.id,
        hour: parsed.$1,
        minute: parsed.$2,
        title: l10n.appTitle,
        body: habit.customTitle ?? _habitLabel(habit, l10n),
        channelId: 'habit_reminders',
        channelName: l10n.settingsReminderTimes,
        actions: const [],
        darwinCategory: null,
        mode: mode,
      );
      ok ? scheduled++ : failed++;
    }

    debugPrint(
      'ArcCore: scheduled $scheduled reminder(s), $failed failed, '
      'tz=$_tzName, exact=$exact, permitted=$permitted',
    );

    return ScheduleReport(
      notificationsPermitted: permitted,
      exactAlarms: exact,
      scheduled: scheduled,
      failed: failed,
      timezone: _tzName,
      skipped: false,
    );
  }

  /// Returns false when the platform refused the schedule, so the caller can
  /// report it instead of the app quietly having no alarms.
  Future<bool> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required List<AndroidNotificationAction> actions,
    required String? darwinCategory,
    required AndroidScheduleMode mode,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        '$channelId$_channelSuffix',
        channelName,
        importance: Importance.max,
        priority: Priority.high,
        actions: actions.isEmpty ? null : actions,
        category: AndroidNotificationCategory.reminder,
        icon: '@drawable/ic_notification',
        sound: _androidSound,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: darwinCategory,
        sound: _iosSound,
      ),
    );

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: details,
        androidScheduleMode: mode,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: channelId,
      );
      return true;
    } on PlatformException catch (e) {
      // Exact-alarm permission can be revoked between the check and the call.
      // Retry inexact rather than leaving the user with no reminder at all.
      if (mode == AndroidScheduleMode.exactAllowWhileIdle) {
        debugPrint('ArcCore: exact schedule refused ($e), retrying inexact');
        return _scheduleDaily(
          id: id,
          hour: hour,
          minute: minute,
          title: title,
          body: body,
          channelId: channelId,
          channelName: channelName,
          actions: actions,
          darwinCategory: darwinCategory,
          mode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
      debugPrint('ArcCore: schedule failed for $channelId ($e)');
      return false;
    } catch (e) {
      debugPrint('ArcCore: schedule failed for $channelId ($e)');
      return false;
    }
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    return next;
  }

  Future<void> snooze(Duration by) async {
    await init();
    final when = tz.TZDateTime.now(tz.local).add(by);
    await _plugin.zonedSchedule(
      id: _baseId + 99,
      title: 'ArcCore',
      body: '',
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'morning_call$_channelSuffix',
          'Morning',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound: _androidSound,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(sound: _iosSound),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'morning_call',
    );
  }

  /// Fires a real reminder [delay] from now, through the same scheduling path
  /// the daily alarms use.
  ///
  /// This is the only honest way to answer "are my reminders working?" - it
  /// exercises the permission, the exact-alarm mode, the timezone and the OEM
  /// battery manager all at once, which is precisely what
  /// edge_case_handling.aggressive_oem_battery_management is about.
  Future<bool> sendTestReminder({
    required String title,
    required String body,
    Duration delay = const Duration(seconds: 10),
  }) async {
    await init();
    await _ensureTimezone(force: true);

    final mode = await canScheduleExact()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      await _plugin.zonedSchedule(
        id: _testId,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_test$_channelSuffix',
            title,
            importance: Importance.max,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            icon: '@drawable/ic_notification',
            sound: _androidSound,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(sound: _iosSound),
        ),
        androidScheduleMode: mode,
        payload: 'test',
      );
      return true;
    } catch (e) {
      debugPrint('ArcCore: test reminder failed ($e)');
      return false;
    }
  }

  /// What is actually armed right now, for the Settings readout.
  Future<ReminderStatus> status() async {
    await init();
    final pendingRequests = await pending();
    final daily = pendingRequests
        .where((r) => r.id >= _baseId && r.id < _baseId + 100)
        .length;
    return ReminderStatus(
      permitted: await hasPermission(),
      exactAlarms: await canScheduleExact(),
      pending: pendingRequests.length,
      dailyReminders: daily,
      timezone: _tzName,
    );
  }

  /// Clears the reminders this service owns, leaving an in-flight test alone.
  ///
  /// A blanket `cancelAll()` here would wipe a test reminder the user just
  /// queued - the app resumes, reschedules, and the notification they were
  /// waiting on never arrives, which looks exactly like the bug they were
  /// trying to diagnose.
  Future<void> _cancelManaged() async {
    final scheduled = await _plugin.pendingNotificationRequests();
    for (final request in scheduled) {
      if (request.id == _testId) continue;
      await _plugin.cancel(id: request.id);
    }
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> pending() async {
    await init();
    return _plugin.pendingNotificationRequests();
  }

  /// edge_case_handling.aggressive_oem_battery_management: if nothing has fired
  /// in 48 hours the app surfaces a passive banner. This is the check behind it.
  Future<bool> looksSilenced(DateTime? lastReschedule) async {
    if (lastReschedule == null) return false;
    if (DateTime.now().difference(lastReschedule) < const Duration(hours: 48)) {
      return false;
    }
    final scheduled = await pending();
    return scheduled.isEmpty;
  }

  // ------------------------------------------------------------------ copy

  static String _titleFor(String channel, AppLocalizations l) =>
      switch (channel) {
        'morning_call' => l.morningAlertTitle,
        'nutrition_reminders' => l.middayAlertTitle,
        'activity_reminders' => l.eveningWorkoutTitle,
        'evening_review' => l.nightReviewTitle,
        _ => l.appTitle,
      };

  static String _channelNameFor(String channel, AppLocalizations l) =>
      switch (channel) {
        'morning_call' => l.morningAlertTitle,
        'nutrition_reminders' => l.middayAlertTitle,
        'activity_reminders' => l.eveningWorkoutTitle,
        'evening_review' => l.nightReviewTitle,
        _ => l.appTitle,
      };

  static List<AndroidNotificationAction> _androidActionsFor(
    String channel,
    AppLocalizations l,
  ) => switch (channel) {
    'morning_call' => [
      AndroidNotificationAction(
        NotifAction.wakeDone,
        l.notifActionWakeDone,
        showsUserInterface: false,
      ),
      AndroidNotificationAction(NotifAction.snooze, l.notifActionSnooze),
    ],
    'activity_reminders' => [
      AndroidNotificationAction(
        NotifAction.logWorkout,
        l.notifActionLogWorkout,
      ),
      AndroidNotificationAction(NotifAction.restDay, l.notifActionRestDay),
    ],
    'evening_review' => [
      AndroidNotificationAction(
        NotifAction.openDebrief,
        l.notifActionOpenDebrief,
        showsUserInterface: true,
      ),
      // Android inline direct-reply for the gratitude prompt.
      AndroidNotificationAction(
        NotifAction.quickGratitude,
        l.notifActionQuickGratitude,
        inputs: [
          AndroidNotificationActionInput(label: l.journalGratitudeLabel),
        ],
      ),
    ],
    _ => const [],
  };

  static List<DarwinNotificationCategory> _darwinCategories() => [
    DarwinNotificationCategory(
      'morning_call',
      actions: [
        DarwinNotificationAction.plain(NotifAction.wakeDone, 'Done'),
        DarwinNotificationAction.plain(NotifAction.snooze, 'Snooze'),
      ],
    ),
    DarwinNotificationCategory(
      'activity_reminders',
      actions: [
        DarwinNotificationAction.plain(NotifAction.logWorkout, 'Log'),
        DarwinNotificationAction.plain(NotifAction.restDay, 'Rest'),
      ],
    ),
    DarwinNotificationCategory(
      'evening_review',
      actions: [
        DarwinNotificationAction.plain(NotifAction.openDebrief, 'Open'),
        DarwinNotificationAction.text(
          NotifAction.quickGratitude,
          'Gratitude',
          buttonTitle: 'Save',
          placeholder: '',
        ),
      ],
    ),
  ];

  static String _habitLabel(Habit habit, AppLocalizations l) =>
      habit.customTitle ?? habit.titleKey ?? l.appTitle;
}
