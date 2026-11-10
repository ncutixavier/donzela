import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/imigongo.dart';
import '../../core/widgets/month_grid.dart';
import '../../core/widgets/pin_setup_sheet.dart';
import '../../services/notifications/notification_service.dart';
import '../account/cloud_controller.dart';
import '../settings/settings_controller.dart';
import '../today/cycle_controller.dart';
import 'onboarding_controller.dart';

/// Onboarding steps. Screen 1 is the language pick; screens 2–5 show the
/// "n kuri 5" progress. Screen 6 is Today's first-use variant.
class OnboardingStepScreen extends StatelessWidget {
  const OnboardingStepScreen({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 2:
        return const _PrivacyStep();
      case 3:
        return const _LastPeriodStep();
      case 4:
        return const _CycleStep();
      case 5:
        return const _PinAndRemindersStep();
      default:
        return const _LanguageStep();
    }
  }
}

/// Shared frame: back button, progress bar with "n kuri 5", content, footer.
class _StepFrame extends StatelessWidget {
  const _StepFrame({
    required this.step,
    required this.body,
    required this.footer,
    this.showProgress = true,
  });

  final int step;
  final Widget body;
  final Widget footer;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = OnboardingController.totalSteps;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, 0),
              child: Row(
                children: [
                  if (step > 1)
                    _RoundButton(
                      icon: Icons.chevron_left,
                      tooltip: l.backBtn,
                      onTap: () async {
                        await context.read<OnboardingController>().goToStep(step - 1);
                        if (context.mounted) context.go('/onboarding/${step - 1}');
                      },
                    )
                  else
                    const SizedBox(width: 44),
                  if (showProgress) ...[
                    const SizedBox(width: AppSpace.md),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: step / total,
                          minHeight: 8,
                          backgroundColor: AppColors.sand,
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Text(l.stepOf(step, total),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.inkMuted)),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
              child: footer,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.ink),
      ),
    );
  }
}

// ---------------------------------------------------------------- Screen 1

class _LanguageStep extends StatelessWidget {
  const _LanguageStep();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    final current = settings.settings.language;
    final onboarding = context.read<OnboardingController>();

    return _StepFrame(
      step: 1,
      showProgress: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.md),
          const Center(child: DonzelaMark(size: 110)),
          const SizedBox(height: AppSpace.lg),
          Text('donzela',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 34)),
          const SizedBox(height: AppSpace.lg),
          Text(l.welcomeTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpace.sm),
          Text(l.welcomeBody, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          Text(l.chooseLanguage, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpace.sm),
          for (final entry in [
            ('rw', l.langRw),
            ('en', l.langEn),
            ('fr', l.langFr),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: _OptionTile(
                label: entry.$2,
                selected: current == entry.$1,
                onTap: () => settings.setLanguage(entry.$1),
              ),
            ),
          const SizedBox(height: AppSpace.lg),
          Center(
            child: Text(l.dataStaysNote,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: AppSpace.md),
          Center(
            child: TextButton(
              onPressed: () => _restore(context),
              child: Text(l.restoreHint, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
      footer: FilledButton(
        onPressed: () async {
          await onboarding.goToStep(2);
          if (context.mounted) context.go('/onboarding/2');
        },
        child: Text(l.continueBtn),
      ),
    );
  }
}

/// Signs in and pulls the user's cloud data. If the account has a finished
/// onboarding, the router moves straight to Today.
Future<void> _restore(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final cloud = context.read<CloudController>();
  final messenger = ScaffoldMessenger.of(context);
  if (!cloud.available) {
    messenger.showSnackBar(SnackBar(content: Text(l.cloudUnavailable)));
    return;
  }
  try {
    if (!await cloud.signIn()) return;
    final result = await cloud.restore();
    await cloud.pullPublicContent();
    messenger.showSnackBar(SnackBar(
      content: Text(result.foundData ? l.restoreFound : l.restoreNone),
    ));
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.control),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.control),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.control),
            border: Border.all(
              color: selected ? AppColors.terracotta : AppColors.sand,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: AppColors.terracotta),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Screen 2

class _PrivacyStep extends StatelessWidget {
  const _PrivacyStep();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = context.read<SettingsController>();
    final onboarding = context.read<OnboardingController>();
    final theme = Theme.of(context);

    Widget point(IconData icon, String title, String body) => Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.sage, size: 28),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(body, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    return _StepFrame(
      step: 2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: _ShieldBadge()),
          const SizedBox(height: AppSpace.xl),
          Text(l.privacyTitle,
              textAlign: TextAlign.center, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpace.sm),
          Text(l.privacySubtitle,
              textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpace.xl),
          point(Icons.smartphone, l.privacy1Title, l.privacy1Body),
          const SizedBox(height: AppSpace.md),
          point(Icons.cloud_outlined, l.privacy2Title, l.privacy2Body),
          const SizedBox(height: AppSpace.md),
          point(Icons.block, l.privacy3Title, l.privacy3Body),
        ],
      ),
      footer: Column(
        children: [
          FilledButton(
            onPressed: () async {
              await settings.acceptPrivacy(now: DateTime.now());
              await onboarding.goToStep(3);
              if (context.mounted) context.go('/onboarding/3');
            },
            child: Text(l.agreeContinue),
          ),
          TextButton(
            onPressed: () => context.push('/privacy'),
            child: Text(l.readPolicy,
                style: const TextStyle(decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}

class _ShieldBadge extends StatelessWidget {
  const _ShieldBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(color: AppColors.brown, shape: BoxShape.circle),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 22, child: ZigzagBand(height: 16)),
          Icon(Icons.verified_user_outlined, size: 70, color: AppColors.cream),
          Positioned(bottom: 22, child: ZigzagBand(height: 16, color: AppColors.terracotta)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Screen 3

class _LastPeriodStep extends StatefulWidget {
  const _LastPeriodStep();

  @override
  State<_LastPeriodStep> createState() => _LastPeriodStepState();
}

class _LastPeriodStepState extends State<_LastPeriodStep> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final onboarding = context.watch<OnboardingController>();
    final selected = onboarding.lastPeriodStart;
    final today = dayOnly(DateTime.now());
    final earliest = addDays(today, -90);

    return _StepFrame(
      step: 3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.lastPeriodTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpace.sm),
          Text(l.lastPeriodBody, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpace.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: l.monthPrev,
                        onPressed: _month.isAfter(DateTime(earliest.year, earliest.month))
                            ? () => setState(() => _month = DateTime(_month.year, _month.month - 1))
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          l.monthYear(_month),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: l.monthNext,
                        onPressed: _month.isBefore(DateTime(today.year, today.month))
                            ? () => setState(() => _month = DateTime(_month.year, _month.month + 1))
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  MonthGrid(
                    month: _month,
                    selected: selected,
                    minDate: earliest,
                    maxDate: today,
                    today: today,
                    dayStyle: (_) => const DayCell(),
                    onTap: (day) => onboarding.setLastPeriod(day),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Center(
            child: TextButton(
              onPressed: () => onboarding.setLastPeriod(
                addDays(today, -14),
                estimate: true,
              ),
              child: Text(l.sinibuka,
                  style: const TextStyle(decoration: TextDecoration.underline)),
            ),
          ),
          if (onboarding.lastPeriodIsEstimate)
            Text(l.sinibukaNote,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
      footer: FilledButton(
        onPressed: selected == null
            ? null
            : () async {
                await onboarding.goToStep(4);
                if (context.mounted) context.go('/onboarding/4');
              },
        child: Text(l.continueBtn),
      ),
    );
  }
}

// ---------------------------------------------------------------- Screen 4

class _CycleStep extends StatelessWidget {
  const _CycleStep();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final onboarding = context.watch<OnboardingController>();
    return _StepFrame(
      step: 4,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.cycleLengthTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpace.sm),
          Text(l.cycleLengthBody, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpace.lg),
          _Stepper(
            label: l.cycleLengthLabel,
            value: onboarding.cycleLength,
            unit: l.daysUnit,
            min: 21,
            max: 45,
            onChanged: onboarding.setCycleLength,
            note: l.cycleRangeNote,
          ),
          const SizedBox(height: AppSpace.md),
          _Stepper(
            label: l.periodLengthLabel,
            value: onboarding.periodLength,
            unit: l.daysUnit,
            min: 2,
            max: 10,
            onChanged: onboarding.setPeriodLength,
          ),
        ],
      ),
      footer: FilledButton(
        onPressed: () async {
          await onboarding.goToStep(5);
          if (context.mounted) context.go('/onboarding/5');
        },
        child: Text(l.continueBtn),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    this.note,
  });

  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StepButton(
                  icon: Icons.remove,
                  enabled: value > min,
                  onTap: () => onChanged(value - 1),
                ),
                Column(
                  children: [
                    Text('$value',
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 44)),
                    Text(unit, style: theme.textTheme.bodyMedium),
                  ],
                ),
                _StepButton(
                  icon: Icons.add,
                  enabled: value < max,
                  onTap: () => onChanged(value + 1),
                  filled: true,
                ),
              ],
            ),
            if (note != null) ...[
              const SizedBox(height: AppSpace.sm),
              Text(note!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        color: filled ? AppColors.terracotta : AppColors.cream,
        shape: const CircleBorder(side: BorderSide(color: AppColors.sand)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Icon(
            icon,
            color: !enabled
                ? AppColors.sandDark
                : filled
                    ? Colors.white
                    : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Screen 5

class _PinAndRemindersStep extends StatefulWidget {
  const _PinAndRemindersStep();

  @override
  State<_PinAndRemindersStep> createState() => _PinAndRemindersStepState();
}

class _PinAndRemindersStepState extends State<_PinAndRemindersStep> {
  bool _pinOn = false;
  String? _pin;
  bool _period = true;
  bool _fertile = true;
  bool _pill = false;

  Future<void> _togglePin(bool on) async {
    if (!on) {
      setState(() {
        _pinOn = false;
        _pin = null;
      });
      return;
    }
    final pin = await showPinSetupSheet(context);
    if (!mounted) return;
    if (pin != null) {
      setState(() {
        _pinOn = true;
        _pin = pin;
      });
    }
  }

  Future<void> _pickPillTime() async {
    final s = context.read<SettingsController>().settings;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.pillHour, minute: s.pillMinute),
    );
    if (picked == null || !mounted) return;
    await context.read<SettingsController>().setPillTime(picked.hour, picked.minute);
  }

  Future<void> _finish({required bool skip}) async {
    final onboarding = context.read<OnboardingController>();
    final cycles = context.read<CycleController>();
    final notifications = context.read<NotificationService>();
    final l = AppLocalizations.of(context);

    final pinOn = !skip && _pinOn && _pin != null;
    final remindersAny = !skip && (_period || _fertile || _pill);
    if (remindersAny) {
      await notifications.requestPermission();
    }

    await onboarding.finish(
      pinOn: pinOn,
      pin: pinOn ? _pin : null,
      remindersPeriod: !skip && _period,
      remindersFertile: !skip && _fertile,
      remindersPill: !skip && _pill,
    );
    await cycles.refresh();
    await cycles.rescheduleReminders(l);
    if (mounted) context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>().settings;
    final theme = Theme.of(context);

    return _StepFrame(
      step: 5,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.pinSetupTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpace.sm),
          Text(l.pinSetupBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpace.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.pinToggle, style: theme.textTheme.titleMedium),
                    value: _pinOn,
                    onChanged: _togglePin,
                  ),
                  if (_pinOn) ...[
                    const SizedBox(height: AppSpace.sm),
                    Text(l.pinHint, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l.remindersTitle, style: theme.textTheme.titleMedium),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.reminderPeriod),
                    value: _period,
                    onChanged: (v) => setState(() => _period = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.reminderFertile),
                    value: _fertile,
                    onChanged: (v) => setState(() => _fertile = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.reminderPill),
                    value: _pill,
                    onChanged: (v) => setState(() => _pill = v),
                  ),
                  if (_pill)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.pillTimeLabel),
                      trailing: Text(
                        '${settings.pillHour.toString().padLeft(2, '0')}:'
                        '${settings.pillMinute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      onTap: _pickPillTime,
                    ),
                  const SizedBox(height: AppSpace.sm),
                  Text(l.reminderNote, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
      footer: Column(
        children: [
          FilledButton(
            onPressed: () => _finish(skip: false),
            child: Text(l.startApp),
          ),
          TextButton(
            onPressed: () => _finish(skip: true),
            child: Text(l.skipBtn),
          ),
        ],
      ),
    );
  }
}
