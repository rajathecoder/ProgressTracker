// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Happy Days';

  @override
  String get appName => 'Happy Days';

  @override
  String get morningAlertTitle => 'Rise & Conquer';

  @override
  String get morningAlertBody => 'The arc doesn\'t wait. Get up.';

  @override
  String get middayAlertTitle => 'Fuel Check';

  @override
  String get middayAlertBody => 'Water only. Clean plate. Stay sharp.';

  @override
  String get eveningWorkoutTitle => 'Move Your Body';

  @override
  String get eveningWorkoutBody => 'Gym or a 30 minute walk. Pick one.';

  @override
  String get nightReviewTitle => 'Evening Debrief';

  @override
  String get nightReviewBody =>
      'Log the day and note one thing you\'re grateful for.';

  @override
  String get habitEarlyWake => 'Wake up early';

  @override
  String get habitWaterOnly => 'Water only';

  @override
  String get habitNoJunkFood => 'No junk food';

  @override
  String get habitSleepTarget => '7-8 hours of sleep';

  @override
  String get habitGymWorkout => 'Gym 4-5 days a week';

  @override
  String get habitStepsGoal => '10k steps';

  @override
  String get habitNoPhoneMeals => 'No phone during meals';

  @override
  String get habitWalking => '30 minutes walk';

  @override
  String get habitGratitude => 'Be grateful to God daily';

  @override
  String get habitNoteProgress => 'Note your progress';

  @override
  String get habitRead => 'Read 20 pages';

  @override
  String get habitMeditate => 'Meditate 10 minutes';

  @override
  String get habitColdShower => 'Cold shower';

  @override
  String get habitStretch => 'Stretch 10 minutes';

  @override
  String get habitNoSocialMedia => 'No social media';

  @override
  String get habitDeepWork => '90 minutes of deep work';

  @override
  String get habitJournal => 'Write in your journal';

  @override
  String get habitLearnSkill => 'Practise your craft';

  @override
  String get habitPlanTomorrow => 'Plan tomorrow tonight';

  @override
  String get habitNoScreensBed => 'No screens before bed';

  @override
  String get habitProtein => 'Hit your protein target';

  @override
  String get habitVitamins => 'Take your vitamins';

  @override
  String get habitFloss => 'Floss';

  @override
  String get habitSunlight => '15 minutes of sunlight';

  @override
  String get habitCallFamily => 'Call someone you love';

  @override
  String get habitActOfKindness => 'One act of kindness';

  @override
  String get habitTidySpace => 'Tidy your space';

  @override
  String get habitNoAlcohol => 'No alcohol';

  @override
  String get habitBudgetCheck => 'Check your budget';

  @override
  String get habitPray => 'Prayer or reflection';

  @override
  String get habitLanguage => 'Practise a language';

  @override
  String get habitSideProject => 'Ship something small';

  @override
  String get statDiscipline => 'Discipline';

  @override
  String get statVitality => 'Vitality';

  @override
  String get statStrength => 'Strength';

  @override
  String get statFocus => 'Focus';

  @override
  String get statSpirit => 'Spirit';

  @override
  String get categoryBody => 'Body';

  @override
  String get categoryMind => 'Mind';

  @override
  String get categorySpirit => 'Spirit';

  @override
  String get categoryCraft => 'Craft';

  @override
  String get categorySocial => 'Social';

  @override
  String get welcomeGreetingMorning => 'Good morning';

  @override
  String get welcomeGreetingAfternoon => 'Good afternoon';

  @override
  String get welcomeGreetingEvening => 'Good evening';

  @override
  String get welcomeTagline => 'Small days, stacked well.';

  @override
  String get welcomeGetStartedHint => 'Let\'s set up your first arc.';

  @override
  String get onboardingWelcome => 'Welcome to Happy Days';

  @override
  String get onboardingSubtitle =>
      'Build the days you want to remember. Everything stays on your device.';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterNickname => 'What should we call you?';

  @override
  String get onboardingIdentityTitle => 'Who\'s running this arc?';

  @override
  String get onboardingArcTitle => 'How long is your arc?';

  @override
  String get onboardingHabitsTitle => 'Pick your starting habits';

  @override
  String get onboardingHabitsSubtitle =>
      'Pick as many as you like. You can add, edit or archive any of them later.';

  @override
  String get onboardingThemeTitle => 'Choose your surface';

  @override
  String get onboardingPermissionTitle => 'Stay on schedule';

  @override
  String onboardingSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get arcLength90 => '90 days';

  @override
  String get arcLength122 => '122 days';

  @override
  String get arcLengthCustom => 'Custom';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String dashboardGreeting(String nickname) {
    return 'Let\'s conquer today, $nickname';
  }

  @override
  String get dashboardTitle => 'Protocol';

  @override
  String get todaysProtocol => 'Today\'s protocol';

  @override
  String get characterSheet => 'Character sheet';

  @override
  String get settingsThemeLight => 'Light Theme';

  @override
  String get settingsThemeDark => 'Dark Theme';

  @override
  String get settingsThemeSystem => 'Follow System';

  @override
  String settingsProfileName(String fullName) {
    return 'Name: $fullName';
  }

  @override
  String arcDayCounter(int current, int total) {
    return 'Day $current of $total';
  }

  @override
  String arcNotStarted(int days) {
    return 'Your arc starts in $days days';
  }

  @override
  String streakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String shieldCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shields',
      one: '1 shield',
      zero: 'No shields',
    );
    return '$_temp0';
  }

  @override
  String shieldConsumed(int remaining) {
    return 'A shield absorbed yesterday\'s miss. $remaining left.';
  }

  @override
  String multiplierActive(String value) {
    return '${value}x XP multiplier active';
  }

  @override
  String levelUpTitle(int level) {
    return 'Level $level';
  }

  @override
  String rankUnlocked(String rankName) {
    return 'Rank unlocked: $rankName';
  }

  @override
  String get achievementUnlocked => 'Achievement unlocked';

  @override
  String bossWeekTitle(String name) {
    return 'Boss Week: $name';
  }

  @override
  String bossWeekProgress(int completed, int required) {
    return '$completed of $required complete';
  }

  @override
  String get notScheduledToday => 'Not scheduled today';

  @override
  String backfillTitle(String date) {
    return 'Log for $date';
  }

  @override
  String get backfillLate => 'Logged late';

  @override
  String get backfillWindowClosed => 'This day is outside your logging window';

  @override
  String metricEntryLabel(String value, String target, String unit) {
    return '$value of $target $unit';
  }

  @override
  String partialCredit(int percent) {
    return 'Partial credit: $percent%';
  }

  @override
  String xpEarned(int xp) {
    return '+$xp XP';
  }

  @override
  String xpToNextLevel(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String todayComplete(int completed, int total) {
    return '$completed of $total done';
  }

  @override
  String get perfectDay => 'Flawless day';

  @override
  String get matrixTitle => 'Matrix';

  @override
  String get matrixZoomWeek => 'Week';

  @override
  String get matrixZoomMonth => 'Month';

  @override
  String get matrixZoomArc => 'Arc';

  @override
  String get jumpToToday => 'Today';

  @override
  String get matrixLinearView => 'List view';

  @override
  String get matrixGridView => 'Grid view';

  @override
  String get filterAll => 'All';

  @override
  String get cellStateComplete => 'completed';

  @override
  String get cellStatePartial => 'partially complete';

  @override
  String get cellStateIncomplete => 'not completed';

  @override
  String get cellStateMissed => 'missed';

  @override
  String get cellStateNotScheduled => 'not scheduled';

  @override
  String cellSemanticLabel(String habit, String date, String state) {
    return '$habit, $date, $state';
  }

  @override
  String habitCompletionRate(int percent) {
    return '$percent%';
  }

  @override
  String get analyticsTitle => 'Insights';

  @override
  String analyticsBestDay(String weekday) {
    return 'Your strongest day is $weekday';
  }

  @override
  String analyticsWeakestDay(String weekday) {
    return 'You miss most on $weekday';
  }

  @override
  String analyticsCorrelation(String habitA, String multiplier) {
    return 'On days you complete $habitA, you complete ${multiplier}x more habits overall';
  }

  @override
  String analyticsProjection(int percent) {
    return 'On this pace you\'ll finish the arc at $percent%';
  }

  @override
  String get analyticsNotEnoughData => 'Come back after 7 days of logging';

  @override
  String get analyticsHeatmap => 'Contribution heatmap';

  @override
  String get analyticsWeekly => 'Weekly consistency';

  @override
  String get analyticsStatProgression => 'Stat progression';

  @override
  String get analyticsWeekday => 'Weekday breakdown';

  @override
  String get analyticsCorrelationTitle => 'Habit correlations';

  @override
  String get analyticsTimeOfDay => 'When you log';

  @override
  String get analyticsProjectionTitle => 'Arc projection';

  @override
  String get analyticsNoCorrelations =>
      'No strong correlations yet. Keep logging.';

  @override
  String get habitLibraryTitle => 'Habit Library';

  @override
  String get createCustomHabit => 'Create your own';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get habitFrequencyDaily => 'Every day';

  @override
  String habitFrequencyWeekly(int count) {
    return '$count times per week';
  }

  @override
  String get habitFrequencyCustom => 'Selected days';

  @override
  String habitFrequencyInterval(int count) {
    return 'Every $count days';
  }

  @override
  String get archiveHabit => 'Archive habit';

  @override
  String get archiveHabitWarning =>
      'Past records are kept. It just won\'t appear on future days.';

  @override
  String get unarchiveHabit => 'Restore habit';

  @override
  String get activeHabits => 'Active';

  @override
  String get archivedHabits => 'Archived';

  @override
  String get habitTitleLabel => 'Habit name';

  @override
  String get habitIconLabel => 'Icon';

  @override
  String get habitCategoryLabel => 'Category';

  @override
  String get habitStatLabel => 'Stat';

  @override
  String get habitXpLabel => 'XP reward';

  @override
  String get habitMetricLabel => 'Measured in';

  @override
  String get habitTargetLabel => 'Daily target';

  @override
  String get habitReminderLabel => 'Reminder';

  @override
  String get habitFrequencyLabel => 'Frequency';

  @override
  String get noReminder => 'No reminder';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get emptyHabitsTitle => 'No habits yet';

  @override
  String get emptyHabitsBody => 'Add a few from the library to start your arc.';

  @override
  String get unitBoolean => 'done';

  @override
  String get unitSteps => 'steps';

  @override
  String get unitLiters => 'litres';

  @override
  String get unitMinutes => 'minutes';

  @override
  String get unitHours => 'hours';

  @override
  String get unitCount => 'times';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalSearchHint => 'Search your entries';

  @override
  String get journalMoodPrompt => 'How was today?';

  @override
  String get journalOnThisDay => 'On this day';

  @override
  String get journalGratitudeLabel => 'One thing you\'re grateful for';

  @override
  String get journalNotesLabel => 'How did today go?';

  @override
  String get journalTagsLabel => 'Tags';

  @override
  String get journalAddPhoto => 'Add photo';

  @override
  String get journalSaved => 'Saved';

  @override
  String get emptyJournalTitle => 'Nothing written yet';

  @override
  String get emptyJournalBody => 'Your debriefs will collect here.';

  @override
  String get mood1 => 'Rough';

  @override
  String get mood2 => 'Low';

  @override
  String get mood3 => 'Steady';

  @override
  String get mood4 => 'Good';

  @override
  String get mood5 => 'Excellent';

  @override
  String get appLockTitle => 'Unlock your journal';

  @override
  String get appLockPinFallback => 'Use PIN instead';

  @override
  String get appLockSetPin => 'Set a PIN';

  @override
  String get appLockEnterPin => 'Enter your PIN';

  @override
  String get appLockWrongPin => 'Incorrect PIN';

  @override
  String get appLockUnlock => 'Unlock';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDayRollover => 'New day starts at';

  @override
  String settingsRetroWindow(int days) {
    return 'Allow logging up to $days days back';
  }

  @override
  String get settingsHardcoreMode => 'Hardcore Mode';

  @override
  String get settingsHardcoreModeDesc =>
      'No shields, no backfill. What you log that day is what counts.';

  @override
  String get settingsPartialCredit => 'Partial credit';

  @override
  String get settingsPartialCreditDesc =>
      'Award proportional XP when you fall short of a numeric target.';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsHighContrast => 'High contrast';

  @override
  String get settingsSound => 'Sound effects';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsBatteryWarning =>
      'Your device may stop reminders. Tap to allow background activity.';

  @override
  String get settingsSectionProfile => 'Profile';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionReminders => 'Reminders';

  @override
  String get settingsSectionArc => 'Arc rules';

  @override
  String get settingsSectionAccessibility => 'Accessibility';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockScopeJournal => 'Journal only';

  @override
  String get settingsAppLockScopeApp => 'Whole app';

  @override
  String get settingsExactAlarms => 'Exact alarms';

  @override
  String get settingsExactAlarmsDesc =>
      'Required for on-the-minute wake-up reminders.';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsReminderTimes => 'Reminder times';

  @override
  String get remindersStatusTitle => 'Reminder status';

  @override
  String remindersHealthy(int count) {
    return '$count reminders armed';
  }

  @override
  String get remindersBlocked => 'Notifications are blocked for Happy Days';

  @override
  String get remindersNoneArmed => 'No reminders are armed';

  @override
  String get remindersExactOn => 'Exact alarms on';

  @override
  String get remindersExactOff =>
      'Inexact alarms - times may drift by a few minutes';

  @override
  String remindersTimezone(String zone) {
    return 'Anchored to $zone';
  }

  @override
  String get sendTestReminder => 'Send a test reminder';

  @override
  String get testReminderQueued =>
      'Test reminder in 10 seconds - close the app to check';

  @override
  String get testReminderFailed => 'Could not schedule the test reminder';

  @override
  String get testReminderTitle => 'Test reminder';

  @override
  String get testReminderBody =>
      'If you can see this, your reminders are working.';

  @override
  String get remindersFixPermission => 'Turn on notifications';

  @override
  String get backgroundRefresh => 'Background refresh';

  @override
  String get backgroundRefreshDesc =>
      'Keeps the widget and daily backup current when the app is closed.';

  @override
  String get backgroundRunNow => 'Run now';

  @override
  String get backgroundRanNow => 'Refreshed';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get profileSaved => 'Profile updated';

  @override
  String get languageSearchHint => 'Search languages';

  @override
  String get languageIndian => 'Indian languages';

  @override
  String get languageWorld => 'More languages';

  @override
  String get languageTranslated => 'Translated';

  @override
  String get languageFallbackNote =>
      'Languages without a translation show English text.';

  @override
  String get focusTitle => 'Focus';

  @override
  String get menuTitle => 'Menu';

  @override
  String get focusSubtitle => 'Concentration timer';

  @override
  String get focusSetDuration => 'Session length';

  @override
  String get focusStart => 'Start';

  @override
  String get focusPause => 'Pause';

  @override
  String get focusResume => 'Resume';

  @override
  String get focusReset => 'Reset';

  @override
  String get focusDone => 'Session complete';

  @override
  String focusDoneBody(int minutes) {
    return '$minutes minutes of focus logged.';
  }

  @override
  String get focusRunning => 'Focus in progress';

  @override
  String focusTodayTotal(int minutes) {
    return '$minutes min today';
  }

  @override
  String focusSessions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
      zero: 'No sessions yet',
    );
    return '$_temp0';
  }

  @override
  String get focusPickPreset => 'Quick pick';

  @override
  String focusMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get focusKeepScreenOn => 'Keep the screen awake';

  @override
  String get focusAbandon => 'Discard session?';

  @override
  String get focusAbandonBody =>
      'Your progress in this session will not be saved.';

  @override
  String get widgetPreviewTitle => 'Home screen widgets';

  @override
  String get widgetPreviewSubtitle =>
      'Add these from your home screen\'s widget picker.';

  @override
  String get widgetRingTitle => 'Habit ring';

  @override
  String get widgetTimerTitle => 'Focus timer';

  @override
  String get widgetStreakTitle => 'Streaks';

  @override
  String get widgetTodayTitle => 'Today';

  @override
  String get widgetWaterTitle => 'Progress';

  @override
  String insightsPartial(int logged, int needed) {
    return '$logged of $needed days logged';
  }

  @override
  String get insightsEarlyTitle => 'Your insights are building';

  @override
  String get journalToday => 'Today\'s entry';

  @override
  String get journalPast => 'Earlier entries';

  @override
  String get journalEdit => 'Edit';

  @override
  String get journalDelete => 'Clear entry';

  @override
  String get journalUnsaved => 'Unsaved changes';

  @override
  String get backupTitle => 'Backup & Restore';

  @override
  String backupLast(String timestamp) {
    return 'Last backup: $timestamp';
  }

  @override
  String get backupNever => 'No backup yet';

  @override
  String get backupEncrypt => 'Protect with a passphrase';

  @override
  String get backupExportJson => 'Export JSON';

  @override
  String get backupExportCsv => 'Export CSV';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get restoreConfirm => 'Replace all current data with this backup?';

  @override
  String get restoreVersionMismatch =>
      'This backup is from a newer version of the app';

  @override
  String get restoreChecksumFailed => 'This file is corrupted or was modified';

  @override
  String get restoreMerge => 'Merge';

  @override
  String get restoreReplace => 'Replace';

  @override
  String restoreDryRun(int days, int habits, int journals) {
    return '$days days, $habits habits, $journals journal entries';
  }

  @override
  String get restoreSuccess => 'Restored';

  @override
  String get passphrasePrompt => 'Enter passphrase';

  @override
  String get trophyHallTitle => 'Trophy Hall';

  @override
  String get trophyLocked => 'Locked';

  @override
  String trophyUnlockedOn(String date) {
    return 'Unlocked $date';
  }

  @override
  String get emptyTrophyTitle => 'No trophies yet';

  @override
  String get emptyTrophyBody => 'Complete your first habit to open the hall.';

  @override
  String achievementProgress(int current, int target) {
    return '$current / $target';
  }

  @override
  String get arcCompleteTitle => 'Arc Complete';

  @override
  String arcCompleteSubtitle(int days) {
    return '$days days. Here\'s what you built.';
  }

  @override
  String get startNewArc => 'Start a new arc';

  @override
  String get carryHabits => 'Carry over my habits';

  @override
  String get carryStats => 'Keep my stats';

  @override
  String get shareCard => 'Share';

  @override
  String get recapTotalXp => 'Total XP';

  @override
  String get recapBestStreak => 'Best streak';

  @override
  String get recapCompletionRate => 'Completion';

  @override
  String get recapPerfectDays => 'Perfect days';

  @override
  String get recapDay1 => 'Day 1';

  @override
  String get recapFinal => 'Final';

  @override
  String get arcHistoryTitle => 'Past arcs';

  @override
  String get permissionNotificationRationale =>
      'Happy Days needs notification access to remind you. Nothing leaves your device.';

  @override
  String get permissionExactAlarmRationale =>
      'Exact alarms keep your 5:30 wake-up on time.';

  @override
  String get permissionActivityRationale =>
      'Step tracking reads your device\'s built-in step counter. No location is used.';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionNotNow => 'Not now';

  @override
  String get permissionOpenSettings => 'Open settings';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get undo => 'Undo';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';

  @override
  String get achievementNamePrefix => 'Achievement';

  @override
  String get achFirstBlood => 'First Blood';

  @override
  String get achFirstBloodDesc => 'Complete your first habit';

  @override
  String get achPerfectDay => 'Flawless';

  @override
  String get achPerfectDayDesc => 'Complete every scheduled habit in one day';

  @override
  String get achStreak3 => 'Ignition';

  @override
  String get achStreak3Desc => '3-day streak';

  @override
  String get achStreak7 => 'One Week In';

  @override
  String get achStreak7Desc => '7-day streak';

  @override
  String get achStreak14 => 'Fortnight';

  @override
  String get achStreak14Desc => '14-day streak';

  @override
  String get achStreak30 => 'Habit Formed';

  @override
  String get achStreak30Desc => '30-day streak';

  @override
  String get achStreak60 => 'Unshakeable';

  @override
  String get achStreak60Desc => '60-day streak';

  @override
  String get achStreak100 => 'Century';

  @override
  String get achStreak100Desc => '100-day streak';

  @override
  String get achPerfectArc => 'The Full Arc';

  @override
  String get achPerfectArcDesc =>
      'Complete the whole arc with no unshielded miss';

  @override
  String get achTenPerfectDays => 'Double Digits';

  @override
  String get achTenPerfectDaysDesc => '10 total perfect days';

  @override
  String get achEarlyRiser30 => 'Dawn Patrol';

  @override
  String get achEarlyRiser30Desc => '30 early wake-ups logged';

  @override
  String get achGym50 => 'Iron Contract';

  @override
  String get achGym50Desc => '50 gym sessions logged';

  @override
  String get achSteps500k => 'Half a Million';

  @override
  String get achSteps500kDesc => '500,000 cumulative steps';

  @override
  String get achGratitude100 => 'Grateful Heart';

  @override
  String get achGratitude100Desc => '100 gratitude entries';

  @override
  String get achClean30 => 'Clean Engine';

  @override
  String get achClean30Desc => '30 no-junk-food days';

  @override
  String get achHydrated60 => 'Water Only';

  @override
  String get achHydrated60Desc => '60 water-only days';

  @override
  String get achLevel10 => 'Frost Initiate';

  @override
  String get achLevel10Desc => 'Reach Level 10';

  @override
  String get achLevel25 => 'Iron Ascetic';

  @override
  String get achLevel25Desc => 'Reach Level 25';

  @override
  String get achLevel50 => 'Winter Sovereign';

  @override
  String get achLevel50Desc => 'Reach Level 50';

  @override
  String get achBalanced => 'Well Rounded';

  @override
  String get achBalancedDesc => 'All five stat scores above 50 at once';

  @override
  String get achPhoenix => 'Phoenix Protocol';

  @override
  String get achPhoenixDesc =>
      'Return after a missed day and complete 7 straight';

  @override
  String get achNoShields30 => 'Bare Handed';

  @override
  String get achNoShields30Desc =>
      '30 consecutive days with zero shields consumed';

  @override
  String get achFirstBackup => 'Insurance';

  @override
  String get achFirstBackupDesc => 'Create your first backup';

  @override
  String get achArchitect => 'Architect';

  @override
  String get achArchitectDesc => 'Create your first custom habit';

  @override
  String get rankEmberSpark => 'Ember Spark';

  @override
  String get rankFrostInitiate => 'Frost Initiate';

  @override
  String get rankIronAscetic => 'Iron Ascetic';

  @override
  String get rankStormWarden => 'Storm Warden';

  @override
  String get rankArcChampion => 'Arc Champion';

  @override
  String get rankWinterSovereign => 'Winter Sovereign';

  @override
  String get bossWeekBanner => 'Boss week active';

  @override
  String bossWeekReward(int xp) {
    return '+$xp XP on completion';
  }

  @override
  String get notifActionWakeDone => 'Mark wake-up done';

  @override
  String get notifActionSnooze => 'Snooze 15m';

  @override
  String get notifActionLogWorkout => 'Log workout';

  @override
  String get notifActionRestDay => 'Rest day';

  @override
  String get notifActionOpenDebrief => 'Open debrief';

  @override
  String get notifActionQuickGratitude => 'Quick gratitude';

  @override
  String radarSemanticSummary(String summary) {
    return 'Stat radar. $summary';
  }

  @override
  String statScoreLabel(String stat, int score) {
    return '$stat: $score out of 100';
  }

  @override
  String get tabularFallback => 'View as table';
}
