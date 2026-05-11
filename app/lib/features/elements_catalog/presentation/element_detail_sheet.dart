import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/elements/chemical_element.dart';

class ElementDetailSheet extends StatelessWidget {
  final ChemicalElement elem;
  final double screenW;
  const ElementDetailSheet({
    super.key,
    required this.elem,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    final color = periodicCategoryColor(elem.cat);
    final dw = math.min(screenW * 0.92, 440.0);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: dw,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(dw * 0.055),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Title row ────────────────────────────────────────────────
              Row(
                children: [
                  const Spacer(),
                  Text(
                    elem.name,
                    style: TextStyle(
                      fontSize: math.min(26.0, dw * 0.072),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A4A),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 17,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: dw * 0.042),
              // ── Card + info row ───────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini element card
                  Container(
                    width: dw * 0.28,
                    height: dw * 0.33,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Color.lerp(color, Colors.black, 0.18)!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.55),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${elem.z}',
                            style: TextStyle(
                              fontSize: dw * 0.036,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withValues(alpha: 0.6),
                              height: 1.0,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                elem.sym,
                                style: TextStyle(
                                  fontSize: dw * 0.120,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black.withValues(alpha: 0.82),
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              elem.name,
                              style: TextStyle(
                                fontSize: dw * 0.028,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withValues(alpha: 0.70),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(
                              '${elem.mass}',
                              style: TextStyle(
                                fontSize: dw * 0.026,
                                color: Colors.black.withValues(alpha: 0.60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: dw * 0.038),
                  // Info column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('Atomic Number:', '${elem.z}'),
                        SizedBox(height: dw * 0.02),
                        _infoRow('Atomic Weight:', '${elem.mass}'),
                        SizedBox(height: dw * 0.026),
                        Text(
                          elem.desc,
                          style: TextStyle(
                            fontSize: math.min(13.5, dw * 0.034),
                            color: const Color(0xFF333333),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: dw * 0.04),
              // ── Fun Fact ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(dw * 0.038),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFFE082),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fun Fact!',
                      style: TextStyle(
                        fontSize: math.min(14.0, dw * 0.036),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7A5800),
                      ),
                    ),
                    SizedBox(height: dw * 0.018),
                    Text(
                      elem.fact,
                      style: TextStyle(
                        fontSize: math.min(13.0, dw * 0.033),
                        color: const Color(0xFF5A4A00),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: dw * 0.036),
              // ── Action buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5A7A8A),
                        side: const BorderSide(color: Color(0xFFB8D4E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        '🔊 Audio en Español',
                        style: TextStyle(fontSize: math.min(12.0, dw * 0.030)),
                      ),
                    ),
                  ),
                  SizedBox(width: dw * 0.026),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5A7A8A),
                        side: const BorderSide(color: Color(0xFFB8D4E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        'Translate',
                        style: TextStyle(fontSize: math.min(12.0, dw * 0.030)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: dw * 0.026),
              // ── OK button ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8BE8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: dw * 0.036),
                    elevation: 3,
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: math.min(17.0, dw * 0.042),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: ' $value'),
        ],
      ),
    );
  }
}
