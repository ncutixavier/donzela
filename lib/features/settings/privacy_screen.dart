import 'package:flutter/material.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imigongo.dart';

/// Privacy policy, in the chosen language (screen 15 link).
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.policyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.lg),
        children: [
          const ZigzagBand(height: 12),
          const SizedBox(height: AppSpace.lg),
          Text(l.policyBody, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
