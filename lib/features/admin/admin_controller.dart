import 'dart:convert';

import '../../data/database/daos.dart';
import '../../data/repositories/content_repository.dart';
export '../../data/repositories/content_repository.dart' show EmergencyContact;
import '../../services/auth/auth_service.dart';
import '../../services/cloud/content_admin_store.dart';

/// Super-admin editing of the Learn and Help content.
///
/// Offline first: every change is applied to this phone straight away and
/// written to the content outbox. The outbox is sent to Firestore when there
/// is a connection, oldest first, and an item stays in the outbox until the
/// cloud accepts it. So the admin can keep working without internet, and the
/// changes reach the cloud later.
class AdminController {
  AdminController({
    required AuthService auth,
    required ContentAdminStore? store,
    required ContentRepository content,
    required ContentOutboxDao outbox,
    required Future<bool> Function() isOnline,
  })  : _auth = auth,
        _store = store,
        _content = content,
        _outbox = outbox,
        _isOnline = isOnline;

  final AuthService _auth;
  final ContentAdminStore? _store;
  final ContentRepository _content;
  final ContentOutboxDao _outbox;
  final Future<bool> Function() _isOnline;

  bool get isSuperAdmin => _auth.isSuperAdmin;

  /// Admin can edit here. Edits are always saved on the phone, even without a
  /// cloud connection, so this only needs the admin account.
  bool get canWrite => isSuperAdmin;

  /// Changes saved on this phone that the cloud has not accepted yet.
  Future<int> pendingCount() => _outbox.count();

  void _requireAdmin() {
    if (!isSuperAdmin) throw StateError('Only the super-admin can edit content');
  }

  /// Creates an article (when [id] is null) or updates one. Returns true when
  /// the change already reached the cloud.
  Future<bool> saveArticle({
    String? id,
    required String lang,
    required String category,
    required String title,
    required String body,
    String? reviewer,
  }) async {
    _requireAdmin();
    final articleId = id ?? _newId(title);
    final reviewed = reviewer != null && reviewer.trim().isNotEmpty;
    final data = <String, dynamic>{
      'id': articleId,
      'lang': lang,
      'category': categoryKey(category),
      'title': title.trim(),
      'body': body.trim(),
      'reviewed_by': reviewed ? reviewer.trim() : null,
      'reviewed_on': reviewed ? DateTime.now().toIso8601String() : null,
    };
    await _content.applyRemote(articles: [data], centres: const []);
    await _enqueue('article', data);
    await flush();
    return await pendingCount() == 0;
  }

  Future<bool> deleteArticle(String id, String lang) async {
    _requireAdmin();
    final data = {'id': id, 'lang': lang, 'deleted': true};
    await _content.applyRemote(articles: [data], centres: const []);
    await _enqueue('delete_article', data);
    await flush();
    return await pendingCount() == 0;
  }

  /// Creates a health centre (when [id] is null) or updates one. Returns true
  /// when the change already reached the cloud. A district that does not exist
  /// yet is simply used: it appears in the list from now on.
  Future<bool> saveCentre({
    String? id,
    required String district,
    required String sector,
    required String name,
    required String phone,
    required String services,
  }) async {
    _requireAdmin();
    final centreId = id ?? 'centre-${DateTime.now().millisecondsSinceEpoch}';
    final data = <String, dynamic>{
      'id': centreId,
      'district': district.trim(),
      'sector': sector.trim(),
      'name': name.trim(),
      'phone': phone.trim(),
      'services': services.trim(),
    };
    await _content.applyRemote(articles: const [], centres: [data]);
    await _enqueue('centre', data);
    await flush();
    return await pendingCount() == 0;
  }

  Future<bool> deleteCentre(String id) async {
    _requireAdmin();
    final data = {'id': id, 'deleted': true};
    await _content.applyRemote(articles: const [], centres: [data]);
    await _enqueue('delete_centre', data);
    await flush();
    return await pendingCount() == 0;
  }

  /// Saves the whole emergency list (add, edit and delete all send the full
  /// list, so the cloud copy always matches the phone).
  Future<bool> saveEmergency(List<EmergencyContact> contacts) async {
    _requireAdmin();
    final data = {
      'contacts': [
        for (final c in contacts)
          {'id': c.id, 'name': c.name.trim(), 'number': c.number.trim()},
      ],
    };
    await _content.setEmergencyContacts([
      for (final c in data['contacts'] as List<Map<String, dynamic>>)
        EmergencyContact.fromJson(c),
    ]);
    await _enqueue('emergency', data);
    await flush();
    return await pendingCount() == 0;
  }

  /// Sends the outbox to Firestore, oldest first. Stops at the first failure,
  /// which stays in the outbox. Returns how many changes were sent.
  Future<int> flush() async {
    final store = _store;
    if (store == null || !isSuperAdmin) return 0;
    if (!await _isOnline()) return 0;
    var sent = 0;
    for (final row in await _outbox.pending()) {
      final data = jsonDecode(row.payload) as Map<String, dynamic>;
      try {
        switch (row.kind) {
          case 'article':
            await store.saveArticle(data);
          case 'delete_article':
            await store.deleteArticle(data['id'] as String, data['lang'] as String);
          case 'centre':
            await store.saveCentre(data);
          case 'delete_centre':
            await store.deleteCentre(data['id'] as String);
          case 'emergency':
            await store.saveEmergency(
              (data['contacts'] as List).cast<Map<String, dynamic>>(),
            );
          default:
            // Unknown kind from a newer app version: drop it so it cannot block the queue.
            break;
        }
      } catch (_) {
        break; // Offline or rejected: keep this and the rest for later.
      }
      await _outbox.remove(row.id);
      sent++;
    }
    return sent;
  }

  Future<void> _enqueue(String kind, Map<String, dynamic> data) =>
      _outbox.add(kind, jsonEncode(data), DateTime.now());

  /// Category key stored with an article: lowercase, words joined with '-'.
  /// The default keys (mine, hygiene, contraception) keep their translations.
  static String categoryKey(String raw) {
    // Letters of any script are kept, so a category typed in Kinyarwanda, French
    // or another language still gets a usable key.
    final key = raw
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return key.isEmpty ? 'mine' : key;
  }

  /// A readable id from the title, plus a timestamp so two titles never clash.
  static String _newId(String title) {
    final slug = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final base = slug.isEmpty ? 'article' : slug;
    final short = base.length > 40 ? base.substring(0, 40) : base;
    return '$short-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
  }
}
