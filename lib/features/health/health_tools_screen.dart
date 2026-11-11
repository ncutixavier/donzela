import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../services/health/health_tools.dart';
import '../today/cycle_controller.dart';

/// The Health tools: quick estimates from dates the person enters. Opened from
/// the card on Today. Each tool updates live as the inputs change.
class HealthToolsScreen extends StatelessWidget {
  const HealthToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.healthTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Text(l.healthSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            _SectionLabel(l.healthSectionCycle),
            for (final tool in const [
              HealthTool.cycleCalculator,
              HealthTool.periodCalc,
              HealthTool.ovulation,
              HealthTool.implant,
              HealthTool.cycleLength,
            ])
              _ToolTile(tool: tool),
            const SizedBox(height: AppSpace.lg),
            _SectionLabel(l.healthSectionPregnancy),
            for (final tool in const [HealthTool.dueDate, HealthTool.weeks])
              _ToolTile(tool: tool),
            const SizedBox(height: AppSpace.lg),
            _Disclaimer(text: l.healthDisclaimer),
          ],
        ),
      ),
    );
  }
}

enum HealthTool {
  cycleCalculator,
  periodCalc,
  ovulation,
  implant,
  cycleLength,
  dueDate,
  weeks,
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.sm),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});

  final HealthTool tool;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, body, icon) = switch (tool) {
      HealthTool.cycleCalculator => (
        l.toolCycleCalcTitle,
        l.toolCycleCalcBody,
        Icons.calculate_outlined,
      ),
      HealthTool.periodCalc => (
        l.toolPeriodCalcTitle,
        l.toolPeriodCalcBody,
        Icons.event_outlined,
      ),
      HealthTool.ovulation => (
        l.toolOvulationTitle,
        l.toolOvulationBody,
        Icons.spa_outlined,
      ),
      HealthTool.implant => (
        l.toolImplantTitle,
        l.toolImplantBody,
        Icons.favorite_border,
      ),
      HealthTool.cycleLength => (
        l.toolCycleLengthTitle,
        l.toolCycleLengthBody,
        Icons.straighten,
      ),
      HealthTool.dueDate => (
        l.toolDueDateTitle,
        l.toolDueDateBody,
        Icons.child_care_outlined,
      ),
      HealthTool.weeks => (
        l.toolWeeksTitle,
        l.toolWeeksBody,
        Icons.calendar_view_week_outlined,
      ),
    };
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: 6,
        ),
        leading: Icon(icon, color: AppColors.terracotta),
        title: Text(title),
        subtitle: Text(body),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => HealthToolPage(tool: tool))),
      ),
    );
  }
}

/// One tool: its inputs above, the live estimate below.
class HealthToolPage extends StatefulWidget {
  const HealthToolPage({super.key, required this.tool});

  final HealthTool tool;

  @override
  State<HealthToolPage> createState() => _HealthToolPageState();
}

class _HealthToolPageState extends State<HealthToolPage> {
  DateTime? _lastStart;
  DateTime? _previousStart;
  DateTime? _nextStart;
  int _cycle = HealthTools.defaultCycleLength;
  int _periodDays = HealthTools.defaultPeriodDays;
  int _weeks = 12;
  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;
    _prefilled = true;
    // Start from the person's own cycle data, so she usually only confirms.
    final p = context.read<CycleController>().prediction;
    _lastStart = p.lastStart ?? dayOnly(DateTime.now());
    _cycle = HealthTools.isValidCycleLength(p.averageCycle)
        ? p.averageCycle
        : HealthTools.defaultCycleLength;
    _previousStart = _lastStart;
    _nextStart = _lastStart;
  }

  Future<DateTime?> _pick(DateTime current, {DateTime? first, DateTime? last}) {
    final today = dayOnly(DateTime.now());
    return showDatePicker(
      context: context,
      initialDate: current,
      firstDate: first ?? DateTime(today.year - 1),
      lastDate: last ?? today,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tool = widget.tool;
    final (title, body) = switch (tool) {
      HealthTool.cycleCalculator => (l.toolCycleCalcTitle, l.toolCycleCalcBody),
      HealthTool.periodCalc => (l.toolPeriodCalcTitle, l.toolPeriodCalcBody),
      HealthTool.ovulation => (l.toolOvulationTitle, l.toolOvulationBody),
      HealthTool.implant => (l.toolImplantTitle, l.toolImplantBody),
      HealthTool.cycleLength => (l.toolCycleLengthTitle, l.toolCycleLengthBody),
      HealthTool.dueDate => (l.toolDueDateTitle, l.toolDueDateBody),
      HealthTool.weeks => (l.toolWeeksTitle, l.toolWeeksBody),
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Text(body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            ..._inputs(l, tool),
            const SizedBox(height: AppSpace.lg),
            ..._results(context, l, tool),
            const SizedBox(height: AppSpace.lg),
            _Disclaimer(text: l.healthDisclaimer),
          ],
        ),
      ),
    );
  }

  List<Widget> _inputs(AppLocalizations l, HealthTool tool) {
    switch (tool) {
      case HealthTool.cycleCalculator:
      case HealthTool.periodCalc:
      case HealthTool.ovulation:
        final lastStart = _lastStart!;
        return [
          _DateField(
            label: l.healthLastPeriod,
            value: lastStart,
            onTap: () async {
              final d = await _pick(lastStart);
              if (d != null) setState(() => _lastStart = dayOnly(d));
            },
          ),
          const SizedBox(height: AppSpace.md),
          _Stepper(
            label: l.healthPeriodDays,
            value: _periodDays,
            min: HealthTools.minPeriodDays,
            max: HealthTools.maxPeriodDays,
            format: (v) => l.healthDays(v),
            onChanged: (v) => setState(() => _periodDays = v),
          ),
          const SizedBox(height: AppSpace.md),
          _Stepper(
            label: l.healthUsualCycle,
            value: _cycle,
            min: HealthTools.minCycleLength,
            max: HealthTools.maxCycleLength,
            format: (v) => l.healthDays(v),
            onChanged: (v) => setState(() => _cycle = v),
          ),
        ];
      case HealthTool.implant:
        final lastStart = _lastStart!;
        return [
          _DateField(
            label: l.healthLastPeriod,
            value: lastStart,
            onTap: () async {
              final d = await _pick(lastStart);
              if (d != null) setState(() => _lastStart = dayOnly(d));
            },
          ),
          const SizedBox(height: AppSpace.md),
          _Stepper(
            label: l.healthUsualCycle,
            value: _cycle,
            min: HealthTools.minCycleLength,
            max: HealthTools.maxCycleLength,
            format: (v) => l.healthDays(v),
            onChanged: (v) => setState(() => _cycle = v),
          ),
        ];
      case HealthTool.cycleLength:
        final prev = _previousStart!;
        final next = _nextStart!;
        return [
          _DateField(
            label: l.healthPreviousPeriod,
            value: prev,
            onTap: () async {
              final d = await _pick(prev);
              if (d != null) setState(() => _previousStart = dayOnly(d));
            },
          ),
          const SizedBox(height: AppSpace.md),
          _DateField(
            label: l.healthNextPeriodStart,
            value: next,
            onTap: () async {
              final d = await _pick(next, first: prev);
              if (d != null) setState(() => _nextStart = dayOnly(d));
            },
          ),
        ];
      case HealthTool.dueDate:
        final lastStart = _lastStart!;
        return [
          _DateField(
            label: l.healthLastPeriod,
            value: lastStart,
            onTap: () async {
              final earliest = dayOnly(DateTime.now()).subtract(
                const Duration(days: HealthTools.maxPregnancyWeeks * 7),
              );
              final d = await _pick(lastStart, first: earliest);
              if (d != null) setState(() => _lastStart = dayOnly(d));
            },
          ),
          const SizedBox(height: AppSpace.md),
          _Stepper(
            label: l.healthUsualCycle,
            value: _cycle,
            min: HealthTools.minCycleLength,
            max: HealthTools.maxCycleLength,
            format: (v) => l.healthDays(v),
            onChanged: (v) => setState(() => _cycle = v),
          ),
        ];
      case HealthTool.weeks:
        return [
          _Stepper(
            label: l.healthWeeksPregnant,
            value: _weeks,
            min: 1,
            max: HealthTools.maxPregnancyWeeks,
            format: (v) => '$v ${l.healthWeeksUnit}',
            onChanged: (v) => setState(() => _weeks = v),
          ),
        ];
    }
  }

  List<Widget> _results(
    BuildContext context,
    AppLocalizations l,
    HealthTool tool,
  ) {
    final today = dayOnly(DateTime.now());
    String range(DateTime a, DateTime b) => '${shortDate(a)} – ${shortDate(b)}';
    switch (tool) {
      case HealthTool.periodCalc:
        final period = HealthTools.periodRange(
          _lastStart!,
          _cycle,
          _periodDays,
        );
        return [
          _ResultCard(
            label: l.healthResultPeriod,
            big: range(period.from, period.to),
            note: l.healthPeriodNote(_periodDays),
          ),
        ];
      case HealthTool.ovulation:
        final ov = HealthTools.ovulation(_lastStart!, _cycle);
        final fertile = HealthTools.fertileWindow(_lastStart!, _cycle);
        return [
          _ResultCard(
            label: l.healthResultOvulation,
            big: shortDate(ov),
            note: l.healthOvulationNote,
          ),
          const SizedBox(height: AppSpace.md),
          _ResultCard(
            label: l.healthResultFertile,
            big: range(fertile.from, fertile.to),
            note: l.healthFertileNote,
          ),
        ];
      case HealthTool.cycleCalculator:
        final last = _lastStart!;
        final ov = HealthTools.ovulation(last, _cycle);
        final period = HealthTools.periodRange(last, _cycle, _periodDays);
        final fertile = HealthTools.fertileWindow(last, _cycle);
        final follicular = HealthTools.follicularRange(last, _cycle);
        final luteal = HealthTools.lutealRange(last, _cycle);
        String range(DateTime a, DateTime b) =>
            '${shortDate(a)} – ${shortDate(b)}';
        return [
          Wrap(
            spacing: AppSpace.md,
            runSpacing: AppSpace.md,
            children: [
              _ResultCard(
                label: l.healthResultOvulation,
                big: shortDate(ov),
                note: l.healthOvulationNote,
              ),
              _ResultCard(
                label: l.healthResultPeriod,
                big: range(period.from, period.to),
                note: l.healthPeriodNote(_periodDays),
              ),
              _ResultCard(
                label: l.healthResultFertile,
                big: range(fertile.from, fertile.to),
                note: l.healthFertileNote,
              ),
              _ResultCard(
                label: l.healthResultFollicular,
                big: range(follicular.from, follicular.to),
                note: l.healthFollicularNote,
              ),
              _ResultCard(
                label: l.healthResultLuteal,
                big: range(luteal.from, luteal.to),
                note: l.healthLutealNote,
              ),
            ],
          ),
        ];
      case HealthTool.implant:
        final w = HealthTools.implantationWindow(_lastStart!, _cycle);
        return [
          _Result(
            label: l.healthResultImplant,
            value:
                '${l.dayMonthYear(w.from)} ${l.healthTo} ${l.dayMonthYear(w.to)}',
          ),
        ];
      case HealthTool.cycleLength:
        final days = HealthTools.cycleLengthBetween(
          _previousStart!,
          _nextStart!,
        );
        final ok = HealthTools.isValidCycleLength(days);
        return [
          _Result(label: l.healthResultCycleLength, value: l.healthDays(days)),
          if (!ok) ...[
            const SizedBox(height: AppSpace.sm),
            Text(l.healthCycleOut, style: TextStyle(color: AppColors.danger)),
          ],
        ];
      case HealthTool.dueDate:
        final age = HealthTools.pregnancyAge(_lastStart!, today);
        return [
          _Result(
            label: l.healthResultDue,
            value: l.dayMonthYear(
              HealthTools.dueDate(_lastStart!, cycleLength: _cycle),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          _Result(
            label: l.healthResultAge,
            value: l.healthWeekDays(age.weeks, age.days),
          ),
        ];
      case HealthTool.weeks:
        final m = HealthTools.weeksToMonths(_weeks);
        return [
          _Result(
            label: l.healthResultMonths,
            value: l.healthMonthsWeeks(m.months, m.weeks),
          ),
        ];
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          l.dayMonthYear(value),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: const Icon(Icons.edit_calendar_outlined),
        onTap: onTap,
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
    required this.format,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final String Function(int) format;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            IconButton(
              tooltip: l.healthLess,
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            SizedBox(
              width: 96,
              child: Text(
                format(value),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
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

/// One phase or event: its name, the big date or range, and a short note.
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.big,
    required this.note,
  });

  final String label;
  final String big;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Card(
        color: AppColors.goldSoft,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text(big, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(note, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: AppColors.goldSoft,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodySmall,
    textAlign: TextAlign.center,
  );
}
