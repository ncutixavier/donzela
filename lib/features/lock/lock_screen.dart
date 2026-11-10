import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imigongo.dart';
import '../../core/widgets/pin_pad.dart';
import '../../services/security/pin_service.dart';
import '../settings/settings_controller.dart';
import 'lock_controller.dart';

/// PIN lock (screen 7). Shown on cold start and after more than 2 minutes in
/// the background. Wrong tries and the 30-second lockout live in secure
/// storage, so killing the app does not reset them.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _entered = '';
  String? _error;
  int _lockedFor = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _lockedFor = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        _lockedFor--;
        if (_lockedFor <= 0) {
          _lockedFor = 0;
          t.cancel();
        }
      });
    });
  }

  Future<void> _submit() async {
    if (_entered.length != 4 || _lockedFor > 0) return;
    final l = AppLocalizations.of(context);
    final result = await context.read<LockController>().tryUnlock(_entered);
    if (!mounted) return;
    if (result.ok) return; // The router moves us to Today.
    setState(() {
      _entered = '';
      _error = result.isLocked ? null : l.pinWrong;
    });
    if (result.isLocked) _startCountdown(result.lockedSeconds);
  }

  Future<void> _forgot() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.resetPinTitle),
        content: Text(l.resetPinBody),
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
    if (ok != true || !mounted) return;
    final settings = context.read<SettingsController>();
    final lock = context.read<LockController>();
    await settings.deleteEverything();
    lock.unlockWithoutPin();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locked = _lockedFor > 0;
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: SafeArea(
        child: Column(
          children: [
            const ZigzagBand(height: 18, color: AppColors.terracotta),
            const SizedBox(height: AppSpace.xl),
            const DonzelaMark(size: 84),
            const SizedBox(height: AppSpace.lg),
            Text(
              locked ? l.pinLockedFor(_lockedFor) : l.pinEnterTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            PinDots(filled: _entered.length),
            SizedBox(
              height: 36,
              child: Center(
                child: _error == null
                    ? null
                    : Text(_error!, style: const TextStyle(color: AppColors.blush)),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
              child: AbsorbPointer(
                absorbing: locked,
                child: Opacity(
                  opacity: locked ? 0.4 : 1,
                  child: PinPad(
                    onDigit: (d) {
                      if (_entered.length >= 4) return;
                      setState(() {
                        _error = null;
                        _entered += d;
                      });
                      if (_entered.length == 4) _submit();
                    },
                    onBackspace: () {
                      if (_entered.isEmpty) return;
                      setState(() => _entered = _entered.substring(0, _entered.length - 1));
                    },
                    onConfirm: _submit,
                    confirmEnabled: _entered.length == 4,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _forgot,
              child: Text(
                l.forgotPin,
                style: const TextStyle(
                  color: AppColors.gold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.md),
          ],
        ),
      ),
    );
  }
}

/// Asks for the current PIN before a sensitive change, such as turning the
/// PIN off. Returns true only when the PIN is correct.
Future<bool> showPinVerifySheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.brown,
    builder: (_) => const _VerifySheet(),
  );
  return result ?? false;
}

class _VerifySheet extends StatefulWidget {
  const _VerifySheet();

  @override
  State<_VerifySheet> createState() => _VerifySheetState();
}

class _VerifySheetState extends State<_VerifySheet> {
  String _entered = '';
  String? _error;

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final result = await context.read<PinService>().verify(_entered);
    if (!mounted) return;
    if (result.ok) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _entered = '';
      _error = result.isLocked ? l.pinLockedFor(result.lockedSeconds) : l.pinWrong;
    });
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
          Text(l.pinEnterTitle,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpace.lg),
          PinDots(filled: _entered.length, color: AppColors.cream, ring: AppColors.cream),
          if (_error != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(_error!, style: const TextStyle(color: AppColors.blush)),
          ],
          const SizedBox(height: AppSpace.lg),
          PinPad(
            onDigit: (d) {
              if (_entered.length >= 4) return;
              setState(() {
                _error = null;
                _entered += d;
              });
              if (_entered.length == 4) _submit();
            },
            onBackspace: () {
              if (_entered.isEmpty) return;
              setState(() => _entered = _entered.substring(0, _entered.length - 1));
            },
            onConfirm: _submit,
            confirmEnabled: _entered.length == 4,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancelBtn, style: const TextStyle(color: AppColors.cream)),
          ),
        ],
      ),
    );
  }
}
