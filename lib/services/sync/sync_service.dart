import '../../data/database/database.dart';

/// One document to write to the cloud, at users/{uid}/{table}/{recordId}.
class CloudWrite {
  const CloudWrite({
    required this.table,
    required this.recordId,
    required this.data,
  });

  final String table;
  final String recordId;
  final Map<String, dynamic> data;
}

/// Where queued changes go. The Firestore implementation lives in
/// services/cloud. Throws when the cloud is unreachable.
abstract class CloudStore {
  Future<void> push(List<CloudWrite> writes);
}

/// Resolves the store for the current user. Returns null when backup cannot
/// run (not signed in, or Firebase unavailable). Nothing is uploaded then.
typedef StoreProvider = Future<CloudStore?> Function();

/// Settings that follow the user to a new phone. Device-only values (PIN
/// flag, analytics choice, onboarding drafts) are deliberately left out.
const syncedSettingKeys = [
  'language',
  'first_name',
  'onboarding_done',
  'cycle_length',
  'period_length',
  'reminders_period',
  'reminders_fertile',
  'reminders_pill',
  'pill_hour',
  'pill_minute',
  'backup_on',
  'consent_version',
  'consent_date',
];

/// Pushes the local sync queue in batches of 500 and marks rows synced (F2).
/// Also keeps the small settings snapshot up to date.
class SyncService {
  SyncService(
    this._db, {
    required StoreProvider storeProvider,
    Future<bool> Function()? isOnline,
  })  : _storeProvider = storeProvider,
        _isOnline = isOnline ?? (() async => true);

  final DonzelaDatabase _db;
  final StoreProvider _storeProvider;
  final Future<bool> Function() _isOnline;

  static const batchSize = 500;

  /// Runs only when backup is on. Returns the number of queue rows handled.
  Future<int> run({required bool backupOn}) async {
    if (!backupOn) return 0;
    if (!await _isOnline()) return 0;
    final store = await _storeProvider();
    if (store == null) return 0;

    var total = 0;
    while (true) {
      final batch = await _db.syncQueueDao.pending(limit: batchSize);
      if (batch.isEmpty) break;
      final writes = <CloudWrite>[];
      for (final row in batch) {
        final w = await _writeFor(row);
        if (w != null) writes.add(w);
      }
      try {
        if (writes.isNotEmpty) await store.push(writes);
      } catch (_) {
        break; // Offline or rejected: keep the rows for next time.
      }
      await _db.syncQueueDao.markSynced(batch.map((r) => r.id).toList());
      total += batch.length;
      if (batch.length < batchSize) break;
    }

    try {
      await store.push([
        CloudWrite(
          table: 'settings',
          recordId: 'current',
          data: await _settingsSnapshot(),
        ),
      ]);
    } catch (_) {
      // Settings catch up on the next run.
    }
    return total;
  }

  Future<int> pendingCount() => _db.syncQueueDao.pendingCount();

  Future<CloudWrite?> _writeFor(SyncQueueRow row) async {
    final updated = row.createdAt.millisecondsSinceEpoch;
    if (row.action == 'delete') {
      return CloudWrite(
        table: row.targetTable,
        recordId: row.recordId,
        data: {'deleted': true, 'updated_at': updated},
      );
    }
    switch (row.targetTable) {
      case 'cycles':
        final c = await (_db.select(_db.cycles)
              ..where((t) => t.id.equals(row.recordId)))
            .getSingleOrNull();
        if (c == null) return null;
        return CloudWrite(
          table: 'cycles',
          recordId: c.id,
          data: {
            'start_date': c.startDate.millisecondsSinceEpoch,
            'end_date': c.endDate?.millisecondsSinceEpoch,
            'period_length': c.periodLength,
            'cycle_length': c.cycleLength,
            'is_estimate': c.isEstimate,
            'deleted': c.deleted,
            'updated_at': c.updatedAt.millisecondsSinceEpoch,
          },
        );
      case 'daily_logs':
        final d = await (_db.select(_db.dailyLogs)
              ..where((t) => t.id.equals(row.recordId)))
            .getSingleOrNull();
        if (d == null) return null;
        return CloudWrite(
          table: 'daily_logs',
          recordId: d.id,
          data: {
            'date': d.date,
            'logged_at': d.loggedAt.millisecondsSinceEpoch,
            'flow': d.flow,
            'symptoms': d.symptoms,
            'mood': d.mood,
            'note': d.note,
            'deleted': d.deleted,
            'updated_at': d.updatedAt.millisecondsSinceEpoch,
          },
        );
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> _settingsSnapshot() async {
    final rows = await _db.settingsDao.readAll();
    final out = <String, dynamic>{
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };
    for (final key in syncedSettingKeys) {
      if (rows.containsKey(key)) out[key] = rows[key];
    }
    return out;
  }
}
