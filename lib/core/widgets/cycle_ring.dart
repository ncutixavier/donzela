import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../services/prediction/prediction_service.dart';
import '../theme/app_theme.dart';
import '../utils/dates.dart';

/// Cycle ring (F4), styled after the Flo-style layout: one segment per cycle
/// day with its number printed outside the ring, coloured arcs for the period,
/// the fertile window and ovulation, and a highlighted marker for today.
/// Drawn only from F3 output, so it always agrees with the calendar.
class CycleRing extends StatelessWidget {
  const CycleRing({
    super.key,
    required this.prediction,
    required this.periodLength,
    required this.today,
    this.child,
    this.size = 260,
  });

  final PredictionResult prediction;
  final int periodLength;
  final DateTime today;
  final Widget? child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              prediction: prediction,
              periodLength: periodLength,
              today: today,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.prediction,
    required this.periodLength,
    required this.today,
  });

  final PredictionResult prediction;
  final int periodLength;
  final DateTime today;

  static const _stroke = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // Leave room outside the arcs for the day numbers.
    final radius = size.width / 2 - 36;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final cycle = prediction.averageCycle <= 0 ? 28 : prediction.averageCycle;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.blushSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke,
    );

    final last = prediction.lastStart;
    if (last == null) return;

    double angleOf(int dayOffset) =>
        -math.pi / 2 + (dayOffset / cycle) * 2 * math.pi;
    double sweepFor(int days) => (days / cycle) * 2 * math.pi;

    void arc(int fromDay, int days, Color color) {
      canvas.drawArc(
        rect,
        angleOf(fromDay),
        sweepFor(days),
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..strokeCap = StrokeCap.butt,
      );
    }

    // Period of this cycle.
    arc(0, periodLength, AppColors.terracotta);

    // Fertile window.
    final fs = prediction.fertileStart;
    final fe = prediction.fertileEnd;
    if (fs != null && fe != null) {
      arc(daysBetween(last, fs), daysBetween(fs, fe) + 1, AppColors.gold);
    }

    // Ovulation marker, in the middle of its day.
    final ov = prediction.ovulation;
    if (ov != null) {
      final a = angleOf(daysBetween(last, ov)) + sweepFor(1) / 2;
      canvas.drawCircle(
        _pointOn(center, radius, a),
        6,
        Paint()..color = AppColors.sage,
      );
    }

    // Day numbers outside the ring. Every day for typical cycles; every
    // other day for long ones so they stay readable.
    final todayIndex = daysBetween(last, today);
    final todayOnRing = todayIndex >= 0 ? todayIndex % cycle : -1;
    final step = cycle > 31 ? 2 : 1;
    for (var i = 0; i < cycle; i++) {
      final isToday = i == todayOnRing;
      if (!isToday && i % step != 0) continue;
      final a = angleOf(i) + sweepFor(1) / 2;
      _paintLabel(
        canvas,
        _pointOn(center, radius + _stroke / 2 + 13, a),
        '${i + 1}',
        isToday
            ? const TextStyle(
                color: AppColors.terracotta,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              )
            : const TextStyle(color: AppColors.inkMuted, fontSize: 9),
      );
    }

    // Today: a white marker with a dark outline on the ring.
    if (todayOnRing >= 0) {
      final p = _pointOn(center, radius, angleOf(todayOnRing) + sweepFor(1) / 2);
      canvas.drawCircle(p, 10, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        10,
        Paint()
          ..color = AppColors.brown
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  static Offset _pointOn(Offset center, double r, double angle) => Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );

  static void _paintLabel(
    Canvas canvas,
    Offset at,
    String text,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(at.dx - tp.width / 2, at.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.prediction != prediction ||
      old.periodLength != periodLength ||
      !isSameDay(old.today, today);
}
