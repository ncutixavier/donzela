import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/content_repository.dart';
import 'package:donzela/features/admin/admin_controller.dart';
import 'package:donzela/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('category keys', () {
    test('words become lowercase keys joined with dashes', () {
      expect(AdminController.categoryKey('Period Hygiene'), 'period-hygiene');
    });

    test('letters from other languages are kept', () {
      expect(AdminController.categoryKey('Santé'), 'santé');
    });

    test('blank input falls back to mine', () {
      expect(AdminController.categoryKey('   '), 'mine');
    });
  });

  group('outbox and lists', () {
    late DonzelaDatabase db;
    late ContentRepository content;
    late AdminController admin;

    setUp(() {
      db = DonzelaDatabase.memory();
      content = ContentRepository(db, includeDrafts: true);
      admin = AdminController(
        auth: AuthService(auth: null),
        store: null,
        content: content,
        outbox: db.contentOutboxDao,
        isOnline: () async => true,
      );
    });

    tearDown(() => db.close());

    test('without a signed-in admin nothing is written or queued', () async {
      await expectLater(
        admin.saveCentre(
          district: 'Rulindo',
          sector: '',
          name: 'Centre',
          phone: '',
          services: '',
        ),
        throwsStateError,
      );
      expect(await admin.pendingCount(), 0);
      expect(await content.districts(), ContentRepository.defaultDistricts);
    });

    test('a district and a category that are in use appear in the lists', () async {
      await content.applyRemote(articles: [
        {
          'id': 'a1',
          'lang': 'en',
          'category': 'nutrition',
          'title': 'Food',
          'body': 'Eat well',
          'reviewed_by': 'Dr',
        },
      ], centres: [
        {'id': 'c1', 'district': 'Rulindo', 'sector': 'S', 'name': 'N', 'phone': '', 'services': ''},
      ]);
      expect(await content.districts(), [...ContentRepository.defaultDistricts, 'Rulindo']);
      expect(await content.categories(), [...ContentRepository.defaultCategories, 'nutrition']);
    });

    test('a queued change stays in the outbox while it cannot be sent', () async {
      await db.contentOutboxDao.add('centre', '{"id":"c1"}', DateTime.now());
      expect(await admin.pendingCount(), 1);
      // No store and no admin here, so nothing is sent and the row is kept.
      expect(await admin.flush(), 0);
      expect(await admin.pendingCount(), 1);
    });
  });
}
