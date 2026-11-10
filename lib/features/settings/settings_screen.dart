import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imigongo.dart';
import '../../core/widgets/pin_setup_sheet.dart';
import '../../services/security/pin_service.dart';
import '../lock/lock_controller.dart';
import '../lock/lock_screen.dart';
import '../account/cloud_controller.dart';
import '../today/cycle_controller.dart';
import 'settings_controller.dart';

/// Settings (screen 15): language, PIN, reminders, privacy, delete everything.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _name =
      TextEditingController(text: context.read<SettingsController>().settings.firstName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _rescheduleReminders() async {
    final l = AppLocalizations.of(context);
    await context.read<CycleController>().rescheduleReminders(l);
  }

  Future<void> _togglePin(bool on) async {
    final settings = context.read<SettingsController>();
    final pins = context.read<PinService>();
    final lock = context.read<LockController>();
    if (on) {
      final pin = await showPinSetupSheet(context);
      if (pin == null) return;
      await pins.setPin(pin);
      await settings.setPinFlag(true);
    } else {
      final ok = await showPinVerifySheet(context);
      if (!ok) return;
      await pins.clear();
      await settings.setPinFlag(false);
      lock.unlockWithoutPin();
    }
  }

  Future<void> _changePin() async {
    final pins = context.read<PinService>();
    final ok = await showPinVerifySheet(context);
    if (!ok || !mounted) return;
    final pin = await showPinSetupSheet(context);
    if (pin == null) return;
    await pins.setPin(pin);
  }

  Future<void> _toggleBackup(bool on) async {
    final l = AppLocalizations.of(context);
    final settings = context.read<SettingsController>();
    final cloud = context.read<CloudController>();
    final messenger = ScaffoldMessenger.of(context);
    if (!on) {
      await settings.setBackup(false, now: DateTime.now());
      return;
    }
    if (!cloud.available) {
      messenger.showSnackBar(SnackBar(content: Text(l.cloudUnavailable)));
      return;
    }
    final consent = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l.backupExplain),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancelBtn)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.backupConsentBtn)),
        ],
      ),
    );
    if (consent != true) return;
    // Backup belongs to a Google account, so sign in before anything uploads.
    try {
      final signedIn = await cloud.signIn();
      if (!signedIn) return;
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
      return;
    }
    if (!mounted) return;
    await settings.setBackup(true, now: DateTime.now());
    await cloud.syncNow();
    messenger.showSnackBar(SnackBar(content: Text(l.backupStarted)));
  }

  Future<void> _pickPillTime() async {
    final s = context.read<SettingsController>();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.settings.pillHour, minute: s.settings.pillMinute),
    );
    if (picked == null || !mounted) return;
    await s.setPillTime(picked.hour, picked.minute);
    await _rescheduleReminders();
  }

  Future<void> _deleteAll() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteAllTitle),
        content: Text(l.deleteAllBody),
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
    if (ok != true || !mounted) return;
    final settings = context.read<SettingsController>();
    final lock = context.read<LockController>();
    await settings.deleteEverything();
    lock.unlockWithoutPin();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<SettingsController>();
    final s = ctrl.settings;
    final theme = Theme.of(context);

    Widget header(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(4, AppSpace.lg, 4, AppSpace.sm),
          child: Text(text,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700, letterSpacing: 1)),
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: l.backBtn,
          onPressed: () => context.pop(),
        ),
        title: Text(l.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.xl),
        children: [
          header(l.sectionPrefs),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l.languageSetting),
                  trailing: DropdownButton<String>(
                    value: s.language,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: 'rw', child: Text(l.langRw)),
                      DropdownMenuItem(value: 'en', child: Text(l.langEn)),
                      DropdownMenuItem(value: 'fr', child: Text(l.langFr)),
                    ],
                    onChanged: (v) {
                      if (v != null) ctrl.setLanguage(v);
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpace.md),
                  child: TextField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l.firstNameLabel),
                    onSubmitted: ctrl.setFirstName,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l.pinSetting),
                  value: s.pinOn,
                  onChanged: _togglePin,
                ),
                if (s.pinOn)
                  ListTile(
                    title: Text(l.changePin),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePin,
                  ),
              ],
            ),
          ),
          header(l.remindersTitle),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l.reminderPeriod),
                  value: s.remindersPeriod,
                  onChanged: (v) async {
                    await ctrl.setReminder('period', v);
                    await _rescheduleReminders();
                  },
                ),
                SwitchListTile(
                  title: Text(l.reminderFertile),
                  value: s.remindersFertile,
                  onChanged: (v) async {
                    await ctrl.setReminder('fertile', v);
                    await _rescheduleReminders();
                  },
                ),
                SwitchListTile(
                  title: Text(l.reminderPill),
                  value: s.remindersPill,
                  onChanged: (v) async {
                    await ctrl.setReminder('pill', v);
                    await _rescheduleReminders();
                  },
                ),
                if (s.remindersPill)
                  ListTile(
                    title: Text(l.pillTimeLabel),
                    trailing: Text(
                      '${s.pillHour.toString().padLeft(2, '0')}:'
                      '${s.pillMinute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: _pickPillTime,
                  ),
              ],
            ),
          ),
          header(l.sectionPrivacy),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l.backupSetting),
                  subtitle: Text(l.backupNote),
                  value: s.backupOn,
                  onChanged: _toggleBackup,
                ),
                if (context.watch<CloudController>().signedIn) ...[
                  const Divider(height: 1),
                  ListTile(
                    title: Text(l.authSignedInAs(
                        context.watch<CloudController>().email ?? '')),
                    trailing: TextButton(
                      onPressed: () async {
                        await context.read<CloudController>().signOut();
                      },
                      child: Text(l.authSignOut),
                    ),
                  ),
                ],
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(l.analyticsSetting),
                  subtitle: Text(l.analyticsNote),
                  value: s.analyticsOn,
                  onChanged: ctrl.setAnalytics,
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l.privacyPolicyLink,
                      style: const TextStyle(
                          color: AppColors.terracotta,
                          decoration: TextDecoration.underline)),
                  onTap: () => context.push('/privacy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger, width: 1.5),
            ),
            onPressed: _deleteAll,
            child: Text(l.deleteAllBtn),
          ),
          const SizedBox(height: AppSpace.xl),
          const ZigzagBand(),
          const SizedBox(height: AppSpace.sm),
          Text(l.appFooter,
              textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          Center(
            child: TextButton(
              onPressed: () => context.push('/privacy'),
              child: Text(l.privacyPolicyLink),
            ),
          ),
        ],
      ),
    );
  }
}
