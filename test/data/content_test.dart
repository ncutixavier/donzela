import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/content_repository.dart';
import 'package:donzela/data/seed/seed_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every article exists in every language and parses', () async {
    final index = [
      'cycle-basics', 'cycle-phases', 'ovulation-fertile', 'irregular-cycles',
      'period-myths', 'see-a-doctor', 'nutrition-activity', 'period-pain',
      'period-hygiene', 'contraception-overview', 'emergency-contraception',
    ];
    final all = await loadBundledArticles(rootBundle);
    expect(all.length, index.length * contentLanguages.length);

    for (final id in index) {
      final forId = all.where((a) => a.id == id).toList();
      expect(forId.map((a) => a.lang).toSet(), contentLanguages.toSet(),
          reason: '$id must exist in rw, en and fr');
      for (final a in forId) {
        expect(a.title.trim(), isNotEmpty);
        expect(a.body.length, greaterThan(400),
            reason: '${a.lang}/$id is too short to be useful');
        expect(a.reviewedBy, isNull,
            reason: 'bundled drafts must not claim a reviewer');
      }
      // Titles differ between languages, so no article was copied unchanged.
      final titles = forId.map((a) => a.title).toSet();
      expect(titles.length, contentLanguages.length);
    }
  });

  test('a missing front matter is rejected', () {
    expect(
      () => parseArticle('no front matter here',
          expectedLang: 'en', expectedCategory: 'mine'),
      throwsFormatException,
    );
  });

  test('reviewed articles parse their reviewer and date', () {
    final a = parseArticle(
      '---\nid: x\ncategory: mine\ntitle: T\nreviewed_by: Dr A\nreviewed_on: 2026-05-01\n---\nBody text',
      expectedLang: 'en',
      expectedCategory: 'mine',
    );
    expect(a.reviewedBy, 'Dr A');
    expect(a.reviewedOn, DateTime(2026, 5, 1));
    expect(a.body, 'Body text');
  });

  group('repository visibility', () {
    late DonzelaDatabase db;

    setUp(() async {
      db = DonzelaDatabase.memory();
      await ContentRepository(db, includeDrafts: true).syncBundledContent();
    });

    tearDown(() => db.close());

    test('release builds hide unreviewed drafts', () async {
      final repo = ContentRepository(db, includeDrafts: false);
      expect(await repo.visibleArticles('en'), isEmpty);
      final draft = await repo.article('cycle-basics', 'en');
      expect(draft, isNull);
    });

    test('debug builds show drafts in every language', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      expect(await repo.visibleArticles('en'), hasLength(11));
      expect(await repo.visibleArticles('rw'), hasLength(11));
      expect(await repo.visibleArticles('fr'), hasLength(11));
    });

    test('category filter works', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      final contraception =
          await repo.visibleArticles('en', category: 'contraception');
      expect(contraception.map((a) => a.id).toSet(),
          {'contraception-overview', 'emergency-contraception'});
    });

    test('offline search finds articles by words in the body', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      final found = await repo.visibleArticles('en', query: 'iron');
      expect(found.map((a) => a.id), contains('nutrition-activity'));
      final frFound = await repo.visibleArticles('fr', query: 'fer');
      expect(frFound.map((a) => a.id), contains('nutrition-activity'));
    });

    test('saved bookmark survives a content re-sync', () async {
      final repo = ContentRepository(db, includeDrafts: true);
      await repo.setSaved('period-pain', 'en', true);
      await repo.syncBundledContent();
      final row = await repo.article('period-pain', 'en');
      expect(row!.saved, isTrue);
    });
  });
}
