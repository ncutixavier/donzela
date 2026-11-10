import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/cycle_repository.dart';
import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:donzela/services/sync/restore_service.dart';
import 'package:donzela/services/sync/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeStore implements CloudStore {
  final writes = <CloudWrite>[];
  @override
  Future<void> push(List<CloudWrite> batch) async => writes.addAll(batch);
}

class FakeReader implements RemoteReader {
  FakeReader(this.tables);
  final Map<String, List<RemoteDoc>> tables;
  @override
  Future<List<RemoteDoc>> fetch(String table) async => tables[table] ?? [];
}

void main() {
  late DonzelaDatabase db;

  setUp(() => db = DonzelaDatabase.memory());
  tearDown(() => db.close());

  group('sync', () {
    test('backup off uploads nothing and keeps the queue', () async {
      await CycleRepository(db).startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
      final store = FakeStore();
      final sync = SyncService(db, storeProvider: () async => store);
      expect(await sync.run(backupOn: false), 0);
      expect(store.writes, isEmpty);
      expect(await db.syncQueueDao.pendingCount(), greaterThan(0));
    });

    test('no signed-in user means nothing is uploaded', () async {
      await CycleRepository(db).startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
      final sync = SyncService(db, storeProvider: () async => null);
      expect(await sync.run(backupOn: true), 0);
      expect(await db.syncQueueDao.pendingCount(), greaterThan(0));
    });

    test('queued cycles and logs are pushed with their payloads, then marked synced', () async {
      await CycleRepository(db).startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
      await DailyLogRepository(db).save(DayLog(
        date: DateTime(2026, 1, 2),
        flow: FlowLevel.medium,
        symptoms: const ['cramps'],
        note: 'hi',
      ));
      final store = FakeStore();
      final sync = SyncService(db, storeProvider: () async => store);
      await sync.run(backupOn: true);

      final cycle = store.writes.firstWhere((w) => w.table == 'cycles');
      expect(cycle.data['period_length'], 5);
      expect(cycle.data['deleted'], isFalse);
      final log = store.writes.firstWhere((w) => w.table == 'daily_logs');
      expect(log.data['date'], '2026-01-02');
      expect(log.data['symptoms'], '["cramps"]');
      expect(log.data['note'], 'hi');
      expect(await db.syncQueueDao.pendingCount(), 0);
    });

    test('a deleted cycle is pushed as a tombstone', () async {
      final repo = CycleRepository(db);
      await repo.startCycle(start: DateTime(2026, 1, 1), periodLength: 5);
      final id = (await repo.all()).single.id;
      await repo.deleteCycle(id);
      final store = FakeStore();
      await SyncService(db, storeProvider: () async => store).run(backupOn: true);
      final tomb = store.writes.where((w) => w.table == 'cycles' && w.recordId == id);
      expect(tomb.last.data['deleted'], isTrue);
    });

    test('settings snapshot holds only synced keys, never the PIN flag', () async {
      await db.settingsDao.put('language', 'fr');
      await db.settingsDao.put('pin_on', '1');
      await db.settingsDao.put('analytics_on', '0');
      final store = FakeStore();
      await SyncService(db, storeProvider: () async => store).run(backupOn: true);
      final snap = store.writes.singleWhere((w) => w.table == 'settings');
      expect(snap.data['language'], 'fr');
      expect(snap.data.containsKey('pin_on'), isFalse);
      expect(snap.data.containsKey('analytics_on'), isFalse);
    });
  });

  group('restore', () {
    test('restores cycles, logs and synced settings onto a fresh phone', () async {
      final reader = FakeReader({
        'cycles': [
          RemoteDoc('c1', {
            'start_date': DateTime(2026, 2, 1).millisecondsSinceEpoch,
            'period_length': 5,
            'updated_at': DateTime(2026, 2, 2).millisecondsSinceEpoch,
          }),
        ],
        'daily_logs': [
          RemoteDoc('l1', {
            'date': '2026-02-03',
            'flow': 'heavy',
            'symptoms': '["headache"]',
            'mood': '[]',
            'updated_at': DateTime(2026, 2, 3).millisecondsSinceEpoch,
          }),
        ],
        'settings': [
          RemoteDoc('current', {'language': 'en', 'onboarding_done': '1'}),
        ],
      });
      final result = await RestoreService(db, reader).run();

      expect(result.cycles, 1);
      expect(result.dailyLogs, 1);
      expect(result.onboardingDone, isTrue);
      expect(result.foundData, isTrue);
      expect((await db.settingsDao.readAll())['language'], 'en');
      expect((await db.settingsDao.readAll())['backup_on'], '1');
      expect((await db.dailyLogsDao.byId('l1'))!.flow, 'heavy');
    });

    test('newest updated_at wins: an older cloud copy does not overwrite local', () async {
      await CycleRepository(db).startCycle(start: DateTime(2026, 3, 1), periodLength: 6);
      final local = (await db.cyclesDao.activeCycles()).single;
      final older = RemoteDoc(local.id, {
        'start_date': DateTime(2026, 3, 1).millisecondsSinceEpoch,
        'period_length': 2,
        'updated_at': local.updatedAt.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      });
      await RestoreService(db, FakeReader({'cycles': [older]})).run();
      expect((await db.cyclesDao.activeCycles()).single.periodLength, 6);
    });

    test('a newer cloud copy replaces the local one', () async {
      await CycleRepository(db).startCycle(start: DateTime(2026, 3, 1), periodLength: 6);
      final local = (await db.cyclesDao.activeCycles()).single;
      final newer = RemoteDoc(local.id, {
        'start_date': DateTime(2026, 3, 1).millisecondsSinceEpoch,
        'period_length': 3,
        'updated_at': local.updatedAt.add(const Duration(days: 1)).millisecondsSinceEpoch,
      });
      await RestoreService(db, FakeReader({'cycles': [newer]})).run();
      expect((await db.cyclesDao.activeCycles()).single.periodLength, 3);
    });

    test('restored rows are not queued back to the cloud', () async {
      await RestoreService(db, FakeReader({
        'daily_logs': [
          RemoteDoc('l9', {
            'date': '2026-04-01',
            'flow': 'none',
            'updated_at': DateTime(2026, 4, 1).millisecondsSinceEpoch,
          }),
        ],
      })).run();
      expect(await db.syncQueueDao.pendingCount(), 0);
    });

    test('empty cloud reports nothing found', () async {
      final r = await RestoreService(db, FakeReader({})).run();
      expect(r.foundData, isFalse);
    });
  });
}
