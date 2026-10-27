/// Values the whole app agrees on. Anything tunable by the user lives in
/// AppSettings instead.
abstract final class AppConstants {
  static const String appVersion = '1.3.0';

  /// data_integrity.schema_migration - bumped whenever a persisted shape
  /// changes. Stored in shared_preferences under [schemaVersionKey].
  static const int schemaVersion = 4;
  static const String schemaVersionKey = 'arccore.schema_version';

  /// The reference arc from the spec (data_models.UserProfile).
  static const int defaultArcLengthDays = 122;
  static const List<int> arcLengthPresets = [90, 122];

  /// gamification_engine + streak_resilience
  static const int maxShields = 3;
  static const int shieldEarnStreakDays = 7;
  static const double partialCreditThreshold = 0.5;
  static const int minHabitXp = 5;
  static const int maxHabitXp = 30;

  /// analytics_lab.guard
  static const int analyticsMinDays = 7;
  static const int correlationMinDays = 14;
  static const double correlationMinRatio = 1.3;

  /// AppSettings defaults
  static const int defaultDayRolloverHour = 4;
  static const int defaultRetroLoggingDays = 2;
  static const int maxRetroLoggingDays = 7;

  /// performance_budget.matrix_grid
  static const double matrixCellSize = 44;
  static const double matrixHitTarget = 48;
  static const double matrixLabelWidth = 148;
  static const double matrixRowHeight = 56;

  /// offline_strategy.auto_backup
  static const int backupRetentionCount = 7;
  static const String backupDirName = 'backups';
  static const String journalPhotoDirName = 'journal_photos';

  /// home_screen_widgets - shared container ids
  static const String androidWidgetName = 'ArcCoreWidgetProvider';
  static const String iOSWidgetName = 'ArcCoreWidget';
  static const String appGroupId = 'group.com.arccore.arccore';

  /// Every Android provider that has to be told to redraw.
  ///
  /// `HomeWidget.updateWidget` refreshes exactly one provider, so updating only
  /// the first left the other four showing whatever Android last drew on its
  /// own 30-minute timer - which is why the Today list appeared permanently
  /// empty.
  static const List<String> androidWidgetProviders = [
    'ArcCoreWidgetProvider',
    'ArcCoreFocusWidgetProvider',
    'ArcCoreStreaksWidgetProvider',
    'ArcCoreTodayWidgetProvider',
    'ArcCoreMetricWidgetProvider',
  ];

  /// Deep-link host -> shell tab index, with an optional index into the Menu
  /// tab's tile list (0 = Focus, 1 = Journal) for hosts that should push
  /// straight through to one of its tiles. `sub` is null for every other
  /// host, including Protocol/Insights, which is one continuous screen.
  static const Map<String, ({int tab, int? sub})> widgetDeepLinkTabs = {
    'dashboard': (tab: 0, sub: null),
    'insights': (tab: 0, sub: null),
    'matrix': (tab: 1, sub: null),
    'focus': (tab: 2, sub: 0),
    'journal': (tab: 2, sub: 1),
    'habits': (tab: 3, sub: null),
  };

  /// Concentration timer
  static const List<int> focusPresetMinutes = [15, 25, 45, 60];
  static const int defaultFocusMinutes = 25;
  static const int minFocusMinutes = 5;
  static const int maxFocusMinutes = 120;

  /// How many habit rows the interactive Today widget shows.
  static const int widgetTodayRows = 4;

  /// workmanager task ids
  static const String taskRefreshWidget = 'arccore.refresh_widget';
  static const String taskAutoBackup = 'arccore.auto_backup';
  static const String taskReconcileSteps = 'arccore.reconcile_steps';
}

/// data_models.Habit.stat_attribute
abstract final class StatKeys {
  static const discipline = 'Discipline';
  static const vitality = 'Vitality';
  static const strength = 'Strength';
  static const focus = 'Focus';
  static const spirit = 'Spirit';
  static const all = [discipline, vitality, strength, focus, spirit];
}

/// data_models.Habit.metric_unit
abstract final class MetricUnits {
  static const boolean = 'boolean';
  static const steps = 'steps';
  static const liters = 'liters';
  static const minutes = 'minutes';
  static const hours = 'hours';
  static const count = 'count';
  static const all = [boolean, steps, liters, minutes, hours, count];
}

/// data_models.Habit.category
abstract final class HabitCategories {
  static const body = 'body';
  static const mind = 'mind';
  static const spirit = 'spirit';
  static const craft = 'craft';
  static const social = 'social';
  static const all = [body, mind, spirit, craft, social];
}

/// core_features.frequency_engine.frequency_types
abstract final class FrequencyTypes {
  static const daily = 'daily';
  static const weeklyTarget = 'weekly_target';
  static const specificDays = 'specific_days';
  static const interval = 'interval';
  static const all = [daily, weeklyTarget, specificDays, interval];
}
