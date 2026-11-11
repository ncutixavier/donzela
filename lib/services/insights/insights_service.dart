import '../../core/utils/dates.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../prediction/prediction_service.dart';

/// Where a logged day falls in the cycle, for "by phase" insights.
enum InsightBucket { period, fertile, other }

InsightBucket bucketFor(DayPhase phase) => switch (phase) {
      DayPhase.period => InsightBucket.period,
      DayPhase.fertile || DayPhase.ovulation => InsightBucket.fertile,
      DayPhase.predictedPeriod || DayPhase.normal => InsightBucket.other,
    };

/// A key (symptom, mood or flow) and how many logged days had it.
class KeyCount {
  const KeyCount(this.key, this.days);
  final String key;
  final int days;
}

/// Everything the Insights tab shows. Computed on the phone from the user's
/// own logs. Nothing here is sent anywhere.
class Insights {
  const Insights({
    required this.daysLogged,
    required this.cyclesTracked,
    required this.averageCycle,
    required this.minCycle,
    required this.maxCycle,
    required this.averagePeriod,
    required this.confidence,
    required this.irregular,
    required this.loggedDaysByBucket,
    required this.symptoms,
    required this.moods,
    required this.flow,
    required this.symptomsByBucket,
    required this.moodsByBucket,
  });

  final int daysLogged;
  final int cyclesTracked;
  final int averageCycle;
  final int? minCycle;
  final int? maxCycle;
  final int averagePeriod;
  final Confidence confidence;
  final bool irregular;

  /// Logged days in each bucket (the denominator for "x of y days").
  final Map<InsightBucket, int> loggedDaysByBucket;

  /// Whole-history counts, most common first.
  final List<KeyCount> symptoms;
  final List<KeyCount> moods;
  final List<KeyCount> flow;

  /// Counts per bucket, most common first.
  final Map<InsightBucket, List<KeyCount>> symptomsByBucket;
  final Map<InsightBucket, List<KeyCount>> moodsByBucket;

  bool get hasData => daysLogged > 0;
}

class InsightsService {
  const InsightsService({PredictionService prediction = const PredictionService()})
      : _prediction = prediction;

  final PredictionService _prediction;

  /// [cycles] are period starts with optional end dates.
  Insights compute({
    required List<CycleRecord> cycles,
    required List<DayLog> logs,
    required int onboardingCycleLength,
    required int periodLength,
    required DateTime today,
  }) {
    // Counts are per day: several entries on one day count as one day.
    final days = mergeByDay(logs);

    final prediction = _prediction.predict(
      cycles: cycles,
      onboardingCycleLength: onboardingCycleLength,
      today: today,
    );

    // Cycle lengths between consecutive starts.
    final starts = [...cycles.map((c) => PredictionService.dayOnly(c.start))]
      ..sort();
    final lengths = <int>[];
    for (var i = 0; i < starts.length - 1; i++) {
      lengths.add(PredictionService.daysBetween(starts[i], starts[i + 1]));
    }
    final valid = lengths.where((l) => l >= 18 && l <= 60).toList();

    // Period lengths from closed periods.
    final periodLengths = [
      for (final c in cycles)
        if (c.end != null)
          PredictionService.daysBetween(c.start, c.end!) + 1,
    ];
    final avgPeriod = periodLengths.isEmpty
        ? periodLength
        : (periodLengths.reduce((a, b) => a + b) / periodLengths.length).round();

    final symptomTotals = <String, int>{};
    final moodTotals = <String, int>{};
    final flowTotals = <String, int>{};
    final bucketDays = <InsightBucket, int>{
      for (final b in InsightBucket.values) b: 0,
    };
    final symptomBuckets = <InsightBucket, Map<String, int>>{
      for (final b in InsightBucket.values) b: {},
    };
    final moodBuckets = <InsightBucket, Map<String, int>>{
      for (final b in InsightBucket.values) b: {},
    };

    for (final log in days) {
      final phase = _prediction.phaseFor(
        day: log.date,
        cycles: cycles,
        onboardingCycleLength: onboardingCycleLength,
        periodLength: periodLength,
      );
      final bucket = bucketFor(phase);
      bucketDays[bucket] = bucketDays[bucket]! + 1;

      for (final s in log.symptoms) {
        symptomTotals[s] = (symptomTotals[s] ?? 0) + 1;
        symptomBuckets[bucket]![s] = (symptomBuckets[bucket]![s] ?? 0) + 1;
      }
      for (final m in log.mood) {
        moodTotals[m] = (moodTotals[m] ?? 0) + 1;
        moodBuckets[bucket]![m] = (moodBuckets[bucket]![m] ?? 0) + 1;
      }
      if (log.hasFlow) {
        flowTotals[log.flow.name] = (flowTotals[log.flow.name] ?? 0) + 1;
      }
    }

    return Insights(
      daysLogged: days.length,
      cyclesTracked: starts.length,
      averageCycle: prediction.averageCycle,
      minCycle: valid.isEmpty ? null : valid.reduce((a, b) => a < b ? a : b),
      maxCycle: valid.isEmpty ? null : valid.reduce((a, b) => a > b ? a : b),
      averagePeriod: avgPeriod,
      confidence: prediction.confidence,
      irregular: prediction.irregular,
      loggedDaysByBucket: bucketDays,
      symptoms: _sorted(symptomTotals),
      moods: _sorted(moodTotals),
      flow: _sorted(flowTotals),
      symptomsByBucket: {
        for (final b in InsightBucket.values) b: _sorted(symptomBuckets[b]!),
      },
      moodsByBucket: {
        for (final b in InsightBucket.values) b: _sorted(moodBuckets[b]!),
      },
    );
  }

  /// One merged entry per local day: symptoms and moods are combined and the
  /// flow is the strongest flow logged that day.
  static List<DayLog> mergeByDay(List<DayLog> entries) {
    final byDay = <String, List<DayLog>>{};
    for (final e in entries) {
      byDay.putIfAbsent(dayKey(e.day), () => []).add(e);
    }
    final out = <DayLog>[];
    for (final group in byDay.values) {
      final symptoms = <String>{};
      final moods = <String>{};
      var flow = FlowLevel.none;
      for (final e in group) {
        symptoms.addAll(e.symptoms);
        moods.addAll(e.mood);
        if (e.flow.index > flow.index) flow = e.flow;
      }
      out.add(DayLog(
        date: group.first.day,
        flow: flow,
        symptoms: symptoms.toList(),
        mood: moods.toList(),
      ));
    }
    return out;
  }

  static List<KeyCount> _sorted(Map<String, int> counts) {
    final list = [for (final e in counts.entries) KeyCount(e.key, e.value)]
      ..sort((a, b) {
        final c = b.days.compareTo(a.days);
        return c != 0 ? c : a.key.compareTo(b.key);
      });
    return list;
  }
}
