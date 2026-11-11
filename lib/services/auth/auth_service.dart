import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/admin.dart';
import '../../core/config/google_client.dart';
import '../cloud/profile_store.dart';

/// Google sign-in for backup and restore (plan F2). Firebase is optional: when
/// it failed to start, every call reports "not signed in" and the app keeps
/// working fully offline.
class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  bool _googleReady = false;

  /// Role from `roles/{email}`. A normal user until the document says otherwise.
  AppRole _role = AppRole.user;

  bool get available => _auth != null;

  User? get currentUser => _auth?.currentUser;
  String? get uid => currentUser?.uid;
  String? get email => currentUser?.email;
  String? get displayName => currentUser?.displayName;
  String? get photoUrl => currentUser?.photoURL;
  bool get isSignedIn => currentUser != null;

  /// The owner: manages the admin list. Set by the owner document in Firestore.
  bool get isRootAdmin => _role == AppRole.owner;

  /// Admin rights: the owner, or an account with role admin.
  bool get isSuperAdmin => _role == AppRole.owner || _role == AppRole.admin;

  /// Runs after sign-in and at app start: keeps the user's profile (name,
  /// email, photo) up to date and reads the role. Without Firebase, or when a
  /// read fails, the account is a normal user.
  Future<void> loadAccount() async {
    _role = AppRole.user;
    final user = currentUser;
    final db = _firestore;
    if (user == null || db == null) return;
    try {
      await ProfileStore(db).saveSignIn(
        uid: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } catch (_) {
      // The profile is saved on the next sign-in if this fails.
    }
    if (!user.emailVerified || user.email == null) return;
    try {
      final snap = await db
          .collection(adminRoleCollection)
          .doc(normalizeAdminEmail(user.email!))
          .get();
      _role = roleFromData(snap.data());
    } catch (_) {
      _role = AppRole.user;
    }
  }

  /// Must run once before the first Google sign-in.
  Future<void> init() async {
    if (_googleReady) return;
    await GoogleSignIn.instance.initialize(serverClientId: googleServerClientId);
    _googleReady = true;
  }

  /// Returns the signed-in user, or null when the user cancelled.
  /// Throws on real failures (no network, Firebase misconfigured).
  Future<User?> signInWithGoogle() async {
    final auth = _auth;
    if (auth == null) throw StateError('Firebase is not available');
    await init();
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw StateError('Google returned no ID token');
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await auth.signInWithCredential(credential);
      await loadAccount();
      return result.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (_googleReady) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Already signed out on the Google side.
      }
    }
    await _auth?.signOut();
    _role = AppRole.user;
  }

  /// Deletes the Firebase account. Firebase may ask for a recent sign-in;
  /// the error is returned so the caller can tell the user.
  Future<String?> deleteAccount() async {
    final user = currentUser;
    if (user == null) return null;
    try {
      // The profile goes first, while the account can still delete it.
      try {
        await _firestore?.collection('users').doc(user.uid).delete();
      } catch (_) {
        // Not fatal: the profile stays until the account is cleaned up.
      }
      await user.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      await signOut();
      return e.code;
    }
  }
}
