import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/database.dart';
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

  static Future<void> _call(String number) =>
      launchUrl(Uri(scheme: 'tel', path: number));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<HelpController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Text(l.helpTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(l.helpSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            // Verify both numbers before launch (see implementation plan).
            _EmergencyCard(
              title: l.emergencyTitle,
              entries: [
                (l.isangeCentre, '3029'),
                (l.ambulance, '912'),
              ],
              onCall: _call,
              callLabel: l.callBtn,
            ),
            const SizedBox(height: AppSpace.lg),
            Text(l.yourDistrict, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            DropdownButtonFormField<String>(
              initialValue: ctrl.district,
              decoration: const InputDecoration(),
              items: [
                for (final d in HelpController.districts)
                  DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: (v) {
                if (v != null) ctrl.selectDistrict(v);
              },
            ),
            const SizedBox(height: AppSpace.md),
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
                  child: _CentreTile(centre: c, onCall: () => _call(c.phone), callLabel: l.callBtn),
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
    required this.onCall,
    required this.callLabel,
  });

  final String title;
  final List<(String, String)> entries;
  final Future<void> Function(String) onCall;
  final String callLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.brown,
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpace.md),
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
  const _CentreTile({required this.centre, required this.onCall, required this.callLabel});

  final HealthCentreRow centre;
  final VoidCallback onCall;
  final String callLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: 6),
        title: Text(centre.name, style: theme.textTheme.titleMedium),
        subtitle: Text('${centre.sector} · ${centre.services}'),
        trailing: IconButton.outlined(
          tooltip: callLabel,
          onPressed: onCall,
          icon: const Icon(Icons.call_outlined, color: AppColors.terracotta),
        ),
      ),
    );
  }
}
