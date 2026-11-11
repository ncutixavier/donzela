import 'package:flutter/foundation.dart';

import '../../core/utils/dates.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/security/pin_service.dart';
import '../settings/settings_controller.dart';

/// Onboarding steps 1–5 (F1). Screen 6 is Today's first-use variant.
///
/// Every answer is saved as it is given, so closing the app mid-onboarding
/// resumes at the same step with the same answers.
class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required SettingsController settings,
    required SettingsRepository settingsRepo,
    required CycleRepository cycles,
    required PinService pins,
    required AnalyticsService analytics,
  })  : _settings = settings,
        _settingsRepo = settingsRepo,
        _cycles = cycles,
        _pins = pins,
        _analytics = analytics {
    // Answers are read from settings, so pass its changes on to the steps.
    _settings.addListener(notifyListeners);
  }

  final SettingsController _settings;
  final SettingsRepository _settingsRepo;
  final CycleRepository _cycles;
  final PinService _pins;
  final AnalyticsService _analytics;

  @override
  void dispose() {
    _settings.removeListener(notifyListeners);
    super.dispose();
  }

  static const totalSteps = 5;

  int get step => _settings.settings.onboardingStep.clamp(1, totalSteps);

  /// Draft answers. Read from settings so they survive an app restart.
  DateTime? get lastPeriodStart => _settings.settings.lastPeriodDraft;
  bool get lastPeriodIsEstimate => _settings.settings.lastPeriodEstimate;
  int get cycleLength => _settings.settings.onboardingCycleLength;
  int get periodLength => _settings.settings.periodLength;

  Future<void> goToStep(int n) async {
    await _settings.setOnboardingStep(n.clamp(1, totalSteps));
    notifyListeners();
  }

  Future<void> setLastPeriod(DateTime? date, {bool estimate = false}) =>
      _settings.setOnboardingLastPeriod(
        date == null ? null : dayOnly(date),
        estimate: estimate,
      );

  Future<void> setCycleLength(int v) =>
      _settings.setCycleDefaults(cycleLength: v.clamp(21, 45));

  Future<void> setPeriodLength(int v) =>
      _settings.setCycleDefaults(periodLength: v.clamp(2, 10));

  /// Final step: create the first cycle, save PIN and reminders, then mark
  /// onboarding done. The caller opens screen 6 afterwards.
  Future<void> finish({
    required bool pinOn,
    String? pin,
    required bool remindersPeriod,
    required bool remindersFertile,
    required bool remindersPill,
  }) async {
    final start = lastPeriodStart ?? dayOnly(DateTime.now());
    final existing = await _cycles.all();
    if (existing.isEmpty) {
      await _cycles.startCycle(
        start: start,
        periodLength: periodLength,
        isEstimate: lastPeriodIsEstimate,
      );
    }
    await _settings.setOnboardingLastPeriod(null, estimate: false);

    if (pinOn && pin != null) {
      await _pins.setPin(pin);
    }
    await _settings.setPinFlag(pinOn);
    await _settingsRepo.putBool('reminders_period', remindersPeriod);
    await _settingsRepo.putBool('reminders_fertile', remindersFertile);
    await _settingsRepo.putBool('reminders_pill', remindersPill);
    await _settings.setOnboardingDone();

    _analytics.track('onboarding_completed');
  }
}
