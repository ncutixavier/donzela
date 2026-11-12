import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/utils/dates.dart';
import '../admin/admin_controller.dart';
import '../admin/admin_users_screen.dart';
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
        final signedIn = await cloud.signIn();
        if (signedIn && mounted) await _showSignedIn();
      });

  /// Bottom sheet shown once after a successful Google sign-in.
  Future<void> _showSignedIn() {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final cloud = ctx.read<CloudController>();
        final l = AppLocalizations.of(ctx);
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatar(photoUrl: cloud.photoUrl, name: cloud.displayName ?? cloud.email ?? '', radius: 36),
                const SizedBox(height: AppSpace.md),
                Text(l.accountWelcome(cloud.displayName ?? cloud.email ?? ''),
                    style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(cloud.email ?? '', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpace.lg),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l.continueBtn),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _syncNow() => _run('sync', () async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        await context.read<AdminController>().flush();
        await cloud.syncNow(onProgress: _report);
        final pending = await cloud.pendingCount();
        _message(pending == 0 ? l.accountSyncDone : l.accountPending(pending));
      });

  // Signed in: the restore is the first 60% of the bar, the public content the
  // last 40%. Signed out: only the public articles and Help numbers are pulled.
  Future<void> _pull() => _run('pull', () async {
        final cloud = context.read<CloudController>();
        final l = AppLocalizations.of(context);
        if (!cloud.available) {
          _message(l.cloudUnavailable);
          return;
        }
        if (!cloud.signedIn) {
          await cloud.pullPublicContent(onProgress: _report);
          _message(l.accountContentUpdated);
          return;
        }
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.accountPull, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      cloud.signedIn ? l.accountPullBody : l.accountPullPublicBody,
                      style: theme.textTheme.bodyMedium,
                    ),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: cloud.signedIn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ProfileAvatar(
                                photoUrl: cloud.photoUrl,
                                name: cloud.displayName ?? cloud.email ?? '',
                                radius: 22,
                              ),
                              const SizedBox(width: AppSpace.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (cloud.displayName != null)
                                      Text(cloud.displayName!, style: theme.textTheme.titleMedium),
                                    Text(cloud.email ?? '', style: theme.textTheme.bodyMedium),
                                  ],
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
            if (context.read<AdminController>().isRootAdmin) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.terracotta),
                  title: Text(l.adminUsersTitle),
                  subtitle: Text(l.adminUsersBody),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
            ],
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
                      const SizedBox(height: 4),
                      Text(
                        settings.backupOn ? l.accountSyncNowBody : l.accountSyncOffBody,
                        style: theme.textTheme.bodyMedium,
                      ),
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

