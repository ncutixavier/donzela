import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';
import '../seed/seed_content.dart';

/// Articles and health centres. The saved flag is local only.
class ContentRepository {
  ContentRepository(this._db, {bool? includeDrafts})
      : includeDrafts = includeDrafts ?? kDebugMode;

  final DonzelaDatabase _db;

  /// Unreviewed articles are visible only in debug builds, marked as drafts.
  /// Release builds never show them (plan: unreviewed articles never ship).
  final bool includeDrafts;

  /// Loads the bundled articles into SQLite. Runs on every launch: it is
  /// cheap, it brings in new or edited articles, and it keeps the saved flag
  /// because the companion leaves that column out.
  Future<void> syncBundledContent({AssetBundle? bundle}) async {
    final articles = await loadBundledArticles(bundle ?? rootBundle);
    for (final a in articles) {
      await _db.contentDao.upsertArticle(ArticlesCompanion(
        id: Value(a.id),
        lang: Value(a.lang),
        category: Value(a.category),
        title: Value(a.title),
        body: Value(a.body),
        reviewedBy: Value(a.reviewedBy),
        reviewedOn: Value(a.reviewedOn),
        updatedAt: Value(DateTime.now()),
      ));
      await _db.contentDao.indexArticle(a.id, a.lang, a.title, a.body);
    }
    for (final c in seedCentres) {
      await _db.contentDao.upsertCentre(HealthCentresCompanion(
        id: Value(c.id),
        district: Value(c.district),
        sector: Value(c.sector),
        name: Value(c.name),
        phone: Value(c.phone),
        services: Value(c.services),
      ));
    }
  }

  /// Applies articles and health centres pulled from Firestore (public, read
  /// only). Remote content replaces local content with the same id and
  /// language. An article without a reviewer is still stored, but release
  /// builds never show it.
  Future<int> applyRemote({
    required List<Map<String, dynamic>> articles,
    required List<Map<String, dynamic>> centres,
  }) async {
    var count = 0;
    for (final a in articles) {
      final id = a['id'] as String?;
      final lang = a['lang'] as String?;
      final title = a['title'] as String?;
      final body = a['body'] as String?;
      if (id == null || lang == null || title == null || body == null) continue;
      final reviewedBy = a['reviewed_by'] as String?;
      final reviewedOn = DateTime.tryParse((a['reviewed_on'] ?? '').toString());
      await _db.contentDao.upsertArticle(ArticlesCompanion(
        id: Value(id),
        lang: Value(lang),
        category: Value((a['category'] as String?) ?? 'mine'),
        title: Value(title),
        body: Value(body),
        reviewedBy: Value(reviewedBy == null || reviewedBy.isEmpty ? null : reviewedBy),
        reviewedOn: Value(reviewedOn),
        updatedAt: Value(DateTime.now()),
      ));
      await _db.contentDao.indexArticle(id, lang, title, body);
      count++;
    }
    for (final c in centres) {
      final id = c['id'] as String?;
      if (id == null) continue;
      await _db.contentDao.upsertCentre(HealthCentresCompanion(
        id: Value(id),
        district: Value((c['district'] as String?) ?? ''),
        sector: Value((c['sector'] as String?) ?? ''),
        name: Value((c['name'] as String?) ?? ''),
        phone: Value((c['phone'] as String?) ?? ''),
        services: Value((c['services'] as String?) ?? ''),
      ));
      count++;
    }
    return count;
  }

  /// Articles shown on Learn, filtered by category and search text.
  Future<List<ArticleRow>> visibleArticles(String lang,
      {String? category, String? query}) async {
    var list = includeDrafts
        ? await _db.contentDao.allArticles(lang)
        : await _db.contentDao.reviewedArticles(lang);
    if (category != null && category != 'all') {
      list = list.where((a) => a.category == category).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final ids = (await _db.contentDao.searchIds(lang, query)).toSet();
      list = list.where((a) => ids.contains(a.id)).toList();
    }
    return list;
  }

  /// Single article. Returns null for unreviewed articles in release builds.
  Future<ArticleRow?> article(String id, String lang) async {
    final a = await _db.contentDao.article(id, lang);
    if (a == null) return null;
    if (a.reviewedBy == null && !includeDrafts) return null;
    return a;
  }

  Future<void> setSaved(String id, String lang, bool saved) =>
      _db.contentDao.setSaved(id, lang, saved);

  Future<List<HealthCentreRow>> centresIn(String district) =>
      _db.contentDao.centresIn(district);
}
