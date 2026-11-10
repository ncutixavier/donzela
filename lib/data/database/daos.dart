import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Cycles])
class CyclesDao extends DatabaseAccessor<DonzelaDatabase> with _$CyclesDaoMixin {
  CyclesDao(super.db);

  Future<List<CycleRow>> activeCycles() =>
      (select(cycles)..where((c) => c.deleted.equals(false))
            ..orderBy([(c) => OrderingTerm.asc(c.startDate)]))
          .get();

  Future<CycleRow?> openCycle() => (select(cycles)
        ..where((c) => c.deleted.equals(false) & c.endDate.isNull())
        ..orderBy([(c) => OrderingTerm.desc(c.startDate)])
        ..limit(1))
      .getSingleOrNull();

  Future<void> upsert(CyclesCompanion row) =>
      into(cycles).insertOnConflictUpdate(row);

  Future<void> softDelete(String id, DateTime now) =>
      (update(cycles)..where((c) => c.id.equals(id))).write(
        CyclesCompanion(deleted: const Value(true), updatedAt: Value(now)),
      );
}

@DriftAccessor(tables: [DailyLogs])
class DailyLogsDao extends DatabaseAccessor<DonzelaDatabase>
    with _$DailyLogsDaoMixin {
  DailyLogsDao(super.db);

  /// Every live entry, oldest first.
  Future<List<DailyLogRow>> all() => (select(dailyLogs)
        ..where((d) => d.deleted.equals(false))
        ..orderBy([(d) => OrderingTerm.asc(d.loggedAt)]))
      .get();

  /// Live entries for one local day, oldest first.
  Future<List<DailyLogRow>> byDate(String date) => (select(dailyLogs)
        ..where((d) => d.date.equals(date) & d.deleted.equals(false))
        ..orderBy([(d) => OrderingTerm.asc(d.loggedAt)]))
      .get();

  Future<DailyLogRow?> byId(String id) =>
      (select(dailyLogs)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<void> upsert(DailyLogsCompanion row) =>
      into(dailyLogs).insertOnConflictUpdate(row);

  Future<void> softDeleteById(String id, DateTime now) =>
      (update(dailyLogs)..where((d) => d.id.equals(id))).write(
        DailyLogsCompanion(deleted: const Value(true), updatedAt: Value(now)),
      );
}

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<DonzelaDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<Map<String, String>> readAll() async {
    final rows = await select(settings).get();
    return {for (final r in rows) r.key: r.value};
  }

  Future<void> put(String key, String value) =>
      into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: value),
      );

  Future<void> clear() => delete(settings).go();
}

@DriftAccessor(tables: [Articles, HealthCentres])
class ContentDao extends DatabaseAccessor<DonzelaDatabase>
    with _$ContentDaoMixin {
  ContentDao(super.db);

  /// Only reviewed articles are ever shown (plan: unreviewed never ship).
  Future<List<ArticleRow>> reviewedArticles(String lang) =>
      (select(articles)
            ..where((a) =>
                a.lang.equals(lang) & a.reviewedBy.isNotNull())
            ..orderBy([(a) => OrderingTerm.asc(a.title)]))
          .get();

  /// Every article for a language, reviewed or not (debug builds only).
  Future<List<ArticleRow>> allArticles(String lang) =>
      (select(articles)
            ..where((a) => a.lang.equals(lang))
            ..orderBy([(a) => OrderingTerm.asc(a.title)]))
          .get();

  Future<ArticleRow?> article(String id, String lang) => (select(articles)
        ..where((a) => a.id.equals(id) & a.lang.equals(lang)))
      .getSingleOrNull();

  Future<void> upsertArticle(ArticlesCompanion row) =>
      into(articles).insertOnConflictUpdate(row);

  Future<void> setSaved(String id, String lang, bool saved) =>
      (update(articles)..where((a) => a.id.equals(id) & a.lang.equals(lang)))
          .write(ArticlesCompanion(saved: Value(saved)));

  Future<List<HealthCentreRow>> centresIn(String district) =>
      (select(healthCentres)
            ..where((h) => h.district.equals(district))
            ..orderBy([(h) => OrderingTerm.asc(h.sector)]))
          .get();

  Future<void> upsertCentre(HealthCentresCompanion row) =>
      into(healthCentres).insertOnConflictUpdate(row);

  Future<int> articleCount() async {
    final c = articles.id.count();
    final q = selectOnly(articles)..addColumns([c]);
    return (await q.map((r) => r.read(c)).getSingle()) ?? 0;
  }

  /// Full-text search over title and body via the FTS5 index.
  Future<List<String>> searchIds(String lang, String query) async {
    final terms = query
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => '"${t.replaceAll('"', '')}"*')
        .join(' ');
    if (terms.isEmpty) return [];
    final rows = await customSelect(
      'SELECT id FROM articles_fts WHERE articles_fts MATCH ? AND lang = ?',
      variables: [Variable.withString(terms), Variable.withString(lang)],
      readsFrom: {articles},
    ).get();
    return rows.map((r) => r.read<String>('id')).toList();
  }

  Future<void> indexArticle(String id, String lang, String title, String body) async {
    await customStatement(
      'DELETE FROM articles_fts WHERE id = ? AND lang = ?',
      [id, lang],
    );
    await customStatement(
      'INSERT INTO articles_fts (id, lang, title, body) VALUES (?, ?, ?, ?)',
      [id, lang, title, body],
    );
  }
}

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<DonzelaDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<void> enqueue({
    required String table,
    required String recordId,
    required String action,
    required DateTime now,
  }) =>
      into(syncQueue).insert(SyncQueueCompanion.insert(
        targetTable: table,
        recordId: recordId,
        action: action,
        createdAt: now,
      ));

  Future<List<SyncQueueRow>> pending({int limit = 500}) =>
      (select(syncQueue)
            ..where((s) => s.synced.equals(false))
            ..orderBy([(s) => OrderingTerm.asc(s.id)])
            ..limit(limit))
          .get();

  Future<void> markSynced(List<int> ids) =>
      (update(syncQueue)..where((s) => s.id.isIn(ids)))
          .write(const SyncQueueCompanion(synced: Value(true)));

  Future<int> pendingCount() async {
    final c = syncQueue.id.count();
    final q = selectOnly(syncQueue)
      ..addColumns([c])
      ..where(syncQueue.synced.equals(false));
    return (await q.map((r) => r.read(c)).getSingle()) ?? 0;
  }

  Future<void> clear() => delete(syncQueue).go();
}
