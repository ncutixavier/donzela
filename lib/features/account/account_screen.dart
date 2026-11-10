import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
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

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (_) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _signIn() => _run(() async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        if (!cloud.available) {
          _message(l.cloudUnavailable);
          return;
        }
        await cloud.signIn();
      });

  Future<void> _syncNow() => _run(() async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        await cloud.syncNow();
        final pending = await cloud.pendingCount();
        _message(pending == 0 ? l.accountSyncDone : l.accountPending(pending));
      });

  Future<void> _pull() => _run(() async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        final result = await cloud.restore();
        await cloud.pullPublicContent();
        final count = result.cycles + result.dailyLogs;
        _message(count == 0 ? l.accountNothingNew : l.accountPulled(count));
      });

  Future<void> _signOut() => _run(() async {
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
                          child: Text(_busy ? l.accountBusy : l.accountSyncNow),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => context.push('/settings'),
                          child: Text(l.accountTurnOnBackup),
                        ),
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
