import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';
import '../seed/seed_content.dart';

/// One emergency number on Help. An empty [name] means the app's translated
/// name for the built-in ids ('isange', 'ambulance') is used.
class EmergencyContact {
  const EmergencyContact({required this.id, required this.name, required this.number});

  final String id;
  final String name;
  final String number;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'number': number};

  factory EmergencyContact.fromJson(Map<String, dynamic> j) => EmergencyContact(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        number: (j['number'] ?? '').toString(),
      );

  EmergencyContact copyWith({String? name, String? number}) =>
      EmergencyContact(id: id, name: name ?? this.name, number: number ?? this.number);
}

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
      if (id == null || lang == null) continue;
      // Tombstone from the super-admin: remove the article here as well.
      if (a['deleted'] == true) {
        await _db.contentDao.deleteArticle(id, lang);
        count++;
        continue;
      }
      final title = a['title'] as String?;
      final body = a['body'] as String?;
      if (title == null || body == null) continue;
      final reviewedBy = a['reviewed_by'] as String?;
      final reviewedOn = DateTime.tryParse((a['reviewed_on'] ?? '').toString());
      final proposed = a['proposed_reviewer'] as String?;
      await _db.contentDao.upsertArticle(ArticlesCompanion(
        id: Value(id),
        lang: Value(lang),
        category: Value((a['category'] as String?) ?? 'mine'),
        title: Value(title),
        body: Value(body),
        reviewedBy: Value(reviewedBy == null || reviewedBy.isEmpty ? null : reviewedBy),
        reviewedOn: Value(reviewedOn),
        proposedReviewer: Value(proposed == null || proposed.isEmpty ? null : proposed),
        updatedAt: Value(DateTime.now()),
      ));
      await _db.contentDao.indexArticle(id, lang, title, body);
      count++;
    }
    for (final c in centres) {
      final id = c['id'] as String?;
      if (id == null) continue;
      if (c['deleted'] == true) {
        await _db.contentDao.deleteCentre(id);
        count++;
        continue;
      }
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
  /// Emergency numbers shown on Help. Defaults are used until the
  /// super-admin sets them.
  static const defaultIsange = '3029';
  static const defaultAmbulance = '912';

  /// Emergency contacts shown on Help. Stored as one JSON list in settings.
  /// Before the list existed, the two old fixed numbers are used.
  Future<List<EmergencyContact>> emergencyContacts() async {
    final rows = await _db.settingsDao.readAll();
    final raw = rows['emergency_contacts'];
    if (raw != null) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      } catch (_) {
        // Unreadable value: fall back to the defaults below.
      }
    }
    return [
      EmergencyContact(
        id: 'isange',
        name: '',
        number: rows['emergency_isange'] ?? defaultIsange,
      ),
      EmergencyContact(
        id: 'ambulance',
        name: '',
        number: rows['emergency_ambulance'] ?? defaultAmbulance,
      ),
    ];
  }

  /// Replaces the whole list. Removing a contact here removes it everywhere.
  Future<void> setEmergencyContacts(List<EmergencyContact> contacts) =>
      _db.settingsDao.put(
        'emergency_contacts',
        jsonEncode(contacts.map((c) => c.toJson()).toList()),
      );

  /// Every health centre in every district, for the "All districts" view.
  Future<List<HealthCentreRow>> allCentres() async {
    final list = await _db.contentDao.allCentres();
    list.sort((a, b) {
      final d = a.district.compareTo(b.district);
      return d != 0 ? d : a.sector.compareTo(b.sector);
    });
    return list;
  }

  /// Articles shown on Learn. The super-admin passes [showDrafts] to see
  /// unreviewed articles too.
  Future<List<ArticleRow>> visibleArticles(String lang,
      {String? category, String? query, bool showDrafts = false}) async {
    var list = (includeDrafts || showDrafts)
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

  /// The three Kigali districts, always listed first.
  static const defaultDistricts = ['Gasabo', 'Kicukiro', 'Nyarugenge'];

  /// Category keys that always exist. Their labels are translated in the app.
  static const defaultCategories = ['mine', 'hygiene', 'contraception'];

  /// Default districts plus any district a health centre already uses, so a
  /// district the admin typed in appears here once it is saved.
  Future<List<String>> districts() async {
    final out = [...defaultDistricts];
    for (final c in await _db.contentDao.allCentres()) {
      final d = c.district.trim();
      if (d.isNotEmpty && !out.contains(d)) out.add(d);
    }
    return out;
  }

  /// The rows of one article, by language. One article is one id with one
  /// row per language, so a translation is the same id in another language.
  Future<Map<String, ArticleRow>> articlesOf(String id) async {
    final rows = <String, ArticleRow>{};
    for (final a in await _db.contentDao.everyArticle()) {
      if (a.id == id) rows[a.lang] = a;
    }
    return rows;
  }

  /// Default categories plus any category an article already uses.
  Future<List<String>> categories() async {
    final out = [...defaultCategories];
    for (final a in await _db.contentDao.everyArticle()) {
      if (!out.contains(a.category)) out.add(a.category);
    }
    return out;
  }
}
