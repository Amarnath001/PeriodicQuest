import 'dart:math' as math;

import 'package:flutter/material.dart';

// ─── Icon painters ────────────────────────────────────────────────────────────

class BeakerIconPainter extends CustomPainter {
  const BeakerIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final body = Path()
      ..moveTo(w * 0.39, h * 0.14)
      ..lineTo(w * 0.36, h * 0.41)
      ..quadraticBezierTo(w * 0.24, h * 0.50, w * 0.14, h * 0.68)
      ..quadraticBezierTo(w * 0.13, h * 0.88, w * 0.50, h * 0.88)
      ..quadraticBezierTo(w * 0.87, h * 0.88, w * 0.86, h * 0.68)
      ..quadraticBezierTo(w * 0.76, h * 0.50, w * 0.64, h * 0.41)
      ..lineTo(w * 0.61, h * 0.14)
      ..close();

    final liquidMask = Path()..addRect(Rect.fromLTWH(0, h * 0.58, w, h));
    final deepMask = Path()..addRect(Rect.fromLTWH(0, h * 0.68, w, h));

    canvas.drawPath(body, Paint()..color = const Color(0xFFE0F2FF));
    canvas.drawPath(
      Path.combine(PathOperation.intersect, body, liquidMask),
      Paint()..color = const Color(0xFF90EEB0),
    );
    canvas.drawPath(
      Path.combine(PathOperation.intersect, body, deepMask),
      Paint()..color = const Color(0xFF4ACA70),
    );
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFF4A9EE0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawLine(
      Offset(w * 0.36, h * 0.14),
      Offset(w * 0.64, h * 0.14),
      Paint()
        ..color = const Color(0xFF4A9EE0)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(w * 0.38, h * 0.74),
      w * 0.042,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    canvas.drawCircle(
      Offset(w * 0.60, h * 0.80),
      w * 0.028,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class RobotIconPainter extends CustomPainter {
  const RobotIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(
      Offset(w * 0.5, h * 0.52),
      w * 0.36,
      Paint()..color = const Color(0xFF6CBAD8),
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.16),
      Offset(w * 0.5, h * 0.07),
      Paint()
        ..color = const Color(0xFF52A8C6)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.05),
      w * 0.032,
      Paint()..color = const Color(0xFF52A8C6),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.210,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.135,
      Paint()..color = const Color(0xFF4A90B8),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.075,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.455, h * 0.470),
      w * 0.028,
      Paint()..color = Colors.white,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.38, h * 0.69)
        ..quadraticBezierTo(w * 0.5, h * 0.78, w * 0.62, h * 0.69),
      Paint()
        ..color = const Color(0xFFFF7070)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class StarIconPainter extends CustomPainter {
  const StarIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final star = _star(Offset(w * 0.5, h * 0.44), w * 0.36, w * 0.15);
    canvas.drawPath(star, Paint()..color = const Color(0xFFFFD030));
    canvas.drawPath(
      star,
      Paint()
        ..color = const Color(0xFFDDAA00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(w * 0.405, h * 0.415),
      w * 0.036,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.595, h * 0.415),
      w * 0.036,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.325, h * 0.478),
      w * 0.050,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65),
    );
    canvas.drawCircle(
      Offset(w * 0.675, h * 0.478),
      w * 0.050,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.385, h * 0.495)
        ..quadraticBezierTo(w * 0.5, h * 0.572, w * 0.615, h * 0.495),
      Paint()
        ..color = const Color(0xFFCC8800)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Trophy cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.820),
          width: w * 0.28,
          height: h * 0.10,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFFD030),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.892),
          width: w * 0.36,
          height: h * 0.048,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFDDAA00),
    );
  }

  Path _star(Offset c, double outer, double inner) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = math.pi * i / 5 - math.pi / 2;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
