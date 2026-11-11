import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/l10n/localization.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/account/cloud_controller.dart';
import 'features/admin/admin_controller.dart';
import 'features/lock/lock_controller.dart';
import 'features/settings/settings_controller.dart';
import 'features/today/cycle_controller.dart';

/// Root widget. Rebuilds when the language changes, so every visible word
/// (including dates) switches at once. Also handles the PIN lock on
/// background/foreground and the secure-screen flag.
class DonzelaApp extends StatefulWidget {
  const DonzelaApp({super.key, required this.settings, required this.lock});

  final SettingsController settings;
  final LockController lock;

  @override
  State<DonzelaApp> createState() => _DonzelaAppState();
}

class _DonzelaAppState extends State<DonzelaApp> with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter(
    settings: widget.settings,
    lock: widget.lock,
  );

  bool _lastPinOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lastPinOn = widget.settings.settings.pinOn;
    widget.settings.addListener(_onSettings);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.settings.removeListener(_onSettings);
    super.dispose();
  }

  void _onSettings() {
    final pinOn = widget.settings.settings.pinOn;
    if (pinOn != _lastPinOn) {
      _lastPinOn = pinOn;
      widget.lock.setSecureScreen(pinOn);
      if (!pinOn) widget.lock.unlockWithoutPin();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final pinOn = widget.settings.settings.pinOn;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        widget.lock.onPaused();
      case AppLifecycleState.resumed:
        widget.lock.onResumed(pinOn: pinOn);
        // Sync whenever the app comes back to the foreground.
        final cloud = context.read<CloudController>();
        cloud.syncNow().ignore();
        // Latest articles and Help information, so the cache stays current.
        cloud.pullPublicContent().catchError((_) {});
        // Admin content saved while offline goes up now that the app is back.
        context.read<AdminController>().flush().ignore();
        cloud.checkIn().ignore();
        context.read<CycleController>().refresh();
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (c) => AppLocalizations.of(c).appName,
          theme: AppTheme.light(),
          locale: localeFor(widget.settings.settings.language),
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationDelegates,
          routerConfig: _router,
        );
      },
    );
  }
}
