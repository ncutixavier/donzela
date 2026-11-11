import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/content_repository.dart';

/// Writes to the public content collections. Only the super-admin can write
/// (see firestore.rules). Deletes are tombstones (`deleted: true`), so every
/// device removes the item the next time it pulls.
class ContentAdminStore {
  ContentAdminStore(this._db);

  final FirebaseFirestore _db;

  Future<void> saveArticle(Map<String, dynamic> data) => _db
      .collection('articles')
      .doc('${data['id']}_${data['lang']}')
      .set({...data, 'deleted': false}, SetOptions(merge: true));

  Future<void> deleteArticle(String id, String lang) => _db
      .collection('articles')
      .doc('${id}_$lang')
      .set({'id': id, 'lang': lang, 'deleted': true}, SetOptions(merge: true));

  Future<void> saveCentre(Map<String, dynamic> data) => _db
      .collection('health_centres')
      .doc(data['id'] as String)
      .set({...data, 'deleted': false}, SetOptions(merge: true));

  Future<void> deleteCentre(String id) => _db
      .collection('health_centres')
      .doc(id)
      .set({'id': id, 'deleted': true}, SetOptions(merge: true));

  /// Writes the whole list. The two built-in numbers are also written under
  /// their old names, so older app versions still show them.
  Future<void> saveEmergency(List<Map<String, dynamic>> contacts) {
    String numberFor(String id, String fallback) => contacts
        .firstWhere((c) => c['id'] == id, orElse: () => {'number': fallback})['number']
        .toString();
    return _db.collection('config').doc('emergency').set(
          {
            'contacts': contacts,
            'isange': numberFor('isange', ContentRepository.defaultIsange),
            'ambulance': numberFor('ambulance', ContentRepository.defaultAmbulance),
          },
        );
  }
}
