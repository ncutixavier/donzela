import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../services/security/pin_service.dart';

/// Session lock (F5). Locked on cold start when a PIN is set, and again when
/// the app returns after more than 2 minutes in the background.
class LockController extends ChangeNotifier {
  LockController({required PinService pins}) : _pins = pins;

  final PinService _pins;

  static const _secureChannel = MethodChannel('donzela/secure');
  static const backgroundLockAfter = Duration(minutes: 2);

  bool _locked = false;
  DateTime? _pausedAt;

  bool get locked => _locked;

  /// Called once at startup, after settings load.
  void startSession({required bool pinOn}) {
    _locked = pinOn;
    _syncSecureFlag(pinOn);
  }

  void onPaused() {
    _pausedAt ??= DateTime.now();
  }

  void onResumed({required bool pinOn}) {
    final since = _pausedAt;
    _pausedAt = null;
    if (!pinOn || since == null) return;
    if (DateTime.now().difference(since) > backgroundLockAfter) {
      _locked = true;
      notifyListeners();
    }
  }

  void lock() {
    _locked = true;
    notifyListeners();
  }

  void unlockWithoutPin() {
    _locked = false;
    notifyListeners();
  }

  /// Checks the PIN. Returns the outcome so the screen can show the
  /// wrong-PIN message or the lockout countdown.
  Future<PinCheck> tryUnlock(String pin) async {
    final result = await _pins.verify(pin);
    if (result.ok) {
      _locked = false;
      notifyListeners();
    }
    return result;
  }

  /// Hides app content in the recent-apps screen while the PIN is on
  /// (FLAG_SECURE, set natively in MainActivity).
  Future<void> setSecureScreen(bool on) => _syncSecureFlag(on);

  Future<void> _syncSecureFlag(bool on) async {
    try {
      await _secureChannel.invokeMethod<void>('setSecure', {'on': on});
    } on MissingPluginException {
      // Not on Android (tests, iOS, desktop).
    } on PlatformException {
      // Native side unavailable; the lock itself still works.
    }
  }
}
