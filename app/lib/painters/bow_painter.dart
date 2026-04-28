import 'package:flutter/material.dart';

class BowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFFC9A84C).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final bowPath = Path();
    bowPath.moveTo(size.width * 0.3, size.height * 0.1);
    bowPath.cubicTo(
      size.width * 0.05, size.height * 0.35,
      size.width * 0.05, size.height * 0.65,
      size.width * 0.3, size.height * 0.9,
    );
    canvas.drawPath(bowPath, strokePaint);

    final stringPaint = Paint()
      ..color = const Color(0xFFC9A84C).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.9),
      stringPaint,
    );

    final arrowPaint = Paint()
      ..color = const Color(0xFFC9A84C).withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.5),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(BowPainter _) => false;
}
