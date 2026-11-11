import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:donzela/services/insights/insights_service.dart';
import 'package:donzela/services/prediction/prediction_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const svc = InsightsService();
  final cycles = [
    CycleRecord(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5)),
    CycleRecord(start: DateTime(2026, 1, 29), end: DateTime(2026, 2, 2)),
    CycleRecord(start: DateTime(2026, 2, 26)),
  ];

  test('empty logs give no data', () {
    final r = svc.compute(
      cycles: const [],
      logs: const [],
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    expect(r.hasData, isFalse);
    expect(r.daysLogged, 0);
    expect(r.averageCycle, 28);
  });

  test('counts cycles and cycle range from valid lengths', () {
    final r = svc.compute(
      cycles: cycles,
      logs: const [],
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    expect(r.cyclesTracked, 3);
    expect(r.minCycle, 28);
    expect(r.maxCycle, 28);
    expect(r.averageCycle, 28);
  });

  test('average period comes from closed periods', () {
    final r = svc.compute(
      cycles: cycles,
      logs: const [],
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    // Jan 1–5 is 5 days, Jan 29–Feb 2 is 5 days.
    expect(r.averagePeriod, 5);
  });

  test('symptoms and moods are counted and sorted most common first', () {
    final logs = [
      DayLog(date: DateTime(2026, 1, 2), symptoms: ['cramps', 'fatigue'], mood: ['sad']),
      DayLog(date: DateTime(2026, 1, 3), symptoms: ['cramps'], mood: ['sad', 'calm']),
      DayLog(date: DateTime(2026, 1, 4), symptoms: ['cramps']),
    ];
    final r = svc.compute(
      cycles: cycles,
      logs: logs,
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    expect(r.symptoms.first.key, 'cramps');
    expect(r.symptoms.first.days, 3);
    expect(r.moods.first.key, 'sad');
    expect(r.moods.first.days, 2);
  });

  test('symptoms are grouped by cycle phase', () {
    // Jan 2–3 are period days; Jan 10 is in the fertile window
    // (ovulation Jan 15, window Jan 10–16).
    final logs = [
      DayLog(date: DateTime(2026, 1, 2), symptoms: ['cramps']),
      DayLog(date: DateTime(2026, 1, 3), symptoms: ['cramps']),
      DayLog(date: DateTime(2026, 1, 10), symptoms: ['bloating']),
      DayLog(date: DateTime(2026, 1, 20), symptoms: ['headache']),
    ];
    final r = svc.compute(
      cycles: cycles,
      logs: logs,
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    expect(r.loggedDaysByBucket[InsightBucket.period], 2);
    expect(r.loggedDaysByBucket[InsightBucket.fertile], 1);
    expect(r.loggedDaysByBucket[InsightBucket.other], 1);
    expect(r.symptomsByBucket[InsightBucket.period]!.single.key, 'cramps');
    expect(r.symptomsByBucket[InsightBucket.period]!.single.days, 2);
    expect(r.symptomsByBucket[InsightBucket.fertile]!.single.key, 'bloating');
  });

  test('flow counts ignore days with no flow', () {
    final logs = [
      DayLog(date: DateTime(2026, 1, 2), flow: FlowLevel.heavy),
      DayLog(date: DateTime(2026, 1, 3), flow: FlowLevel.none),
      DayLog(date: DateTime(2026, 1, 4), flow: FlowLevel.heavy),
    ];
    final r = svc.compute(
      cycles: cycles,
      logs: logs,
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 3, 1),
    );
    expect(r.flow.single.key, 'heavy');
    expect(r.flow.single.days, 2);
  });

  test('irregular cycles are reported', () {
    final irregular = [
      CycleRecord(start: DateTime(2026, 1, 1)),
      CycleRecord(start: DateTime(2026, 1, 25)), // 24
      CycleRecord(start: DateTime(2026, 3, 2)), // 36
      CycleRecord(start: DateTime(2026, 4, 1)), // 30
      CycleRecord(start: DateTime(2026, 5, 11)), // 40
    ];
    final r = svc.compute(
      cycles: irregular,
      logs: const [],
      onboardingCycleLength: 28,
      periodLength: 5,
      today: DateTime(2026, 5, 20),
    );
    expect(r.irregular, isTrue);
    expect(r.minCycle, 24);
    expect(r.maxCycle, 40);
  });

  test('bucketFor maps predictions to the three buckets', () {
    expect(bucketFor(DayPhase.period), InsightBucket.period);
    expect(bucketFor(DayPhase.fertile), InsightBucket.fertile);
    expect(bucketFor(DayPhase.ovulation), InsightBucket.fertile);
    expect(bucketFor(DayPhase.normal), InsightBucket.other);
    expect(bucketFor(DayPhase.predictedPeriod), InsightBucket.other);
  });
}
