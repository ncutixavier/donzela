import 'package:donzela/services/health/health_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final start = DateTime(2026, 11, 1);

  test('a 28-day cycle: next period on day 28, ovulation on day 14', () {
    expect(HealthTools.nextPeriod(start, 28), DateTime(2026, 11, 29));
    expect(HealthTools.ovulation(start, 28), DateTime(2026, 11, 15));
  });

  test('fertile window runs from 5 days before ovulation to 1 day after', () {
    final w = HealthTools.fertileWindow(start, 28);
    expect(w.from, DateTime(2026, 11, 10));
    expect(w.to, DateTime(2026, 11, 16));
  });

  test('implantation is 6 to 12 days after ovulation', () {
    final w = HealthTools.implantationWindow(start, 28);
    expect(w.from, DateTime(2026, 11, 21));
    expect(w.to, DateTime(2026, 11, 27));
  });

  test('due date is 280 days from the last period for a 28-day cycle', () {
    expect(HealthTools.dueDate(start), DateTime(2027, 8, 8));
  });

  test('a longer cycle moves the due date later by the same days', () {
    expect(HealthTools.dueDate(start, cycleLength: 32),
        HealthTools.dueDate(start).add(const Duration(days: 4)));
  });

  test('pregnancy age in weeks and days', () {
    final age = HealthTools.pregnancyAge(start, DateTime(2026, 12, 20));
    expect(age.weeks, 7);
    expect(age.days, 0);
  });

  test('cycle length between two period starts', () {
    expect(HealthTools.cycleLengthBetween(DateTime(2026, 1, 1), DateTime(2026, 1, 29)), 28);
  });

  test('weeks convert to months and weeks', () {
    final ten = HealthTools.weeksToMonths(10);
    expect(ten.months, 2);
    expect(ten.weeks, 1);
  });

  test('only cycle lengths from 21 to 45 days are accepted', () {
    expect(HealthTools.isValidCycleLength(20), isFalse);
    expect(HealthTools.isValidCycleLength(21), isTrue);
    expect(HealthTools.isValidCycleLength(45), isTrue);
    expect(HealthTools.isValidCycleLength(46), isFalse);
  });

  test('the next period range covers the usual number of days', () {
    final r = HealthTools.periodRange(start, 28, 5);
    expect(r.from, DateTime(2026, 11, 29));
    expect(r.to, DateTime(2026, 12, 3));
  });

  test('follicular runs from the last period to ovulation; luteal from after ovulation to the day before the next period', () {
    final f = HealthTools.follicularRange(start, 28);
    expect(f.from, DateTime(2026, 11, 1));
    expect(f.to, DateTime(2026, 11, 15));
    final l = HealthTools.lutealRange(start, 28);
    expect(l.from, DateTime(2026, 11, 16));
    expect(l.to, DateTime(2026, 11, 28));
  });
}
