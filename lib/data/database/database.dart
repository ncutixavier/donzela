import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos.dart';
import 'tables.dart';

part 'database.g.dart';

/// Local source of truth (F2). All user data lives here on the phone.
/// Schema version 1 is the MVP; later changes add a migration step below.
@DriftDatabase(
  tables: [Cycles, DailyLogs, Settings, Articles, HealthCentres, SyncQueue, ContentOutbox],
  daos: [CyclesDao, DailyLogsDao, SettingsDao, ContentDao, SyncQueueDao, ContentOutboxDao],
)
class DonzelaDatabase extends _$DonzelaDatabase {
  DonzelaDatabase(super.e);

  /// Opens the on-disk database in the app documents folder.
  factory DonzelaDatabase.open() {
    return DonzelaDatabase(LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'donzela.sqlite'));
      return NativeDatabase.createInBackground(file);
    }));
  }

  /// In-memory database for tests.
  factory DonzelaDatabase.memory() => DonzelaDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE VIRTUAL TABLE IF NOT EXISTS articles_fts '
            'USING fts5(id UNINDEXED, lang UNINDEXED, title, body)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 6) {
            // v6: when each article was first created.
            await m.addColumn(articles, articles.createdAt);
          }
          if (from < 5) {
            // v5: who wrote the article.
            await m.addColumn(articles, articles.author);
          }
          if (from < 4) {
            // v4: the reviewer named for a draft article, kept until publishing.
            await m.addColumn(articles, articles.proposedReviewer);
          }
          if (from < 3) {
            // v3: the content outbox for admin changes waiting for the cloud.
            await m.createTable(contentOutbox);
          }
          if (from < 2) {
            // v2: many log entries per day. The old unique date is removed and
            // each existing entry gets its time from updated_at.
            await m.alterTable(TableMigration(
              dailyLogs,
              newColumns: [dailyLogs.loggedAt],
              columnTransformer: {dailyLogs.loggedAt: dailyLogs.updatedAt},
            ));
          }
        },
        beforeOpen: (details) async {
          await customStatement(
            'CREATE VIRTUAL TABLE IF NOT EXISTS articles_fts '
            'USING fts5(id UNINDEXED, lang UNINDEXED, title, body)',
          );
        },
      );

  /// Removes all user data from this phone. Articles and health centres are
  /// app content, not user data, so they stay (their saved flags are reset).
  Future<void> wipeUserData() {
    return transaction(() async {
      await delete(cycles).go();
      await delete(dailyLogs).go();
      await delete(settings).go();
      await delete(syncQueue).go();
      await (update(articles)).write(const ArticlesCompanion(saved: Value(false)));
    });
  }

  /// Every write runs in one transaction that also writes a sync_queue row,
  /// so a change is never saved without being queued for backup.
  Future<T> writeAndQueue<T>({
    required String table,
    required String recordId,
    required String action,
    required Future<T> Function() write,
  }) {
    return transaction(() async {
      final result = await write();
      await syncQueueDao.enqueue(
        table: table,
        recordId: recordId,
        action: action,
        now: DateTime.now(),
      );
      return result;
    });
  }
}
