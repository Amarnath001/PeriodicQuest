import 'dart:math' as math;

import 'package:flutter/material.dart';

class KawaiiStarPainter extends CustomPainter {
  const KawaiiStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    final cx = w * 0.5;
    final cy = h * 0.5;
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? w * 0.46 : w * 0.20;
      final a = math.pi * i / 5 - math.pi / 2;
      final p = Offset(cx + r * math.cos(a), cy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD030));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFCC9900)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(cx - w * 0.12, cy - h * 0.06),
      w * 0.065,
      Paint()..color = const Color(0xFF1A1A2A),
    );
    canvas.drawCircle(
      Offset(cx + w * 0.12, cy - h * 0.06),
      w * 0.065,
      Paint()..color = const Color(0xFF1A1A2A),
    );
    canvas.drawCircle(
      Offset(cx - w * 0.22, cy + h * 0.06),
      w * 0.07,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      Offset(cx + w * 0.22, cy + h * 0.06),
      w * 0.07,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.6),
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.10, cy + h * 0.10)
        ..quadraticBezierTo(cx, cy + h * 0.20, cx + w * 0.10, cy + h * 0.10),
      Paint()
        ..color = const Color(0xFFCC8800)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
