import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/l10n/localization.dart';
import '../../core/utils/dates.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../data/database/database.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/insights/insights_service.dart';
import '../../services/prediction/prediction_service.dart';
import '../../services/sync/sync_service.dart';
import '../settings/settings_controller.dart';

/// One completed or open cycle in the nurse report.
class ReportCycle {
  const ReportCycle({required this.start, this.cycleLength, required this.periodLength});
  final DateTime start;
  final int? cycleLength;
  final int periodLength;
}

class ReportData {
  const ReportData({
    required this.cycles,
    required this.averageCycle,
    required this.averagePeriod,
    required this.lastStart,
    required this.topSymptoms,
  });

  /// Most recent 6 cycles, oldest first.
  final List<ReportCycle> cycles;
  final int averageCycle;
  final int averagePeriod;
  final DateTime? lastStart;

  /// Symptom key → number of days logged, highest first, at most 3.
  final List<MapEntry<String, int>> topSymptoms;
}

/// Shared data layer for Today, the daily log and the calendar (F4).
/// Predictions are recomputed after every period log or edit and cached here.
class CycleController extends ChangeNotifier {
  CycleController({
    required CycleRepository cycles,
    required DailyLogRepository logs,
    required SettingsController settings,
    required NotificationService notifications,
    required AnalyticsService analytics,
    required SyncService sync,
  })  : _cycles = cycles,
        _logs = logs,
        _settings = settings,
        _notifications = notifications,
        _analytics = analytics,
        _sync = sync;

  final CycleRepository _cycles;
  final DailyLogRepository _logs;
  final SettingsController _settings;
  final NotificationService _notifications;
  final AnalyticsService _analytics;
  final SyncService _sync;

  static const _predictor = PredictionService();

  List<CycleRow> _rows = const [];
  List<DayLog> _entries = const [];
  PredictionResult _prediction = const PredictionResult.empty(28);
  bool _loaded = false;

  bool get loaded => _loaded;
  PredictionResult get prediction => _prediction;
  List<CycleRow> get cycleRows => _rows;
  bool get hasOpenPeriod => _rows.any((c) => c.endDate == null);

  /// True for the first-use variant of Today (screen 6).
  bool get isFirstUse => _rows.length <= 1 && _entries.isEmpty;

  /// Every entry logged on [day], oldest first.
  List<DayLog> logsFor(DateTime day) =>
      _entries.where((l) => isSameDay(l.day, day)).toList();

  int get _onboardingCycle => _settings.settings.onboardingCycleLength;
  int get _periodLength => _settings.settings.periodLength;

  Future<void> refresh() async {
    _rows = await _cycles.all();
    final logs = await _logs.all();
    _entries = logs;
    _recompute();
    _loaded = true;
    notifyListeners();
  }

  void _recompute() {
    final records = _rows
        .map((c) => CycleRecord(
              start: c.startDate,
              end: c.endDate,
              isEstimate: c.isEstimate,
            ))
        .toList();
    _prediction = _predictor.predict(
      cycles: records,
      onboardingCycleLength: _onboardingCycle,
      today: DateTime.now(),
    );
  }

  /// Phase of one calendar day, using the same rules as the ring.
  DayPhase phaseFor(DateTime day) {
    final records = _rows
        .map((c) => CycleRecord(
              start: c.startDate,
              end: c.endDate,
              isEstimate: c.isEstimate,
            ))
        .toList();
    return _predictor.phaseFor(
      day: day,
      cycles: records,
      onboardingCycleLength: _onboardingCycle,
      periodLength: _periodLength,
    );
  }

  /// Save one entry (new or edited). A flow other than "none" on a day with
  /// no open period is handled by the caller: it asks "did your period start
  /// today?".
  Future<void> saveLog(DayLog log) async {
    await _logs.save(log);
    _analytics.track('day_logged');
    await refresh();
    _afterWrite();
  }

  /// Starts a period on [day]. Use [end] when the period is already over.
  Future<void> startPeriod(DateTime day, {DateTime? end}) async {
    // A new period closes the open one the day before it starts.
    final open = _rows.where((c) => c.endDate == null).lastOrNull;
    if (open != null && dayOnly(day).isAfter(open.startDate)) {
      await _cycles.endPeriod(addDays(day, -1));
    }
    await _cycles.startCycle(
      start: day,
      periodLength: _periodLength,
      end: end,
    );
    await refresh();
    _afterWrite();
  }

  /// Closes the open period on [day] and saves its length.
  Future<void> endPeriod(DateTime day) async {
    await _cycles.endPeriod(day);
    await refresh();
    _afterWrite();
  }

  /// Removes one log entry. Other entries on the same day are kept.
  Future<void> deleteLogEntry(String id) async {
    await _logs.delete(id);
    await refresh();
    _afterWrite();
  }

  Future<void> moveStart(String id, DateTime newStart) async {
    await _cycles.moveStart(id, newStart);
    await refresh();
    _afterWrite();
  }

  Future<void> deleteCycle(String id) async {
    await _cycles.deleteCycle(id);
    await refresh();
    _afterWrite();
  }

  /// Re-schedules local reminders from the latest prediction. Strings come
  /// from the caller so this controller stays free of BuildContext.
  Future<void> rescheduleReminders(AppLocalizations l) async {
    final s = _settings.settings;
    final anyOn = s.remindersPeriod || s.remindersFertile || s.remindersPill;
    if (!anyOn) {
      await _notifications.cancelAll();
      return;
    }
    await _notifications.rescheduleAll(
      prediction: _prediction,
      periodOn: s.remindersPeriod,
      fertileOn: s.remindersFertile,
      pillOn: s.remindersPill,
      pillHour: s.pillHour,
      pillMinute: s.pillMinute,
      title: l.notifTitle,
      body: l.notifBody,
      now: DateTime.now(),
    );
  }

  /// Background push. Never blocks the UI and never loses data: failures
  /// leave the rows in the queue.
  void _afterWrite() {
    unawaited(_sync.run(backupOn: _settings.settings.backupOn).catchError((_) => 0));
  }

  /// Builds the nurse report from logged cycles. No dates other than cycle
  /// starts leave this function in any analytics event.
  ReportData buildReport() {
    final sorted = [..._rows]..sort((a, b) => a.startDate.compareTo(b.startDate));
    final lastSix = sorted.length > 6 ? sorted.sublist(sorted.length - 6) : sorted;

    final cycles = <ReportCycle>[
      for (var i = 0; i < lastSix.length; i++)
        ReportCycle(
          start: lastSix[i].startDate,
          cycleLength: i < lastSix.length - 1
              ? daysBetween(lastSix[i].startDate, lastSix[i + 1].startDate)
              : (lastSix[i].cycleLength),
          periodLength: lastSix[i].periodLength,
        ),
    ];

    final lengths = cycles.map((c) => c.cycleLength).whereType<int>().toList();
    final periods = cycles.map((c) => c.periodLength).toList();
    final avgCycle = lengths.isEmpty
        ? _onboardingCycle
        : (lengths.reduce((a, b) => a + b) / lengths.length).round();
    final avgPeriod = periods.isEmpty
        ? _periodLength
        : (periods.reduce((a, b) => a + b) / periods.length).round();

    final since = cycles.isEmpty ? null : cycles.first.start;
    final counts = <String, int>{};
    for (final log in InsightsService.mergeByDay(_entries)) {
      if (since != null && log.date.isBefore(since)) continue;
      for (final s in log.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }
    final top = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ReportData(
      cycles: cycles,
      averageCycle: avgCycle,
      averagePeriod: avgPeriod,
      lastStart: sorted.isEmpty ? null : sorted.last.startDate,
      topSymptoms: top.take(3).toList(),
    );
  }

  void trackReportShared() => _analytics.track('report_shared');
}
