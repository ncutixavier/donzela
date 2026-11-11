import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/database/database.dart';
import 'data/repositories/cycle_repository.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/daily_log_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'features/account/cloud_controller.dart';
import 'features/admin/admin_controller.dart';
import 'features/help/help_controller.dart';
import 'features/learn/learn_controller.dart';
import 'features/logs/logs_controller.dart';
import 'features/lock/lock_controller.dart';
import 'features/onboarding/onboarding_controller.dart';
import 'features/settings/settings_controller.dart';
import 'features/today/cycle_controller.dart';
import 'firebase_options.dart';
import 'services/analytics/analytics_service.dart';
import 'services/auth/auth_service.dart';
import 'services/cloud/content_admin_store.dart';
import 'services/cloud/firestore_cloud_store.dart';
import 'services/notifications/notification_service.dart';
import 'services/security/pin_service.dart';
import 'services/sync/connectivity.dart';
import 'services/sync/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final root = await buildRoot(useFirebase: true);
  runApp(root);
}

/// Wires repositories, services and controllers once and returns the root
/// widget. [database] and [initNotifications] exist so tests can run the real
/// app against an in-memory database without platform plugins.
Future<Widget> buildRoot({
  DonzelaDatabase? database,
  bool initNotifications = true,
  bool useFirebase = false,
}) async {
  // Firebase is optional: if it cannot start, the app runs fully offline.
  var firebaseReady = false;
  if (useFirebase) {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      firebaseReady = true;
    } catch (_) {
      firebaseReady = false;
    }
  }
  final crash = CrashReporter(sink: firebaseReady
      ? (type, message) => FirebaseCrashlytics.instance
          .recordError(Exception('$type: $message'), null, fatal: false)
      : null);
  if (firebaseReady) {
    crash.install();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  final auth = AuthService(auth: firebaseReady ? FirebaseAuth.instance : null);
  final firestore = firebaseReady ? FirebaseFirestore.instance : null;

  // Repositories and services are created once here and passed down.
  final db = database ?? DonzelaDatabase.open();
  final settingsRepo = SettingsRepository(db);
  final cycleRepo = CycleRepository(db);
  final dailyRepo = DailyLogRepository(db);
  final contentRepo = ContentRepository(db);
  await contentRepo.syncBundledContent();

  final analytics = AnalyticsService(
    sink: firebaseReady
        ? (name, params) => FirebaseAnalytics.instance.logEvent(
              name: name,
              parameters: params.isEmpty ? null : params,
            )
        : null,
  );
  final notifications = NotificationService();
  try {
    if (initNotifications) await notifications.init();
  } catch (e) {
    // Reminders are optional; the rest of the app must still start.
    crash.record(e, null);
  }
  final pins = PinService();
  // Backup needs a signed-in user; without one nothing is uploaded.
  Future<CloudStore?> storeProvider() async {
    final uid = auth.uid;
    if (firestore == null || uid == null) return null;
    return FirestoreCloudStore(firestore, uid);
  }

  final sync = SyncService(
    db,
    storeProvider: storeProvider,
    isOnline: isDeviceOnline,
  );

  final settings = SettingsController(
    repo: settingsRepo,
    analytics: analytics,
    wipeLocalData: () async {
      // Delete the cloud copy first, while still signed in.
      final store = await storeProvider();
      if (store != null) {
        try {
          await (store as FirestoreCloudStore).deleteAll();
        } catch (_) {
          // Offline: the cloud copy is removed the next time the user signs in.
        }
        await auth.deleteAccount();
      }
      await db.wipeUserData();
      await pins.clear();
      await notifications.cancelAll();
    },
  );
  await settings.load();

  final lock = LockController(pins: pins)
    ..startSession(pinOn: settings.settings.pinOn);

  final cycles = CycleController(
    cycles: cycleRepo,
    logs: dailyRepo,
    settings: settings,
    notifications: notifications,
    analytics: analytics,
    sync: sync,
  );
  await cycles.refresh();

  final onboarding = OnboardingController(
    settings: settings,
    settingsRepo: settingsRepo,
    cycles: cycleRepo,
    pins: pins,
    analytics: analytics,
  );
  final learn = LearnController(content: contentRepo, analytics: analytics);
  final help = HelpController(content: contentRepo, analytics: analytics);
  final cloud = CloudController(
    auth: auth,
    firestore: firestore,
    db: db,
    settings: settings,
    content: contentRepo,
    sync: sync,
  );
  final admin = AdminController(
    auth: auth,
    store: firestore == null ? null : ContentAdminStore(firestore),
    content: contentRepo,
    outbox: db.contentOutboxDao,
    isOnline: isDeviceOnline,
  );
  if (firebaseReady) {
    // Public content and the daily check-in run in the background.
    cloud.pullPublicContent().catchError((_) {});
    cloud.checkIn().catchError((_) {});
  }
  final logs = LogsController(
    logs: dailyRepo,
    cycles: cycleRepo,
    settings: settings,
    cycleChanges: cycles,
  )..load();

  return MultiProvider(
    providers: [
      Provider<DonzelaDatabase>.value(value: db),
      Provider<CycleRepository>.value(value: cycleRepo),
      Provider<DailyLogRepository>.value(value: dailyRepo),
      Provider<ContentRepository>.value(value: contentRepo),
      Provider<SettingsRepository>.value(value: settingsRepo),
      Provider<PinService>.value(value: pins),
      Provider<NotificationService>.value(value: notifications),
      Provider<AnalyticsService>.value(value: analytics),
      Provider<SyncService>.value(value: sync),
      ChangeNotifierProvider<SettingsController>.value(value: settings),
      ChangeNotifierProvider<LockController>.value(value: lock),
      ChangeNotifierProvider<CycleController>.value(value: cycles),
      ChangeNotifierProvider<OnboardingController>.value(value: onboarding),
      ChangeNotifierProvider<LearnController>.value(value: learn),
      ChangeNotifierProvider<HelpController>.value(value: help),
      ChangeNotifierProvider<LogsController>.value(value: logs),
      ChangeNotifierProvider<CloudController>.value(value: cloud),
      Provider<AdminController>.value(value: admin),
    ],
    child: DonzelaApp(settings: settings, lock: lock),
  );
}
