import 'package:flutter/material.dart';

/// Static periodic-table entry used for exploration and detail views.
class ChemicalElement {
  final int z;
  final String sym;
  final String name;
  final String cat;
  final double mass;
  final String desc;
  final String fact;

  const ChemicalElement(
    this.z,
    this.sym,
    this.name,
    this.mass,
    this.cat,
    this.desc,
    this.fact,
  );
}

/// Tile background keyed by internal category string from [ChemicalElement.cat].
Color periodicCategoryColor(String cat) {
  switch (cat) {
    case 'alkali':
      return const Color(0xFFFFF176);
    case 'alkaline':
      return const Color(0xFFB8EEB8);
    case 'transition':
      return const Color(0xFFFFD4A0);
    case 'post':
      return const Color(0xFFAAD4F0);
    case 'metalloid':
      return const Color(0xFFA8E8D0);
    case 'nonmetal':
      return const Color(0xFFB8EEF4);
    case 'halogen':
      return const Color(0xFFA8DDB8);
    case 'noble':
      return const Color(0xFFD0C0F4);
    case 'lanthanide':
      return const Color(0xFFFFC0C8);
    case 'actinide':
      return const Color(0xFFF0B0D8);
    default:
      return const Color(0xFFDDDDDD);
  }
}
