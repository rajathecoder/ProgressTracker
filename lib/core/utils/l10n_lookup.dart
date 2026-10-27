import '../../data/models/habit.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_constants.dart';

/// Maps the ARB keys stored on models back to localized strings.
///
/// Habits, stats, categories, ranks and achievements all persist a *key*, not a
/// display string, so a user who switches language sees their whole arc
/// re-labelled rather than a mix of two languages.
abstract final class L10nLookup {
  static String habitTitle(Habit habit, AppLocalizations l) {
    final custom = habit.customTitle;
    if (custom != null && custom.trim().isNotEmpty) return custom;
    final key = habit.titleKey;
    return key == null ? l.errorGeneric : habitKey(key, l);
  }

  static String habitKey(String key, AppLocalizations l) => switch (key) {
    'habitEarlyWake' => l.habitEarlyWake,
    'habitWaterOnly' => l.habitWaterOnly,
    'habitNoJunkFood' => l.habitNoJunkFood,
    'habitSleepTarget' => l.habitSleepTarget,
    'habitGymWorkout' => l.habitGymWorkout,
    'habitStepsGoal' => l.habitStepsGoal,
    'habitNoPhoneMeals' => l.habitNoPhoneMeals,
    'habitWalking' => l.habitWalking,
    'habitGratitude' => l.habitGratitude,
    'habitNoteProgress' => l.habitNoteProgress,
    'habitRead' => l.habitRead,
    'habitMeditate' => l.habitMeditate,
    'habitColdShower' => l.habitColdShower,
    'habitStretch' => l.habitStretch,
    'habitNoSocialMedia' => l.habitNoSocialMedia,
    'habitDeepWork' => l.habitDeepWork,
    'habitJournal' => l.habitJournal,
    'habitLearnSkill' => l.habitLearnSkill,
    'habitPlanTomorrow' => l.habitPlanTomorrow,
    'habitNoScreensBed' => l.habitNoScreensBed,
    'habitProtein' => l.habitProtein,
    'habitVitamins' => l.habitVitamins,
    'habitFloss' => l.habitFloss,
    'habitSunlight' => l.habitSunlight,
    'habitCallFamily' => l.habitCallFamily,
    'habitActOfKindness' => l.habitActOfKindness,
    'habitTidySpace' => l.habitTidySpace,
    'habitNoAlcohol' => l.habitNoAlcohol,
    'habitBudgetCheck' => l.habitBudgetCheck,
    'habitPray' => l.habitPray,
    'habitLanguage' => l.habitLanguage,
    'habitSideProject' => l.habitSideProject,
    _ => key,
  };

  static String stat(String stat, AppLocalizations l) => switch (stat) {
    StatKeys.discipline => l.statDiscipline,
    StatKeys.vitality => l.statVitality,
    StatKeys.strength => l.statStrength,
    StatKeys.focus => l.statFocus,
    StatKeys.spirit => l.statSpirit,
    _ => stat,
  };

  static String category(String category, AppLocalizations l) =>
      switch (category) {
        HabitCategories.body => l.categoryBody,
        HabitCategories.mind => l.categoryMind,
        HabitCategories.spirit => l.categorySpirit,
        HabitCategories.craft => l.categoryCraft,
        HabitCategories.social => l.categorySocial,
        _ => category,
      };

  static String unit(String unit, AppLocalizations l) => switch (unit) {
    MetricUnits.boolean => l.unitBoolean,
    MetricUnits.steps => l.unitSteps,
    MetricUnits.liters => l.unitLiters,
    MetricUnits.minutes => l.unitMinutes,
    MetricUnits.hours => l.unitHours,
    MetricUnits.count => l.unitCount,
    _ => unit,
  };

  static String rank(String key, AppLocalizations l) => switch (key) {
    'rankEmberSpark' => l.rankEmberSpark,
    'rankFrostInitiate' => l.rankFrostInitiate,
    'rankIronAscetic' => l.rankIronAscetic,
    'rankStormWarden' => l.rankStormWarden,
    'rankArcChampion' => l.rankArcChampion,
    'rankWinterSovereign' => l.rankWinterSovereign,
    _ => key,
  };

  static String achievementName(String key, AppLocalizations l) =>
      switch (key) {
        'achFirstBlood' => l.achFirstBlood,
        'achPerfectDay' => l.achPerfectDay,
        'achStreak3' => l.achStreak3,
        'achStreak7' => l.achStreak7,
        'achStreak14' => l.achStreak14,
        'achStreak30' => l.achStreak30,
        'achStreak60' => l.achStreak60,
        'achStreak100' => l.achStreak100,
        'achPerfectArc' => l.achPerfectArc,
        'achTenPerfectDays' => l.achTenPerfectDays,
        'achEarlyRiser30' => l.achEarlyRiser30,
        'achGym50' => l.achGym50,
        'achSteps500k' => l.achSteps500k,
        'achGratitude100' => l.achGratitude100,
        'achClean30' => l.achClean30,
        'achHydrated60' => l.achHydrated60,
        'achLevel10' => l.achLevel10,
        'achLevel25' => l.achLevel25,
        'achLevel50' => l.achLevel50,
        'achBalanced' => l.achBalanced,
        'achPhoenix' => l.achPhoenix,
        'achNoShields30' => l.achNoShields30,
        'achFirstBackup' => l.achFirstBackup,
        'achArchitect' => l.achArchitect,
        _ => key,
      };

  static String achievementDesc(String key, AppLocalizations l) =>
      switch (key) {
        'achFirstBloodDesc' => l.achFirstBloodDesc,
        'achPerfectDayDesc' => l.achPerfectDayDesc,
        'achStreak3Desc' => l.achStreak3Desc,
        'achStreak7Desc' => l.achStreak7Desc,
        'achStreak14Desc' => l.achStreak14Desc,
        'achStreak30Desc' => l.achStreak30Desc,
        'achStreak60Desc' => l.achStreak60Desc,
        'achStreak100Desc' => l.achStreak100Desc,
        'achPerfectArcDesc' => l.achPerfectArcDesc,
        'achTenPerfectDaysDesc' => l.achTenPerfectDaysDesc,
        'achEarlyRiser30Desc' => l.achEarlyRiser30Desc,
        'achGym50Desc' => l.achGym50Desc,
        'achSteps500kDesc' => l.achSteps500kDesc,
        'achGratitude100Desc' => l.achGratitude100Desc,
        'achClean30Desc' => l.achClean30Desc,
        'achHydrated60Desc' => l.achHydrated60Desc,
        'achLevel10Desc' => l.achLevel10Desc,
        'achLevel25Desc' => l.achLevel25Desc,
        'achLevel50Desc' => l.achLevel50Desc,
        'achBalancedDesc' => l.achBalancedDesc,
        'achPhoenixDesc' => l.achPhoenixDesc,
        'achNoShields30Desc' => l.achNoShields30Desc,
        'achFirstBackupDesc' => l.achFirstBackupDesc,
        'achArchitectDesc' => l.achArchitectDesc,
        _ => key,
      };

  static String frequency(
    Habit habit,
    AppLocalizations l,
  ) => switch (habit.frequencyType) {
    FrequencyTypes.daily => l.habitFrequencyDaily,
    FrequencyTypes.weeklyTarget => l.habitFrequencyWeekly(habit.frequencyValue),
    FrequencyTypes.specificDays => l.habitFrequencyCustom,
    FrequencyTypes.interval => l.habitFrequencyInterval(habit.frequencyValue),
    _ => l.habitFrequencyDaily,
  };

  static String mood(int mood, AppLocalizations l) => switch (mood) {
    1 => l.mood1,
    2 => l.mood2,
    3 => l.mood3,
    4 => l.mood4,
    _ => l.mood5,
  };
}
