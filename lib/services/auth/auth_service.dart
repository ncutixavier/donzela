import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/admin.dart';
import '../../core/config/google_client.dart';

/// Google sign-in for backup and restore (plan F2). Firebase is optional: when
/// it failed to start, every call reports "not signed in" and the app keeps
/// working fully offline.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth;

  final FirebaseAuth? _auth;
  bool _googleReady = false;

  bool get available => _auth != null;

  User? get currentUser => _auth?.currentUser;
  String? get uid => currentUser?.uid;
  String? get email => currentUser?.email;
  bool get isSignedIn => currentUser != null;

  /// True when the signed-in account is the super-admin (verified address).
  bool get isSuperAdmin => isSuperAdminEmail(
        currentUser?.email,
        emailVerified: currentUser?.emailVerified ?? false,
      );

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
  }

  /// Deletes the Firebase account. Firebase may ask for a recent sign-in;
  /// the error is returned so the caller can tell the user.
  Future<String?> deleteAccount() async {
    final user = currentUser;
    if (user == null) return null;
    try {
      await user.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      await signOut();
      return e.code;
    }
  }
}
