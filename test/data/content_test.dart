import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/content_repository.dart';
import 'package:donzela/features/learn/learn_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// Articles arrive from Firestore (see ContentRepository.applyRemote) and are
/// kept in the local database, so these tests feed them in directly.
Map<String, dynamic> article(String id, String lang, String category,
        {String? reviewer, String body = 'Body text about iron and fer'}) =>
    {
      'id': id,
      'lang': lang,
      'category': category,
      'title': '$id ($lang)',
      'body': body,
      'reviewed_by': reviewer,
      'reviewed_on': reviewer == null ? null : '2026-05-01T00:00:00.000',
    };

void main() {
  group('repository visibility', () {
    late DonzelaDatabase db;

    setUp(() async {
      db = DonzelaDatabase.memory();
      await ContentRepository(db, includeDrafts: true).applyRemote(articles: [
        article('cycle-basics', 'en', 'mine', reviewer: 'Donzela Team'),
        article('cycle-basics', 'fr', 'mine', reviewer: 'Donzela Team'),
        article('draft-one', 'en', 'mine'),
        article('contraception-overview', 'en', 'contraception', reviewer: 'Donzela Team'),
        article('nutrition-activity', 'en', 'hygiene', reviewer: 'Donzela Team',
            body: 'Foods with iron help.'),
        article('nutrition-activity', 'fr', 'hygiene', reviewer: 'Donzela Team',
            body: 'Les aliments riches en fer aident.'),
      ], centres: const []);
    });

    tearDown(() => db.close());

    test('release builds hide unreviewed drafts', () async {
      final repo = ContentRepository(db, includeDrafts: false);
      final shown = await repo.visibleArticles('en');
      expect(shown.map((a) => a.id), isNot(contains('draft-one')));
      expect(await repo.article('draft-one', 'en'), isNull);
    });

    test('debug builds show drafts too', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      expect(await repo.visibleArticles('en'), hasLength(4));
    });

    test('a language with no article shows nothing in that language', () async {
      final repo = ContentRepository(db, includeDrafts: false);
      expect(await repo.visibleArticles('rw'), isEmpty);
    });

    test('category filter works', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      final contraception =
          await repo.visibleArticles('en', category: 'contraception');
      expect(contraception.map((a) => a.id), ['contraception-overview']);
    });

    test('offline search finds articles by words in the body', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      final found = await repo.visibleArticles('en', query: 'iron');
      expect(found.map((a) => a.id), contains('nutrition-activity'));
      final frFound = await repo.visibleArticles('fr', query: 'fer');
      expect(frFound.map((a) => a.id), contains('nutrition-activity'));
    });

    test('saved bookmark survives a re-pull of the same article', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      await repo.setSaved('nutrition-activity', 'en', true);
      await repo.applyRemote(articles: [
        article('nutrition-activity', 'en', 'hygiene', reviewer: 'Donzela Team'),
      ], centres: const []);
      final row = await repo.article('nutrition-activity', 'en');
      expect(row!.saved, isTrue);
    });

    test('the content is readable with no connection: nothing is fetched on read', () async {
      // A second repository over the same database reads the cache directly.
      final repo = ContentRepository(db, includeDrafts: false);
      expect((await repo.visibleArticles('fr')).map((a) => a.id),
          ['cycle-basics', 'nutrition-activity']);
    });
  });

  group('article dates', () {
    test('created, published and updated dates are stored and kept', () async {
      final db = DonzelaDatabase.memory();
      addTearDown(db.close);
      final repo = ContentRepository(db, includeDrafts: true);
      await repo.applyRemote(articles: [
        {
          'id': 'dated',
          'lang': 'en',
          'category': 'mine',
          'title': 'Dated',
          'body': 'Text',
          'reviewed_by': 'Donzela Team',
          'created_at': '2026-01-02T00:00:00.000',
          'published_at': '2026-01-03T00:00:00.000',
          'updated_at': '2026-02-04T00:00:00.000',
        },
      ], centres: const []);
      final a = await repo.article('dated', 'en');
      expect(a!.createdAt, DateTime(2026, 1, 2));
      expect(a.reviewedOn, DateTime(2026, 1, 3));
      expect(a.updatedAt, DateTime(2026, 2, 4));
    });
  });

  group('pulling replaces stale articles', () {
    test('an article removed in Firestore is removed here, and new ones arrive', () async {
      final db = DonzelaDatabase.memory();
      addTearDown(db.close);
      final repo = ContentRepository(db, includeDrafts: true);
      await repo.applyRemote(articles: [article('old-bundled', 'en', 'mine', reviewer: 'Dr')], centres: const []);
      await repo.applyRemote(
        articles: [article('fresh', 'en', 'mine', reviewer: 'Donzela Team')],
        centres: const [],
        replaceArticles: true,
      );
      expect(await repo.article('old-bundled', 'en'), isNull);
      expect(await repo.article('fresh', 'en'), isNotNull);
    });

    test('an unsent local change is kept even when Firestore does not have it', () async {
      final db = DonzelaDatabase.memory();
      addTearDown(db.close);
      final repo = ContentRepository(db, includeDrafts: true);
      await repo.applyRemote(articles: [article('pending', 'en', 'mine')], centres: const []);
      await db.contentOutboxDao.add(
        'article',
        '{"id":"pending","lang":"en"}',
        DateTime.now(),
      );
      await repo.applyRemote(articles: const [], centres: const [], replaceArticles: true);
      expect(await repo.article('pending', 'en'), isNotNull);
    });
  });

  group('category chips', () {
    test('only categories with an article are offered', () {
      ArticleRow row(String category) => ArticleRow(
            id: 'a-$category',
            lang: 'en',
            category: category,
            title: 'T',
            body: 'B',
            reviewedBy: 'Donzela Team',
            updatedAt: DateTime(2026),
            saved: false,
          );
      final used = usedCategoryKeys(
        [row('mine')],
        ['mine', 'hygiene', 'contraception'],
      );
      expect(used, ['mine']);
    });
  });
}
