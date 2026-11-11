import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/admin.dart';
import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import 'admin_users_controller.dart';

/// Owner only: everyone who has signed in with Google, and who is admin. A
/// person can also be made admin before they sign in; the role waits for them.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _email = TextEditingController();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    context.read<AdminUsersController>().load();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  String _reasonText(AppLocalizations l, String code) => switch (code) {
        'invalid' => l.adminUsersInvalid,
        'owner' => l.adminUsersOwner,
        _ => l.authSignInFailed,
      };

  String _roleText(AppLocalizations l, AppRole role) => switch (role) {
        AppRole.owner => l.adminUsersRoleOwner,
        AppRole.admin => l.adminUsersRoleAdmin,
        AppRole.user => l.adminUsersRoleUser,
      };

  void _show(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _invite() async {
    final l = AppLocalizations.of(context);
    final ctrl = context.read<AdminUsersController>();
    final reason = await ctrl.makeAdmin(_email.text);
    if (!mounted) return;
    if (reason == null) {
      _email.clear();
      _show(l.adminSaved);
    } else {
      _show(_reasonText(l, reason));
    }
  }

  Future<void> _toggle(UserRow row) async {
    final l = AppLocalizations.of(context);
    final ctrl = context.read<AdminUsersController>();
    final makeAdmin = row.role != AppRole.admin;
    final reason = makeAdmin
        ? await ctrl.makeAdmin(row.profile.email)
        : await ctrl.removeAdmin(row.profile.email);
    if (!mounted) return;
    _show(reason == null ? l.adminSaved : _reasonText(l, reason));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ctrl = context.watch<AdminUsersController>();
    return Scaffold(
      appBar: AppBar(title: Text(l.adminUsersTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Text(l.adminUsersBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l.adminUsersEmailLabel,
                helperText: l.adminUsersEmailHint,
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            FilledButton.icon(
              onPressed: _invite,
              icon: const Icon(Icons.person_add_alt_1),
              label: Text(l.adminUsersAdd),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(l.adminUsersListTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            if (ctrl.loading)
              const Center(child: CircularProgressIndicator())
            else if (ctrl.users.isEmpty)
              Text(l.adminUsersNone, style: theme.textTheme.bodyMedium)
            else
              for (final row in ctrl.users)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: row.profile.photoUrl == null
                          ? null
                          : NetworkImage(row.profile.photoUrl!),
                      child: row.profile.photoUrl == null
                          ? Text(row.profile.name.isEmpty ? '?' : row.profile.name[0].toUpperCase())
                          : null,
                    ),
                    title: Text(row.profile.name),
                    subtitle: Text('${row.profile.email} · ${_roleText(l, row.role)}'),
                    trailing: row.role == AppRole.owner
                        ? null
                        : TextButton(
                            onPressed: () => _toggle(row),
                            child: Text(row.role == AppRole.admin
                                ? l.adminUsersRemove
                                : l.adminUsersMakeAdmin),
                          ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
