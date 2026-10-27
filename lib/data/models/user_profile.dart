import 'package:isar_community/isar.dart';

import '../../core/constants/app_constants.dart';

part 'user_profile.g.dart';

/// data_models.UserProfile.stat_scores - raw XP per stat.
///
/// These are *raw* totals. The radar plots a normalised projection computed at
/// read time (gamification_engine.stat_normalization), never these numbers.
@embedded
class StatScores {
  int discipline = 0;
  int vitality = 0;
  int focus = 0;
  int strength = 0;
  int spirit = 0;

  StatScores();

  int operator [](String stat) => switch (stat) {
    StatKeys.discipline => discipline,
    StatKeys.vitality => vitality,
    StatKeys.focus => focus,
    StatKeys.strength => strength,
    StatKeys.spirit => spirit,
    _ => 0,
  };

  void add(String stat, int xp) {
    switch (stat) {
      case StatKeys.discipline:
        discipline += xp;
      case StatKeys.vitality:
        vitality += xp;
      case StatKeys.focus:
        focus += xp;
      case StatKeys.strength:
        strength += xp;
      case StatKeys.spirit:
        spirit += xp;
    }
  }

  void reset() {
    discipline = vitality = focus = strength = spirit = 0;
  }

  Map<String, dynamic> toJson() => {
    'discipline': discipline,
    'vitality': vitality,
    'focus': focus,
    'strength': strength,
    'spirit': spirit,
  };

  static StatScores fromJson(Map<String, dynamic> j) => StatScores()
    ..discipline = (j['discipline'] as num?)?.toInt() ?? 0
    ..vitality = (j['vitality'] as num?)?.toInt() ?? 0
    ..focus = (j['focus'] as num?)?.toInt() ?? 0
    ..strength = (j['strength'] as num?)?.toInt() ?? 0
    ..spirit = (j['spirit'] as num?)?.toInt() ?? 0;
}

/// data_models.UserProfile - a singleton row (id == 1).
@collection
class UserProfile {
  static const int singletonId = 1;

  Id id = singletonId;

  String fullName = '';
  String nickname = '';

  /// 'system' | 'light' | 'dark'
  String themePreference = 'system';

  DateTime arcStartDate = DateTime.now();
  DateTime arcEndDate = DateTime.now().add(
    const Duration(days: AppConstants.defaultArcLengthDays - 1),
  );
  int arcLengthDays = AppConstants.defaultArcLengthDays;

  int currentArcId = 0;

  int currentLevel = 1;
  int totalXp = 0;

  int currentStreak = 0;
  int bestStreak = 0;

  int shieldsHeld = 0;
  int shieldsConsumedTotal = 0;

  StatScores statScores = StatScores();

  /// Set once onboarding completes; gates the app shell.
  bool onboardingComplete = false;

  /// The day the app was installed - everything before it is pre-install.
  DateTime installedAt = DateTime.now();

  UserProfile();

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'nickname': nickname,
    'theme_preference': themePreference,
    'arc_start_date': arcStartDate.toIso8601String(),
    'arc_end_date': arcEndDate.toIso8601String(),
    'arc_length_days': arcLengthDays,
    'current_arc_id': currentArcId,
    'current_level': currentLevel,
    'total_xp': totalXp,
    'current_streak': currentStreak,
    'best_streak': bestStreak,
    'shields_held': shieldsHeld,
    'shields_consumed_total': shieldsConsumedTotal,
    'stat_scores': statScores.toJson(),
    'onboarding_complete': onboardingComplete,
    'installed_at': installedAt.toIso8601String(),
  };

  static UserProfile fromJson(Map<String, dynamic> j) => UserProfile()
    ..id = (j['id'] as num?)?.toInt() ?? singletonId
    ..fullName = j['full_name'] as String? ?? ''
    ..nickname = j['nickname'] as String? ?? ''
    ..themePreference = j['theme_preference'] as String? ?? 'system'
    ..arcStartDate =
        DateTime.tryParse(j['arc_start_date'] as String? ?? '') ??
        DateTime.now()
    ..arcEndDate =
        DateTime.tryParse(j['arc_end_date'] as String? ?? '') ?? DateTime.now()
    ..arcLengthDays =
        (j['arc_length_days'] as num?)?.toInt() ??
        AppConstants.defaultArcLengthDays
    ..currentArcId = (j['current_arc_id'] as num?)?.toInt() ?? 0
    ..currentLevel = (j['current_level'] as num?)?.toInt() ?? 1
    ..totalXp = (j['total_xp'] as num?)?.toInt() ?? 0
    ..currentStreak = (j['current_streak'] as num?)?.toInt() ?? 0
    ..bestStreak = (j['best_streak'] as num?)?.toInt() ?? 0
    ..shieldsHeld = (j['shields_held'] as num?)?.toInt() ?? 0
    ..shieldsConsumedTotal = (j['shields_consumed_total'] as num?)?.toInt() ?? 0
    ..statScores = j['stat_scores'] == null
        ? StatScores()
        : StatScores.fromJson(
            Map<String, dynamic>.from(j['stat_scores'] as Map),
          )
    ..onboardingComplete = j['onboarding_complete'] as bool? ?? false
    ..installedAt =
        DateTime.tryParse(j['installed_at'] as String? ?? '') ?? DateTime.now();
}
