import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Horizontally drifting decorative cloud blob.
class AnimatedCloud extends StatelessWidget {
  final AnimationController cloudController;
  final double size;
  final double baseLeft;
  final double top;
  final double phase;
  final double amp;
  final double opacity;

  const AnimatedCloud({
    super.key,
    required this.cloudController,
    required this.size,
    required this.baseLeft,
    required this.top,
    required this.phase,
    required this.amp,
    this.opacity = 0.22,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: baseLeft,
      top: top,
      child: AnimatedBuilder(
        animation: cloudController,
        builder: (_, child) {
          final dx =
              math.sin((cloudController.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.38),
            color: Colors.white.withValues(alpha: opacity),
          ),
        ),
      ),
    );
  }
}
