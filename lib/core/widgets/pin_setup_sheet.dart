import 'package:flutter/material.dart';

import '../l10n/localization.dart';
import '../theme/app_theme.dart';
import 'pin_pad.dart';

/// Asks for a new 4-digit PIN twice. Returns the PIN, or null when the user
/// cancels. Rejects a PIN that does not match the first entry.
Future<String?> showPinSetupSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.brown,
    builder: (_) => const _PinSetupSheet(),
  );
}

class _PinSetupSheet extends StatefulWidget {
  const _PinSetupSheet();

  @override
  State<_PinSetupSheet> createState() => _PinSetupSheetState();
}

class _PinSetupSheetState extends State<_PinSetupSheet> {
  String _first = '';
  String _current = '';
  bool _confirming = false;
  String? _error;

  void _digit(String d) {
    if (_current.length >= 4) return;
    setState(() {
      _error = null;
      _current += d;
    });
  }

  void _back() {
    if (_current.isEmpty) return;
    setState(() => _current = _current.substring(0, _current.length - 1));
  }

  void _confirm() {
    final l = AppLocalizations.of(context);
    if (_current.length != 4) return;
    if (!_confirming) {
      setState(() {
        _first = _current;
        _current = '';
        _confirming = true;
      });
      return;
    }
    if (_current == _first) {
      Navigator.of(context).pop(_current);
    } else {
      setState(() {
        _error = l.pinWrong;
        _current = '';
        _confirming = false;
        _first = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.xl,
        AppSpace.lg,
        MediaQuery.viewInsetsOf(context).bottom + AppSpace.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _confirming ? l.pinConfirmTitle : l.pinNewTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          PinDots(
            filled: _current.length,
            color: AppColors.cream,
            ring: AppColors.cream,
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpace.md),
            Text(_error!, style: const TextStyle(color: AppColors.blush)),
          ],
          const SizedBox(height: AppSpace.lg),
          PinPad(
            onDigit: _digit,
            onBackspace: _back,
            onConfirm: _confirm,
            confirmEnabled: _current.length == 4,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.cancelBtn, style: const TextStyle(color: AppColors.cream)),
          ),
        ],
      ),
    );
  }
}
