import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/database.dart';
import '../admin/admin_controller.dart';
import 'help_controller.dart';

/// Opens the health-centre form as a bottom sheet that fills the screen.
/// Returns true when a centre was saved (on this phone, and in the cloud when
/// online).
Future<bool?> showCentreSheet(BuildContext context, {HealthCentreRow? existing}) {
  final ctrl = context.read<HelpController>();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => FractionallySizedBox(
      heightFactor: 1,
      alignment: Alignment.bottomCenter,
      child: _CentreSheet(
        existing: existing,
        // "All districts" is not a district, so a new centre starts with the first one.
        initialDistrict: existing?.district ??
            (ctrl.showingAll ? ctrl.districts.first : ctrl.district),
        districts: ctrl.districts,
      ),
    ),
  );
}

class _CentreSheet extends StatefulWidget {
  const _CentreSheet({
    required this.existing,
    required this.initialDistrict,
    required this.districts,
  });

  final HealthCentreRow? existing;
  final String initialDistrict;
  final List<String> districts;

  @override
  State<_CentreSheet> createState() => _CentreSheetState();
}

class _CentreSheetState extends State<_CentreSheet> {
  TextEditingController? _district;
  late final _sector = TextEditingController(text: widget.existing?.sector ?? '');
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _phone = TextEditingController(text: widget.existing?.phone ?? '');
  late final _services = TextEditingController(text: widget.existing?.services ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _sector.dispose();
    _name.dispose();
    _phone.dispose();
    _services.dispose();
    super.dispose();
  }

  /// True when the typed district is not in the list yet. It will be added when saved.
  bool get _isNewDistrict {
    final typed = _district?.text.trim() ?? '';
    return typed.isNotEmpty && !widget.districts.contains(typed);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final district = _district?.text.trim() ?? '';
    if (district.isEmpty || _name.text.trim().isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.adminRequired)));
      return;
    }
    setState(() => _saving = true);
    final admin = context.read<AdminController>();
    final help = context.read<HelpController>();
    try {
      final synced = await admin.saveCentre(
            id: widget.existing?.id,
            district: district,
            sector: _sector.text,
            name: _name.text,
            phone: _phone.text,
            services: _services.text,
          );
      // Show the district the centre was saved in, even if it is new.
      await help.selectDistrict(district);
      if (!mounted) return;
      nav.pop(true);
      messenger.showSnackBar(SnackBar(content: Text(synced ? l.adminSaved : l.adminSavedLocal)));
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(editing ? l.adminEditCentre : l.adminAddCentre),
        actions: [
          IconButton(
            tooltip: l.cancelBtn,
            icon: const Icon(Icons.close),
            onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Autocomplete<String>(
              initialValue: TextEditingValue(text: widget.initialDistrict),
              optionsBuilder: (value) {
                final q = value.text.trim().toLowerCase();
                if (q.isEmpty) return widget.districts;
                return widget.districts.where((d) => d.toLowerCase().contains(q));
              },
              fieldViewBuilder: (context, controller, focus, onSubmit) {
                _district = controller;
                return TextField(
                  controller: controller,
                  focusNode: focus,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l.fieldDistrict,
                    helperText: _isNewDistrict ? l.newDistrictNote : l.districtPickNote,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpace.md),
            TextField(
              controller: _sector,
              decoration: InputDecoration(labelText: l.fieldSector),
            ),
            const SizedBox(height: AppSpace.md),
            TextField(
              controller: _name,
              decoration: InputDecoration(labelText: l.fieldName),
            ),
            const SizedBox(height: AppSpace.md),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l.fieldPhone),
            ),
            const SizedBox(height: AppSpace.md),
            TextField(
              controller: _services,
              decoration: InputDecoration(labelText: l.fieldServices),
            ),
            const SizedBox(height: AppSpace.xl),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l.saveBtn),
            ),
          ],
        ),
      ),
    );
  }
}
