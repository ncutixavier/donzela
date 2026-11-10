import 'package:drift/drift.dart';

import '../../data/database/database.dart';
import 'sync_service.dart';

/// One document read back from the cloud.
class RemoteDoc {
  const RemoteDoc(this.id, this.data);
  final String id;
  final Map<String, dynamic> data;
}

/// Reads one user table from the cloud. Firestore implements it; tests use a
/// fake.
abstract class RemoteReader {
  Future<List<RemoteDoc>> fetch(String table);
}

class RestoreResult {
  const RestoreResult({
    required this.cycles,
    required this.dailyLogs,
    required this.onboardingDone,
  });

  final int cycles;
  final int dailyLogs;
  final bool onboardingDone;

  bool get foundData => cycles > 0 || dailyLogs > 0 || onboardingDone;
}

/// Brings a signed-in user's cloud data onto this phone (plan F2: "reinstall
/// and sign in restores it"). Newest updated_at wins for each record.
/// Restored rows are written locally only, so they are not queued back.
class RestoreService {
  RestoreService(this._db, this._reader);

  final DonzelaDatabase _db;
  final RemoteReader _reader;

  Future<RestoreResult> run() async {
    final cycles = await _restoreCycles();
    final logs = await _restoreDailyLogs();
    final settingsDone = await _restoreSettings();
    return RestoreResult(
      cycles: cycles,
      dailyLogs: logs,
      onboardingDone: settingsDone,
    );
  }

  DateTime _ms(Object? v) =>
      DateTime.fromMillisecondsSinceEpoch((v as num?)?.toInt() ?? 0);

  Future<int> _restoreCycles() async {
    var written = 0;
    for (final doc in await _reader.fetch('cycles')) {
      final d = doc.data;
      final remoteUpdated = _ms(d['updated_at']);
      final local = await (_db.select(_db.cycles)
            ..where((c) => c.id.equals(doc.id)))
          .getSingleOrNull();
      if (local != null && !remoteUpdated.isAfter(local.updatedAt)) continue;

      await _db.cyclesDao.upsert(CyclesCompanion(
        id: Value(doc.id),
        startDate: Value(_ms(d['start_date'])),
        endDate: Value(
          d['end_date'] == null ? null : _ms(d['end_date']),
        ),
        periodLength: Value((d['period_length'] as num?)?.toInt() ?? 5),
        cycleLength: Value((d['cycle_length'] as num?)?.toInt()),
        isEstimate: Value(d['is_estimate'] == true),
        updatedAt: Value(remoteUpdated),
        deleted: Value(d['deleted'] == true),
      ));
      written++;
    }
    return written;
  }

  Future<int> _restoreDailyLogs() async {
    var written = 0;
    for (final doc in await _reader.fetch('daily_logs')) {
      final d = doc.data;
      final date = d['date'] as String?;
      if (date == null) continue;
      final remoteUpdated = _ms(d['updated_at']);
      final local = await _db.dailyLogsDao.byId(doc.id);
      if (local != null && !remoteUpdated.isAfter(local.updatedAt)) continue;

      await _db.dailyLogsDao.upsert(DailyLogsCompanion(
        id: Value(doc.id),
        date: Value(date),
        // Entries carry their own time; older copies fall back to midnight.
        loggedAt: Value(d['logged_at'] == null
            ? DateTime.parse(date)
            : _ms(d['logged_at'])),
        flow: Value((d['flow'] as String?) ?? 'none'),
        symptoms: Value((d['symptoms'] as String?) ?? '[]'),
        mood: Value((d['mood'] as String?) ?? '[]'),
        note: Value(d['note'] as String?),
        updatedAt: Value(remoteUpdated),
        deleted: Value(d['deleted'] == true),
      ));
      written++;
    }
    return written;
  }

  /// Applies cloud settings this phone does not have yet. Device-only values
  /// (PIN, analytics) are never restored. Returns whether onboarding was done
  /// in the cloud.
  Future<bool> _restoreSettings() async {
    final docs = await _reader.fetch('settings');
    final remote = docs.where((d) => d.id == 'current').firstOrNull;
    if (remote == null) return false;

    final local = await _db.settingsDao.readAll();
    for (final key in syncedSettingKeys) {
      final value = remote.data[key];
      if (value == null || local.containsKey(key)) continue;
      await _db.settingsDao.put(key, value.toString());
    }
    // Backup stays on after a restore, since the user chose it before.
    await _db.settingsDao.put('backup_on', '1');
    return remote.data['onboarding_done'].toString() == '1' ||
        remote.data['onboarding_done'] == true;
  }
}
