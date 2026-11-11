import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/cycle_ring.dart';
import '../../core/widgets/imigongo.dart';
import '../../services/insights/insights_service.dart';
import '../../services/prediction/prediction_service.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../daily_log/daily_log_sheet.dart';
import '../logs/logs_screen.dart' show flowLabel;
import '../settings/settings_controller.dart';
import 'cycle_controller.dart';

/// Today (screen 8), and the first-use variant (screen 6) for a new user.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cycles = context.watch<CycleController>();
    final settings = context.watch<SettingsController>().settings;
    final now = DateTime.now();
    final today = dayOnly(now);
    final prediction = cycles.prediction;
    final phase = cycles.loaded ? cycles.phaseFor(today) : DayPhase.normal;
    final firstUse = cycles.isFirstUse;
    final greeting = now.hour < 12 ? l.greetingMorning : l.greetingAfternoon;
    final name = settings.firstName;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.longDate(today), style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          name.isEmpty ? greeting : '$greeting, $name',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: l.settingsTitle,
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              Center(
                child: CycleRing(
                  prediction: prediction,
                  periodLength: settings.periodLength,
                  today: today,
                  child: _RingCentre(
                    prediction: prediction,
                    today: today,
                    phase: phase,
                    firstUse: firstUse,
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              FilledButton.icon(
                onPressed: () => showDailyLogSheet(context, today),
                icon: const Icon(Icons.add),
                label: Text(l.logToday),
              ),
              if (cycles.logsFor(today).isNotEmpty) ...[
                const SizedBox(height: AppSpace.sm),
                Center(
                  child: Text(
                    l.todayLoggedLine(_logSummary(
                      l,
                      InsightsService.mergeByDay(cycles.logsFor(today)).first,
                    )),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
              const SizedBox(height: AppSpace.lg),
              Center(child: _NextPeriodLine(prediction: prediction, today: today)),
              if (prediction.fertileStart != null && prediction.fertileEnd != null) ...[
                const SizedBox(height: AppSpace.xs),
                Center(
                  child: Text(
                    l.fertileWindowLine(
                      _shortDate(l, prediction.fertileStart!),
                      _shortDate(l, prediction.fertileEnd!),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
              Center(
                child: TextButton(
                  onPressed: () => context.push('/logs'),
                  child: Text(l.insightsShortcut,
                      style: const TextStyle(decoration: TextDecoration.underline)),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              Center(
                child: Text(
                  l.estimatesOnly,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              const _RingLegend(),
              if (prediction.irregular) ...[
                const SizedBox(height: AppSpace.md),
                _InfoCard(
                  text: l.flagIrregular,
                  onTap: () => context.go('/learn'),
                  linkText: l.readMore,
                ),
              ],
              const SizedBox(height: AppSpace.lg),
              const SizedBox(height: AppSpace.lg),
              _TipCard(phase: phase),
            ],
          ),
        ),
      ),
    );
  }
}

/// "9 Ugushyingo" style date for the fertile-window line.
String _shortDate(AppLocalizations l, DateTime d) =>
    '${d.day} ${l.monthNames[d.month - 1]}';

/// What was logged today, in a few words (flow, symptoms, mood).
String _logSummary(AppLocalizations l, DayLog log) {
  final parts = <String>[
    if (log.hasFlow) flowLabel(l, log.flow),
    ...log.symptoms.map(l.symptomLabel),
    ...log.mood.map(l.moodLabel),
  ];
  return parts.isEmpty ? l.noteEmpty : parts.join(' · ');
}

/// Centre of the ring. Shows the countdown to the next period and the phase,
/// as in the Flo-style layout. First use keeps the "first estimate" label.
class _RingCentre extends StatelessWidget {
  const _RingCentre({
    required this.prediction,
    required this.today,
    required this.phase,
    required this.firstUse,
  });

  final PredictionResult prediction;
  final DateTime today;
  final DayPhase phase;
  final bool firstUse;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (firstUse) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l.todayCycleDay, style: theme.textTheme.bodyMedium),
          Text(
            prediction.cycleDay == null ? '–' : '${prediction.cycleDay}',
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 56, height: 1),
          ),
          const SizedBox(height: AppSpace.sm),
          _Chip(label: l.firstEstimate, color: AppColors.goldSoft, textColor: AppColors.brown),
          const SizedBox(height: AppSpace.xs),
          Text(l.estimateChip, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
        ],
      );
    }

    final next = prediction.nextPeriodStart;
    final days = next == null ? null : daysBetween(today, next).clamp(0, 9999);
    final late = prediction.late;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          late ? l.centreLate : l.centreNextPeriodLabel,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        if (!late && days != null) ...[
          Text(
            '$days',
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 52, height: 1.05),
          ),
          Text(l.centreDaysUnit, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: AppSpace.sm),
        _Chip(label: _phaseLabel(l, phase), color: _phaseColor(phase), textColor: AppColors.brown),
        const SizedBox(height: AppSpace.xs),
        Text(l.estimateChip, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }
}

class _NextPeriodLine extends StatelessWidget {
  const _NextPeriodLine({required this.prediction, required this.today});

  final PredictionResult prediction;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final next = prediction.nextPeriodStart;
    if (next == null) return const SizedBox.shrink();
    final text = prediction.late
        ? l.nextPeriodLate(l.dayMonthYear(next))
        : l.nextPeriodIn(
            daysBetween(today, next).clamp(0, 9999),
            l.dayMonthYear(next),
          );
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text, required this.onTap, required this.linkText});

  final String text;
  final VoidCallback onTap;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.goldSoft,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: onTap,
              child: Text(linkText,
                  style: const TextStyle(decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.phase});

  final DayPhase phase;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final body = switch (phase) {
      DayPhase.period || DayPhase.predictedPeriod => l.tipPeriod,
      DayPhase.fertile || DayPhase.ovulation => l.tipFertile,
      DayPhase.normal => l.tipFollicular,
    };
    return Card(
      color: AppColors.brown,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: SizedBox(width: 90, child: ZigzagBand(height: 60, color: AppColors.terracotta)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.tipTitle,
                      style: const TextStyle(
                          color: AppColors.gold, fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpace.sm),
                  Text(body, style: const TextStyle(color: AppColors.cream, height: 1.4)),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, foregroundColor: AppColors.gold),
                    onPressed: () => context.go('/learn'),
                    child: Text(l.readMore,
                        style: const TextStyle(decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, required this.textColor});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.chip)),
      child: Text(label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}

String _phaseLabel(AppLocalizations l, DayPhase p) => switch (p) {
      DayPhase.period => l.phasePeriod,
      DayPhase.predictedPeriod => l.phasePredictedPeriod,
      DayPhase.fertile => l.phaseFertile,
      DayPhase.ovulation => l.phaseOvulation,
      DayPhase.normal => l.phaseNormal,
    };

Color _phaseColor(DayPhase p) => switch (p) {
      DayPhase.period => AppColors.blush,
      DayPhase.predictedPeriod => AppColors.blushSoft,
      DayPhase.fertile => AppColors.goldSoft,
      DayPhase.ovulation => AppColors.sageSoft,
      DayPhase.normal => AppColors.sand,
    };

/// Explains the colours of the cycle ring, so each arc has a label.
class _RingLegend extends StatelessWidget {
  const _RingLegend();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13);
    Widget item(Color color, String label, {bool outline = false, bool dot = false}) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dot ? 10 : 14,
            height: dot ? 10 : 14,
            decoration: BoxDecoration(
              color: color,
              shape: dot ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: dot ? null : BorderRadius.circular(4),
              border: outline ? Border.all(color: AppColors.brown, width: 2) : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: style),
        ],
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpace.lg,
      runSpacing: AppSpace.sm,
      children: [
        item(AppColors.terracotta, l.legendPeriod),
        item(AppColors.gold, l.legendFertile),
        item(AppColors.sage, l.legendOvulation, dot: true),
        item(Colors.white, l.legendToday, outline: true, dot: true),
      ],
    );
  }
}
