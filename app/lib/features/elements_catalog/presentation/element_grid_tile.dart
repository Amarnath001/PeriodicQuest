import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/elements/chemical_element.dart';

// ─── Element tile (grid cell) ─────────────────────────────────────────────────

class ElementGridTile extends StatelessWidget {
  final ChemicalElement elem;
  final double cardW;
  final VoidCallback onTap;

  const ElementGridTile({
    super.key,
    required this.elem,
    required this.cardW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = periodicCategoryColor(elem.cat);
    final border = Color.lerp(color, Colors.black, 0.18)!;
    final m = cardW * 0.042;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(m),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(cardW * 0.13),
          border: Border.all(color: border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: border.withValues(alpha: 0.38),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            cardW * 0.07,
            cardW * 0.06,
            cardW * 0.04,
            cardW * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${elem.z}',
                style: TextStyle(
                  fontSize: math.max(7.0, cardW * 0.155),
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.55),
                  height: 1.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    elem.sym,
                    style: TextStyle(
                      fontSize: math.max(14.0, cardW * 0.40),
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withValues(alpha: 0.80),
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  elem.name,
                  style: TextStyle(
                    fontSize: math.max(5.5, cardW * 0.115),
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Element detail dialog ────────────────────────────────────────────────────
