import 'package:flutter/material.dart';

/// The habit / achievement icon registry.
///
/// Models persist an int codepoint, but rendering goes through [resolve] rather
/// than `IconData(codePoint, fontFamily: 'MaterialIcons')`. Two reasons:
///
///  * correctness - a raw codepoint that is not in the font renders as an
///    arbitrary unrelated glyph, silently;
///  * tree-shaking - `flutter build` strips unreferenced icons, and const
///    `Icons.*` references in [all] are what keep this set in the font subset.
abstract final class AppIcons {
  /// Every icon a habit may use, in a stable order. Adding to the end is safe;
  /// reordering is not, because stored habits reference codepoints.
  static const List<IconData> all = [
    Icons.check_circle_outline,
    Icons.alarm,
    Icons.water_drop,
    Icons.restaurant,
    Icons.bedtime,
    Icons.fitness_center,
    Icons.directions_walk,
    Icons.no_cell,
    Icons.directions_run,
    Icons.favorite,
    Icons.edit_note,
    Icons.shower,
    Icons.self_improvement,
    Icons.egg_alt,
    Icons.medication,
    Icons.cleaning_services,
    Icons.no_drinks,
    Icons.menu_book,
    Icons.spa,
    Icons.do_not_disturb_on,
    Icons.psychology,
    Icons.schedule,
    Icons.mobile_off,
    Icons.account_balance_wallet,
    Icons.article,
    Icons.nightlight_round,
    Icons.wb_sunny,
    Icons.inventory_2,
    Icons.build,
    Icons.translate,
    Icons.rocket_launch,
    Icons.edit,
    Icons.call,
    Icons.volunteer_activism,
    Icons.local_fire_department,
    Icons.star,
    Icons.military_tech,
    Icons.balance,
    Icons.emoji_events,
    Icons.shield_moon,
    Icons.bolt,
    Icons.local_drink,
    Icons.sports_gymnastics,
    Icons.headphones,
    Icons.savings,
    Icons.pets,
  ];

  static final Map<int, IconData> _byCodePoint = {
    for (final icon in all) icon.codePoint: icon,
  };

  /// Codepoint -> const IconData. Unknown values fall back rather than
  /// rendering a wrong glyph.
  static IconData resolve(int codePoint) =>
      _byCodePoint[codePoint] ?? Icons.check_circle_outline;

  // Named handles for the preset catalogue, so the presets read as intent
  // rather than as magic numbers.
  static const alarm = Icons.alarm;
  static const water = Icons.water_drop;
  static const food = Icons.restaurant;
  static const sleep = Icons.bedtime;
  static const gym = Icons.fitness_center;
  static const steps = Icons.directions_walk;
  static const noPhone = Icons.no_cell;
  static const walk = Icons.directions_run;
  static const gratitude = Icons.favorite;
  static const notes = Icons.edit_note;
  static const coldShower = Icons.shower;
  static const stretch = Icons.self_improvement;
  static const protein = Icons.egg_alt;
  static const vitamins = Icons.medication;
  static const floss = Icons.cleaning_services;
  static const noAlcohol = Icons.no_drinks;
  static const read = Icons.menu_book;
  static const meditate = Icons.spa;
  static const noSocial = Icons.do_not_disturb_on;
  static const deepWork = Icons.psychology;
  static const plan = Icons.schedule;
  static const noScreens = Icons.mobile_off;
  static const budget = Icons.account_balance_wallet;
  static const journal = Icons.article;
  static const pray = Icons.nightlight_round;
  static const sunlight = Icons.wb_sunny;
  static const tidy = Icons.inventory_2;
  static const craft = Icons.build;
  static const language = Icons.translate;
  static const ship = Icons.rocket_launch;
  static const call = Icons.call;
  static const kindness = Icons.volunteer_activism;

  /// Achievement id -> emblem. Lives here rather than in the evaluator so the
  /// domain layer stays free of Flutter types.
  static IconData forAchievement(String id) => switch (id) {
    'first_blood' => Icons.bolt,
    'perfect_day' || 'ten_perfect_days' => Icons.star,
    'streak_3' ||
    'streak_7' ||
    'streak_14' ||
    'streak_30' ||
    'streak_60' ||
    'streak_100' => Icons.local_fire_department,
    'perfect_arc' => Icons.emoji_events,
    'early_riser_30' => Icons.alarm,
    'gym_50' => Icons.fitness_center,
    'steps_500k' => Icons.directions_walk,
    'gratitude_100' => Icons.favorite,
    'clean_30' => Icons.restaurant,
    'hydrated_60' => Icons.water_drop,
    'level_10' || 'level_25' || 'level_50' => Icons.military_tech,
    'balanced' => Icons.balance,
    'phoenix' => Icons.auto_awesome,
    'no_shields_30' => Icons.shield_moon,
    'first_backup' => Icons.savings,
    'architect' => Icons.build,
    _ => Icons.emoji_events,
  };

  // Achievement emblems.
  static const streak = Icons.local_fire_department;
  static const milestone = Icons.star;
  static const level = Icons.military_tech;
  static const balanced = Icons.balance;
  static const trophy = Icons.emoji_events;
  static const shield = Icons.shield_moon;
  static const comeback = Icons.bolt;
  static const meta = Icons.savings;
}
