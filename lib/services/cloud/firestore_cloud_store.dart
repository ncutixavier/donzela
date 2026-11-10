import 'package:cloud_firestore/cloud_firestore.dart';

import '../sync/restore_service.dart';
import '../sync/sync_service.dart';

/// Firestore layout (plan F2):
///   users/{uid}/cycles/{id}, users/{uid}/daily_logs/{id}, users/{uid}/settings/current
///   checkins/{uid}                       daily check-in (last seen, version, language)
///   articles/{id}, health_centres/{id}   public content, read-only for the app
///
/// Writes are batched in groups of 500. The security rules let a signed-in
/// user touch only her own tree.
class FirestoreCloudStore implements CloudStore, RemoteReader {
  FirestoreCloudStore(this._db, this.uid);

  final FirebaseFirestore _db;
  final String uid;

  static const userTables = ['cycles', 'daily_logs', 'settings'];
  static const _batchLimit = 500;

  CollectionReference<Map<String, dynamic>> _userCol(String table) =>
      _db.collection('users').doc(uid).collection(table);

  @override
  Future<void> push(List<CloudWrite> writes) async {
    for (var i = 0; i < writes.length; i += _batchLimit) {
      final batch = _db.batch();
      for (final w in writes.skip(i).take(_batchLimit)) {
        batch.set(
          _userCol(w.table).doc(w.recordId),
          w.data,
          SetOptions(merge: true),
        );
      }
      await batch.commit();
    }
  }

  @override
  Future<List<RemoteDoc>> fetch(String table) async {
    final snap = await _userCol(table).get();
    return [for (final d in snap.docs) RemoteDoc(d.id, d.data())];
  }

  /// Removes everything this user has in the cloud.
  Future<void> deleteAll() async {
    for (final table in userTables) {
      final snap = await _userCol(table).get();
      for (var i = 0; i < snap.docs.length; i += _batchLimit) {
        final batch = _db.batch();
        for (final d in snap.docs.skip(i).take(_batchLimit)) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }
    }
    await _db.collection('users').doc(uid).delete();
    await _db.collection('checkins').doc(uid).delete();
  }

  /// Daily check-in: last seen date, app version and language only.
  Future<void> checkIn({
    required String appVersion,
    required String language,
    required String lastSeen,
  }) =>
      _db.collection('checkins').doc(uid).set({
        'last_seen': lastSeen,
        'app_version': appVersion,
        'language': language,
      }, SetOptions(merge: true));

  /// Public content (articles or health centres). Read-only from the app.
  static Future<List<Map<String, dynamic>>> publicCollection(
    FirebaseFirestore db,
    String name,
  ) async {
    final snap = await db.collection(name).get();
    return [
      for (final d in snap.docs)
        {
          'id': d.id,
          // Timestamps become ISO strings so the repository needs no Firebase types.
          for (final e in d.data().entries)
            e.key: e.value is Timestamp
                ? (e.value as Timestamp).toDate().toIso8601String()
                : e.value,
        },
    ];
  }
}
