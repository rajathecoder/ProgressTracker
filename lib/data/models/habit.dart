import 'package:isar_community/isar.dart';

import '../../core/constants/app_constants.dart';

part 'habit.g.dart';

/// data_models.Habit
///
/// A habit is a *definition*, not a record. Editing one bumps [version] rather
/// than rewriting history - every HabitEntry snapshots the version, xp and
/// target it was awarded under (edge_case_handling.habit_edited_mid_arc).
@collection
class Habit {
  Id id = Isar.autoIncrement;

  /// ARB key for preset habits; null for user-created ones.
  String? titleKey;

  /// Used when [titleKey] is null.
  String? customTitle;

  String iconAssetPath = '';

  /// Codepoint of the Material icon rendered when no clay asset is bundled.
  int iconCodePoint = 0xe5ca; // Icons.check

  @Index()
  String category = HabitCategories.body;

  int targetMetric = 1;

  String metricUnit = MetricUnits.boolean;

  @Index()
  String statAttribute = StatKeys.discipline;

  int xpReward = 10;

  /// 'HH:mm' local time, or null for no per-habit reminder.
  String? reminderTime;

  String frequencyType = FrequencyTypes.daily;

  /// N per week for weekly_target, N days for interval, 1 for daily.
  int frequencyValue = 1;

  /// 1 = Monday .. 7 = Sunday. Only meaningful for specific_days.
  List<int> activeWeekdays = const [1, 2, 3, 4, 5, 6, 7];

  int sortOrder = 0;

  @Index()
  bool isArchived = false;

  bool isCustom = false;

  DateTime createdAt = DateTime.now();

  DateTime? archivedAt;

  /// Increments on every semantic edit.
  int version = 1;

  /// Which arc this habit belongs to. Habits carried into a new arc are
  /// copied, so history stays attached to the arc it was logged in.
  @Index()
  int arcId = 0;

  Habit();

  Habit.create({
    this.titleKey,
    this.customTitle,
    this.iconAssetPath = '',
    this.iconCodePoint = 0xe5ca,
    this.category = HabitCategories.body,
    this.targetMetric = 1,
    this.metricUnit = MetricUnits.boolean,
    this.statAttribute = StatKeys.discipline,
    this.xpReward = 10,
    this.reminderTime,
    this.frequencyType = FrequencyTypes.daily,
    this.frequencyValue = 1,
    this.activeWeekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.sortOrder = 0,
    this.isArchived = false,
    this.isCustom = false,
    this.version = 1,
    this.arcId = 0,
    DateTime? createdAt,
    this.archivedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @ignore
  bool get isBoolean => metricUnit == MetricUnits.boolean;

  /// XP is clamped on write, not on read, but a defensive clamp here keeps
  /// imported data honest (data_integrity.restore).
  @ignore
  int get clampedXp =>
      xpReward.clamp(AppConstants.minHabitXp, AppConstants.maxHabitXp);

  Habit copyForNewArc(int newArcId) => Habit.create(
    titleKey: titleKey,
    customTitle: customTitle,
    iconAssetPath: iconAssetPath,
    iconCodePoint: iconCodePoint,
    category: category,
    targetMetric: targetMetric,
    metricUnit: metricUnit,
    statAttribute: statAttribute,
    xpReward: xpReward,
    reminderTime: reminderTime,
    frequencyType: frequencyType,
    frequencyValue: frequencyValue,
    activeWeekdays: List<int>.from(activeWeekdays),
    sortOrder: sortOrder,
    isCustom: isCustom,
    version: version,
    arcId: newArcId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title_key': titleKey,
    'custom_title': customTitle,
    'icon_asset_path': iconAssetPath,
    'icon_code_point': iconCodePoint,
    'category': category,
    'target_metric': targetMetric,
    'metric_unit': metricUnit,
    'stat_attribute': statAttribute,
    'xp_reward': xpReward,
    'reminder_time': reminderTime,
    'frequency_type': frequencyType,
    'frequency_value': frequencyValue,
    'active_weekdays': activeWeekdays,
    'sort_order': sortOrder,
    'is_archived': isArchived,
    'is_custom': isCustom,
    'created_at': createdAt.toIso8601String(),
    'archived_at': archivedAt?.toIso8601String(),
    'version': version,
    'arc_id': arcId,
  };

  static Habit fromJson(Map<String, dynamic> j) => Habit()
    ..id = (j['id'] as num?)?.toInt() ?? Isar.autoIncrement
    ..titleKey = j['title_key'] as String?
    ..customTitle = j['custom_title'] as String?
    ..iconAssetPath = j['icon_asset_path'] as String? ?? ''
    ..iconCodePoint = (j['icon_code_point'] as num?)?.toInt() ?? 0xe5ca
    ..category = j['category'] as String? ?? HabitCategories.body
    ..targetMetric = (j['target_metric'] as num?)?.toInt() ?? 1
    ..metricUnit = j['metric_unit'] as String? ?? MetricUnits.boolean
    ..statAttribute = j['stat_attribute'] as String? ?? StatKeys.discipline
    ..xpReward = (j['xp_reward'] as num?)?.toInt() ?? 10
    ..reminderTime = j['reminder_time'] as String?
    ..frequencyType = j['frequency_type'] as String? ?? FrequencyTypes.daily
    ..frequencyValue = (j['frequency_value'] as num?)?.toInt() ?? 1
    ..activeWeekdays =
        (j['active_weekdays'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        const [1, 2, 3, 4, 5, 6, 7]
    ..sortOrder = (j['sort_order'] as num?)?.toInt() ?? 0
    ..isArchived = j['is_archived'] as bool? ?? false
    ..isCustom = j['is_custom'] as bool? ?? false
    ..createdAt =
        DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now()
    ..archivedAt = j['archived_at'] == null
        ? null
        : DateTime.tryParse(j['archived_at'] as String)
    ..version = (j['version'] as num?)?.toInt() ?? 1
    ..arcId = (j['arc_id'] as num?)?.toInt() ?? 0;
}
