import 'package:cloud_firestore/cloud_firestore.dart';

/// Fields kept in `users/{uid}`. Only these are allowed by firestore.rules, so
/// a profile never carries health data or a role.
const profileFields = <String>{
  'uid',
  'email',
  'name',
  'photo_url',
  'provider',
  'created_at',
  'last_sign_in',
};

/// The profile data for one signed-in Google account. [createdAt] is set only
/// on the first sign-in, so it is kept when the account signs in again.
Map<String, dynamic> profileData({
  required String uid,
  required String? email,
  required String? name,
  required String? photoUrl,
  required DateTime now,
  DateTime? createdAt,
}) {
  final cleanEmail = (email ?? '').trim().toLowerCase();
  return {
    'uid': uid,
    'email': cleanEmail,
    'name': (name ?? '').trim().isEmpty ? cleanEmail : name!.trim(),
    'photo_url': (photoUrl ?? '').trim().isEmpty ? null : photoUrl!.trim(),
    'provider': 'google',
    if (createdAt != null) 'created_at': createdAt.toIso8601String(),
    'last_sign_in': now.toIso8601String(),
  };
}

/// One person who has signed in with Google.
class UserProfile {
  const UserProfile({required this.uid, required this.email, required this.name, this.photoUrl});

  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
}

/// Reads and writes `users/{uid}` profiles.
class ProfileStore {
  ProfileStore(this._db);

  final FirebaseFirestore _db;

  /// Creates the profile on first sign-in and refreshes name, email and photo
  /// on later ones.
  Future<void> saveSignIn({
    required String uid,
    required String? email,
    required String? name,
    required String? photoUrl,
  }) async {
    final ref = _db.collection('users').doc(uid);
    final existing = await ref.get();
    DateTime? createdAt;
    if (!existing.exists) createdAt = DateTime.now();
    await ref.set(
      profileData(
        uid: uid,
        email: email,
        name: name,
        photoUrl: photoUrl,
        now: DateTime.now(),
        createdAt: createdAt,
      ),
      SetOptions(merge: true),
    );
  }

  /// Every profile, by name. Only owners and admins can read them (rules).
  Future<List<UserProfile>> all() async {
    final snap = await _db.collection('users').get();
    final list = [
      for (final d in snap.docs)
        UserProfile(
          uid: d.id,
          email: (d.data()['email'] ?? '').toString(),
          name: (d.data()['name'] ?? d.data()['email'] ?? '').toString(),
          photoUrl: d.data()['photo_url'] as String?,
        ),
    ];
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }
}
