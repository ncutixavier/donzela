/// Pure Dart cycle prediction engine (F3). No Flutter, no database, no UI.
///
/// Rules follow the implementation plan:
/// - Average cycle = mean of the last 3–6 valid completed cycles; fewer than
///   2 valid cycles → onboarding value.
/// - Cycles shorter than 18 or longer than 60 days are ignored for averaging.
/// - Next period = last start + average.
/// - Ovulation = next period − 14 days.
/// - Fertile window = ovulation − 5 … ovulation + 1.
library;

enum Confidence { low, medium, high }

enum DayPhase { period, predictedPeriod, fertile, ovulation, normal }

/// One logged cycle. Dates are day-only (time component ignored).
class CycleRecord {
  const CycleRecord({
    required this.start,
    this.end,
    this.isEstimate = false,
  });

  final DateTime start;

  /// Last day of the logged period. Null while the period is still open.
  final DateTime? end;
  final bool isEstimate;
}

class PredictionResult {
  const PredictionResult({
    required this.lastStart,
    required this.cycleDay,
    required this.nextPeriodStart,
    required this.ovulation,
    required this.fertileStart,
    required this.fertileEnd,
    required this.averageCycle,
    required this.confidence,
    required this.irregular,
    required this.late,
    required this.loggedCycles,
  });

  /// Empty result when nothing has been logged yet.
  const PredictionResult.empty(this.averageCycle)
      : lastStart = null,
        cycleDay = null,
        nextPeriodStart = null,
        ovulation = null,
        fertileStart = null,
        fertileEnd = null,
        confidence = Confidence.low,
        irregular = false,
        late = false,
        loggedCycles = 0;

  final DateTime? lastStart;
  final int? cycleDay;
  final DateTime? nextPeriodStart;
  final DateTime? ovulation;
  final DateTime? fertileStart;
  final DateTime? fertileEnd;
  final int averageCycle;
  final Confidence confidence;
  final bool irregular;
  final bool late;
  final int loggedCycles;
}

class PredictionService {
  const PredictionService();

  static const int minValidCycle = 18;
  static const int maxValidCycle = 60;
  static const int maxAverageWindow = 6;
  static const int irregularSpreadDays = 9;
  static const int irregularMaxCycle = 45;
  static const int highConfidenceSpreadDays = 7;
  static const int lateAfterDays = 7;
  static const int lutealDays = 14;
  static const int fertileBeforeOvulation = 5;
  static const int fertileAfterOvulation = 1;

  /// Strips time from a date so all arithmetic is in whole days.
  static DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static int daysBetween(DateTime a, DateTime b) {
    final ua = DateTime.utc(a.year, a.month, a.day);
    final ub = DateTime.utc(b.year, b.month, b.day);
    return ub.difference(ua).inDays;
  }

  static DateTime addDays(DateTime d, int n) =>
      DateTime(d.year, d.month, d.day + n);

  /// Sorted, de-duplicated list of cycle starts.
  List<CycleRecord> _sorted(List<CycleRecord> cycles) {
    final list = cycles
        .map((c) => CycleRecord(
              start: dayOnly(c.start),
              end: c.end == null ? null : dayOnly(c.end!),
              isEstimate: c.isEstimate,
            ))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final out = <CycleRecord>[];
    for (final c in list) {
      if (out.isEmpty || out.last.start != c.start) out.add(c);
    }
    return out;
  }

  /// Lengths between consecutive starts (all, including implausible ones).
  List<int> _lengths(List<CycleRecord> sorted) {
    final out = <int>[];
    for (var i = 0; i < sorted.length - 1; i++) {
      out.add(daysBetween(sorted[i].start, sorted[i + 1].start));
    }
    return out;
  }

  List<int> _validLengths(List<int> lengths) => lengths
      .where((l) => l >= minValidCycle && l <= maxValidCycle)
      .toList();

  int _spread(List<int> values) {
    if (values.length < 2) return 0;
    var lo = values.first;
    var hi = values.first;
    for (final v in values) {
      if (v < lo) lo = v;
      if (v > hi) hi = v;
    }
    return hi - lo;
  }

  /// Average cycle length used for predictions.
  int averageCycle(List<CycleRecord> cycles, int onboardingCycleLength) {
    final valid = _validLengths(_lengths(_sorted(cycles)));
    if (valid.length < 2) return onboardingCycleLength;
    final window = valid.length > maxAverageWindow
        ? valid.sublist(valid.length - maxAverageWindow)
        : valid;
    final sum = window.fold<int>(0, (a, b) => a + b);
    return (sum / window.length).round();
  }

  PredictionResult predict({
    required List<CycleRecord> cycles,
    required int onboardingCycleLength,
    required DateTime today,
  }) {
    final sorted = _sorted(cycles);
    final avg = averageCycle(sorted, onboardingCycleLength);
    if (sorted.isEmpty) return PredictionResult.empty(avg);

    final lengths = _lengths(sorted);
    final valid = _validLengths(lengths);
    final lastStart = sorted.last.start;
    final t = dayOnly(today);

    final nextStart = addDays(lastStart, avg);
    final ovulation = addDays(nextStart, -lutealDays);
    final fertileStart = addDays(ovulation, -fertileBeforeOvulation);
    final fertileEnd = addDays(ovulation, fertileAfterOvulation);

    final n = sorted.length;
    final Confidence confidence;
    if (sorted.last.isEstimate || n <= 1) {
      confidence = Confidence.low;
    } else if (n <= 3) {
      confidence = Confidence.medium;
    } else {
      confidence = _spread(valid) <= highConfidenceSpreadDays
          ? Confidence.high
          : Confidence.medium;
    }

    final irregular = _spread(valid) > irregularSpreadDays ||
        lengths.any((l) => l > irregularMaxCycle);

    final late = daysBetween(nextStart, t) > lateAfterDays;

    final cycleDay = daysBetween(lastStart, t) >= 0
        ? daysBetween(lastStart, t) + 1
        : null;

    return PredictionResult(
      lastStart: lastStart,
      cycleDay: cycleDay,
      nextPeriodStart: nextStart,
      ovulation: ovulation,
      fertileStart: fertileStart,
      fertileEnd: fertileEnd,
      averageCycle: avg,
      confidence: confidence,
      irregular: irregular,
      late: late,
      loggedCycles: n,
    );
  }

  /// Phase for a single calendar day. Used by both Today's ring and the
  /// calendar so they always agree.
  ///
  /// Past cycles use the real next start; the latest cycle uses the
  /// prediction. Logged period days win over predicted ones.
  DayPhase phaseFor({
    required DateTime day,
    required List<CycleRecord> cycles,
    required int onboardingCycleLength,
    required int periodLength,
  }) {
    final d = dayOnly(day);
    final sorted = _sorted(cycles);
    if (sorted.isEmpty) return DayPhase.normal;

    // Logged period days.
    for (var i = 0; i < sorted.length; i++) {
      final c = sorted[i];
      final end = c.end ?? addDays(c.start, periodLength - 1);
      if (!d.isBefore(c.start) && !d.isAfter(end)) return DayPhase.period;
    }

    // Ovulation and fertile window: one per cycle.
    for (var i = 0; i < sorted.length; i++) {
      final DateTime nextStart;
      if (i < sorted.length - 1) {
        nextStart = sorted[i + 1].start;
      } else {
        nextStart = predict(
          cycles: sorted,
          onboardingCycleLength: onboardingCycleLength,
          today: d,
        ).nextPeriodStart!;
      }
      final ov = addDays(nextStart, -lutealDays);
      if (d == ov) return DayPhase.ovulation;
      final fStart = addDays(ov, -fertileBeforeOvulation);
      final fEnd = addDays(ov, fertileAfterOvulation);
      if (!d.isBefore(fStart) && !d.isAfter(fEnd)) return DayPhase.fertile;
    }

    // Predicted period for the upcoming cycle.
    final next = predict(
      cycles: sorted,
      onboardingCycleLength: onboardingCycleLength,
      today: d,
    ).nextPeriodStart!;
    if (!d.isBefore(next) && !d.isAfter(addDays(next, periodLength - 1))) {
      return DayPhase.predictedPeriod;
    }

    return DayPhase.normal;
  }
}
