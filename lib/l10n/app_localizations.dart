import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sw'),
    Locale('ta'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Happy Days'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Happy Days'**
  String get appName;

  /// No description provided for @morningAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Rise & Conquer'**
  String get morningAlertTitle;

  /// No description provided for @morningAlertBody.
  ///
  /// In en, this message translates to:
  /// **'The arc doesn\'t wait. Get up.'**
  String get morningAlertBody;

  /// No description provided for @middayAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Check'**
  String get middayAlertTitle;

  /// No description provided for @middayAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Water only. Clean plate. Stay sharp.'**
  String get middayAlertBody;

  /// No description provided for @eveningWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Move Your Body'**
  String get eveningWorkoutTitle;

  /// No description provided for @eveningWorkoutBody.
  ///
  /// In en, this message translates to:
  /// **'Gym or a 30 minute walk. Pick one.'**
  String get eveningWorkoutBody;

  /// No description provided for @nightReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening Debrief'**
  String get nightReviewTitle;

  /// No description provided for @nightReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Log the day and note one thing you\'re grateful for.'**
  String get nightReviewBody;

  /// No description provided for @habitEarlyWake.
  ///
  /// In en, this message translates to:
  /// **'Wake up early'**
  String get habitEarlyWake;

  /// No description provided for @habitWaterOnly.
  ///
  /// In en, this message translates to:
  /// **'Water only'**
  String get habitWaterOnly;

  /// No description provided for @habitNoJunkFood.
  ///
  /// In en, this message translates to:
  /// **'No junk food'**
  String get habitNoJunkFood;

  /// No description provided for @habitSleepTarget.
  ///
  /// In en, this message translates to:
  /// **'7-8 hours of sleep'**
  String get habitSleepTarget;

  /// No description provided for @habitGymWorkout.
  ///
  /// In en, this message translates to:
  /// **'Gym 4-5 days a week'**
  String get habitGymWorkout;

  /// No description provided for @habitStepsGoal.
  ///
  /// In en, this message translates to:
  /// **'10k steps'**
  String get habitStepsGoal;

  /// No description provided for @habitNoPhoneMeals.
  ///
  /// In en, this message translates to:
  /// **'No phone during meals'**
  String get habitNoPhoneMeals;

  /// No description provided for @habitWalking.
  ///
  /// In en, this message translates to:
  /// **'30 minutes walk'**
  String get habitWalking;

  /// No description provided for @habitGratitude.
  ///
  /// In en, this message translates to:
  /// **'Be grateful to God daily'**
  String get habitGratitude;

  /// No description provided for @habitNoteProgress.
  ///
  /// In en, this message translates to:
  /// **'Note your progress'**
  String get habitNoteProgress;

  /// No description provided for @habitRead.
  ///
  /// In en, this message translates to:
  /// **'Read 20 pages'**
  String get habitRead;

  /// No description provided for @habitMeditate.
  ///
  /// In en, this message translates to:
  /// **'Meditate 10 minutes'**
  String get habitMeditate;

  /// No description provided for @habitColdShower.
  ///
  /// In en, this message translates to:
  /// **'Cold shower'**
  String get habitColdShower;

  /// No description provided for @habitStretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch 10 minutes'**
  String get habitStretch;

  /// No description provided for @habitNoSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'No social media'**
  String get habitNoSocialMedia;

  /// No description provided for @habitDeepWork.
  ///
  /// In en, this message translates to:
  /// **'90 minutes of deep work'**
  String get habitDeepWork;

  /// No description provided for @habitJournal.
  ///
  /// In en, this message translates to:
  /// **'Write in your journal'**
  String get habitJournal;

  /// No description provided for @habitLearnSkill.
  ///
  /// In en, this message translates to:
  /// **'Practise your craft'**
  String get habitLearnSkill;

  /// No description provided for @habitPlanTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Plan tomorrow tonight'**
  String get habitPlanTomorrow;

  /// No description provided for @habitNoScreensBed.
  ///
  /// In en, this message translates to:
  /// **'No screens before bed'**
  String get habitNoScreensBed;

  /// No description provided for @habitProtein.
  ///
  /// In en, this message translates to:
  /// **'Hit your protein target'**
  String get habitProtein;

  /// No description provided for @habitVitamins.
  ///
  /// In en, this message translates to:
  /// **'Take your vitamins'**
  String get habitVitamins;

  /// No description provided for @habitFloss.
  ///
  /// In en, this message translates to:
  /// **'Floss'**
  String get habitFloss;

  /// No description provided for @habitSunlight.
  ///
  /// In en, this message translates to:
  /// **'15 minutes of sunlight'**
  String get habitSunlight;

  /// No description provided for @habitCallFamily.
  ///
  /// In en, this message translates to:
  /// **'Call someone you love'**
  String get habitCallFamily;

  /// No description provided for @habitActOfKindness.
  ///
  /// In en, this message translates to:
  /// **'One act of kindness'**
  String get habitActOfKindness;

  /// No description provided for @habitTidySpace.
  ///
  /// In en, this message translates to:
  /// **'Tidy your space'**
  String get habitTidySpace;

  /// No description provided for @habitNoAlcohol.
  ///
  /// In en, this message translates to:
  /// **'No alcohol'**
  String get habitNoAlcohol;

  /// No description provided for @habitBudgetCheck.
  ///
  /// In en, this message translates to:
  /// **'Check your budget'**
  String get habitBudgetCheck;

  /// No description provided for @habitPray.
  ///
  /// In en, this message translates to:
  /// **'Prayer or reflection'**
  String get habitPray;

  /// No description provided for @habitLanguage.
  ///
  /// In en, this message translates to:
  /// **'Practise a language'**
  String get habitLanguage;

  /// No description provided for @habitSideProject.
  ///
  /// In en, this message translates to:
  /// **'Ship something small'**
  String get habitSideProject;

  /// No description provided for @statDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Discipline'**
  String get statDiscipline;

  /// No description provided for @statVitality.
  ///
  /// In en, this message translates to:
  /// **'Vitality'**
  String get statVitality;

  /// No description provided for @statStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get statStrength;

  /// No description provided for @statFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get statFocus;

  /// No description provided for @statSpirit.
  ///
  /// In en, this message translates to:
  /// **'Spirit'**
  String get statSpirit;

  /// No description provided for @categoryBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get categoryBody;

  /// No description provided for @categoryMind.
  ///
  /// In en, this message translates to:
  /// **'Mind'**
  String get categoryMind;

  /// No description provided for @categorySpirit.
  ///
  /// In en, this message translates to:
  /// **'Spirit'**
  String get categorySpirit;

  /// No description provided for @categoryCraft.
  ///
  /// In en, this message translates to:
  /// **'Craft'**
  String get categoryCraft;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @welcomeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get welcomeGreetingMorning;

  /// No description provided for @welcomeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get welcomeGreetingAfternoon;

  /// No description provided for @welcomeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get welcomeGreetingEvening;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Small days, stacked well.'**
  String get welcomeTagline;

  /// No description provided for @welcomeGetStartedHint.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your first arc.'**
  String get welcomeGetStartedHint;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Happy Days'**
  String get onboardingWelcome;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build the days you want to remember. Everything stays on your device.'**
  String get onboardingSubtitle;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get enterNickname;

  /// No description provided for @onboardingIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s running this arc?'**
  String get onboardingIdentityTitle;

  /// No description provided for @onboardingArcTitle.
  ///
  /// In en, this message translates to:
  /// **'How long is your arc?'**
  String get onboardingArcTitle;

  /// No description provided for @onboardingHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your starting habits'**
  String get onboardingHabitsTitle;

  /// No description provided for @onboardingHabitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick as many as you like. You can add, edit or archive any of them later.'**
  String get onboardingHabitsSubtitle;

  /// No description provided for @onboardingThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your surface'**
  String get onboardingThemeTitle;

  /// No description provided for @onboardingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on schedule'**
  String get onboardingPermissionTitle;

  /// No description provided for @onboardingSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String onboardingSelectedCount(int count);

  /// No description provided for @arcLength90.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get arcLength90;

  /// No description provided for @arcLength122.
  ///
  /// In en, this message translates to:
  /// **'122 days'**
  String get arcLength122;

  /// No description provided for @arcLengthCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get arcLengthCustom;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'Let\'s conquer today, {nickname}'**
  String dashboardGreeting(String nickname);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get dashboardTitle;

  /// No description provided for @todaysProtocol.
  ///
  /// In en, this message translates to:
  /// **'Today\'s protocol'**
  String get todaysProtocol;

  /// No description provided for @characterSheet.
  ///
  /// In en, this message translates to:
  /// **'Character sheet'**
  String get characterSheet;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsProfileName.
  ///
  /// In en, this message translates to:
  /// **'Name: {fullName}'**
  String settingsProfileName(String fullName);

  /// No description provided for @arcDayCounter.
  ///
  /// In en, this message translates to:
  /// **'Day {current} of {total}'**
  String arcDayCounter(int current, int total);

  /// No description provided for @arcNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Your arc starts in {days} days'**
  String arcNotStarted(int days);

  /// No description provided for @streakCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1 day streak} other{{count} day streak}}'**
  String streakCount(int count);

  /// No description provided for @shieldCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No shields} =1{1 shield} other{{count} shields}}'**
  String shieldCount(int count);

  /// No description provided for @shieldConsumed.
  ///
  /// In en, this message translates to:
  /// **'A shield absorbed yesterday\'s miss. {remaining} left.'**
  String shieldConsumed(int remaining);

  /// No description provided for @multiplierActive.
  ///
  /// In en, this message translates to:
  /// **'{value}x XP multiplier active'**
  String multiplierActive(String value);

  /// No description provided for @levelUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelUpTitle(int level);

  /// No description provided for @rankUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Rank unlocked: {rankName}'**
  String rankUnlocked(String rankName);

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked'**
  String get achievementUnlocked;

  /// No description provided for @bossWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss Week: {name}'**
  String bossWeekTitle(String name);

  /// No description provided for @bossWeekProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {required} complete'**
  String bossWeekProgress(int completed, int required);

  /// No description provided for @notScheduledToday.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled today'**
  String get notScheduledToday;

  /// No description provided for @backfillTitle.
  ///
  /// In en, this message translates to:
  /// **'Log for {date}'**
  String backfillTitle(String date);

  /// No description provided for @backfillLate.
  ///
  /// In en, this message translates to:
  /// **'Logged late'**
  String get backfillLate;

  /// No description provided for @backfillWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'This day is outside your logging window'**
  String get backfillWindowClosed;

  /// No description provided for @metricEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'{value} of {target} {unit}'**
  String metricEntryLabel(String value, String target, String unit);

  /// No description provided for @partialCredit.
  ///
  /// In en, this message translates to:
  /// **'Partial credit: {percent}%'**
  String partialCredit(int percent);

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String xpEarned(int xp);

  /// No description provided for @xpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} XP'**
  String xpToNextLevel(int current, int target);

  /// No description provided for @todayComplete.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} done'**
  String todayComplete(int completed, int total);

  /// No description provided for @perfectDay.
  ///
  /// In en, this message translates to:
  /// **'Flawless day'**
  String get perfectDay;

  /// No description provided for @matrixTitle.
  ///
  /// In en, this message translates to:
  /// **'Matrix'**
  String get matrixTitle;

  /// No description provided for @matrixZoomWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get matrixZoomWeek;

  /// No description provided for @matrixZoomMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get matrixZoomMonth;

  /// No description provided for @matrixZoomArc.
  ///
  /// In en, this message translates to:
  /// **'Arc'**
  String get matrixZoomArc;

  /// No description provided for @jumpToToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get jumpToToday;

  /// No description provided for @matrixLinearView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get matrixLinearView;

  /// No description provided for @matrixGridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get matrixGridView;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @cellStateComplete.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get cellStateComplete;

  /// No description provided for @cellStatePartial.
  ///
  /// In en, this message translates to:
  /// **'partially complete'**
  String get cellStatePartial;

  /// No description provided for @cellStateIncomplete.
  ///
  /// In en, this message translates to:
  /// **'not completed'**
  String get cellStateIncomplete;

  /// No description provided for @cellStateMissed.
  ///
  /// In en, this message translates to:
  /// **'missed'**
  String get cellStateMissed;

  /// No description provided for @cellStateNotScheduled.
  ///
  /// In en, this message translates to:
  /// **'not scheduled'**
  String get cellStateNotScheduled;

  /// No description provided for @cellSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'{habit}, {date}, {state}'**
  String cellSemanticLabel(String habit, String date, String state);

  /// No description provided for @habitCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String habitCompletionRate(int percent);

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get analyticsTitle;

  /// No description provided for @analyticsBestDay.
  ///
  /// In en, this message translates to:
  /// **'Your strongest day is {weekday}'**
  String analyticsBestDay(String weekday);

  /// No description provided for @analyticsWeakestDay.
  ///
  /// In en, this message translates to:
  /// **'You miss most on {weekday}'**
  String analyticsWeakestDay(String weekday);

  /// No description provided for @analyticsCorrelation.
  ///
  /// In en, this message translates to:
  /// **'On days you complete {habitA}, you complete {multiplier}x more habits overall'**
  String analyticsCorrelation(String habitA, String multiplier);

  /// No description provided for @analyticsProjection.
  ///
  /// In en, this message translates to:
  /// **'On this pace you\'ll finish the arc at {percent}%'**
  String analyticsProjection(int percent);

  /// No description provided for @analyticsNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Come back after 7 days of logging'**
  String get analyticsNotEnoughData;

  /// No description provided for @analyticsHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Contribution heatmap'**
  String get analyticsHeatmap;

  /// No description provided for @analyticsWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly consistency'**
  String get analyticsWeekly;

  /// No description provided for @analyticsStatProgression.
  ///
  /// In en, this message translates to:
  /// **'Stat progression'**
  String get analyticsStatProgression;

  /// No description provided for @analyticsWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday breakdown'**
  String get analyticsWeekday;

  /// No description provided for @analyticsCorrelationTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit correlations'**
  String get analyticsCorrelationTitle;

  /// No description provided for @analyticsTimeOfDay.
  ///
  /// In en, this message translates to:
  /// **'When you log'**
  String get analyticsTimeOfDay;

  /// No description provided for @analyticsProjectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Arc projection'**
  String get analyticsProjectionTitle;

  /// No description provided for @analyticsNoCorrelations.
  ///
  /// In en, this message translates to:
  /// **'No strong correlations yet. Keep logging.'**
  String get analyticsNoCorrelations;

  /// No description provided for @habitLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit Library'**
  String get habitLibraryTitle;

  /// No description provided for @createCustomHabit.
  ///
  /// In en, this message translates to:
  /// **'Create your own'**
  String get createCustomHabit;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get editHabit;

  /// No description provided for @habitFrequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get habitFrequencyDaily;

  /// No description provided for @habitFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'{count} times per week'**
  String habitFrequencyWeekly(int count);

  /// No description provided for @habitFrequencyCustom.
  ///
  /// In en, this message translates to:
  /// **'Selected days'**
  String get habitFrequencyCustom;

  /// No description provided for @habitFrequencyInterval.
  ///
  /// In en, this message translates to:
  /// **'Every {count} days'**
  String habitFrequencyInterval(int count);

  /// No description provided for @archiveHabit.
  ///
  /// In en, this message translates to:
  /// **'Archive habit'**
  String get archiveHabit;

  /// No description provided for @archiveHabitWarning.
  ///
  /// In en, this message translates to:
  /// **'Past records are kept. It just won\'t appear on future days.'**
  String get archiveHabitWarning;

  /// No description provided for @unarchiveHabit.
  ///
  /// In en, this message translates to:
  /// **'Restore habit'**
  String get unarchiveHabit;

  /// No description provided for @activeHabits.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeHabits;

  /// No description provided for @archivedHabits.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedHabits;

  /// No description provided for @habitTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitTitleLabel;

  /// No description provided for @habitIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get habitIconLabel;

  /// No description provided for @habitCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get habitCategoryLabel;

  /// No description provided for @habitStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Stat'**
  String get habitStatLabel;

  /// No description provided for @habitXpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP reward'**
  String get habitXpLabel;

  /// No description provided for @habitMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Measured in'**
  String get habitMetricLabel;

  /// No description provided for @habitTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily target'**
  String get habitTargetLabel;

  /// No description provided for @habitReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get habitReminderLabel;

  /// No description provided for @habitFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get habitFrequencyLabel;

  /// No description provided for @noReminder.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get noReminder;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @emptyHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get emptyHabitsTitle;

  /// No description provided for @emptyHabitsBody.
  ///
  /// In en, this message translates to:
  /// **'Add a few from the library to start your arc.'**
  String get emptyHabitsBody;

  /// No description provided for @unitBoolean.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get unitBoolean;

  /// No description provided for @unitSteps.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get unitSteps;

  /// No description provided for @unitLiters.
  ///
  /// In en, this message translates to:
  /// **'litres'**
  String get unitLiters;

  /// No description provided for @unitMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get unitMinutes;

  /// No description provided for @unitHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get unitHours;

  /// No description provided for @unitCount.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get unitCount;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your entries'**
  String get journalSearchHint;

  /// No description provided for @journalMoodPrompt.
  ///
  /// In en, this message translates to:
  /// **'How was today?'**
  String get journalMoodPrompt;

  /// No description provided for @journalOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'On this day'**
  String get journalOnThisDay;

  /// No description provided for @journalGratitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'One thing you\'re grateful for'**
  String get journalGratitudeLabel;

  /// No description provided for @journalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'How did today go?'**
  String get journalNotesLabel;

  /// No description provided for @journalTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get journalTagsLabel;

  /// No description provided for @journalAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get journalAddPhoto;

  /// No description provided for @journalSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get journalSaved;

  /// No description provided for @emptyJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing written yet'**
  String get emptyJournalTitle;

  /// No description provided for @emptyJournalBody.
  ///
  /// In en, this message translates to:
  /// **'Your debriefs will collect here.'**
  String get emptyJournalBody;

  /// No description provided for @mood1.
  ///
  /// In en, this message translates to:
  /// **'Rough'**
  String get mood1;

  /// No description provided for @mood2.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get mood2;

  /// No description provided for @mood3.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get mood3;

  /// No description provided for @mood4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get mood4;

  /// No description provided for @mood5.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get mood5;

  /// No description provided for @appLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock your journal'**
  String get appLockTitle;

  /// No description provided for @appLockPinFallback.
  ///
  /// In en, this message translates to:
  /// **'Use PIN instead'**
  String get appLockPinFallback;

  /// No description provided for @appLockSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get appLockSetPin;

  /// No description provided for @appLockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get appLockEnterPin;

  /// No description provided for @appLockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get appLockWrongPin;

  /// No description provided for @appLockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get appLockUnlock;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDayRollover.
  ///
  /// In en, this message translates to:
  /// **'New day starts at'**
  String get settingsDayRollover;

  /// No description provided for @settingsRetroWindow.
  ///
  /// In en, this message translates to:
  /// **'Allow logging up to {days} days back'**
  String settingsRetroWindow(int days);

  /// No description provided for @settingsHardcoreMode.
  ///
  /// In en, this message translates to:
  /// **'Hardcore Mode'**
  String get settingsHardcoreMode;

  /// No description provided for @settingsHardcoreModeDesc.
  ///
  /// In en, this message translates to:
  /// **'No shields, no backfill. What you log that day is what counts.'**
  String get settingsHardcoreModeDesc;

  /// No description provided for @settingsPartialCredit.
  ///
  /// In en, this message translates to:
  /// **'Partial credit'**
  String get settingsPartialCredit;

  /// No description provided for @settingsPartialCreditDesc.
  ///
  /// In en, this message translates to:
  /// **'Award proportional XP when you fall short of a numeric target.'**
  String get settingsPartialCreditDesc;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get settingsHighContrast;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSound;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsBatteryWarning.
  ///
  /// In en, this message translates to:
  /// **'Your device may stop reminders. Tap to allow background activity.'**
  String get settingsBatteryWarning;

  /// No description provided for @settingsSectionProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsSectionProfile;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsSectionReminders;

  /// No description provided for @settingsSectionArc.
  ///
  /// In en, this message translates to:
  /// **'Arc rules'**
  String get settingsSectionArc;

  /// No description provided for @settingsSectionAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsSectionAccessibility;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsSectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// No description provided for @settingsAppLockScopeJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal only'**
  String get settingsAppLockScopeJournal;

  /// No description provided for @settingsAppLockScopeApp.
  ///
  /// In en, this message translates to:
  /// **'Whole app'**
  String get settingsAppLockScopeApp;

  /// No description provided for @settingsExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms'**
  String get settingsExactAlarms;

  /// No description provided for @settingsExactAlarmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Required for on-the-minute wake-up reminders.'**
  String get settingsExactAlarmsDesc;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsReminderTimes.
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get settingsReminderTimes;

  /// No description provided for @remindersStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder status'**
  String get remindersStatusTitle;

  /// No description provided for @remindersHealthy.
  ///
  /// In en, this message translates to:
  /// **'{count} reminders armed'**
  String remindersHealthy(int count);

  /// No description provided for @remindersBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked for Happy Days'**
  String get remindersBlocked;

  /// No description provided for @remindersNoneArmed.
  ///
  /// In en, this message translates to:
  /// **'No reminders are armed'**
  String get remindersNoneArmed;

  /// No description provided for @remindersExactOn.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms on'**
  String get remindersExactOn;

  /// No description provided for @remindersExactOff.
  ///
  /// In en, this message translates to:
  /// **'Inexact alarms - times may drift by a few minutes'**
  String get remindersExactOff;

  /// No description provided for @remindersTimezone.
  ///
  /// In en, this message translates to:
  /// **'Anchored to {zone}'**
  String remindersTimezone(String zone);

  /// No description provided for @sendTestReminder.
  ///
  /// In en, this message translates to:
  /// **'Send a test reminder'**
  String get sendTestReminder;

  /// No description provided for @testReminderQueued.
  ///
  /// In en, this message translates to:
  /// **'Test reminder in 10 seconds - close the app to check'**
  String get testReminderQueued;

  /// No description provided for @testReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not schedule the test reminder'**
  String get testReminderFailed;

  /// No description provided for @testReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Test reminder'**
  String get testReminderTitle;

  /// No description provided for @testReminderBody.
  ///
  /// In en, this message translates to:
  /// **'If you can see this, your reminders are working.'**
  String get testReminderBody;

  /// No description provided for @remindersFixPermission.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get remindersFixPermission;

  /// No description provided for @backgroundRefresh.
  ///
  /// In en, this message translates to:
  /// **'Background refresh'**
  String get backgroundRefresh;

  /// No description provided for @backgroundRefreshDesc.
  ///
  /// In en, this message translates to:
  /// **'Keeps the widget and daily backup current when the app is closed.'**
  String get backgroundRefreshDesc;

  /// No description provided for @backgroundRunNow.
  ///
  /// In en, this message translates to:
  /// **'Run now'**
  String get backgroundRunNow;

  /// No description provided for @backgroundRanNow.
  ///
  /// In en, this message translates to:
  /// **'Refreshed'**
  String get backgroundRanNow;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSaved;

  /// No description provided for @languageSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search languages'**
  String get languageSearchHint;

  /// No description provided for @languageIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian languages'**
  String get languageIndian;

  /// No description provided for @languageWorld.
  ///
  /// In en, this message translates to:
  /// **'More languages'**
  String get languageWorld;

  /// No description provided for @languageTranslated.
  ///
  /// In en, this message translates to:
  /// **'Translated'**
  String get languageTranslated;

  /// No description provided for @languageFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'Languages without a translation show English text.'**
  String get languageFallbackNote;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @focusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Concentration timer'**
  String get focusSubtitle;

  /// No description provided for @focusSetDuration.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get focusSetDuration;

  /// No description provided for @focusStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get focusStart;

  /// No description provided for @focusPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get focusPause;

  /// No description provided for @focusResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get focusResume;

  /// No description provided for @focusReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get focusReset;

  /// No description provided for @focusDone.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get focusDone;

  /// No description provided for @focusDoneBody.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes of focus logged.'**
  String focusDoneBody(int minutes);

  /// No description provided for @focusRunning.
  ///
  /// In en, this message translates to:
  /// **'Focus in progress'**
  String get focusRunning;

  /// No description provided for @focusTodayTotal.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min today'**
  String focusTodayTotal(int minutes);

  /// No description provided for @focusSessions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sessions yet} =1{1 session} other{{count} sessions}}'**
  String focusSessions(int count);

  /// No description provided for @focusPickPreset.
  ///
  /// In en, this message translates to:
  /// **'Quick pick'**
  String get focusPickPreset;

  /// No description provided for @focusMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String focusMinutesShort(int minutes);

  /// No description provided for @focusKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen awake'**
  String get focusKeepScreenOn;

  /// No description provided for @focusAbandon.
  ///
  /// In en, this message translates to:
  /// **'Discard session?'**
  String get focusAbandon;

  /// No description provided for @focusAbandonBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress in this session will not be saved.'**
  String get focusAbandonBody;

  /// No description provided for @widgetPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Home screen widgets'**
  String get widgetPreviewTitle;

  /// No description provided for @widgetPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add these from your home screen\'s widget picker.'**
  String get widgetPreviewSubtitle;

  /// No description provided for @widgetRingTitle.
  ///
  /// In en, this message translates to:
  /// **'Habit ring'**
  String get widgetRingTitle;

  /// No description provided for @widgetTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus timer'**
  String get widgetTimerTitle;

  /// No description provided for @widgetStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get widgetStreakTitle;

  /// No description provided for @widgetTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get widgetTodayTitle;

  /// No description provided for @widgetWaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get widgetWaterTitle;

  /// No description provided for @insightsPartial.
  ///
  /// In en, this message translates to:
  /// **'{logged} of {needed} days logged'**
  String insightsPartial(int logged, int needed);

  /// No description provided for @insightsEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your insights are building'**
  String get insightsEarlyTitle;

  /// No description provided for @journalToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s entry'**
  String get journalToday;

  /// No description provided for @journalPast.
  ///
  /// In en, this message translates to:
  /// **'Earlier entries'**
  String get journalPast;

  /// No description provided for @journalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get journalEdit;

  /// No description provided for @journalDelete.
  ///
  /// In en, this message translates to:
  /// **'Clear entry'**
  String get journalDelete;

  /// No description provided for @journalUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get journalUnsaved;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupTitle;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {timestamp}'**
  String backupLast(String timestamp);

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get backupNever;

  /// No description provided for @backupEncrypt.
  ///
  /// In en, this message translates to:
  /// **'Protect with a passphrase'**
  String get backupEncrypt;

  /// No description provided for @backupExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get backupExportJson;

  /// No description provided for @backupExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get backupExportCsv;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace all current data with this backup?'**
  String get restoreConfirm;

  /// No description provided for @restoreVersionMismatch.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of the app'**
  String get restoreVersionMismatch;

  /// No description provided for @restoreChecksumFailed.
  ///
  /// In en, this message translates to:
  /// **'This file is corrupted or was modified'**
  String get restoreChecksumFailed;

  /// No description provided for @restoreMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get restoreMerge;

  /// No description provided for @restoreReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get restoreReplace;

  /// No description provided for @restoreDryRun.
  ///
  /// In en, this message translates to:
  /// **'{days} days, {habits} habits, {journals} journal entries'**
  String restoreDryRun(int days, int habits, int journals);

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restoreSuccess;

  /// No description provided for @passphrasePrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter passphrase'**
  String get passphrasePrompt;

  /// No description provided for @trophyHallTitle.
  ///
  /// In en, this message translates to:
  /// **'Trophy Hall'**
  String get trophyHallTitle;

  /// No description provided for @trophyLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get trophyLocked;

  /// No description provided for @trophyUnlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked {date}'**
  String trophyUnlockedOn(String date);

  /// No description provided for @emptyTrophyTitle.
  ///
  /// In en, this message translates to:
  /// **'No trophies yet'**
  String get emptyTrophyTitle;

  /// No description provided for @emptyTrophyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your first habit to open the hall.'**
  String get emptyTrophyBody;

  /// No description provided for @achievementProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String achievementProgress(int current, int target);

  /// No description provided for @arcCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Arc Complete'**
  String get arcCompleteTitle;

  /// No description provided for @arcCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{days} days. Here\'s what you built.'**
  String arcCompleteSubtitle(int days);

  /// No description provided for @startNewArc.
  ///
  /// In en, this message translates to:
  /// **'Start a new arc'**
  String get startNewArc;

  /// No description provided for @carryHabits.
  ///
  /// In en, this message translates to:
  /// **'Carry over my habits'**
  String get carryHabits;

  /// No description provided for @carryStats.
  ///
  /// In en, this message translates to:
  /// **'Keep my stats'**
  String get carryStats;

  /// No description provided for @shareCard.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCard;

  /// No description provided for @recapTotalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get recapTotalXp;

  /// No description provided for @recapBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get recapBestStreak;

  /// No description provided for @recapCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get recapCompletionRate;

  /// No description provided for @recapPerfectDays.
  ///
  /// In en, this message translates to:
  /// **'Perfect days'**
  String get recapPerfectDays;

  /// No description provided for @recapDay1.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get recapDay1;

  /// No description provided for @recapFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get recapFinal;

  /// No description provided for @arcHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Past arcs'**
  String get arcHistoryTitle;

  /// No description provided for @permissionNotificationRationale.
  ///
  /// In en, this message translates to:
  /// **'Happy Days needs notification access to remind you. Nothing leaves your device.'**
  String get permissionNotificationRationale;

  /// No description provided for @permissionExactAlarmRationale.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms keep your 5:30 wake-up on time.'**
  String get permissionExactAlarmRationale;

  /// No description provided for @permissionActivityRationale.
  ///
  /// In en, this message translates to:
  /// **'Step tracking reads your device\'s built-in step counter. No location is used.'**
  String get permissionActivityRationale;

  /// No description provided for @permissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permissionAllow;

  /// No description provided for @permissionNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get permissionNotNow;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permissionOpenSettings;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @achievementNamePrefix.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get achievementNamePrefix;

  /// No description provided for @achFirstBlood.
  ///
  /// In en, this message translates to:
  /// **'First Blood'**
  String get achFirstBlood;

  /// No description provided for @achFirstBloodDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first habit'**
  String get achFirstBloodDesc;

  /// No description provided for @achPerfectDay.
  ///
  /// In en, this message translates to:
  /// **'Flawless'**
  String get achPerfectDay;

  /// No description provided for @achPerfectDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete every scheduled habit in one day'**
  String get achPerfectDayDesc;

  /// No description provided for @achStreak3.
  ///
  /// In en, this message translates to:
  /// **'Ignition'**
  String get achStreak3;

  /// No description provided for @achStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'3-day streak'**
  String get achStreak3Desc;

  /// No description provided for @achStreak7.
  ///
  /// In en, this message translates to:
  /// **'One Week In'**
  String get achStreak7;

  /// No description provided for @achStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'7-day streak'**
  String get achStreak7Desc;

  /// No description provided for @achStreak14.
  ///
  /// In en, this message translates to:
  /// **'Fortnight'**
  String get achStreak14;

  /// No description provided for @achStreak14Desc.
  ///
  /// In en, this message translates to:
  /// **'14-day streak'**
  String get achStreak14Desc;

  /// No description provided for @achStreak30.
  ///
  /// In en, this message translates to:
  /// **'Habit Formed'**
  String get achStreak30;

  /// No description provided for @achStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'30-day streak'**
  String get achStreak30Desc;

  /// No description provided for @achStreak60.
  ///
  /// In en, this message translates to:
  /// **'Unshakeable'**
  String get achStreak60;

  /// No description provided for @achStreak60Desc.
  ///
  /// In en, this message translates to:
  /// **'60-day streak'**
  String get achStreak60Desc;

  /// No description provided for @achStreak100.
  ///
  /// In en, this message translates to:
  /// **'Century'**
  String get achStreak100;

  /// No description provided for @achStreak100Desc.
  ///
  /// In en, this message translates to:
  /// **'100-day streak'**
  String get achStreak100Desc;

  /// No description provided for @achPerfectArc.
  ///
  /// In en, this message translates to:
  /// **'The Full Arc'**
  String get achPerfectArc;

  /// No description provided for @achPerfectArcDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete the whole arc with no unshielded miss'**
  String get achPerfectArcDesc;

  /// No description provided for @achTenPerfectDays.
  ///
  /// In en, this message translates to:
  /// **'Double Digits'**
  String get achTenPerfectDays;

  /// No description provided for @achTenPerfectDaysDesc.
  ///
  /// In en, this message translates to:
  /// **'10 total perfect days'**
  String get achTenPerfectDaysDesc;

  /// No description provided for @achEarlyRiser30.
  ///
  /// In en, this message translates to:
  /// **'Dawn Patrol'**
  String get achEarlyRiser30;

  /// No description provided for @achEarlyRiser30Desc.
  ///
  /// In en, this message translates to:
  /// **'30 early wake-ups logged'**
  String get achEarlyRiser30Desc;

  /// No description provided for @achGym50.
  ///
  /// In en, this message translates to:
  /// **'Iron Contract'**
  String get achGym50;

  /// No description provided for @achGym50Desc.
  ///
  /// In en, this message translates to:
  /// **'50 gym sessions logged'**
  String get achGym50Desc;

  /// No description provided for @achSteps500k.
  ///
  /// In en, this message translates to:
  /// **'Half a Million'**
  String get achSteps500k;

  /// No description provided for @achSteps500kDesc.
  ///
  /// In en, this message translates to:
  /// **'500,000 cumulative steps'**
  String get achSteps500kDesc;

  /// No description provided for @achGratitude100.
  ///
  /// In en, this message translates to:
  /// **'Grateful Heart'**
  String get achGratitude100;

  /// No description provided for @achGratitude100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 gratitude entries'**
  String get achGratitude100Desc;

  /// No description provided for @achClean30.
  ///
  /// In en, this message translates to:
  /// **'Clean Engine'**
  String get achClean30;

  /// No description provided for @achClean30Desc.
  ///
  /// In en, this message translates to:
  /// **'30 no-junk-food days'**
  String get achClean30Desc;

  /// No description provided for @achHydrated60.
  ///
  /// In en, this message translates to:
  /// **'Water Only'**
  String get achHydrated60;

  /// No description provided for @achHydrated60Desc.
  ///
  /// In en, this message translates to:
  /// **'60 water-only days'**
  String get achHydrated60Desc;

  /// No description provided for @achLevel10.
  ///
  /// In en, this message translates to:
  /// **'Frost Initiate'**
  String get achLevel10;

  /// No description provided for @achLevel10Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach Level 10'**
  String get achLevel10Desc;

  /// No description provided for @achLevel25.
  ///
  /// In en, this message translates to:
  /// **'Iron Ascetic'**
  String get achLevel25;

  /// No description provided for @achLevel25Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach Level 25'**
  String get achLevel25Desc;

  /// No description provided for @achLevel50.
  ///
  /// In en, this message translates to:
  /// **'Winter Sovereign'**
  String get achLevel50;

  /// No description provided for @achLevel50Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach Level 50'**
  String get achLevel50Desc;

  /// No description provided for @achBalanced.
  ///
  /// In en, this message translates to:
  /// **'Well Rounded'**
  String get achBalanced;

  /// No description provided for @achBalancedDesc.
  ///
  /// In en, this message translates to:
  /// **'All five stat scores above 50 at once'**
  String get achBalancedDesc;

  /// No description provided for @achPhoenix.
  ///
  /// In en, this message translates to:
  /// **'Phoenix Protocol'**
  String get achPhoenix;

  /// No description provided for @achPhoenixDesc.
  ///
  /// In en, this message translates to:
  /// **'Return after a missed day and complete 7 straight'**
  String get achPhoenixDesc;

  /// No description provided for @achNoShields30.
  ///
  /// In en, this message translates to:
  /// **'Bare Handed'**
  String get achNoShields30;

  /// No description provided for @achNoShields30Desc.
  ///
  /// In en, this message translates to:
  /// **'30 consecutive days with zero shields consumed'**
  String get achNoShields30Desc;

  /// No description provided for @achFirstBackup.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get achFirstBackup;

  /// No description provided for @achFirstBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first backup'**
  String get achFirstBackupDesc;

  /// No description provided for @achArchitect.
  ///
  /// In en, this message translates to:
  /// **'Architect'**
  String get achArchitect;

  /// No description provided for @achArchitectDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first custom habit'**
  String get achArchitectDesc;

  /// No description provided for @rankEmberSpark.
  ///
  /// In en, this message translates to:
  /// **'Ember Spark'**
  String get rankEmberSpark;

  /// No description provided for @rankFrostInitiate.
  ///
  /// In en, this message translates to:
  /// **'Frost Initiate'**
  String get rankFrostInitiate;

  /// No description provided for @rankIronAscetic.
  ///
  /// In en, this message translates to:
  /// **'Iron Ascetic'**
  String get rankIronAscetic;

  /// No description provided for @rankStormWarden.
  ///
  /// In en, this message translates to:
  /// **'Storm Warden'**
  String get rankStormWarden;

  /// No description provided for @rankArcChampion.
  ///
  /// In en, this message translates to:
  /// **'Arc Champion'**
  String get rankArcChampion;

  /// No description provided for @rankWinterSovereign.
  ///
  /// In en, this message translates to:
  /// **'Winter Sovereign'**
  String get rankWinterSovereign;

  /// No description provided for @bossWeekBanner.
  ///
  /// In en, this message translates to:
  /// **'Boss week active'**
  String get bossWeekBanner;

  /// No description provided for @bossWeekReward.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP on completion'**
  String bossWeekReward(int xp);

  /// No description provided for @notifActionWakeDone.
  ///
  /// In en, this message translates to:
  /// **'Mark wake-up done'**
  String get notifActionWakeDone;

  /// No description provided for @notifActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze 15m'**
  String get notifActionSnooze;

  /// No description provided for @notifActionLogWorkout.
  ///
  /// In en, this message translates to:
  /// **'Log workout'**
  String get notifActionLogWorkout;

  /// No description provided for @notifActionRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get notifActionRestDay;

  /// No description provided for @notifActionOpenDebrief.
  ///
  /// In en, this message translates to:
  /// **'Open debrief'**
  String get notifActionOpenDebrief;

  /// No description provided for @notifActionQuickGratitude.
  ///
  /// In en, this message translates to:
  /// **'Quick gratitude'**
  String get notifActionQuickGratitude;

  /// No description provided for @radarSemanticSummary.
  ///
  /// In en, this message translates to:
  /// **'Stat radar. {summary}'**
  String radarSemanticSummary(String summary);

  /// No description provided for @statScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'{stat}: {score} out of 100'**
  String statScoreLabel(String stat, int score);

  /// No description provided for @tabularFallback.
  ///
  /// In en, this message translates to:
  /// **'View as table'**
  String get tabularFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nl',
    'pl',
    'pt',
    'ru',
    'sw',
    'ta',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
