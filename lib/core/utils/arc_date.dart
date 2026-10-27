import 'package:intl/intl.dart';

/// The single source of date truth for the whole app.
///
/// edge_case_handling.day_rollover: "All date_key resolution runs through a
/// single effectiveDateKey(DateTime) helper - never DateTime.now().day inline."
/// Nothing outside this file is allowed to format a date key.
abstract final class ArcDate {
  static final DateFormat _keyFormat = DateFormat('yyyy-MM-dd');

  /// The calendar day a moment *belongs to*, given the user's rollover hour.
  ///
  /// With the default rollover of 04:00, a log written at 01:30 on the 5th
  /// counts for the 4th - which is what someone finishing a late night
  /// actually means.
  static DateTime effectiveDate(DateTime moment, int rolloverHour) {
    final local = moment.isUtc ? moment.toLocal() : moment;
    final shifted = local.hour < rolloverHour
        ? local.subtract(const Duration(days: 1))
        : local;
    return DateTime(shifted.year, shifted.month, shifted.day);
  }

  static String effectiveDateKey(DateTime moment, int rolloverHour) =>
      _keyFormat.format(effectiveDate(moment, rolloverHour));

  /// Midnight-normalised calendar day, ignoring rollover. Use for arithmetic
  /// over dates that are already calendar days.
  static DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static String keyOf(DateTime day) => _keyFormat.format(dayOnly(day));

  static DateTime? parseKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  /// Whole days between two calendar days. DST-safe: we count calendar days,
  /// we do not divide a Duration by 24h.
  static int daysBetween(DateTime from, DateTime to) {
    final a = dayOnly(from);
    final b = dayOnly(to);
    return (b.difference(a).inHours / 24).round();
  }

  /// 1-based arc day. Day 1 is [arcStart] itself.
  static int arcDayNumber(DateTime arcStart, DateTime day) =>
      daysBetween(arcStart, day) + 1;

  /// 1-based arc week; week 1 covers arc days 1-7.
  static int arcWeekNumber(DateTime arcStart, DateTime day) {
    final n = arcDayNumber(arcStart, day);
    if (n < 1) return 0;
    return ((n - 1) ~/ 7) + 1;
  }

  /// Monday of the ISO week containing [day] - weekly_target habits reset here.
  static DateTime startOfIsoWeek(DateTime day) {
    final d = dayOnly(day);
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }

  static List<DateTime> daysInRange(DateTime start, DateTime end) {
    final out = <DateTime>[];
    var cursor = dayOnly(start);
    final last = dayOnly(end);
    while (!cursor.isAfter(last)) {
      out.add(cursor);
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 1);
    }
    return out;
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Formats for display in the active locale - never manual concatenation
  /// (localization_engine.formatting_rules).
  static String formatMedium(DateTime d, String locale) =>
      DateFormat.yMMMd(locale).format(d);

  static String formatDayMonth(DateTime d, String locale) =>
      DateFormat.MMMd(locale).format(d);

  static String formatWeekdayShort(DateTime d, String locale) =>
      DateFormat.E(locale).format(d);

  static String formatWeekdayFull(int weekday, String locale) {
    // 2024-01-01 was a Monday, so this maps 1..7 onto real weekday names
    // without hardcoding any English.
    final ref = DateTime(2024, 1, weekday);
    return DateFormat.EEEE(locale).format(ref);
  }

  static String formatTimestamp(DateTime d, String locale) =>
      DateFormat.yMMMd(locale).add_jm().format(d.toLocal());

  static String formatHourLabel(int hour, String locale) =>
      DateFormat.j(locale).format(DateTime(2024, 1, 1, hour));

  /// Parses 'HH:mm' into (hour, minute); returns null on anything else.
  static (int, int)? parseTimeOfDay(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return (h, m);
  }

  static String formatHHmm(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
