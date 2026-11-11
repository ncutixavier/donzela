import '../database/database.dart';

/// Typed view of the `settings` key/value table.
class AppSettings {
  const AppSettings({
    this.language = 'rw',
    this.pinOn = false,
    this.remindersPeriod = true,
    this.remindersFertile = true,
    this.remindersPill = false,
    this.pillHour = 9,
    this.pillMinute = 0,
    this.backupOn = false,
    this.analyticsOn = true,
    this.consentVersion,
    this.consentDate,
    this.onboardingDone = false,
    this.onboardingStep = 1,
    this.firstName = '',
    this.onboardingCycleLength = 28,
    this.periodLength = 5,
    this.lastPeriodDraft,
    this.lastPeriodEstimate = false,
    this.lastSync,
  });

  final String language;
  final bool pinOn;
  final bool remindersPeriod;
  final bool remindersFertile;
  final bool remindersPill;
  final int pillHour;
  final int pillMinute;
  final bool backupOn;
  final bool analyticsOn;
  final String? consentVersion;
  final DateTime? consentDate;
  final bool onboardingDone;
  final int onboardingStep;
  final String firstName;
  final int onboardingCycleLength;
  final int periodLength;
  final DateTime? lastPeriodDraft;
  final bool lastPeriodEstimate;
  /// When the last full sync finished. Device-only; never synced.
  final DateTime? lastSync;

  static const policyVersion = '1.0';

  factory AppSettings.fromMap(Map<String, String> m) {
    bool b(String k, bool def) => m.containsKey(k) ? m[k] == '1' : def;
    int i(String k, int def) => int.tryParse(m[k] ?? '') ?? def;
    return AppSettings(
      language: m['language'] ?? 'rw',
      pinOn: b('pin_on', false),
      remindersPeriod: b('reminders_period', true),
      remindersFertile: b('reminders_fertile', true),
      remindersPill: b('reminders_pill', false),
      pillHour: i('pill_hour', 9),
      pillMinute: i('pill_minute', 0),
      backupOn: b('backup_on', false),
      analyticsOn: b('analytics_on', true),
      consentVersion: m['consent_version'],
      consentDate: m['consent_date'] == null
          ? null
          : DateTime.tryParse(m['consent_date']!),
      onboardingDone: b('onboarding_done', false),
      onboardingStep: i('onboarding_step', 1),
      firstName: m['first_name'] ?? '',
      onboardingCycleLength: i('cycle_length', 28),
      periodLength: i('period_length', 5),
      lastPeriodDraft: m['onboarding_last_period'] == null
          ? null
          : DateTime.tryParse(m['onboarding_last_period']!),
      lastPeriodEstimate: b('onboarding_last_estimate', false),
      lastSync: m['last_sync'] == null ? null : DateTime.tryParse(m['last_sync']!),
    );
  }
}

class SettingsRepository {
  SettingsRepository(this._db);

  final DonzelaDatabase _db;

  Future<AppSettings> load() async =>
      AppSettings.fromMap(await _db.settingsDao.readAll());

  Future<void> put(String key, String value) => _db.settingsDao.put(key, value);

  Future<void> putBool(String key, bool value) =>
      put(key, value ? '1' : '0');

  Future<void> putInt(String key, int value) => put(key, value.toString());

  Future<void> recordConsent(DateTime now) async {
    await put('consent_version', AppSettings.policyVersion);
    await put('consent_date', now.toIso8601String());
  }

  Future<void> clearAll() => _db.settingsDao.clear();
}
