import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import 'cloud_controller.dart';

/// Pulls the latest articles and Help information from Firestore. Used by the
/// refresh buttons on Learn and Help and by the app at launch. Needs no
/// account. Returns true when the pull worked.
Future<bool> refreshPublicContent(BuildContext context) async {
  final l = AppLocalizations.of(context);
  final cloud = context.read<CloudController>();
  final messenger = ScaffoldMessenger.of(context);
  if (!cloud.available) {
    messenger.showSnackBar(SnackBar(content: Text(l.cloudUnavailable)));
    return false;
  }
  try {
    await cloud.pullPublicContent();
    messenger.showSnackBar(SnackBar(content: Text(l.accountContentUpdated)));
    return true;
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l.contentPullFailed)));
    return false;
  }
}

/// Refresh icon for a page header. Shows a spinner while the pull runs.
class RefreshContentButton extends StatelessWidget {
  const RefreshContentButton({super.key, required this.busy, required this.onPressed});

  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (busy) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return IconButton(
      tooltip: l.refreshContent,
      icon: const Icon(Icons.refresh),
      onPressed: onPressed,
    );
  }
}
