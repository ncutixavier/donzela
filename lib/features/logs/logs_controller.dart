import 'package:flutter/foundation.dart';

import '../../core/utils/dates.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../services/insights/insights_service.dart';
import '../settings/settings_controller.dart';
import '../today/cycle_controller.dart';

/// Data for the Logs and Insights tabs. Recomputes whenever the cycle data
/// changes, so an edit in the daily log shows up here straight away.
class LogsController extends ChangeNotifier {
  LogsController({
    required DailyLogRepository logs,
    required CycleRepository cycles,
    required SettingsController settings,
    required CycleController cycleChanges,
    InsightsService insightsService = const InsightsService(),
  })  : _logs = logs,
        _cycles = cycles,
        _settings = settings,
        _cycleChanges = cycleChanges,
        _insights = insightsService {
    _cycleChanges.addListener(_onCycleChanged);
  }

  final DailyLogRepository _logs;
  final CycleRepository _cycles;
  final SettingsController _settings;
  final CycleController _cycleChanges;
  final InsightsService _insights;

  List<DayLog> _all = const [];
  Insights? _stats;
  bool _loaded = false;
  DateTime? _filterDay;

  /// Every entry, newest first, after the date filter.
  List<DayLog> get entries {
    final filter = _filterDay;
    final list = filter == null
        ? _all
        : _all.where((e) => isSameDay(e.day, filter)).toList();
    return list.reversed.toList();
  }

  /// The day shown by the filter, or null for all days.
  DateTime? get filterDay => _filterDay;
  Insights? get insights => _stats;
  bool get loaded => _loaded;

  void _onCycleChanged() => load();

  Future<void> load() async {
    final all = await _logs.all();
    final rows = await _cycles.records();
    final s = _settings.settings;
    final stats = _insights.compute(
      cycles: rows,
      logs: all,
      onboardingCycleLength: s.onboardingCycleLength,
      periodLength: s.periodLength,
      today: dayOnly(DateTime.now()),
    );
    _all = all;
    _stats = stats;
    _loaded = true;
    notifyListeners();
  }

  /// Show only the entries of one day, or all days when [day] is null.
  void setFilterDay(DateTime? day) {
    _filterDay = day == null ? null : dayOnly(day);
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _logs.delete(id);
    await load();
    _cycleChanges.refresh();
  }

  @override
  void dispose() {
    _cycleChanges.removeListener(_onCycleChanged);
    super.dispose();
  }
}
