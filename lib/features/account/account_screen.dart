import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../admin/admin_controller.dart';
import '../settings/settings_controller.dart';
import 'cloud_controller.dart';

/// Account tab: sign in with Google, see sync status, sync now, and pull
/// recent updates. Everything here happens only when the user presses a
/// button; nothing is pulled in the background.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _busy = false;

  /// Which action is running ('sync' or 'pull'), so only its card shows progress.
  String? _activity;

  /// 0 to 1 for the running action. Starts at 0 so the bar shows 0% at once.
  double _progress = 0;

  void _report(double p) {
    if (mounted) setState(() => _progress = p.clamp(0, 1));
  }

  Future<void> _run(String activity, Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _activity = activity;
      _progress = 0;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _activity = null;
        });
      }
    }
  }

  /// Progress bar with the percentage, shown under the button while it runs.
  Widget _progressBar(AppLocalizations l, ThemeData theme) {
    final percent = (_progress * 100).round();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: _progress, minHeight: 8),
          const SizedBox(height: 6),
          Text(l.accountProgress(percent), style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _signIn() => _run('signin', () async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        if (!cloud.available) {
          _message(l.cloudUnavailable);
          return;
        }
        await cloud.signIn();
      });

  Future<void> _syncNow() => _run('sync', () async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        await context.read<AdminController>().flush();
        await cloud.syncNow(onProgress: _report);
        final pending = await cloud.pendingCount();
        _message(pending == 0 ? l.accountSyncDone : l.accountPending(pending));
      });

  // The restore is the first 60% of the bar, the public content the last 40%.
  Future<void> _pull() => _run('pull', () async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        final result = await cloud.restore(onProgress: (p) => _report(p * 0.6));
        await cloud.pullPublicContent(onProgress: (p) => _report(0.6 + p * 0.4));
        final count = result.cycles + result.dailyLogs;
        _message(count == 0 ? l.accountNothingNew : l.accountPulled(count));
      });

  Future<void> _signOut() => _run('signout', () async {
        await context.read<CloudController>().signOut();
      });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cloud = context.watch<CloudController>();
    final settings = context.watch<SettingsController>().settings;
    final lastSync = settings.lastSync;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xl),
          children: [
            Text(l.accountTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpace.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: cloud.signedIn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_circle, color: AppColors.terracotta, size: 36),
                              const SizedBox(width: AppSpace.md),
                              Expanded(
                                child: Text(
                                  cloud.email ?? '',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpace.md),
                          Text(
                            settings.backupOn ? l.accountBackupOn : l.accountBackupOff,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastSync == null
                                ? l.accountNeverSynced
                                : l.accountLastSync(dateTimeText(lastSync)),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.accountSignedOutBody, style: theme.textTheme.bodyLarge),
                          const SizedBox(height: AppSpace.md),
                          FilledButton(
                            onPressed: _busy ? null : _signIn,
                            child: Text(_busy ? l.accountBusy : l.authSignIn),
                          ),
                        ],
                      ),
              ),
            ),
            if (cloud.signedIn && context.read<AdminController>().isSuperAdmin) ...[
              const SizedBox(height: AppSpace.md),
              Card(
                color: AppColors.goldSoft,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.adminBadge, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(l.adminOnlyBadgeBody, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ],
            if (cloud.signedIn) ...[
              const SizedBox(height: AppSpace.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.accountSyncNow, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpace.sm),
                      if (settings.backupOn)
                        FilledButton(
                          onPressed: _busy ? null : _syncNow,
                          child: Text(_busy && _activity == 'sync' ? l.accountBusy : l.accountSyncNow),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => context.push('/settings'),
                          child: Text(l.accountTurnOnBackup),
                        ),
                      if (_busy && _activity == 'sync') _progressBar(l, theme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l.accountPull, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpace.sm),
                      Text(l.accountPullBody, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: AppSpace.md),
                      OutlinedButton(
                        onPressed: _busy ? null : _pull,
                        child: Text(l.accountPull),
                      ),
                      if (_busy && _activity == 'pull') _progressBar(l, theme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              TextButton(
                onPressed: _busy ? null : _signOut,
                child: Text(l.authSignOut),
              ),
            ],
            if (!cloud.available) ...[
              const SizedBox(height: AppSpace.md),
              Text(l.cloudUnavailable, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
