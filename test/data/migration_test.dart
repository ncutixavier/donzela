import 'dart:io';

import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('v1 databases keep their logs and allow several entries per day', () async {
    final dir = Directory.systemTemp.createTempSync('donzela_migration');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/old.sqlite';

    // Start from a real database with every table, then put back the version 1
    // daily_logs table (one log per day, enforced by a unique date).
    final fresh = DonzelaDatabase(NativeDatabase(File(path)));
    await fresh.customSelect('SELECT 1').get();
    await fresh.close();

    final old = sqlite3.open(path);
    // Version 1 had none of proposed_reviewer (v4), author (v5) or created_at (v6).
    old.execute('ALTER TABLE articles DROP COLUMN proposed_reviewer');
    old.execute('ALTER TABLE articles DROP COLUMN author');
    old.execute('ALTER TABLE articles DROP COLUMN created_at');
    old.execute('DROP TABLE daily_logs');
    old.execute('''
      CREATE TABLE daily_logs (
        id TEXT NOT NULL PRIMARY KEY,
        date TEXT NOT NULL UNIQUE,
        flow TEXT NOT NULL DEFAULT 'none',
        symptoms TEXT NOT NULL DEFAULT '[]',
        mood TEXT NOT NULL DEFAULT '[]',
        note TEXT,
        updated_at INTEGER NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0
      )''');
    old.execute(
      "INSERT INTO daily_logs (id, date, flow, symptoms, mood, updated_at, deleted) "
      "VALUES ('old-1', '2026-05-01', 'heavy', '[\"cramps\"]', '[]', 1777939200, 0)",
    );
    old.execute('PRAGMA user_version = 1');
    old.dispose();

    // Open with the current code: the migration runs.
    final db = DonzelaDatabase(NativeDatabase(File(path)));
    addTearDown(db.close);

    final kept = await DailyLogRepository(db).all();
    expect(kept, hasLength(1));
    expect(kept.single.id, 'old-1');
    expect(kept.single.flow, FlowLevel.heavy);
    expect(kept.single.symptoms, ['cramps']);

    // The unique date is gone, so a second entry on the same day is allowed.
    await DailyLogRepository(db).save(DayLog(
      date: DateTime(2026, 5, 1, 19, 30),
      symptoms: const ['headache'],
    ));
    expect(await DailyLogRepository(db).forDay(DateTime(2026, 5, 1)), hasLength(2));
  });
}
