import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/database.dart';
import '../account/cloud_controller.dart';
import '../admin/admin_controller.dart';
import '../account/content_refresh.dart';
import 'centre_sheet.dart';
import 'emergency_sheet.dart';
import 'help_controller.dart';

/// Find help (screen 14). Emergency numbers are always shown. Call buttons use
/// tel: links and work without a data connection.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    context.read<HelpController>().load();
  }

  bool _refreshing = false;

  /// Pulls the latest Help information (centres and numbers), then shows it.
  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final ok = await refreshPublicContent(context);
    if (!mounted) return;
    setState(() => _refreshing = false);
    if (ok) await context.read<HelpController>().reload();
  }

  static Future<void> _call(String number) =>
      launchUrl(Uri(scheme: 'tel', path: number));

  Future<void> _editCentre(HealthCentreRow? existing) async {
    await showCentreSheet(context, existing: existing);
  }

  Future<void> _deleteCentre(HealthCentreRow c) async {
    final l = AppLocalizations.of(context);
    final admin = context.read<AdminController>();
    final ctrl = context.read<HelpController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.logDeleteTitle),
        content: Text(l.adminDeleteBody),
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
    await admin.deleteCentre(c.id);
    await ctrl.reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<HelpController>();
    final theme = Theme.of(context);
    // Rebuild on sign-in, so the admin tools appear straight away.
    context.watch<CloudController>();
    final isAdmin = context.read<AdminController>().isSuperAdmin;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Row(
              children: [
                Expanded(child: Text(l.helpTitle, style: theme.textTheme.headlineMedium)),
                RefreshContentButton(busy: _refreshing, onPressed: _refresh),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.helpSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            // Verify the built-in numbers before launch (see implementation plan).
            _EmergencyCard(
              title: l.emergencyTitle,
              entries: [
                for (final c in ctrl.emergency) (emergencyLabel(l, c), c.number),
              ],
              emptyText: l.emergencyNone,
              onCall: _call,
              callLabel: l.callBtn,
              onEdit: isAdmin ? () => showEmergencySheet(context) : null,
              editLabel: l.emergencyManage,
            ),
            const SizedBox(height: AppSpace.lg),
            Text(l.yourDistrict, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            DropdownButtonFormField<String>(
              initialValue: ctrl.district,
              decoration: const InputDecoration(),
              items: [
                DropdownMenuItem(
                  value: HelpController.allDistricts,
                  child: Text(l.filterAll),
                ),
                for (final d in ctrl.districts)
                  DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: (v) {
                if (v != null) ctrl.selectDistrict(v);
              },
            ),
            const SizedBox(height: AppSpace.md),
            if (isAdmin) ...[
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
                onPressed: () => _editCentre(null),
                icon: const Icon(Icons.add),
                label: Text(l.adminAddCentre),
              ),
              const SizedBox(height: AppSpace.md),
            ],
            if (ctrl.centres.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpace.lg),
                  child: Text(l.centresNone, style: theme.textTheme.bodyMedium),
                ),
              )
            else
              for (final c in ctrl.centres)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.sm),
                  child: _CentreTile(
                    centre: c,
                    showDistrict: ctrl.showingAll,
                    onCall: () => _call(c.phone),
                    callLabel: l.callBtn,
                    onEdit: isAdmin ? () => _editCentre(c) : null,
                    onDelete: isAdmin ? () => _deleteCentre(c) : null,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard({
    required this.title,
    required this.entries,
    required this.emptyText,
    required this.onCall,
    required this.callLabel,
    this.onEdit,
    this.editLabel,
  });

  final String title;
  final List<(String, String)> entries;
  final String emptyText;
  final Future<void> Function(String) onCall;
  final String callLabel;

  /// Set only for the super-admin.
  final VoidCallback? onEdit;
  final String? editLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.brown,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                if (onEdit != null)
                  IconButton(
                    tooltip: editLabel,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            if (entries.isEmpty)
              Text(emptyText, style: const TextStyle(color: Colors.white))
            else
              for (final (name, number) in entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.sm),
                  child: Material(
                    color: AppColors.terracotta,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.control),
                      onTap: () => onCall(number),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(name,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                            Text(number,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w800)),
                            const SizedBox(width: AppSpace.sm),
                            Semantics(
                              label: callLabel,
                              child: const Icon(Icons.call, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _CentreTile extends StatelessWidget {
  const _CentreTile({
    required this.centre,
    required this.showDistrict,
    required this.onCall,
    required this.callLabel,
    this.onEdit,
    this.onDelete,
  });

  final HealthCentreRow centre;

  /// True in the "All districts" view, so each centre shows where it is.
  final bool showDistrict;
  final VoidCallback onCall;
  final String callLabel;

  /// Set only for the super-admin.
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = showDistrict
        ? '${centre.district} · ${centre.sector}'
        : centre.sector;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: 6),
        title: Text(centre.name, style: theme.textTheme.titleMedium),
        subtitle: Text('$place · ${centre.services}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                tooltip: AppLocalizations.of(context).adminEditCentre,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: AppColors.brown),
              ),
            if (onDelete != null)
              IconButton(
                tooltip: AppLocalizations.of(context).deleteBtn,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              ),
            IconButton.outlined(
              tooltip: callLabel,
              onPressed: onCall,
              icon: const Icon(Icons.call_outlined, color: AppColors.terracotta),
            ),
          ],
        ),
      ),
    );
  }
}
