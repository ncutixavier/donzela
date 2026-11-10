import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../services/prediction/prediction_service.dart';
import '../today/cycle_controller.dart';

/// Opens the daily log for [day] as a modal bottom sheet (screen 9).
///
/// A day can hold many entries. Without [entryId] the sheet adds a new entry
/// at the chosen time. With [entryId] it edits that entry.
Future<void> showDailyLogSheet(
  BuildContext context,
  DateTime day, {
  String? entryId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: AppColors.cream,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: _DailyLogSheet(day: dayOnly(day), entryId: entryId),
    ),
  );
}

class _DailyLogSheet extends StatefulWidget {
  const _DailyLogSheet({required this.day, this.entryId});

  final DateTime day;
  final String? entryId;

  @override
  State<_DailyLogSheet> createState() => _DailyLogSheetState();
}

class _DailyLogSheetState extends State<_DailyLogSheet> {
  FlowLevel _flow = FlowLevel.none;
  final Set<String> _symptoms = {};
  final Set<String> _moods = {};
  final _note = TextEditingController();
  late TimeOfDay _time;
  // Seconds are not picked in the UI; they come from the entry being edited,
  // or from the moment a new entry is started.
  int _seconds = 0;
  // A new entry shows the live time and keeps it moving every second, until
  // the user picks a time by hand.
  Timer? _clock;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // New entries default to the current time; for a past day that is just
    // a starting point the user can change.
    final now = DateTime.now();
    _time = TimeOfDay.fromDateTime(now);
    _seconds = now.second;
    if (widget.entryId == null) {
      _clock = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        final t = DateTime.now();
        setState(() {
          _time = TimeOfDay.fromDateTime(t);
          _seconds = t.second;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    if (widget.entryId != null) _load();
  }

  Future<void> _load() async {
    final repo = context.read<DailyLogRepository>();
    final existing = await repo.byId(widget.entryId!);
    if (!mounted || existing == null) return;
    setState(() {
      _flow = existing.flow;
      _symptoms
        ..clear()
        ..addAll(existing.symptoms);
      _moods
        ..clear()
        ..addAll(existing.mood);
      _note.text = existing.note ?? '';
      _time = TimeOfDay.fromDateTime(existing.date);
      _seconds = existing.date.second;
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    _note.dispose();
    super.dispose();
  }

  String _flowLabel(AppLocalizations l, FlowLevel f) => switch (f) {
        FlowLevel.none => l.flowNone,
        FlowLevel.spotting => l.flowSpotting,
        FlowLevel.medium => l.flowMedium,
        FlowLevel.heavy => l.flowHeavy,
      };

  String _timeText() => timeWithSeconds(DateTime(
        2000,
        1,
        1,
        _time.hour,
        _time.minute,
        _seconds,
      ));

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    // The user chose a time, so stop the live clock.
    _clock?.cancel();
    setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final cycles = context.read<CycleController>();
    final l = AppLocalizations.of(context);
    final nav = Navigator.of(context);

    // A flow other than "none" on a day with no open period asks whether a
    // period started today, then starts a new cycle if yes.
    if (_flow != FlowLevel.none &&
        !cycles.hasOpenPeriod &&
        cycles.phaseFor(widget.day) != DayPhase.period) {
      final yes = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l.dayStartQ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.no),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.yes),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (yes == true) {
        await cycles.startPeriod(widget.day);
      }
    }

    await cycles.saveLog(DayLog(
      id: widget.entryId,
      date: DateTime(
        widget.day.year,
        widget.day.month,
        widget.day.day,
        _time.hour,
        _time.minute,
        _seconds,
      ),
      flow: _flow,
      symptoms: _symptoms.toList(),
      mood: _moods.toList(),
      note: _note.text,
    ));
    await cycles.rescheduleReminders(l);
    if (mounted) nav.pop();
  }

  Future<void> _deleteEntry() async {
    final cycles = context.read<CycleController>();
    final l = AppLocalizations.of(context);
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.logDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancelBtn)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.deleteBtn),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await cycles.deleteLogEntry(widget.entryId!);
    if (mounted) nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cycles = context.watch<CycleController>();
    final theme = Theme.of(context);
    final openStart = cycles.cycleRows
        .where((c) => c.endDate == null)
        .map((c) => c.startDate)
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
    final canEnd = openStart != null && !widget.day.isBefore(openStart);
    final editing = widget.entryId != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(editing ? l.editEntryTitle : l.logSheetTitle,
              style: theme.textTheme.titleLarge),
          Text(l.longDate(widget.day), style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpace.md),
          Row(
            children: [
              Expanded(child: _Label(l.entryTimeLabel)),
              // The theme gives outlined buttons an infinite minimum width,
              // which cannot sit inside a Row, so this one sets its own size.
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: _pickTime,
                icon: const Icon(Icons.schedule, size: 18),
                label: Text(_timeText()),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          _Label(l.flowTitle),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final f in FlowLevel.values)
                ChoiceChip(
                  label: Text(_flowLabel(l, f)),
                  selected: _flow == f,
                  selectedColor: AppColors.terracotta,
                  labelStyle: TextStyle(
                    color: _flow == f ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                  onSelected: (_) => setState(() => _flow = f),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          _Label(l.symptomsTitle),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final key in symptomKeys)
                FilterChip(
                  label: Text(l.symptomLabel(key)),
                  selected: _symptoms.contains(key),
                  selectedColor: AppColors.blush,
                  onSelected: (on) => setState(() {
                    on ? _symptoms.add(key) : _symptoms.remove(key);
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          _Label(l.moodTitle),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: [
              for (final key in moodKeys)
                FilterChip(
                  label: Text(l.moodLabel(key)),
                  selected: _moods.contains(key),
                  selectedColor: AppColors.goldSoft,
                  onSelected: (on) => setState(() {
                    on ? _moods.add(key) : _moods.remove(key);
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          _Label(l.notesTitle),
          TextField(
            controller: _note,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(hintText: l.notesHint),
          ),
          if (canEnd && !editing) ...[
            const SizedBox(height: AppSpace.sm),
            OutlinedButton(
              onPressed: () async {
                await cycles.endPeriod(widget.day);
                await cycles.rescheduleReminders(l);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l.periodEnded),
            ),
          ],
          const SizedBox(height: AppSpace.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l.saveBtn),
          ),
          if (editing) ...[
            const SizedBox(height: AppSpace.sm),
            TextButton(
              onPressed: _deleteEntry,
              child: Text(l.deleteBtn, style: const TextStyle(color: AppColors.danger)),
            ),
          ],
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
