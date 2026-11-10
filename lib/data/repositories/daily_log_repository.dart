import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/dates.dart';
import '../database/database.dart';

/// Flow choices, matching the mockup order: Nta yo, Make, Hagati, Menshi.
enum FlowLevel { none, spotting, medium, heavy }

/// Symptom and mood keys are stable identifiers; labels come from ARB files.
const symptomKeys = [
  'cramps',
  'headache',
  'backache',
  'bloating',
  'acne',
  'breast',
  'fatigue',
];
const moodKeys = ['calm', 'happy', 'sad', 'irritable', 'anxious'];

/// One entry in the log. A day can hold many entries. [date] is the moment
/// the entry describes (local date and time), so the day is `dayOnly(date)`.
class DayLog {
  const DayLog({
    this.id,
    required this.date,
    this.flow = FlowLevel.none,
    this.symptoms = const [],
    this.mood = const [],
    this.note,
  });

  /// Null for a new entry that has not been saved yet.
  final String? id;
  final DateTime date;
  final FlowLevel flow;
  final List<String> symptoms;
  final List<String> mood;
  final String? note;

  bool get hasFlow => flow != FlowLevel.none;

  DateTime get day => dayOnly(date);
}

class DailyLogRepository {
  DailyLogRepository(this._db);

  final DonzelaDatabase _db;
  static const _uuid = Uuid();

  static DayLog _fromRow(DailyLogRow r) => DayLog(
        id: r.id,
        date: r.loggedAt,
        flow: FlowLevel.values.firstWhere(
          (f) => f.name == r.flow,
          orElse: () => FlowLevel.none,
        ),
        symptoms: List<String>.from(jsonDecode(r.symptoms) as List),
        mood: List<String>.from(jsonDecode(r.mood) as List),
        note: r.note,
      );

  /// Every live entry, oldest first.
  Future<List<DayLog>> all() async =>
      (await _db.dailyLogsDao.all()).map(_fromRow).toList();

  /// Entries for one local day, oldest first.
  Future<List<DayLog>> forDay(DateTime day) async =>
      (await _db.dailyLogsDao.byDate(dayKey(day))).map(_fromRow).toList();

  Future<DayLog?> byId(String id) async {
    final row = await _db.dailyLogsDao.byId(id);
    return row == null || row.deleted ? null : _fromRow(row);
  }

  /// Saves an entry. A new entry gets an id; an existing one is updated.
  /// Writes to SQLite first and queues the change for sync.
  Future<String> save(DayLog entry) async {
    final id = entry.id ?? _uuid.v4();
    final now = DateTime.now();
    await _db.writeAndQueue(
      table: 'daily_logs',
      recordId: id,
      action: 'upsert',
      write: () => _db.dailyLogsDao.upsert(DailyLogsCompanion(
        id: Value(id),
        date: Value(dayKey(entry.date)),
        loggedAt: Value(entry.date),
        flow: Value(entry.flow.name),
        symptoms: Value(jsonEncode(entry.symptoms)),
        mood: Value(jsonEncode(entry.mood)),
        note: Value(entry.note == null || entry.note!.trim().isEmpty
            ? null
            : entry.note!.trim()),
        updatedAt: Value(now),
        deleted: const Value(false),
      )),
    );
    return id;
  }

  /// Removes one entry (soft delete, queued for sync). Other entries on the
  /// same day are kept.
  Future<void> delete(String id) async {
    final existing = await _db.dailyLogsDao.byId(id);
    if (existing == null || existing.deleted) return;
    final now = DateTime.now();
    await _db.writeAndQueue(
      table: 'daily_logs',
      recordId: id,
      action: 'delete',
      write: () => _db.dailyLogsDao.softDeleteById(id, now),
    );
  }
}
