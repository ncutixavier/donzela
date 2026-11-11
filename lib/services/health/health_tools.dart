import '../../core/utils/dates.dart';

/// Estimates for the Health tools. Pure functions, so they can be tested
/// without the screens. Every result is an estimate, not medical advice.
class HealthTools {
  HealthTools._();

  static const defaultCycleLength = 28;
  static const minCycleLength = 21;
  static const maxCycleLength = 45;

  /// Days from ovulation to the next period. Fairly constant from person to person.
  static const lutealDays = 14;

  /// A pregnancy is counted from the first day of the last period.
  static const pregnancyDays = 280;
  static const maxPregnancyWeeks = 42;

  static bool isValidCycleLength(int days) => days >= minCycleLength && days <= maxCycleLength;

  /// Next period, from the first day of the last period and the usual cycle length.
  static DateTime nextPeriod(DateTime lastStart, int cycleLength) =>
      addDays(dayOnly(lastStart), cycleLength);

  /// Ovulation, about [lutealDays] before the next period.
  static DateTime ovulation(DateTime lastStart, int cycleLength) =>
      addDays(nextPeriod(lastStart, cycleLength), -lutealDays);

  /// Days when pregnancy is possible: the days before ovulation plus the day after.
  static ({DateTime from, DateTime to}) fertileWindow(DateTime lastStart, int cycleLength) {
    final ov = ovulation(lastStart, cycleLength);
    return (from: addDays(ov, -5), to: addDays(ov, 1));
  }

  /// When an embryo would usually implant in the womb, a few days after ovulation.
  static ({DateTime from, DateTime to}) implantationWindow(DateTime lastStart, int cycleLength) {
    final ov = ovulation(lastStart, cycleLength);
    return (from: addDays(ov, 6), to: addDays(ov, 12));
  }

  /// Estimated due date (first day of the last period + 280 days). A longer or
  /// shorter usual cycle moves it by the same number of days.
  static DateTime dueDate(DateTime lastStart, {int cycleLength = defaultCycleLength}) =>
      addDays(dayOnly(lastStart), pregnancyDays + (cycleLength - defaultCycleLength));

  /// Weeks and days since the first day of the last period, on [today].
  static ({int weeks, int days}) pregnancyAge(DateTime lastStart, DateTime today) {
    final total = daysBetween(lastStart, today);
    return (weeks: total ~/ 7, days: total % 7);
  }

  /// Length of a cycle from the first days of two consecutive periods.
  static int cycleLengthBetween(DateTime previousStart, DateTime nextStart) =>
      daysBetween(previousStart, nextStart);

  /// Weeks to whole months and remaining weeks, for example 10 weeks is 2 months and 1 week.
  static ({int months, int weeks}) weeksToMonths(int weeks) {
    const weeksPerMonth = 4.345;
    final months = (weeks / weeksPerMonth).floor();
    final remaining = (weeks - months * weeksPerMonth).round();
    return (months: months, weeks: remaining);
  }
}
