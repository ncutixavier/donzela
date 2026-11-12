import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../settings/settings_controller.dart';
import 'cycle_controller.dart';

/// Opened by tapping the cycle ring on Today. Updates the last period start,
/// the usual cycle length and the period length.
Future<void> showCycleSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => const _CycleSheet(),
  );
}

class _CycleSheet extends StatefulWidget {
  const _CycleSheet();

  @override
  State<_CycleSheet> createState() => _CycleSheetState();
}

class _CycleSheetState extends State<_CycleSheet> {
  static const _minCycle = 21;
  static const _maxCycle = 45;
  static const _minPeriod = 1;
  static const _maxPeriod = 10;

  late DateTime _lastStart;
  late int _cycle;
  late int _period;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final cycles = context.read<CycleController>();
    final settings = context.read<SettingsController>().settings;
    _lastStart = cycles.prediction.lastStart ?? dayOnly(DateTime.now());
    _cycle = settings.onboardingCycleLength.clamp(_minCycle, _maxCycle);
    _period = settings.periodLength.clamp(_minPeriod, _maxPeriod);
  }

  Future<void> _pickDate() async {
    final today = dayOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastStart,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today,
    );
    if (picked != null) setState(() => _lastStart = dayOnly(picked));
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final cycles = context.read<CycleController>();
    final settings = context.read<SettingsController>();
    setState(() => _saving = true);
    try {
      // The most recent cycle is the "last period". Move it, or start one if none exists.
      final rows = cycles.cycleRows;
      final latest = rows.isEmpty
          ? null
          : rows.reduce((a, b) => a.startDate.isAfter(b.startDate) ? a : b);
      if (latest == null) {
        await cycles.startPeriod(_lastStart);
      } else if (!isSameDay(latest.startDate, _lastStart)) {
        await cycles.moveStart(latest.id, _lastStart);
      }
      await settings.setCycleDefaults(
        cycleLength: _cycle,
        periodLength: _period,
      );
      if (!mounted) return;
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.adminSaved)));
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpace.lg,
          0,
          AppSpace.lg,
          AppSpace.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.cycleSheetTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpace.lg),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.lg,
                ),
                title: Text(
                  l.cycleLastStart,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  l.dayMonthYear(_lastStart),
                  style: theme.textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.edit_calendar_outlined),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: AppSpace.md),
            _Stepper(
              label: l.cycleLengthLabel,
              value: _cycle,
              min: _minCycle,
              max: _maxCycle,
              onChanged: (v) => setState(() => _cycle = v),
            ),
            const SizedBox(height: 4),
            Text(l.cycleLengthNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpace.md),
            _Stepper(
              label: l.periodLengthLabel,
              value: _period,
              min: _minPeriod,
              max: _maxPeriod,
              onChanged: (v) => setState(() => _period = v),
            ),
            const SizedBox(height: AppSpace.xl),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l.cycleSheetSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            IconButton(
              tooltip: l.healthLess,
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            SizedBox(
              width: 72,
              child: Text(
                l.healthDays(value),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l.healthMore,
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
