/// core_features.actionable_notifications.copy_variation
///
/// "Each channel draws its body text from a bundled pack of 20 localised
/// motivational lines, rotated deterministically by day index so it never feels
/// canned but stays fully offline."
///
/// These are English source lines. They live in Dart rather than the ARB because
/// they are a *pack* rotated by index; translators localise the pack file per
/// locale (see `packFor`) rather than 80 individual ARB keys.
abstract final class NotificationCopy {
  static const Map<String, List<String>> _en = {
    'morning_call': [
      "The arc doesn't wait. Get up.",
      'Day starts now. Feet on the floor.',
      'Nobody is coming. That is the good news.',
      'You set this alarm for a reason.',
      'Cold start. Warm finish.',
      'The version of you that quits is still asleep.',
      'One hard hour buys an easy day.',
      'Be the reason today goes well.',
      'Discipline is just memory of the goal.',
      'You already decided. Move.',
      'Winners are boring at 5:30am.',
      'This is the part nobody sees.',
      'Small start. Long arc.',
      'You can rest tonight. Not now.',
      'Momentum is built, not found.',
      'Your future self is watching.',
      'Do it before you feel like it.',
      'The bed is a trap. Escape.',
      'Show up. That is the whole trick.',
      'Another day on the sheet.',
    ],
    'nutrition_reminders': [
      'Water only. Clean plate. Stay sharp.',
      'Fuel, not comfort.',
      'What you eat now, you carry all afternoon.',
      'Hydrate before you snack.',
      'Simple food. Clear head.',
      'The junk is not worth the crash.',
      'Eat like the person you are becoming.',
      'Half your plate should be green.',
      'Slow down. Taste it.',
      'Phone down while you eat.',
      'One clean meal at a time.',
      'Cravings pass. Progress compounds.',
      'Protein first.',
      'Drink the water. All of it.',
      'You are not hungry. You are bored.',
      'Clean fuel, clean focus.',
      'Skip the sugar spike today.',
      'Your body keeps the receipts.',
      'Feed the arc.',
      'Discipline tastes fine after a week.',
    ],
    'activity_reminders': [
      'Gym or a 30 minute walk. Pick one.',
      'Move. Even badly. Just move.',
      'The hardest rep is the front door.',
      'Twenty minutes still counts.',
      'You never regret the workout.',
      'Strength is a deposit, not a gift.',
      'Sweat now, sleep better.',
      'Legs first. Excuses second.',
      'Ten thousand steps do not walk themselves.',
      'Show the body who runs this.',
      'Tired is not the same as done.',
      'Every session is a vote.',
      'Go get the easy win.',
      'Half effort beats no effort.',
      'The body follows the calendar.',
      'Move before the day moves you.',
      'One more set. One more day.',
      'Motion beats mood.',
      'You booked this with yourself.',
      'Earn the evening.',
    ],
    'evening_review': [
      "Log the day and note one thing you're grateful for.",
      'Close the loop before you sleep.',
      'What went right today?',
      'Two minutes. Then rest.',
      'Write it down or it never happened.',
      'Name one thing you are thankful for.',
      'The sheet is waiting.',
      'Honest log. Honest arc.',
      'Even a bad day deserves a record.',
      'Mark it, then let it go.',
      'Tomorrow starts with tonight.',
      'Debrief, not judgement.',
      'One line is enough.',
      'What would you repeat tomorrow?',
      'Gratitude, then lights out.',
      'You showed up. Log it.',
      'The streak needs a witness.',
      'Note the win, however small.',
      'Set tomorrow up before bed.',
      'Day logged. Well done.',
    ],
  };

  /// Deterministic rotation by day index - the same day always gets the same
  /// line, so the copy is stable across a reschedule.
  static String lineFor(String channel, int dayIndex, {String locale = 'en'}) {
    final pack = packFor(locale)[channel] ?? _en[channel]!;
    if (pack.isEmpty) return '';
    return pack[dayIndex.abs() % pack.length];
  }

  /// Localised packs slot in here. Locales without a pack fall back to English,
  /// which is the same policy gen_l10n uses for untranslated ARB keys.
  static Map<String, List<String>> packFor(String locale) => _en;

  static const List<String> channels = [
    'morning_call',
    'nutrition_reminders',
    'activity_reminders',
    'evening_review',
  ];
}
