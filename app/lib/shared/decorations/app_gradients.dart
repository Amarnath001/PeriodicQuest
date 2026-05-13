import 'package:flutter/material.dart';

/// Gradients reused across full-screen skies.
abstract final class AppGradients {
  static const skyBlue = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF9EDBF8), Color(0xFFBFEAFF), Color(0xFFDDF3FF)],
    stops: [0.0, 0.5, 1.0],
  );

  /// Explore shell and full periodic table grid share the same lavender field.
  static const explorePurple = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC8B8F8), Color(0xFFDDD0FF), Color(0xFFF0E8FF)],
    stops: [0.0, 0.5, 1.0],
  );
}
