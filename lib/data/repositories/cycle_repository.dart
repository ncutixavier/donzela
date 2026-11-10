import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/dates.dart';
import '../../services/prediction/prediction_service.dart';
import '../database/database.dart';

/// Cycle data access (F4 data layer). Screens never touch the database.
class CycleRepository {
  CycleRepository(this._db);

  final DonzelaDatabase _db;
  static const _uuid = Uuid();

  Future<List<CycleRow>> all() => _db.cyclesDao.activeCycles();

  Future<List<CycleRecord>> records() async => (await all())
      .map((c) => CycleRecord(
            start: c.startDate,
            end: c.endDate,
            isEstimate: c.isEstimate,
          ))
      .toList();

  Future<CycleRow?> openCycle() => _db.cyclesDao.openCycle();

  /// Starts a new period. [end] is null while the period is still open.
  Future<void> startCycle({
    required DateTime start,
    required int periodLength,
    bool isEstimate = false,
    DateTime? end,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.cyclesDao.upsert(CyclesCompanion.insert(
        id: id,
        startDate: dayOnly(start),
        endDate: Value(end == null ? null : dayOnly(end)),
        periodLength: periodLength,
        isEstimate: Value(isEstimate),
        updatedAt: now,
      ));
      await _db.syncQueueDao.enqueue(
        table: 'cycles',
        recordId: id,
        action: 'upsert',
        now: now,
      );
      await _recomputeLengths();
    });
  }

  /// Closes the open period on [end] and saves its length.
  Future<void> endPeriod(DateTime end) async {
    final open = await openCycle();
    if (open == null) return;
    final e = dayOnly(end);
    final length = daysBetween(open.startDate, e) + 1;
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.cyclesDao.upsert(CyclesCompanion(
        id: Value(open.id),
        startDate: Value(open.startDate),
        endDate: Value(e),
        periodLength: Value(length < 1 ? 1 : length),
        isEstimate: Value(open.isEstimate),
        updatedAt: Value(now),
      ));
      await _db.syncQueueDao.enqueue(
        table: 'cycles',
        recordId: open.id,
        action: 'upsert',
        now: now,
      );
      await _recomputeLengths();
    });
  }

  Future<void> deleteCycle(String id) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.cyclesDao.softDelete(id, now);
      await _db.syncQueueDao.enqueue(
        table: 'cycles',
        recordId: id,
        action: 'delete',
        now: now,
      );
      await _recomputeLengths();
    });
  }

  /// Moves a cycle's start date (used by long-press on the calendar).
  Future<void> moveStart(String id, DateTime newStart) async {
    final now = DateTime.now();
    final row = await (_db.select(_db.cycles)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    await _db.transaction(() async {
      await _db.cyclesDao.upsert(CyclesCompanion(
        id: Value(id),
        startDate: Value(dayOnly(newStart)),
        endDate: Value(row.endDate),
        periodLength: Value(row.periodLength),
        isEstimate: const Value(false),
        updatedAt: Value(now),
      ));
      await _db.syncQueueDao.enqueue(
        table: 'cycles',
        recordId: id,
        action: 'upsert',
        now: now,
      );
      await _recomputeLengths();
    });
  }

  /// Keeps `cycle_length` correct for every completed cycle (start to next
  /// start). Must run inside a transaction.
  Future<void> _recomputeLengths() async {
    final rows = await all();
    final now = DateTime.now();
    for (var i = 0; i < rows.length; i++) {
      final int? expected = i < rows.length - 1
          ? daysBetween(rows[i].startDate, rows[i + 1].startDate)
          : null;
      if (rows[i].cycleLength == expected) continue;
      await (_db.update(_db.cycles)..where((c) => c.id.equals(rows[i].id)))
          .write(CyclesCompanion(
        cycleLength: Value(expected),
        updatedAt: Value(now),
      ));
      await _db.syncQueueDao.enqueue(
        table: 'cycles',
        recordId: rows[i].id,
        action: 'upsert',
        now: now,
      );
    }
  }
}
