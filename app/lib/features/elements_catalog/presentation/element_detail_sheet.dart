import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/audio/element_audio_service.dart';
import '../../../domain/elements/chemical_element.dart';

class ElementDetailSheet extends StatefulWidget {
  final ChemicalElement elem;
  final double screenW;

  const ElementDetailSheet({
    super.key,
    required this.elem,
    required this.screenW,
  });

  @override
  State<ElementDetailSheet> createState() => _ElementDetailSheetState();
}

class _ElementDetailSheetState extends State<ElementDetailSheet> {
  final _audio = ElementAudioService.instance;

  @override
  void initState() {
    super.initState();
    // Auto-play narration when the modal opens.
    // Runs after the first frame so the dialog animation has begun.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _audio.speakElement(widget.elem);
    });
  }

  @override
  void dispose() {
    // Stop audio if the user dismisses before narration finishes.
    _audio.stop();
    super.dispose();
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final color = periodicCategoryColor(widget.elem.cat);
    final dw = math.min(widget.screenW * 0.92, 440.0);

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
              // ── Title row ─────────────────────────────────────────────────
              Row(
                children: [
                  const Spacer(),
                  Text(
                    widget.elem.name,
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
                  _ElementMiniCard(elem: widget.elem, color: color, dw: dw),
                  SizedBox(width: dw * 0.038),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('Atomic Number:', '${widget.elem.z}'),
                        SizedBox(height: dw * 0.02),
                        _infoRow('Atomic Weight:', '${widget.elem.mass}'),
                        SizedBox(height: dw * 0.026),
                        Text(
                          widget.elem.desc,
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
              // ── Fun Fact ──────────────────────────────────────────────────
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
                      widget.elem.fact,
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
                    child: _AudioReplayButton(
                      elem: widget.elem,
                      audio: _audio,
                      dw: dw,
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

// ─── Audio replay button ──────────────────────────────────────────────────────
//
// Listens to ElementAudioService.isPlaying via ValueListenableBuilder so it
// updates reactively without requiring setState in the parent.

class _AudioReplayButton extends StatelessWidget {
  final ChemicalElement elem;
  final ElementAudioService audio;
  final double dw;

  const _AudioReplayButton({
    required this.elem,
    required this.audio,
    required this.dw,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: audio.isPlaying,
      builder: (context, playing, _) {
        return OutlinedButton(
          onPressed: playing ? null : () => audio.speakElement(elem),
          style: OutlinedButton.styleFrom(
            foregroundColor: playing
                ? const Color(0xFF3A7A5A)
                : const Color(0xFF5A7A8A),
            side: BorderSide(
              color: playing
                  ? const Color(0xFF88D4B0)
                  : const Color(0xFFB8D4E8),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (playing) _PulsingDot() else const Text('🔊'),
              const SizedBox(width: 4),
              Text(
                playing ? 'Playing…' : 'Play Audio',
                style: TextStyle(fontSize: math.min(12.0, dw * 0.030)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Subtle pulsing dot shown while audio plays ───────────────────────────────

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF3A7A5A),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─── Mini element card (extracted to keep build() readable) ──────────────────

class _ElementMiniCard extends StatelessWidget {
  final ChemicalElement elem;
  final Color color;
  final double dw;

  const _ElementMiniCard({
    required this.elem,
    required this.color,
    required this.dw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
