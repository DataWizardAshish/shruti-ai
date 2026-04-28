import 'dart:math';
import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.46;
    final innerRadius = size.width * 0.36;
    final hubRadius = size.width * 0.06;

    paint.strokeWidth = 1.0;
    canvas.drawCircle(center, outerRadius, paint);
    paint.strokeWidth = 0.5;
    canvas.drawCircle(center, outerRadius * 0.92, paint);

    paint.strokeWidth = 1.0;
    canvas.drawCircle(center, innerRadius, paint);

    paint.strokeWidth = 1.5;
    canvas.drawCircle(center, hubRadius, paint);

    paint.strokeWidth = 0.8;
    for (int i = 0; i < 16; i++) {
      final angle = (i * 2 * pi) / 16;
      canvas.drawLine(
        Offset(
          center.dx + hubRadius * cos(angle),
          center.dy + hubRadius * sin(angle),
        ),
        Offset(
          center.dx + innerRadius * cos(angle),
          center.dy + innerRadius * sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WheelPainter _) => false;
}
