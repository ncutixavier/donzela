import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/month_grid.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../services/prediction/prediction_service.dart';
import '../daily_log/daily_log_sheet.dart';
import '../logs/logs_screen.dart' show flowLabel;
import '../today/cycle_controller.dart';

/// Calendar and cycle history (screen 10). Day colours come from the same
/// phase helper as Today's ring, so the two always agree.
///
/// Tap a day to see its entries below the calendar. Long-press a day to start
/// or end a period.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _centerPage = 600;
  final PageController _pages = PageController(initialPage: _centerPage);
  final DateTime _baseMonth = DateTime(DateTime.now().year, DateTime.now().month);

  DateTime _monthFor(int page) =>
      DateTime(_baseMonth.year, _baseMonth.month + (page - _centerPage));

  int _currentPage = _centerPage;
  DateTime? _selected;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  /// Strongest flow logged on [day], or none.
  FlowLevel _topFlow(CycleController cycles, DateTime day) {
    var top = FlowLevel.none;
    for (final e in cycles.logsFor(day)) {
      if (e.flow.index > top.index) top = e.flow;
    }
    return top;
  }

  DayCell _style(CycleController cycles, DateTime day) {
    final marked = cycles.logsFor(day).isNotEmpty;
    switch (cycles.phaseFor(day)) {
      case DayPhase.period:
        // Period days get darker with heavier flow, as in Flo.
        switch (_topFlow(cycles, day)) {
          case FlowLevel.spotting:
            return DayCell(
              fill: AppColors.blush,
              textColor: AppColors.terracotta,
              marked: marked,
            );
          case FlowLevel.medium:
            return DayCell(
              fill: Color.lerp(AppColors.blush, AppColors.terracotta, 0.7),
              textColor: Colors.white,
              marked: marked,
            );
          case FlowLevel.heavy:
          case FlowLevel.none:
            return DayCell(
              fill: AppColors.terracotta,
              textColor: Colors.white,
              marked: marked,
            );
        }
      case DayPhase.predictedPeriod:
        return DayCell(
          fill: AppColors.blushSoft,
          outline: AppColors.terracotta,
          textColor: AppColors.terracotta,
          marked: marked,
        );
      case DayPhase.fertile:
        return DayCell(fill: AppColors.goldSoft, marked: marked);
      case DayPhase.ovulation:
        return DayCell(fill: AppColors.sage, textColor: Colors.white, marked: marked);
      case DayPhase.normal:
        return DayCell(marked: marked);
    }
  }

  void _goToday() {
    _pages.jumpToPage(_centerPage);
    setState(() {
      _currentPage = _centerPage;
      _selected = dayOnly(DateTime.now());
    });
  }

  Future<void> _longPress(BuildContext context, DateTime day) async {
    final cycles = context.read<CycleController>();
    final l = AppLocalizations.of(context);
    final rows = cycles.cycleRows;
    final startsHere = rows.where((c) => isSameDay(c.startDate, day)).toList();
    final open = rows.where((c) => c.endDate == null).toList();
    final canEnd = open.isNotEmpty && !day.isBefore(open.last.startDate);

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow_rounded),
              title: Text(l.periodStartHere),
              onTap: () async {
                Navigator.pop(ctx);
                await cycles.startPeriod(day);
                await cycles.rescheduleReminders(l);
              },
            ),
            if (canEnd)
              ListTile(
                leading: const Icon(Icons.stop_rounded),
                title: Text(l.periodEndHere),
                onTap: () async {
                  Navigator.pop(ctx);
                  await cycles.endPeriod(day);
                  await cycles.rescheduleReminders(l);
                },
              ),
            if (startsHere.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l.deleteBtn),
                onTap: () async {
                  Navigator.pop(ctx);
                  await cycles.deleteCycle(startsHere.first.id);
                  await cycles.rescheduleReminders(l);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cycles = context.watch<CycleController>();
    final today = dayOnly(DateTime.now());
    final selected = _selected ?? today;
    final report = cycles.buildReport();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xl),
          children: [
            Text(l.calendarTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpace.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: l.monthPrev,
                          onPressed: () => _pages.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Text(
                            l.monthYear(_monthFor(_currentPage)),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: l.monthNext,
                          onPressed: () => _pages.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    if (_currentPage != _centerPage)
                      TextButton(
                        onPressed: _goToday,
                        child: Text(l.goToday),
                      ),
                    // A calendar keeps a phone-sized grid on wide screens too.
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: SizedBox(
                      height: 340,
                      child: PageView.builder(
                        controller: _pages,
                        onPageChanged: (p) => setState(() => _currentPage = p),
                        itemBuilder: (context, page) => SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: MonthGrid(
                            month: _monthFor(page),
                            today: today,
                            selected: selected,
                            dayStyle: (day) => _style(cycles, day),
                            onTap: (day) => setState(() => _selected = day),
                            onLongPress: (day) => _longPress(context, day),
                          ),
                        ),
                      ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Wrap(
                      spacing: AppSpace.md,
                      runSpacing: AppSpace.xs,
                      children: [
                        _Legend(color: AppColors.terracotta, label: l.legendPeriod),
                        _Legend(color: AppColors.blushSoft, label: l.legendPredicted, outline: true),
                        _Legend(color: AppColors.goldSoft, label: l.legendFertile),
                        _Legend(color: AppColors.sage, label: l.legendOvulation),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            _DayPanel(day: selected),
            const SizedBox(height: AppSpace.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.historyTitle, style: theme.textTheme.titleMedium),
                    Text(
                      cycles.prediction.irregular ? l.irregularCycles : l.regularCycles,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onPressed: () => context.push('/logs'),
                            child: Text(l.logsOpenBtn),
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onPressed: () => context.push('/report'),
                            child: Text(l.reportBtn),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.md),
                    Row(
                      children: [
                        Expanded(
                          child: _Stat(
                            label: l.avgCycle,
                            value: l.daysCount(report.averageCycle),
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: _Stat(
                            label: l.avgPeriod,
                            value: l.daysCount(report.averagePeriod),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpace.md),
                    if (report.cycles.isEmpty)
                      Text(l.reportNoData, style: theme.textTheme.bodyMedium)
                    else
                      for (final c in report.cycles.reversed.take(6))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(child: Text(l.dayMonthYear(c.start))),
                              Text(
                                c.cycleLength == null ? '–' : l.daysCount(c.cycleLength!),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: AppSpace.md),
                              Text(
                                '${l.legendPeriod}: ${l.daysCount(c.periodLength)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The entries of the selected day, with their times, below the calendar.
class _DayPanel extends StatelessWidget {
  const _DayPanel({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cycles = context.watch<CycleController>();
    final entries = cycles.logsFor(day)..sort((a, b) => a.date.compareTo(b.date));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l.longDate(day), style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: () => showDailyLogSheet(context, day),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.addEntryBtn),
                ),
              ],
            ),
            if (entries.isEmpty)
              Text(l.noEntriesOnDay, style: theme.textTheme.bodyMedium)
            else
              for (final e in entries)
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                  onTap: () => showDailyLogSheet(context, day, entryId: e.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeWithSeconds(e.date),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          [
                            if (e.hasFlow) flowLabel(l, e.flow),
                            ...e.symptoms.map(l.symptomLabel),
                            ...e.mood.map(l.moodLabel),
                          ].join(' · '),
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (e.note != null && e.note!.isNotEmpty)
                          Text(
                            e.note!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.outline = false});

  final Color color;
  final String label;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: outline ? Border.all(color: AppColors.terracotta) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
