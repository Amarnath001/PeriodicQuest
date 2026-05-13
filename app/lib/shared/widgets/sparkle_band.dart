import 'package:flutter/material.dart';

/// One positioned sparkle in an ambient twinkle layer.
@immutable
class SparkleBand {
  final double left;
  final double top;
  final double size;
  final int colorArgb;
  final double phase;

  const SparkleBand({
    required this.left,
    required this.top,
    required this.size,
    required this.colorArgb,
    required this.phase,
  });
}
