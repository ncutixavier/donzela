import 'package:flutter/foundation.dart';

import '../../data/repositories/settings_repository.dart';
import '../../services/analytics/analytics_service.dart';

/// App-wide settings (F5 and F1 preferences). Screens read [settings] and
/// call the setters, which write to SQLite before notifying listeners.
class SettingsController extends ChangeNotifier {
  SettingsController({
    required SettingsRepository repo,
    required AnalyticsService analytics,
    required Future<void> Function() wipeLocalData,
  })  : _repo = repo,
        _analytics = analytics,
        _wipe = wipeLocalData;

  final SettingsRepository _repo;
  final AnalyticsService _analytics;
  final Future<void> Function() _wipe;

  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _repo.load();
    _analytics.enabled = _settings.analyticsOn;
    notifyListeners();
  }

  Future<void> _refresh() async {
    _settings = await _repo.load();
    notifyListeners();
  }

  /// Privacy step: records consent with the date and policy version.
  Future<void> acceptPrivacy({required DateTime now}) async {
    await _repo.recordConsent(now);
    await _refresh();
  }

  Future<void> setLanguage(String code) async {
    await _repo.put('language', code);
    await _refresh();
  }

  Future<void> setFirstName(String name) async {
    await _repo.put('first_name', name.trim());
    await _refresh();
  }

  /// Turning the PIN on or off is handled by the lock controller, which
  /// also stores the hash. This only records the flag.
  Future<void> setPinFlag(bool on) async {
    await _repo.putBool('pin_on', on);
    await _refresh();
  }

  Future<void> setReminder(String type, bool on) async {
    final key = switch (type) {
      'period' => 'reminders_period',
      'fertile' => 'reminders_fertile',
      'pill' => 'reminders_pill',
      _ => throw ArgumentError.value(type, 'type'),
    };
    await _repo.putBool(key, on);
    if (on) _analytics.track('reminder_enabled', {'type': type});
    await _refresh();
  }

  Future<void> setPillTime(int hour, int minute) async {
    await _repo.putInt('pill_hour', hour);
    await _repo.putInt('pill_minute', minute);
    await _refresh();
  }

  /// Turning backup on records consent with the date and policy version.
  Future<void> setBackup(bool on, {required DateTime now}) async {
    if (on) {
      await _repo.recordConsent(now);
      _analytics.track('backup_enabled');
    }
    await _repo.putBool('backup_on', on);
    await _refresh();
  }

  Future<void> setAnalytics(bool on) async {
    await _repo.putBool('analytics_on', on);
    _analytics.enabled = on;
    await _refresh();
  }

  Future<void> setOnboardingStep(int step) async {
    await _repo.putInt('onboarding_step', step);
    _settings = await _repo.load();
    // Step changes are frequent; no need to notify the whole app.
  }

  Future<void> setOnboardingDone() async {
    await _repo.putBool('onboarding_done', true);
    await _refresh();
  }

  Future<void> setLastSync(DateTime when) async {
    await _repo.put('last_sync', when.toIso8601String());
    await _refresh();
  }

  /// Draft last-period date from onboarding step 3. Null clears it.
  Future<void> setOnboardingLastPeriod(DateTime? date, {bool estimate = false}) async {
    if (date == null) {
      await _repo.put('onboarding_last_period', '');
    } else {
      await _repo.put('onboarding_last_period', date.toIso8601String());
    }
    await _repo.putBool('onboarding_last_estimate', estimate);
    await _refresh();
  }

  Future<void> setCycleDefaults({int? cycleLength, int? periodLength}) async {
    if (cycleLength != null) await _repo.putInt('cycle_length', cycleLength);
    if (periodLength != null) await _repo.putInt('period_length', periodLength);
    await _refresh();
  }

  /// "Siba amakuru yanjye yose": wipes SQLite, secure storage and cloud data
  /// (through [_wipe]), then returns the app to onboarding.
  Future<void> deleteEverything() async {
    await _wipe();
    _settings = const AppSettings();
    notifyListeners();
  }
}
