import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/utils/dates.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../services/insights/insights_service.dart';
import '../../services/prediction/prediction_service.dart';
import '../daily_log/daily_log_sheet.dart';
import 'logs_controller.dart';

/// Your logs (every day you wrote down) and Insights (patterns from them).
class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final ctrl = context.read<LogsController>();
    // Loading notifies listeners, which must not happen during build.
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.load());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.logsTitle),
          bottom: TabBar(
            labelColor: AppColors.terracotta,
            unselectedLabelColor: AppColors.inkMuted,
            indicatorColor: AppColors.terracotta,
            tabs: [
              Tab(text: l.tabLogs),
              Tab(text: l.tabInsights),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_LogList(), _InsightsView()],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Logs tab

class _LogList extends StatelessWidget {
  const _LogList();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<LogsController>();
    final theme = Theme.of(context);

    final filterBar = _FilterBar(day: ctrl.filterDay);

    if (ctrl.loaded && ctrl.entries.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, 0),
            child: filterBar,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.xl),
                child: Text(l.noLogs,
                    textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
              ),
            ),
          ),
        ],
      );
    }

    // Group by month, newest month first.
    final items = <Widget>[];
    String? currentMonth;
    for (final entry in ctrl.entries) {
      final month = l.monthYear(entry.date);
      if (month != currentMonth) {
        currentMonth = month;
        items.add(Padding(
          padding: const EdgeInsets.fromLTRB(4, AppSpace.lg, 4, AppSpace.sm),
          child: Text(month, style: theme.textTheme.titleMedium),
        ));
      }
      items.add(Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm),
        child: _LogCard(entry: entry),
      ));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xl),
      children: [filterBar, ...items],
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.entry});

  final DayLog entry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ctrl = context.read<LogsController>();

    return Dismissible(
      key: ValueKey('log-${entry.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpace.lg),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l.logDeleteTitle),
            content: Text(l.logDeleteBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancelBtn),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.deleteBtn),
              ),
            ],
          ),
        );
        return ok ?? false;
      },
      onDismissed: (_) => ctrl.deleteEntry(entry.id!),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => showDailyLogSheet(context, entry.date, entryId: entry.id),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dateTimeText(entry.date),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (entry.hasFlow)
                      _Pill(text: flowLabel(l, entry.flow), color: AppColors.blush),
                  ],
                ),
                if (entry.symptoms.isNotEmpty) ...[
                  const SizedBox(height: AppSpace.sm),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final s in entry.symptoms)
                        _Pill(text: l.symptomLabel(s), color: AppColors.cream),
                    ],
                  ),
                ],
                if (entry.mood.isNotEmpty) ...[
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    entry.mood.map(l.moodLabel).join(' · '),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: AppSpace.sm),
                Text(
                  entry.note == null || entry.note!.isEmpty ? l.noteEmpty : entry.note!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: entry.note == null ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------- Insights tab

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<LogsController>();
    final s = ctrl.insights;
    final theme = Theme.of(context);

    if (s == null || !s.hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xl),
          child: Text(l.insightsNoData,
              textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ),
      );
    }

    final confidence = switch (s.confidence) {
      Confidence.low => l.confLow,
      Confidence.medium => l.confMedium,
      Confidence.high => l.confHigh,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.lg, AppSpace.lg, AppSpace.xl),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(label: l.tabLogs, value: '${s.daysLogged}'),
                    ),
                    Expanded(
                      child: _Stat(label: l.avgCycle, value: l.daysCount(s.averageCycle)),
                    ),
                    Expanded(
                      child: _Stat(label: l.avgPeriod, value: l.daysCount(s.averagePeriod)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                Text(l.insightsDaysLogged(s.daysLogged), style: theme.textTheme.bodyMedium),
                Text(l.insightsCyclesTracked(s.cyclesTracked), style: theme.textTheme.bodyMedium),
                if (s.minCycle != null && s.maxCycle != null)
                  Text(
                    l.insightsCycleRange(s.minCycle!, s.maxCycle!),
                    style: theme.textTheme.bodyMedium,
                  ),
                const SizedBox(height: AppSpace.sm),
                Text(confidence, style: const TextStyle(fontWeight: FontWeight.w700)),
                if (s.irregular) ...[
                  const SizedBox(height: AppSpace.sm),
                  Text(l.flagIrregular, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        _SectionTitle(l.insightsSymptoms),
        _BarList(items: s.symptoms, total: s.daysLogged, labelOf: l.symptomLabel, l: l),
        const SizedBox(height: AppSpace.lg),
        _SectionTitle(l.insightsMoods),
        _BarList(items: s.moods, total: s.daysLogged, labelOf: l.moodLabel, l: l),
        const SizedBox(height: AppSpace.lg),
        _SectionTitle(l.insightsFlow),
        _BarList(
          items: s.flow,
          total: s.daysLogged,
          labelOf: (key) => flowLabel(
            l,
            FlowLevel.values.firstWhere((f) => f.name == key, orElse: () => FlowLevel.none),
          ),
          l: l,
        ),
        const SizedBox(height: AppSpace.lg),
        _SectionTitle(l.insightsByPhase),
        for (final bucket in InsightBucket.values)
          if ((s.loggedDaysByBucket[bucket] ?? 0) > 0)
            _PhaseBlock(
              title: _bucketLabel(l, bucket),
              symptoms: s.symptomsByBucket[bucket] ?? const [],
              moods: s.moodsByBucket[bucket] ?? const [],
              loggedDays: s.loggedDaysByBucket[bucket]!,
              l: l,
            ),
        const SizedBox(height: AppSpace.lg),
        Text(l.insightsDisclaimer, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

/// Date filter for the Logs list. Shows the chosen day, with a way to clear it.
class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.day});

  final DateTime? day;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.read<LogsController>();
    return Wrap(
      spacing: AppSpace.sm,
      runSpacing: AppSpace.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          // Own minimum size: the theme's infinite width cannot sit in a Wrap.
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 14),
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: day ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 366)),
            );
            if (picked != null) ctrl.setFilterDay(picked);
          },
          icon: const Icon(Icons.calendar_today_outlined, size: 18),
          label: Text(day == null ? l.filterByDate : l.longDate(day!)),
        ),
        if (day != null)
          TextButton(
            onPressed: () => ctrl.setFilterDay(null),
            child: Text(l.clearFilter),
          ),
      ],
    );
  }
}

String _bucketLabel(AppLocalizations l, InsightBucket b) => switch (b) {
      InsightBucket.period => l.phasePeriod,
      InsightBucket.fertile => l.phaseFertile,
      InsightBucket.other => l.phaseNormal,
    };

class _PhaseBlock extends StatelessWidget {
  const _PhaseBlock({
    required this.title,
    required this.symptoms,
    required this.moods,
    required this.loggedDays,
    required this.l,
  });

  final String title;
  final List<KeyCount> symptoms;
  final List<KeyCount> moods;
  final int loggedDays;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            for (final s in symptoms.take(3))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  '${l.symptomLabel(s.key)} · ${l.insightsCountOf(s.days, loggedDays)}',
                ),
              ),
            for (final m in moods.take(2))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  '${l.moodLabel(m.key)} · ${l.insightsCountOf(m.days, loggedDays)}',
                ),
              ),
            if (symptoms.isEmpty && moods.isEmpty)
              Text(l.noteEmpty, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _BarList extends StatelessWidget {
  const _BarList({
    required this.items,
    required this.total,
    required this.labelOf,
    required this.l,
  });

  final List<KeyCount> items;
  final int total;
  final String Function(String key) labelOf;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(l.noteEmpty, style: Theme.of(context).textTheme.bodyMedium);
    }
    return Column(
      children: [
        for (final item in items.take(6))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(labelOf(item.key))),
                    Text(l.insightsCountOf(item.days, total),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : item.days / total,
                    minHeight: 8,
                    backgroundColor: AppColors.sand,
                    color: AppColors.terracotta,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

/// Flow choice label, shared by the log card and insights.
String flowLabel(AppLocalizations l, FlowLevel f) => switch (f) {
      FlowLevel.none => l.flowNone,
      FlowLevel.spotting => l.flowSpotting,
      FlowLevel.medium => l.flowMedium,
      FlowLevel.heavy => l.flowHeavy,
    };
