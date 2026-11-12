import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/config/admin.dart';

/// Reads and changes the roles in `roles/{email}`. Only the owner can write
/// here; firestore.rules refuse everyone else.
class RoleStore {
  RoleStore(this._db);

  final FirebaseFirestore _db;

  /// Emails with the admin role, sorted. The owner is listed separately.
  Future<List<String>> adminEmails() async {
    final snap = await _db
        .collection(adminRoleCollection)
        .where('role', isEqualTo: 'admin')
        .get();
    return [for (final d in snap.docs) d.id]..sort();
  }

  /// Every role document: email -> role ('owner', 'admin' or 'user'). Only the
  /// owner can read all roles (rules).
  Future<Map<String, String>> roles() async {
    final snap = await _db.collection(adminRoleCollection).get();
    return {
      for (final d in snap.docs) d.id: (d.data()['role'] ?? 'user').toString(),
    };
  }

  /// Sets an account to `admin` or `user`. The document is kept when it goes
  /// back to `user`, so the change is visible in the console.
  Future<void> setRole(String email, {required bool admin, required String byEmail}) {
    final id = normalizeAdminEmail(email);
    return _db.collection(adminRoleCollection).doc(id).set({
      'email': id,
      'role': admin ? 'admin' : 'user',
      'changed_by': normalizeAdminEmail(byEmail),
      'changed_on': DateTime.now().toIso8601String(),
    });
  }
}
