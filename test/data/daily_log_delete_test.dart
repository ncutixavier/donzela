import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DonzelaDatabase db;
  late DailyLogRepository logs;

  setUp(() {
    db = DonzelaDatabase.memory();
    logs = DailyLogRepository(db);
  });

  tearDown(() => db.close());

  test('deleting one entry hides it and queues a delete for sync', () async {
    final id = await logs.save(DayLog(date: DateTime(2026, 4, 2, 9), symptoms: const ['cramps']));
    await logs.save(DayLog(date: DateTime(2026, 4, 3, 9), symptoms: const ['fatigue']));
    final before = await db.syncQueueDao.pendingCount();

    await logs.delete(id);

    final remaining = await logs.all();
    expect(remaining.map((l) => l.date), [DateTime(2026, 4, 3, 9)]);
    expect(await db.syncQueueDao.pendingCount(), greaterThan(before));
    final actions = (await db.syncQueueDao.pending())
        .where((r) => r.targetTable == 'daily_logs')
        .map((r) => r.action);
    expect(actions, contains('delete'));
  });

  test('deleting an unknown entry does nothing', () async {
    await logs.delete('no-such-id');
    expect(await logs.all(), isEmpty);
  });

  test('deleting one entry keeps the other entries on the same day', () async {
    final first = await logs.save(DayLog(date: DateTime(2026, 4, 2, 8), symptoms: const ['cramps']));
    await logs.save(DayLog(date: DateTime(2026, 4, 2, 20), symptoms: const ['headache']));
    await logs.delete(first);
    final day = await logs.forDay(DateTime(2026, 4, 2));
    expect(day, hasLength(1));
    expect(day.single.symptoms, ['headache']);
  });
}
