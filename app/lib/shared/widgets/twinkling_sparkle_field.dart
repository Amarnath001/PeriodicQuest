import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'sparkle_band.dart';
import 'sparkle_dot.dart';

/// Positions [SparkleBand] entries with a shared twinkle animation.
List<Widget> buildTwinklingSparkles({
  required AnimationController sparkleController,
  required List<SparkleBand> bands,
}) {
  return bands.map((s) {
    return Positioned(
      left: s.left,
      top: s.top,
      child: AnimatedBuilder(
        animation: sparkleController,
        builder: (_, _) {
          final t = (sparkleController.value + s.phase) % 1.0;
          final v = (math.sin(t * math.pi * 2) + 1) / 2;
          return Opacity(
            opacity: 0.25 + 0.75 * v,
            child: Transform.scale(
              scale: 0.5 + 0.5 * v,
              child: SparkleDot(size: s.size, color: Color(s.colorArgb)),
            ),
          );
        },
      ),
    );
  }).toList();
}
