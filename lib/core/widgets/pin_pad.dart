import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Four-dot PIN indicator.
class PinDots extends StatelessWidget {
  const PinDots({super.key, required this.filled, this.color = AppColors.ink, this.ring = AppColors.terracotta});

  final int filled;
  final Color color;
  final Color ring;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? color : Colors.transparent,
              border: Border.all(color: ring, width: 2),
            ),
          ),
      ],
    );
  }
}

/// Keypad for PIN entry (lock screen and PIN setup). Digits 1–9, 0, backspace
/// and confirm. Dark style matches screen 7.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onConfirm,
    this.confirmEnabled = true,
    this.dark = true,
  });

  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onConfirm;
  final bool confirmEnabled;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final keyColor = dark ? const Color(0xFF583D36) : AppColors.surface;
    final textColor = dark ? Colors.white : AppColors.ink;

    Widget key(Widget child, VoidCallback? onTap, {Color? bg}) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Material(
            color: bg ?? keyColor,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: onTap,
              child: SizedBox(
                height: 64,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      );
    }

    Widget digit(String d) => key(
          Text(d,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w600, color: textColor)),
          () => onDigit(d),
        );

    return Column(
      children: [
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(children: [for (final d in row) digit(d)]),
        Row(
          children: [
            key(Icon(Icons.backspace_outlined, color: textColor),
                onBackspace,
                bg: Colors.transparent),
            digit('0'),
            key(
              const Icon(Icons.check, color: Colors.white),
              confirmEnabled ? onConfirm : null,
              bg: confirmEnabled ? AppColors.terracotta : keyColor,
            ),
          ],
        ),
      ],
    );
  }
}
