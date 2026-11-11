import 'package:donzela/services/prediction/prediction_service.dart';
import 'package:flutter_test/flutter_test.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

/// Builds consecutive cycle starts from a first date and a list of lengths.
List<CycleRecord> cyclesFrom(DateTime first, List<int> lengths) {
  final out = <CycleRecord>[CycleRecord(start: first)];
  var cur = first;
  for (final l in lengths) {
    cur = PredictionService.addDays(cur, l);
    out.add(CycleRecord(start: cur));
  }
  return out;
}

void main() {
  const svc = PredictionService();

  group('average cycle', () {
    test('regular 28-day cycles average 28', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28, 28, 28]);
      expect(svc.averageCycle(cycles, 30), 28);
    });

    test('short 22-day cycles average 22', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [22, 22, 22, 22]);
      expect(svc.averageCycle(cycles, 28), 22);
    });

    test('long 35-day cycles average 35', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [35, 35, 35]);
      expect(svc.averageCycle(cycles, 28), 35);
    });

    test('first cycle only uses onboarding value', () {
      final cycles = cyclesFrom(d(2026, 1, 1), []);
      expect(svc.averageCycle(cycles, 27), 27);
    });

    test('fewer than 2 valid cycles uses onboarding value', () {
      // Only one completed cycle (28) and one implausible (10): 1 valid.
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 10]);
      expect(svc.averageCycle(cycles, 31), 31);
    });

    test('cycles shorter than 18 or longer than 60 are ignored', () {
      // 28, 10 (ignored), 28 → valid [28, 28].
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 10, 28]);
      expect(svc.averageCycle(cycles, 30), 28);
    });

    test('uses only the last 6 valid cycles', () {
      // Old long cycles must fall out of the window.
      final cycles = cyclesFrom(
        d(2025, 1, 1),
        [40, 40, 40, 28, 28, 28, 28, 28, 28],
      );
      expect(svc.averageCycle(cycles, 30), 28);
    });
  });

  group('prediction', () {
    test('next period, ovulation and fertile window follow the rules', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28, 28]);
      // Last start = 2026-01-01 + 84 days = 2026-03-26.
      final r = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2026, 3, 27),
      );
      expect(r.lastStart, d(2026, 3, 26));
      expect(r.nextPeriodStart, d(2026, 4, 23));
      expect(r.ovulation, d(2026, 4, 9));
      expect(r.fertileStart, d(2026, 4, 4));
      expect(r.fertileEnd, d(2026, 4, 10));
      expect(r.cycleDay, 2);
    });

    test('ovulation is 14 days before next period', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [30, 30]);
      final r = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2026, 3, 1),
      );
      expect(
        PredictionService.daysBetween(r.ovulation!, r.nextPeriodStart!),
        14,
      );
    });

    test('leap year: 28 days after 1 Feb 2028 is 29 Feb', () {
      final cycles = cyclesFrom(d(2028, 2, 1), []);
      final r = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2028, 2, 2),
      );
      expect(r.nextPeriodStart, d(2028, 2, 29));
    });

    test('leap year: cycle spanning 29 Feb counts correctly', () {
      final cycles = cyclesFrom(d(2028, 2, 15), [28, 28]);
      expect(svc.averageCycle(cycles, 30), 28);
    });

    test('no logged cycles returns empty result', () {
      final r = svc.predict(
        cycles: const [],
        onboardingCycleLength: 28,
        today: d(2026, 1, 1),
      );
      expect(r.lastStart, isNull);
      expect(r.nextPeriodStart, isNull);
      expect(r.loggedCycles, 0);
    });

    test('first cycle only is low confidence', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), []),
        onboardingCycleLength: 28,
        today: d(2026, 1, 5),
      );
      expect(r.confidence, Confidence.low);
    });

    test('estimated (Sinibuka) start is low confidence', () {
      final cycles = [
        CycleRecord(start: d(2026, 1, 1)),
        CycleRecord(start: d(2026, 1, 29)),
        CycleRecord(start: d(2026, 2, 26), isEstimate: true),
      ];
      final r = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2026, 2, 27),
      );
      expect(r.confidence, Confidence.low);
    });

    test('2–3 logged cycles is medium confidence', () {
      final r2 = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [28]),
        onboardingCycleLength: 28,
        today: d(2026, 1, 30),
      );
      expect(r2.confidence, Confidence.medium);
      final r3 = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [28, 28]),
        onboardingCycleLength: 28,
        today: d(2026, 2, 27),
      );
      expect(r3.confidence, Confidence.medium);
    });

    test('4+ cycles with variation ≤ 7 days is high confidence', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [28, 30, 27]),
        onboardingCycleLength: 28,
        today: d(2026, 4, 1),
      );
      expect(r.loggedCycles, 4);
      expect(r.confidence, Confidence.high);
    });

    test('4+ cycles with variation > 7 days is medium confidence', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [24, 32, 28]),
        onboardingCycleLength: 28,
        today: d(2026, 4, 1),
      );
      expect(r.confidence, Confidence.medium);
    });

    test('irregular when lengths vary by more than 9 days', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [24, 36, 30, 40]),
        onboardingCycleLength: 28,
        today: d(2026, 5, 1),
      );
      expect(r.irregular, isTrue);
    });

    test('irregular when any cycle is over 45 days', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [28, 50, 28]),
        onboardingCycleLength: 28,
        today: d(2026, 5, 1),
      );
      expect(r.irregular, isTrue);
    });

    test('regular cycles are not flagged irregular', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 1, 1), [28, 29, 28]),
        onboardingCycleLength: 28,
        today: d(2026, 4, 1),
      );
      expect(r.irregular, isFalse);
    });

    test('late when today is more than 7 days past predicted start', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      // Next start = 2026-02-26 + 28 = 2026-03-26.
      final notLate = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2026, 4, 2), // 7 days after → not late
      );
      final late = svc.predict(
        cycles: cycles,
        onboardingCycleLength: 28,
        today: d(2026, 4, 3), // 8 days after → late
      );
      expect(notLate.late, isFalse);
      expect(late.late, isTrue);
    });

    test('editing a past cycle changes the prediction', () {
      final before = cyclesFrom(d(2026, 1, 1), [28, 28]);
      final after = [
        CycleRecord(start: d(2026, 1, 1)),
        CycleRecord(start: d(2026, 1, 20)), // first cycle now 19 days
        CycleRecord(start: d(2026, 2, 16)), // second cycle now 27 days
      ];
      final rBefore = svc.predict(
        cycles: before,
        onboardingCycleLength: 28,
        today: d(2026, 3, 1),
      );
      final rAfter = svc.predict(
        cycles: after,
        onboardingCycleLength: 28,
        today: d(2026, 3, 1),
      );
      expect(rBefore.averageCycle, 28);
      expect(rAfter.averageCycle, 23); // (19 + 27) / 2
    });

    test('cycle day is null before the last start', () {
      final r = svc.predict(
        cycles: cyclesFrom(d(2026, 3, 1), []),
        onboardingCycleLength: 28,
        today: d(2026, 2, 1),
      );
      expect(r.cycleDay, isNull);
    });
  });

  group('phaseFor', () {
    test('logged period days are period', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      final phase = svc.phaseFor(
        day: d(2026, 1, 3),
        cycles: cycles,
        onboardingCycleLength: 28,
        periodLength: 5,
      );
      expect(phase, DayPhase.period);
    });

    test('past ovulation day uses the real next start', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      // Cycle 1 (Jan 1) → next start Jan 29 → ovulation Jan 15.
      expect(
        svc.phaseFor(
          day: d(2026, 1, 15),
          cycles: cycles,
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.ovulation,
      );
    });

    test('fertile window surrounds ovulation', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      expect(
        svc.phaseFor(
          day: d(2026, 1, 10),
          cycles: cycles,
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.fertile,
      );
      expect(
        svc.phaseFor(
          day: d(2026, 1, 16),
          cycles: cycles,
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.fertile,
      );
    });

    test('predicted period for the upcoming cycle', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      // Last start Feb 26 → next Mar 26.
      expect(
        svc.phaseFor(
          day: d(2026, 3, 27),
          cycles: cycles,
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.predictedPeriod,
      );
    });

    test('ordinary day is normal', () {
      final cycles = cyclesFrom(d(2026, 1, 1), [28, 28]);
      expect(
        svc.phaseFor(
          day: d(2026, 1, 22),
          cycles: cycles,
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.normal,
      );
    });

    test('no cycles means normal everywhere', () {
      expect(
        svc.phaseFor(
          day: d(2026, 1, 1),
          cycles: const [],
          onboardingCycleLength: 28,
          periodLength: 5,
        ),
        DayPhase.normal,
      );
    });
  });
}
