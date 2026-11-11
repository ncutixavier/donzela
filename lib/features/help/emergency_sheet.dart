import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../admin/admin_controller.dart';
import 'help_controller.dart';

/// Name shown for a contact: the typed name, or the translated name for the
/// two built-in numbers.
String emergencyLabel(AppLocalizations l, EmergencyContact c) {
  if (c.name.trim().isNotEmpty) return c.name;
  return switch (c.id) {
    'isange' => l.isangeCentre,
    'ambulance' => l.ambulance,
    _ => c.number,
  };
}

/// Full-height bottom sheet to add, edit and delete emergency numbers. Only
/// the super-admin can open it. Every change saves the whole list.
Future<void> showEmergencySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => const FractionallySizedBox(
      heightFactor: 1,
      alignment: Alignment.bottomCenter,
      child: _EmergencySheet(),
    ),
  );
}

class _EmergencySheet extends StatelessWidget {
  const _EmergencySheet();

  Future<void> _persist(BuildContext context, List<EmergencyContact> list) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final admin = context.read<AdminController>();
    final help = context.read<HelpController>();
    try {
      final synced = await admin.saveEmergency(list);
      await help.reload();
      messenger.showSnackBar(SnackBar(content: Text(synced ? l.adminSaved : l.adminSavedLocal)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
    }
  }

  Future<void> _add(BuildContext context, List<EmergencyContact> list) async {
    final created = await showEmergencyForm(context);
    if (created == null || !context.mounted) return;
    await _persist(context, [...list, created]);
  }

  Future<void> _edit(BuildContext context, List<EmergencyContact> list, int index) async {
    final updated = await showEmergencyForm(context, existing: list[index]);
    if (updated == null || !context.mounted) return;
    final next = [...list]..[index] = updated;
    await _persist(context, next);
  }

  Future<void> _delete(BuildContext context, List<EmergencyContact> list, int index) async {
    final l = AppLocalizations.of(context);
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
    if (ok != true || !context.mounted) return;
    await _persist(context, [...list]..removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final list = context.watch<HelpController>().emergency;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l.emergencyManage),
        actions: [
          IconButton(
            tooltip: l.cancelBtn,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text(l.emergencyNone))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpace.lg),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final c = list[i];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpace.lg, vertical: 6),
                            title: Text(emergencyLabel(l, c)),
                            subtitle: Text(c.number),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: l.emergencyEdit,
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.brown),
                                  onPressed: () => _edit(context, list, i),
                                ),
                                IconButton(
                                  tooltip: l.deleteBtn,
                                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                                  onPressed: () => _delete(context, list, i),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _add(context, list),
                  icon: const Icon(Icons.add),
                  label: Text(l.emergencyAdd),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Form for one emergency number. Returns the contact, or null when cancelled.
Future<EmergencyContact?> showEmergencyForm(
  BuildContext context, {
  EmergencyContact? existing,
}) {
  return showModalBottomSheet<EmergencyContact>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 1,
      alignment: Alignment.bottomCenter,
      child: _EmergencyForm(existing: existing),
    ),
  );
}

class _EmergencyForm extends StatefulWidget {
  const _EmergencyForm({this.existing});

  final EmergencyContact? existing;

  @override
  State<_EmergencyForm> createState() => _EmergencyFormState();
}

class _EmergencyFormState extends State<_EmergencyForm> {
  late final _name = TextEditingController(
    text: widget.existing == null
        ? ''
        : emergencyLabel(AppLocalizations.of(context), widget.existing!),
  );
  late final _number = TextEditingController(text: widget.existing?.number ?? '');

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    super.dispose();
  }

  void _save() {
    final l = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty || _number.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.adminRequired)));
      return;
    }
    final id = widget.existing?.id ?? 'custom-${DateTime.now().millisecondsSinceEpoch}';
    Navigator.of(context).pop(
      EmergencyContact(id: id, name: _name.text.trim(), number: _number.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.existing == null ? l.emergencyAdd : l.emergencyEdit),
        actions: [
          IconButton(
            tooltip: l.cancelBtn,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l.fieldName),
            ),
            const SizedBox(height: AppSpace.md),
            TextField(
              controller: _number,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l.fieldPhone),
            ),
            const SizedBox(height: AppSpace.xl),
            FilledButton(onPressed: _save, child: Text(l.saveBtn)),
          ],
        ),
      ),
    );
  }
}
