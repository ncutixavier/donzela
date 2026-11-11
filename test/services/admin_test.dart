import 'package:donzela/core/config/admin.dart';
import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/content_repository.dart';
import 'package:donzela/features/admin/admin_controller.dart';
import 'package:donzela/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('super-admin check', () {
    test('the super-admin with a verified address is admin', () {
      expect(isSuperAdminEmail(superAdminEmail, emailVerified: true), isTrue);
    });

    test('the check ignores letter case', () {
      expect(isSuperAdminEmail('NCUTI60@Gmail.com', emailVerified: true), isTrue);
    });

    test('an unverified address is not admin', () {
      expect(isSuperAdminEmail(superAdminEmail, emailVerified: false), isFalse);
    });

    test('any other account is not admin', () {
      expect(isSuperAdminEmail('someone@example.com', emailVerified: true), isFalse);
      expect(isSuperAdminEmail(null, emailVerified: true), isFalse);
    });

    test('without Firebase nobody is admin, and writes are refused', () async {
      final db = DonzelaDatabase.memory();
      addTearDown(db.close);
      final auth = AuthService(auth: null);
      final admin = AdminController(
        auth: auth,
        store: null,
        content: ContentRepository(db, includeDrafts: true),
        outbox: db.contentOutboxDao,
        isOnline: () async => false,
      );
      expect(admin.isSuperAdmin, isFalse);
      expect(admin.canWrite, isFalse);
      expect(
        () => admin.saveDraft(
          lang: 'en',
          category: 'mine',
          title: 'T',
          body: 'B',
        ),
        throwsStateError,
      );
      expect(
        () => admin.saveEmergency(const [EmergencyContact(id: 'isange', name: '', number: '1')]),
        throwsStateError,
      );
    });
  });

  group('content changes applied locally', () {
    late DonzelaDatabase db;
    late ContentRepository content;

    setUp(() {
      db = DonzelaDatabase.memory();
      content = ContentRepository(db, includeDrafts: false);
    });

    tearDown(() => db.close());

    test('a new article is saved, shown when reviewed, and searchable', () async {
      await content.applyRemote(articles: [
        {
          'id': 'new-1',
          'lang': 'en',
          'category': 'mine',
          'title': 'Fresh article',
          'body': 'Ferrous iron helps.',
          'reviewed_by': 'Dr A',
          'reviewed_on': '2026-11-01T00:00:00.000',
        },
      ], centres: const []);
      final shown = await content.visibleArticles('en');
      expect(shown.map((a) => a.id), contains('new-1'));
      final found = await content.visibleArticles('en', query: 'ferrous');
      expect(found.map((a) => a.id), ['new-1']);
    });

    test('an unreviewed article is hidden unless the admin asks for drafts', () async {
      await content.applyRemote(articles: [
        {'id': 'draft-1', 'lang': 'en', 'title': 'Draft', 'body': 'Text', 'reviewed_by': null},
      ], centres: const []);
      expect(await content.visibleArticles('en'), isEmpty);
      final drafts = await content.visibleArticles('en', showDrafts: true);
      expect(drafts.map((a) => a.id), ['draft-1']);
    });

    test('a tombstone removes the article here and from search', () async {
      await content.applyRemote(articles: [
        {'id': 'gone', 'lang': 'en', 'title': 'Bye', 'body': 'Searchable words', 'reviewed_by': 'Dr'},
      ], centres: const []);
      await content.applyRemote(articles: [
        {'id': 'gone', 'lang': 'en', 'deleted': true},
      ], centres: const []);
      expect(await content.article('gone', 'en'), isNull);
      final found = await content.visibleArticles('en', query: 'searchable');
      expect(found, isEmpty);
    });

    test('health centres can be added and removed with a tombstone', () async {
      await content.applyRemote(articles: const [], centres: [
        {'id': 'c1', 'district': 'Gasabo', 'sector': 'Kimironko', 'name': 'Kimironko HC', 'phone': '0780000000', 'services': 'Family planning'},
      ]);
      expect((await content.centresIn('Gasabo')).map((c) => c.name), ['Kimironko HC']);
      await content.applyRemote(articles: const [], centres: [
        {'id': 'c1', 'deleted': true},
      ]);
      expect(await content.centresIn('Gasabo'), isEmpty);
    });

    test('emergency numbers default until the admin sets them', () async {
      final defaults = await content.emergencyContacts();
      expect(defaults.map((c) => c.number), [
        ContentRepository.defaultIsange,
        ContentRepository.defaultAmbulance,
      ]);
    });

    test('emergency contacts can be added and removed as a whole list', () async {
      await content.setEmergencyContacts(const [
        EmergencyContact(id: 'isange', name: '', number: '3030'),
        EmergencyContact(id: 'custom-1', name: 'Police', number: '112'),
      ]);
      var list = await content.emergencyContacts();
      expect(list.map((c) => c.name), ['', 'Police']);
      expect(list.last.number, '112');
      await content.setEmergencyContacts(const [
        EmergencyContact(id: 'isange', name: '', number: '3030'),
      ]);
      list = await content.emergencyContacts();
      expect(list.map((c) => c.id), ['isange']);
    });
  });
}
