import 'package:flutter/material.dart';

class AllElementsCategoryIcon extends CustomPainter {
  const AllElementsCategoryIcon();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void tile(Offset center, String label, Color bg, double rot) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rot);
      final s = w * 0.28;
      final rr = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: s, height: s),
        Radius.circular(s * 0.18),
      );
      canvas.drawRRect(rr, Paint()..color = bg);
      canvas.drawRRect(
        rr,
        Paint()
          ..color = bg.withValues(alpha: 0)
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: s * 0.42,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    tile(Offset(w * 0.28, h * 0.58), 'H', const Color(0xFFF5C030), -0.12);
    tile(Offset(w * 0.55, h * 0.70), 'O', const Color(0xFF9C7BD4), 0.10);
    tile(Offset(w * 0.72, h * 0.48), 'N', const Color(0xFF5BBD70), -0.08);
    tile(Offset(w * 0.50, h * 0.30), 'Au', const Color(0xFFE8A030), 0.15);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class MetalsCategoryIcon extends CustomPainter {
  const MetalsCategoryIcon();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Chest body
    final bodyPaint = Paint()..color = const Color(0xFFB87040);
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.42, w * 0.76, h * 0.46),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Chest lid (curved top)
    final lidPath = Path()
      ..moveTo(w * 0.12, h * 0.44)
      ..lineTo(w * 0.12, h * 0.30)
      ..quadraticBezierTo(w * 0.50, h * 0.10, w * 0.88, h * 0.30)
      ..lineTo(w * 0.88, h * 0.44)
      ..close();
    canvas.drawPath(lidPath, bodyPaint);

    // Lid band
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.40, w * 0.76, h * 0.07),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF8B5020),
    );

    // Golden latch
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.445),
      w * 0.07,
      Paint()..color = const Color(0xFFFFD030),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.445),
      w * 0.04,
      Paint()..color = const Color(0xFFCC8800),
    );

    // Coins spilling out
    final coinPaint = Paint()..color = const Color(0xFFFFD030);
    for (final c in [
      Offset(w * 0.30, h * 0.28),
      Offset(w * 0.50, h * 0.22),
      Offset(w * 0.68, h * 0.28),
      Offset(w * 0.40, h * 0.18),
      Offset(w * 0.60, h * 0.20),
    ]) {
      canvas.drawCircle(c, w * 0.075, coinPaint);
      canvas.drawCircle(
        c,
        w * 0.075,
        Paint()
          ..color = const Color(0xFFCC8800)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class NonmetalsCategoryIcon extends CustomPainter {
  const NonmetalsCategoryIcon();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void tube(
      double cx,
      double cy,
      double tw,
      double th,
      double r,
      Color fill,
      Color liquid,
    ) {
      final body = Path()
        ..moveTo(cx - tw / 2, cy - th / 2)
        ..lineTo(cx - tw / 2, cy + th / 2 - r)
        ..quadraticBezierTo(cx - tw / 2, cy + th / 2, cx, cy + th / 2)
        ..quadraticBezierTo(
          cx + tw / 2,
          cy + th / 2,
          cx + tw / 2,
          cy + th / 2 - r,
        )
        ..lineTo(cx + tw / 2, cy - th / 2)
        ..close();
      // Handle at top
      final handle = Path()
        ..moveTo(cx - tw * 0.7, cy - th / 2)
        ..lineTo(cx - tw * 0.7, cy - th / 2 - th * 0.10)
        ..lineTo(cx + tw * 0.7, cy - th / 2 - th * 0.10)
        ..lineTo(cx + tw * 0.7, cy - th / 2);

      final liquidMask = Path()
        ..addRect(Rect.fromLTWH(0, cy + th * 0.05, w, h));
      canvas.drawPath(body, Paint()..color = fill);
      canvas.drawPath(
        Path.combine(PathOperation.intersect, body, liquidMask),
        Paint()..color = liquid,
      );
      canvas.drawPath(
        body,
        Paint()
          ..color = const Color(0xFF5090B8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        handle,
        Paint()
          ..color = const Color(0xFF5090B8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    tube(
      w * 0.35,
      h * 0.55,
      w * 0.25,
      h * 0.55,
      w * 0.12,
      const Color(0xFFE0F4FF),
      const Color(0xFF70C8E0),
    );
    tube(
      w * 0.65,
      h * 0.52,
      w * 0.22,
      h * 0.50,
      w * 0.11,
      const Color(0xFFE8F8FF),
      const Color(0xFF90D8E8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class NobleGasesCategoryIcon extends CustomPainter {
  const NobleGasesCategoryIcon();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main circle face
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.52),
      w * 0.36,
      Paint()..color = const Color(0xFFAA88E8),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.52),
      w * 0.36,
      Paint()
        ..color = const Color(0xFF8860CC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Sheen
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.34),
        width: w * 0.18,
        height: h * 0.09,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // Eyes (dots)
    canvas.drawCircle(
      Offset(w * 0.385, h * 0.485),
      w * 0.048,
      Paint()..color = const Color(0xFF2A1A4A),
    );
    canvas.drawCircle(
      Offset(w * 0.615, h * 0.485),
      w * 0.048,
      Paint()..color = const Color(0xFF2A1A4A),
    );

    // Eye highlights
    canvas.drawCircle(
      Offset(w * 0.372, h * 0.472),
      w * 0.016,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.602, h * 0.472),
      w * 0.016,
      Paint()..color = Colors.white,
    );

    // Rosy cheeks
    canvas.drawCircle(
      Offset(w * 0.29, h * 0.56),
      w * 0.06,
      Paint()..color = const Color(0xFFFFB0D8).withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      Offset(w * 0.71, h * 0.56),
      w * 0.06,
      Paint()..color = const Color(0xFFFFB0D8).withValues(alpha: 0.6),
    );

    // Smile
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.37, h * 0.60)
        ..quadraticBezierTo(w * 0.50, h * 0.68, w * 0.63, h * 0.60),
      Paint()
        ..color = const Color(0xFF2A1A4A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Small atom rings
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.12),
        width: w * 0.28,
        height: h * 0.12,
      ),
      Paint()
        ..color = const Color(0xFF8860CC).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.12),
        width: w * 0.14,
        height: h * 0.22,
      ),
      Paint()
        ..color = const Color(0xFF8860CC).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
