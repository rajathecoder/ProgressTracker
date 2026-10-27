import 'package:flutter/widgets.dart';

import '../../data/models/habit.dart';
import 'app_constants.dart';
import 'app_icons.dart';

/// One entry in the preset catalogue. [titleKey] is an ARB key, so the library
/// is localised for free and a preset habit's name follows the user's language.
class HabitPreset {
  const HabitPreset({
    required this.titleKey,
    required this.category,
    required this.stat,
    required this.xp,
    required this.icon,
    this.metricUnit = MetricUnits.boolean,
    this.target = 1,
    this.frequencyType = FrequencyTypes.daily,
    this.frequencyValue = 1,
    this.activeWeekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminderTime,
    this.isSeed = false,
  });

  final String titleKey;
  final String category;
  final String stat;
  final int xp;

  /// A const `Icons.*` reference, so the icon is correct and tree-shakeable.
  final IconData icon;
  final String metricUnit;
  final int target;
  final String frequencyType;
  final int frequencyValue;
  final List<int> activeWeekdays;
  final String? reminderTime;

  /// The ten habits from the original spec brief - preselected in onboarding.
  final bool isSeed;

  Habit toHabit({required int sortOrder, required int arcId}) => Habit.create(
    titleKey: titleKey,
    iconCodePoint: icon.codePoint,
    category: category,
    targetMetric: target,
    metricUnit: metricUnit,
    statAttribute: stat,
    xpReward: xp,
    reminderTime: reminderTime,
    frequencyType: frequencyType,
    frequencyValue: frequencyValue,
    activeWeekdays: activeWeekdays,
    sortOrder: sortOrder,
    arcId: arcId,
  );
}

/// core_features.habit_library - "a preset catalogue of 30+ habits across five
/// categories, each with a 3D clay icon, default stat mapping and suggested
/// XP."
///
/// The ten `isSeed` entries reproduce core_features.rpg_attributes.stat_mapping
/// exactly, which is what makes the spec's calibration hold: 150 max daily XP,
/// 18,300 over a perfect 122-day arc, landing at roughly Level 51.
abstract final class HabitPresets {
  static const List<HabitPreset> all = [
    // ------------------------------------------------------- seed set (10)
    HabitPreset(
      titleKey: 'habitEarlyWake',
      category: HabitCategories.mind,
      stat: StatKeys.discipline,
      xp: 15,
      icon: AppIcons.alarm,
      reminderTime: '05:30',
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitWaterOnly',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 10,
      icon: AppIcons.water,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitNoJunkFood',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 15,
      icon: AppIcons.food,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitSleepTarget',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 20,
      icon: AppIcons.sleep,
      metricUnit: MetricUnits.hours,
      target: 7,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitGymWorkout',
      category: HabitCategories.body,
      stat: StatKeys.strength,
      xp: 25,
      icon: AppIcons.gym,
      frequencyType: FrequencyTypes.weeklyTarget,
      frequencyValue: 4,
      reminderTime: '17:30',
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitStepsGoal',
      category: HabitCategories.body,
      stat: StatKeys.strength,
      xp: 15,
      icon: AppIcons.steps,
      metricUnit: MetricUnits.steps,
      target: 10000,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitNoPhoneMeals',
      category: HabitCategories.mind,
      stat: StatKeys.focus,
      xp: 15,
      icon: AppIcons.noPhone,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitWalking',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 10,
      icon: AppIcons.walk,
      metricUnit: MetricUnits.minutes,
      target: 30,
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitGratitude',
      category: HabitCategories.spirit,
      stat: StatKeys.spirit,
      xp: 15,
      icon: AppIcons.gratitude,
      reminderTime: '21:30',
      isSeed: true,
    ),
    HabitPreset(
      titleKey: 'habitNoteProgress',
      category: HabitCategories.mind,
      stat: StatKeys.focus,
      xp: 10,
      icon: AppIcons.notes,
      reminderTime: '21:30',
      isSeed: true,
    ),

    // ------------------------------------------------------------- body (+6)
    HabitPreset(
      titleKey: 'habitColdShower',
      category: HabitCategories.body,
      stat: StatKeys.discipline,
      xp: 15,
      icon: AppIcons.coldShower,
    ),
    HabitPreset(
      titleKey: 'habitStretch',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 10,
      icon: AppIcons.stretch,
      metricUnit: MetricUnits.minutes,
      target: 10,
    ),
    HabitPreset(
      titleKey: 'habitProtein',
      category: HabitCategories.body,
      stat: StatKeys.strength,
      xp: 15,
      icon: AppIcons.protein,
    ),
    HabitPreset(
      titleKey: 'habitVitamins',
      category: HabitCategories.body,
      stat: StatKeys.vitality,
      xp: 5,
      icon: AppIcons.vitamins,
    ),
    HabitPreset(
      titleKey: 'habitFloss',
      category: HabitCategories.body,
      stat: StatKeys.discipline,
      xp: 5,
      icon: AppIcons.floss,
    ),
    HabitPreset(
      titleKey: 'habitNoAlcohol',
      category: HabitCategories.body,
      stat: StatKeys.discipline,
      xp: 15,
      icon: AppIcons.noAlcohol,
    ),

    // ------------------------------------------------------------- mind (+7)
    HabitPreset(
      titleKey: 'habitRead',
      category: HabitCategories.mind,
      stat: StatKeys.focus,
      xp: 15,
      icon: AppIcons.read,
      metricUnit: MetricUnits.count,
      target: 20,
    ),
    HabitPreset(
      titleKey: 'habitMeditate',
      category: HabitCategories.mind,
      stat: StatKeys.focus,
      xp: 15,
      icon: AppIcons.meditate,
      metricUnit: MetricUnits.minutes,
      target: 10,
    ),
    HabitPreset(
      titleKey: 'habitNoSocialMedia',
      category: HabitCategories.mind,
      stat: StatKeys.discipline,
      xp: 20,
      icon: AppIcons.noSocial,
    ),
    HabitPreset(
      titleKey: 'habitDeepWork',
      category: HabitCategories.mind,
      stat: StatKeys.focus,
      xp: 25,
      icon: AppIcons.deepWork,
      metricUnit: MetricUnits.minutes,
      target: 90,
      frequencyType: FrequencyTypes.specificDays,
      activeWeekdays: [1, 2, 3, 4, 5],
    ),
    HabitPreset(
      titleKey: 'habitPlanTomorrow',
      category: HabitCategories.mind,
      stat: StatKeys.discipline,
      xp: 10,
      icon: AppIcons.plan,
      reminderTime: '21:30',
    ),
    HabitPreset(
      titleKey: 'habitNoScreensBed',
      category: HabitCategories.mind,
      stat: StatKeys.discipline,
      xp: 15,
      icon: AppIcons.noScreens,
    ),
    HabitPreset(
      titleKey: 'habitBudgetCheck',
      category: HabitCategories.mind,
      stat: StatKeys.discipline,
      xp: 10,
      icon: AppIcons.budget,
      frequencyType: FrequencyTypes.specificDays,
      activeWeekdays: [7],
    ),

    // ----------------------------------------------------------- spirit (+4)
    HabitPreset(
      titleKey: 'habitJournal',
      category: HabitCategories.spirit,
      stat: StatKeys.spirit,
      xp: 15,
      icon: AppIcons.journal,
      reminderTime: '21:30',
    ),
    HabitPreset(
      titleKey: 'habitPray',
      category: HabitCategories.spirit,
      stat: StatKeys.spirit,
      xp: 15,
      icon: AppIcons.pray,
    ),
    HabitPreset(
      titleKey: 'habitSunlight',
      category: HabitCategories.spirit,
      stat: StatKeys.vitality,
      xp: 10,
      icon: AppIcons.sunlight,
      metricUnit: MetricUnits.minutes,
      target: 15,
    ),
    HabitPreset(
      titleKey: 'habitTidySpace',
      category: HabitCategories.spirit,
      stat: StatKeys.discipline,
      xp: 10,
      icon: AppIcons.tidy,
    ),

    // ------------------------------------------------------------ craft (+4)
    HabitPreset(
      titleKey: 'habitLearnSkill',
      category: HabitCategories.craft,
      stat: StatKeys.focus,
      xp: 20,
      icon: AppIcons.craft,
      metricUnit: MetricUnits.minutes,
      target: 45,
    ),
    HabitPreset(
      titleKey: 'habitLanguage',
      category: HabitCategories.craft,
      stat: StatKeys.focus,
      xp: 15,
      icon: AppIcons.language,
      metricUnit: MetricUnits.minutes,
      target: 15,
    ),
    HabitPreset(
      titleKey: 'habitSideProject',
      category: HabitCategories.craft,
      stat: StatKeys.discipline,
      xp: 25,
      icon: AppIcons.ship,
      frequencyType: FrequencyTypes.weeklyTarget,
      frequencyValue: 3,
    ),

    // ----------------------------------------------------------- social (+2)
    HabitPreset(
      titleKey: 'habitCallFamily',
      category: HabitCategories.social,
      stat: StatKeys.spirit,
      xp: 15,
      icon: AppIcons.call,
      frequencyType: FrequencyTypes.weeklyTarget,
      frequencyValue: 2,
    ),
    HabitPreset(
      titleKey: 'habitActOfKindness',
      category: HabitCategories.social,
      stat: StatKeys.spirit,
      xp: 15,
      icon: AppIcons.kindness,
    ),
  ];

  static List<HabitPreset> get seeds =>
      all.where((p) => p.isSeed).toList(growable: false);

  static List<HabitPreset> byCategory(String category) =>
      all.where((p) => p.category == category).toList(growable: false);

  /// Icons offered in the custom habit builder - the whole registry, so the
  /// picker can never offer a codepoint that would not render.
  static List<int> get iconChoices =>
      AppIcons.all.map((i) => i.codePoint).toList(growable: false);
}
