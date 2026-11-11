import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/config/app_info.dart';
import '../../core/utils/dates.dart';
import '../../data/database/database.dart';
import '../../data/repositories/content_repository.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/firestore_cloud_store.dart';
import '../../services/sync/restore_service.dart';
import '../../services/sync/sync_service.dart';
import '../settings/settings_controller.dart';

/// Account, backup and restore (plan F2). Works only when Firebase started;
/// otherwise every action reports the cloud as unavailable.
class CloudController extends ChangeNotifier {
  CloudController({
    required AuthService auth,
    required FirebaseFirestore? firestore,
    required DonzelaDatabase db,
    required SettingsController settings,
    required ContentRepository content,
    required SyncService sync,
  })  : _auth = auth,
        _firestore = firestore,
        _db = db,
        _settings = settings,
        _content = content,
        _sync = sync;

  final AuthService _auth;
  final FirebaseFirestore? _firestore;
  final DonzelaDatabase _db;
  final SettingsController _settings;
  final ContentRepository _content;
  final SyncService _sync;

  bool get available => _auth.available && _firestore != null;
  bool get signedIn => _auth.isSignedIn;
  String? get email => _auth.email;

  /// Signs in with Google. Returns false when the user cancelled.
  Future<bool> signIn() async {
    final user = await _auth.signInWithGoogle();
    notifyListeners();
    return user != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  /// Pulls the signed-in user's data onto this phone. Returns what was found.
  Future<RestoreResult> restore({void Function(double)? onProgress}) async {
    final store = _store();
    final result = await RestoreService(_db, store).run(onProgress: onProgress);
    await _settings.load();
    return result;
  }

  /// Pulls public articles and health centres, so Learn and Help stay current.
  /// [onProgress] reports 0 to 1 across the three reads (articles, centres, numbers).
  Future<void> pullPublicContent({void Function(double)? onProgress}) async {
    final db = _firestore;
    if (db == null) return;
    onProgress?.call(0);
    final articles = await FirestoreCloudStore.publicCollection(db, 'articles');
    onProgress?.call(1 / 3);
    final centres =
        await FirestoreCloudStore.publicCollection(db, 'health_centres');
    onProgress?.call(2 / 3);
    await _content.applyRemote(articles: articles, centres: centres);
    final emergency = await FirestoreCloudStore.publicDoc(db, 'config', 'emergency');
    if (emergency != null) {
      final list = emergency['contacts'];
      if (list is List) {
        // Current format: the full list of contacts.
        await _content.setEmergencyContacts([
          for (final e in list)
            EmergencyContact.fromJson(Map<String, dynamic>.from(e as Map)),
        ]);
      } else {
        // Older format: the two fixed numbers.
        await _content.setEmergencyContacts([
          EmergencyContact(
            id: 'isange',
            name: '',
            number: (emergency['isange'] ?? ContentRepository.defaultIsange).toString(),
          ),
          EmergencyContact(
            id: 'ambulance',
            name: '',
            number: (emergency['ambulance'] ?? ContentRepository.defaultAmbulance).toString(),
          ),
        ]);
      }
    }
    onProgress?.call(1);
  }

  /// Uploads queued changes now, when backup is on. The last-sync time is
  /// recorded only when nothing is left waiting.
  Future<int> syncNow({void Function(double)? onProgress}) async {
    final handled = await _sync.run(
      backupOn: _settings.settings.backupOn,
      onProgress: onProgress,
    );
    if (_settings.settings.backupOn && await _sync.pendingCount() == 0) {
      await _settings.setLastSync(DateTime.now());
    }
    return handled;
  }

  Future<int> pendingCount() => _sync.pendingCount();

  /// Daily check-in (last seen date, app version, language). Only when the
  /// user has usage numbers turned on and is signed in.
  Future<void> checkIn() async {
    final db = _firestore;
    if (db == null || !signedIn || !_settings.settings.analyticsOn) return;
    await FirestoreCloudStore(db, _auth.uid!).checkIn(
      appVersion: appVersion,
      language: _settings.settings.language,
      lastSeen: dayKey(DateTime.now()),
    );
  }

  FirestoreCloudStore _store() {
    final db = _firestore;
    final uid = _auth.uid;
    if (db == null || uid == null) {
      throw StateError('Sign in to use backup');
    }
    return FirestoreCloudStore(db, uid);
  }
}
