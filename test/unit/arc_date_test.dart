import 'package:arccore/core/utils/arc_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('effectiveDateKey', () {
    test('a 01:30 log counts for the previous day at the default rollover', () {
      final moment = DateTime(2026, 10, 5, 1, 30);
      expect(ArcDate.effectiveDateKey(moment, 4), '2026-10-04');
    });

    test('a 04:00 log counts for the current day', () {
      expect(
        ArcDate.effectiveDateKey(DateTime(2026, 10, 5, 4), 4),
        '2026-10-05',
      );
    });

    test('a rollover of 0 disables the shift entirely', () {
      expect(
        ArcDate.effectiveDateKey(DateTime(2026, 10, 5, 0, 30), 0),
        '2026-10-05',
      );
    });

    test('shifts correctly across a month boundary', () {
      expect(
        ArcDate.effectiveDateKey(DateTime(2026, 11, 1, 2), 4),
        '2026-10-31',
      );
    });

    test('shifts correctly across a year boundary', () {
      expect(
        ArcDate.effectiveDateKey(DateTime(2027, 1, 1, 3, 59), 4),
        '2026-12-31',
      );
    });
  });

  group('daysBetween', () {
    test('counts calendar days, not 24h blocks', () {
      expect(
        ArcDate.daysBetween(DateTime(2026, 9, 1), DateTime(2026, 12, 31)),
        121,
      );
    });

    test('survives a spring-forward DST transition', () {
      // US DST 2026: 8 March. A naive Duration division would return 0 here on
      // a machine in a DST zone because the day is only 23 hours long.
      final a = DateTime(2026, 3, 8);
      final b = DateTime(2026, 3, 9);
      expect(ArcDate.daysBetween(a, b), 1);
    });

    test('survives a fall-back DST transition', () {
      expect(
        ArcDate.daysBetween(DateTime(2026, 11, 1), DateTime(2026, 11, 2)),
        1,
      );
    });

    test('is negative when the range runs backwards', () {
      expect(
        ArcDate.daysBetween(DateTime(2026, 9, 10), DateTime(2026, 9, 1)),
        -9,
      );
    });
  });

  group('arc numbering', () {
    final start = DateTime(2026, 9, 1);

    test('day 1 is the start date itself', () {
      expect(ArcDate.arcDayNumber(start, start), 1);
      expect(ArcDate.arcDayNumber(start, DateTime(2026, 12, 31)), 122);
    });

    test('week 1 covers arc days 1-7', () {
      expect(ArcDate.arcWeekNumber(start, start), 1);
      expect(ArcDate.arcWeekNumber(start, DateTime(2026, 9, 7)), 1);
      expect(ArcDate.arcWeekNumber(start, DateTime(2026, 9, 8)), 2);
      expect(ArcDate.arcWeekNumber(start, DateTime(2026, 9, 22)), 4);
    });
  });

  group('ISO week', () {
    test('resets on Monday', () {
      final wednesday = DateTime(2026, 10, 7);
      expect(wednesday.weekday, DateTime.wednesday);
      final monday = ArcDate.startOfIsoWeek(wednesday);
      expect(monday.weekday, DateTime.monday);
      expect(monday, DateTime(2026, 10, 5));
    });

    test('a Monday is its own week start', () {
      final monday = DateTime(2026, 10, 5);
      expect(ArcDate.startOfIsoWeek(monday), monday);
    });

    test('a Sunday belongs to the week that began six days earlier', () {
      expect(
        ArcDate.startOfIsoWeek(DateTime(2026, 10, 11)),
        DateTime(2026, 10, 5),
      );
    });
  });

  group('time parsing', () {
    test('round-trips HH:mm', () {
      expect(ArcDate.parseTimeOfDay('05:30'), (5, 30));
      expect(ArcDate.formatHHmm(5, 30), '05:30');
      expect(ArcDate.formatHHmm(21, 5), '21:05');
    });

    test('rejects malformed input rather than guessing', () {
      expect(ArcDate.parseTimeOfDay('530'), isNull);
      expect(ArcDate.parseTimeOfDay('25:00'), isNull);
      expect(ArcDate.parseTimeOfDay('05:99'), isNull);
      expect(ArcDate.parseTimeOfDay(''), isNull);
    });
  });

  test('daysInRange is inclusive at both ends', () {
    final days = ArcDate.daysInRange(
      DateTime(2026, 9, 1),
      DateTime(2026, 9, 5),
    );
    expect(days.length, 5);
    expect(days.first, DateTime(2026, 9, 1));
    expect(days.last, DateTime(2026, 9, 5));
  });
}
