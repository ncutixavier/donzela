import 'package:donzela/core/utils/dates.dart';
import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/cycle_repository.dart';
import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:donzela/data/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DonzelaDatabase db;
  late CycleRepository cycles;
  late DailyLogRepository logs;
  late SettingsRepository settings;

  setUp(() {
    db = DonzelaDatabase.memory();
    cycles = CycleRepository(db);
    logs = DailyLogRepository(db);
    settings = SettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('every write adds a sync_queue row', () async {
    await cycles.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
    final pending = await db.syncQueueDao.pendingCount();
    expect(pending, greaterThanOrEqualTo(1));
  });

  test('cycle lengths are derived from consecutive starts', () async {
    await cycles.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
    await cycles.startCycle(start: DateTime(2026, 1, 29), periodLength: 5);
    await cycles.startCycle(start: DateTime(2026, 2, 26), periodLength: 5);
    final rows = await cycles.all();
    expect(rows[0].cycleLength, 28);
    expect(rows[1].cycleLength, 28);
    expect(rows[2].cycleLength, isNull);
  });

  test('endPeriod closes the open cycle and stores its length', () async {
    await cycles.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
    await cycles.endPeriod(DateTime(2026, 1, 4));
    final row = (await cycles.all()).single;
    expect(row.endDate, DateTime(2026, 1, 4));
    expect(row.periodLength, 4);
    expect(await cycles.openCycle(), isNull);
  });

  test('delete is soft: the row is hidden but still queued for sync', () async {
    await cycles.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
    final id = (await cycles.all()).single.id;
    await cycles.deleteCycle(id);
    expect(await cycles.all(), isEmpty);
    final raw = await (db.select(db.cycles)..where((c) => c.id.equals(id))).getSingle();
    expect(raw.deleted, isTrue);
  });

  test('several entries on one day are kept, each with its own time', () async {
    final morning = DateTime(2026, 3, 3, 8, 15);
    final evening = DateTime(2026, 3, 3, 21, 40);
    await logs.save(DayLog(
      date: morning,
      flow: FlowLevel.medium,
      symptoms: const ['cramps', 'fatigue'],
      mood: const ['calm'],
      note: '  hello  ',
    ));
    final id = await logs.save(DayLog(date: evening, flow: FlowLevel.heavy));

    final day = await logs.forDay(DateTime(2026, 3, 3));
    expect(day, hasLength(2));
    expect(day.first.date, morning);
    expect(day.first.note, 'hello');
    expect(day.first.symptoms, ['cramps', 'fatigue']);
    expect(day.last.date, evening);
    expect(day.last.flow, FlowLevel.heavy);

    // Saving again with the id updates that entry, not a new one.
    await logs.save(DayLog(id: id, date: evening, flow: FlowLevel.spotting));
    final updated = await logs.byId(id);
    expect(updated!.flow, FlowLevel.spotting);
    expect(await logs.forDay(DateTime(2026, 3, 3)), hasLength(2));
  });

  test('settings default and persist', () async {
    final defaults = await settings.load();
    expect(defaults.language, 'rw');
    expect(defaults.onboardingDone, isFalse);
    await settings.put('language', 'fr');
    await settings.putBool('pin_on', true);
    final updated = await settings.load();
    expect(updated.language, 'fr');
    expect(updated.pinOn, isTrue);
  });

  test('wipeUserData removes user data but keeps app content', () async {
    await cycles.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
    await logs.save(DayLog(date: DateTime(2026, 1, 2), flow: FlowLevel.spotting));
    await settings.put('language', 'en');
    await db.wipeUserData();
    expect(await cycles.all(), isEmpty);
    expect(await logs.all(), isEmpty);
    expect((await settings.load()).language, 'rw');
  });

  test('day keys are stable yyyy-MM-dd', () {
    expect(dayKey(DateTime(2026, 1, 9, 23, 59)), '2026-01-09');
    expect(parseDayKey('2028-02-29'), DateTime(2028, 2, 29));
  });
}
