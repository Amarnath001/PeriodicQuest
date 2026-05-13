import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Small four-point sparkle drawn for ambient decoration.
class SparkleDot extends StatelessWidget {
  final double size;
  final Color color;

  const SparkleDot({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: SparklePainter(color)),
  );
}

class SparklePainter extends CustomPainter {
  final Color color;

  const SparklePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final outer = size.width / 2, inner = size.width / 9;
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final oa = math.pi * i / 2 - math.pi / 2;
      final ia = oa + math.pi / 4;
      if (i == 0) {
        path.moveTo(cx + outer * math.cos(oa), cy + outer * math.sin(oa));
      } else {
        path.lineTo(cx + outer * math.cos(oa), cy + outer * math.sin(oa));
      }
      path.lineTo(cx + inner * math.cos(ia), cy + inner * math.sin(ia));
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
