import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Imigongo-inspired zigzag band (decorative strip at the top/bottom of
/// onboarding, lock and learn cards).
class ZigzagBand extends StatelessWidget {
  const ZigzagBand({super.key, this.color = AppColors.gold, this.height = 14});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Takes the width its parent allows. Falls back to 200 when unbounded,
    // so it can sit inside a Positioned or a Row without layout errors.
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => CustomPaint(
          size: Size(
            constraints.hasBoundedWidth ? constraints.maxWidth : 200,
            height,
          ),
          painter: _ZigzagPainter(color),
        ),
      ),
    );
  }
}

class _ZigzagPainter extends CustomPainter {
  _ZigzagPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.miter;
    const step = 14.0;
    final path = Path()..moveTo(0, size.height);
    var x = 0.0;
    var up = true;
    while (x < size.width + step) {
      x += step / 2;
      path.lineTo(x, up ? 0 : size.height);
      up = !up;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ZigzagPainter old) => old.color != color;
}

/// Circular brand mark: a ring of blocks around a crescent moon.
class DonzelaMark extends StatelessWidget {
  const DonzelaMark({super.key, this.size = 96, this.background = AppColors.brown});

  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MarkPainter(background)),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.background);
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;

    canvas.drawCircle(c, r, Paint()..color = background);

    final block = Paint()..color = AppColors.terracotta;
    const blocks = 16;
    for (var i = 0; i < blocks; i++) {
      final a = (i / blocks) * 6.283185307;
      final sweep = 6.283185307 / blocks * 0.62;
      final rect = Rect.fromCircle(center: c, radius: r * 0.82);
      canvas.drawArc(rect, a, sweep, false, block
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.16);
    }

    canvas.drawCircle(
      c,
      r * 0.52,
      Paint()
        ..color = AppColors.blush
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.03,
    );

    // Crescent: a gold disc with a background-coloured disc cut out.
    final outer = Path()
      ..addOval(Rect.fromCircle(center: c.translate(-r * 0.04, 0), radius: r * 0.3));
    final inner = Path()
      ..addOval(Rect.fromCircle(center: c.translate(r * 0.08, -r * 0.03), radius: r * 0.26));
    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, inner),
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant _MarkPainter old) => old.background != background;
}
