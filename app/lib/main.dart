import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const PeriodicQuestApp());

class PeriodicQuestApp extends StatelessWidget {
  const PeriodicQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Periodic Quest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

// ─── Landing Page ─────────────────────────────────────────────────────────────

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late final AnimationController _cloudCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _sparkleCtrl;
  late final AnimationController _btnCtrl;

  @override
  void initState() {
    super.initState();
    _cloudCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
  }

  @override
  void dispose() {
    _cloudCtrl.dispose();
    _floatCtrl.dispose();
    _sparkleCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9EDBF8), Color(0xFFBFEAFF), Color(0xFFDDF3FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(child: LayoutBuilder(builder: _buildLayout)),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final sw = bc.maxWidth; // full screen width — clouds/sparkles use this
    final h = bc.maxHeight;
    final w = math.min(sw, 860.0); // content width cap
    final lh = math.min(h, w * 1.85);
    final cardSz = math.min(w * 0.22, 110.0);

    return Stack(
      children: [
        // ── Moving cloud blobs ────────────────────────────────────────────
        _cloud(
          size: sw * 0.9,
          baseLeft: -sw * 0.22,
          top: h * 0.04,
          phase: 0.00,
          amp: sw * 0.05,
        ),
        _cloud(
          size: sw * 0.70,
          baseLeft: sw * 0.43,
          top: h * 0.22,
          phase: 0.50,
          amp: sw * 0.04,
        ),
        _cloud(
          size: sw * 0.58,
          baseLeft: -sw * 0.06,
          top: h * 0.62,
          phase: 0.25,
          amp: sw * 0.03,
        ),

        // ── Twinkling sparkles ─────────────────────────────────────────────
        ..._sparkles(sw, h),

        // ── Main content centred, capped at w ─────────────────────────────
        Center(
          child: SizedBox(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: lh * 0.030),
                _OutlinedTitle(fontSize: math.min(52.0, w * 0.11)),
                SizedBox(height: lh * 0.008),
                Text(
                  'Learn Chemistry the Fun Way!',
                  style: TextStyle(
                    fontSize: math.min(18.0, w * 0.039),
                    color: const Color(0xFF3D6B80),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: lh * 0.012),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      _robot(w, lh),
                      _card(
                        w: w,
                        h: lh,
                        sz: cardSz,
                        left: true,
                        top: false,
                        num: 7,
                        sym: 'N',
                        name: 'Nitrogen',
                        color: const Color(0xFF5BBD70),
                        angle: -0.10,
                        phase: 0.50,
                      ),
                      _card(
                        w: w,
                        h: lh,
                        sz: cardSz,
                        left: false,
                        top: false,
                        num: 2,
                        sym: 'He',
                        name: 'Helium',
                        color: const Color(0xFF8B6EC7),
                        angle: 0.10,
                        phase: 0.75,
                      ),
                      _card(
                        w: w,
                        h: lh,
                        sz: cardSz,
                        left: true,
                        top: true,
                        num: 1,
                        sym: 'H',
                        name: 'Hydrogen',
                        color: const Color(0xFFF5C030),
                        angle: -0.12,
                        phase: 0.00,
                      ),
                      _card(
                        w: w,
                        h: lh,
                        sz: cardSz,
                        left: false,
                        top: true,
                        num: 8,
                        sym: 'O',
                        name: 'Oxygen',
                        color: const Color(0xFF9C7BD4),
                        angle: 0.12,
                        phase: 0.25,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    w * 0.10,
                    0,
                    w * 0.10,
                    lh * 0.032,
                  ),
                  child: _startButton(context, w, lh),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Cloud blob ─────────────────────────────────────────────────────────────

  Widget _cloud({
    required double size,
    required double baseLeft,
    required double top,
    required double phase,
    required double amp,
  }) {
    return Positioned(
      left: baseLeft,
      top: top,
      child: AnimatedBuilder(
        animation: _cloudCtrl,
        builder: (_, child) {
          final dx = math.sin((_cloudCtrl.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.38),
            color: Colors.white.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }

  // ── Sparkles ───────────────────────────────────────────────────────────────

  List<Widget> _sparkles(double w, double h) {
    // [left, top, size, colorARGB, phase]
    final specs = <List<dynamic>>[
      [w * 0.04, h * 0.038, 20.0, 0xFFFFFFFF, 0.00],
      [w * 0.93, h * 0.068, 15.0, 0xFFFFE082, 0.10],
      [w * 0.29, h * 0.018, 11.0, 0xCCFFFFFF, 0.20],
      [w * 0.66, h * 0.013, 9.0, 0xFFFFE082, 0.30],
      [w * 0.07, h * 0.710, 24.0, 0xFFFFE082, 0.40],
      [w * 0.92, h * 0.730, 18.0, 0xFFFFFFFF, 0.50],
      [w * 0.44, h * 0.730, 11.0, 0xFFFFE082, 0.60],
      [w * 0.56, h * 0.690, 10.0, 0xCCFFFFFF, 0.70],
      [w * 0.02, h * 0.440, 11.0, 0xFFFFE082, 0.80],
      [w * 0.97, h * 0.490, 13.0, 0xCCFFFFFF, 0.90],
    ];

    return specs.map((s) {
      return Positioned(
        left: s[0] as double,
        top: s[1] as double,
        child: AnimatedBuilder(
          animation: _sparkleCtrl,
          builder: (_, ignored) {
            final t = (_sparkleCtrl.value + (s[4] as double)) % 1.0;
            final v = (math.sin(t * math.pi * 2) + 1) / 2;
            return Opacity(
              opacity: 0.25 + 0.75 * v,
              child: Transform.scale(
                scale: 0.5 + 0.5 * v,
                child: _Sparkle(
                  size: s[2] as double,
                  color: Color(s[3] as int),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  // ── Floating element card ──────────────────────────────────────────────────

  Widget _card({
    required double w,
    required double h,
    required double sz,
    required bool left,
    required bool top,
    required int num,
    required String sym,
    required String name,
    required Color color,
    required double angle,
    required double phase,
  }) {
    return Positioned(
      left: left ? (top ? w * 0.015 : -w * 0.12) : null,
      right: left ? null : (top ? w * 0.015 : -w * 0.12),

      // Lower the top value so they sit near the robot's hands/sides
      top: top ? h * 0.010 : h * 0.420,
      child: AnimatedBuilder(
        animation: _floatCtrl,
        builder: (_, child) {
          final dy = -7.0 * math.sin((_floatCtrl.value + phase) * math.pi * 2);
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: Transform.rotate(
          angle: angle,
          child: _ElementCard(
            atomicNumber: num,
            symbol: sym,
            name: name,
            color: color,
            size: sz,
          ),
        ),
      ),
    );
  }

  // ── Floating robot ─────────────────────────────────────────────────────────

  Widget _robot(double w, double h) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, child) {
        final dy = -10.0 * math.sin(_floatCtrl.value * math.pi * 2);
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: SizedBox(
        width: w * 0.60,
        height: h * 0.63,
        child: const CustomPaint(painter: _RobotPainter()),
      ),
    );
  }

  // ── Start button with press animation ─────────────────────────────────────

  Widget _startButton(BuildContext context, double w, double h) {
    final clampedH = (h * 0.082).clamp(48.0, 70.0);
    return GestureDetector(
      onTapDown: (_) => _btnCtrl.forward(),
      onTapUp: (_) => _btnCtrl.reverse(),
      onTapCancel: () => _btnCtrl.reverse(),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ignored1, ignored2, ignored3) => const GameModePage(),
          transitionsBuilder: (ignored, anim, ignoredSec, child) =>
              SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                    ),
                child: child,
              ),
          transitionDuration: const Duration(milliseconds: 320),
        ),
      ),
      child: AnimatedBuilder(
        animation: _btnCtrl,
        builder: (_, child) =>
            Transform.scale(scale: 1 - 0.04 * _btnCtrl.value, child: child),
        child: Container(
          width: double.infinity,
          height: clampedH,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFDD55), Color(0xFFFFAA1A)],
            ),
            borderRadius: BorderRadius.circular(clampedH / 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFCC7700),
                blurRadius: 0,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Color(0x55FF9900),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'START GAME',
            style: TextStyle(
              fontSize: math.min(18.0, w * 0.048),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF7A4800),
              letterSpacing: 3.0,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Outlined title ───────────────────────────────────────────────────────────

class _OutlinedTitle extends StatelessWidget {
  final double fontSize;
  const _OutlinedTitle({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    const text = 'Periodic Quest';
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 9
              ..strokeJoin = StrokeJoin.round
              ..color = const Color(0xFFFFD080),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..strokeJoin = StrokeJoin.round
              ..color = const Color(0xFFCC8820),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF8B5E1A),
          ),
        ),
      ],
    );
  }
}

// ─── 4-pointed sparkle ────────────────────────────────────────────────────────

class _Sparkle extends StatelessWidget {
  final double size;
  final Color color;
  const _Sparkle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _SparklePainter(color)),
  );
}

class _SparklePainter extends CustomPainter {
  final Color color;
  const _SparklePainter(this.color);

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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Element card ─────────────────────────────────────────────────────────────

class _ElementCard extends StatelessWidget {
  final int atomicNumber;
  final String symbol;
  final String name;
  final Color color;
  final double size;

  const _ElementCard({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final w = size;
    final h = size * 1.10;
    final light = Color.lerp(color, Colors.white, 0.28)!;
    final dark = Color.lerp(color, Colors.black, 0.18)!;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, color, dark],
          stops: const [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.circular(w * 0.14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 2,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gloss sheen at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: h * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(w * 0.14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              w * 0.10,
              w * 0.07,
              w * 0.07,
              w * 0.08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$atomicNumber',
                  style: TextStyle(
                    fontSize: w * 0.14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      symbol,
                      style: TextStyle(
                        fontSize: w * 0.44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: w * 0.115,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Robot mascot (CustomPainter) ─────────────────────────────────────────────

class _RobotPainter extends CustomPainter {
  const _RobotPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const cLight = Color(0xFF8DCDE8);
    const cMid = Color(0xFF6CBAD8);
    const cDark = Color(0xFF52A8C6);

    // ── Ground shadow ──────────────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.945),
        width: w * 0.52,
        height: h * 0.04,
      ),
      Paint()
        ..color = const Color(0x33207090)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // ── Legs ──────────────────────────────────────────────────────────────
    _rr(
      canvas,
      Rect.fromCenter(
        center: Offset(w * 0.345, h * 0.895),
        width: w * 0.185,
        height: h * 0.135,
      ),
      w * 0.092,
      Paint()..color = cDark,
    );
    _rr(
      canvas,
      Rect.fromCenter(
        center: Offset(w * 0.655, h * 0.895),
        width: w * 0.185,
        height: h * 0.135,
      ),
      w * 0.092,
      Paint()..color = cDark,
    );

    // Leg highlight strip
    _rr(
      canvas,
      Rect.fromCenter(
        center: Offset(w * 0.345, h * 0.875),
        width: w * 0.08,
        height: h * 0.03,
      ),
      w * 0.015,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );
    _rr(
      canvas,
      Rect.fromCenter(
        center: Offset(w * 0.655, h * 0.875),
        width: w * 0.08,
        height: h * 0.03,
      ),
      w * 0.015,
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // ── Arms ──────────────────────────────────────────────────────────────
    _rotRR(
      canvas,
      Offset(w * 0.075, h * 0.565),
      w * 0.13,
      h * 0.225,
      w * 0.065,
      -0.30,
      Paint()..color = cMid,
    );
    _rotRR(
      canvas,
      Offset(w * 0.925, h * 0.565),
      w * 0.13,
      h * 0.225,
      w * 0.065,
      0.30,
      Paint()..color = cMid,
    );

    // ── Body ──────────────────────────────────────────────────────────────
    final bodyRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.515),
      width: w * 0.72,
      height: h * 0.61,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.30)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cLight, cMid, cDark],
          stops: [0.0, 0.45, 1.0],
        ).createShader(bodyRect),
    );

    // Body gloss sheen
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.245),
        width: w * 0.24,
        height: h * 0.09,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.38),
    );

    // ── Antenna ───────────────────────────────────────────────────────────
    canvas.drawLine(
      Offset(w * 0.5, h * 0.205),
      Offset(w * 0.5, h * 0.075),
      Paint()
        ..color = cDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.024
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.050),
      w * 0.044,
      Paint()..color = cDark,
    );
    canvas.drawCircle(
      Offset(w * 0.488, h * 0.042),
      w * 0.016,
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );

    // ── Eye sclera ────────────────────────────────────────────────────────
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.385),
      w * 0.247,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.385),
      w * 0.247,
      Paint()
        ..color = const Color(0xFFBBDEEF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Iris
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.385),
      w * 0.160,
      Paint()..color = const Color(0xFF4A90B8),
    );

    // Pupil
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.385),
      w * 0.093,
      Paint()..color = const Color(0xFF1A3545),
    );

    // Highlights
    canvas.drawCircle(
      Offset(w * 0.454, h * 0.366),
      w * 0.037,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.553, h * 0.416),
      w * 0.019,
      Paint()..color = Colors.white,
    );

    // ── Mouth ─────────────────────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.420, h * 0.556)
        ..quadraticBezierTo(w * 0.500, h * 0.584, w * 0.580, h * 0.556),
      Paint()
        ..color = const Color(0xFFFF7070)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.027
        ..strokeCap = StrokeCap.round,
    );
  }

  void _rr(Canvas canvas, Rect rect, double r, Paint paint) => canvas.drawRRect(
    RRect.fromRectAndRadius(rect, Radius.circular(r)),
    paint,
  );

  void _rotRR(
    Canvas canvas,
    Offset c,
    double bw,
    double bh,
    double r,
    double angle,
    Paint paint,
  ) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    _rr(
      canvas,
      Rect.fromCenter(center: Offset.zero, width: bw, height: bh),
      r,
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Game Mode Page ───────────────────────────────────────────────────────────

class GameModePage extends StatefulWidget {
  const GameModePage({super.key});

  @override
  State<GameModePage> createState() => _GameModePageState();
}

class _GameModePageState extends State<GameModePage>
    with TickerProviderStateMixin {
  late final AnimationController _sparkleCtrl;
  late final AnimationController _cloudCtrl;

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _cloudCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _sparkleCtrl.dispose();
    _cloudCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9EDBF8), Color(0xFFBFEAFF), Color(0xFFDDF3FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(child: LayoutBuilder(builder: _buildLayout)),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final sw = bc.maxWidth;
    final h = bc.maxHeight;
    final w = math.min(sw, 900.0);
    final lh = math.min(h, w * 1.85);

    return Stack(
      children: [
        _cloud(
          size: sw * 0.9,
          baseLeft: -sw * 0.22,
          top: h * 0.05,
          phase: 0.00,
          amp: sw * 0.05,
        ),
        _cloud(
          size: sw * 0.70,
          baseLeft: sw * 0.43,
          top: h * 0.60,
          phase: 0.50,
          amp: sw * 0.04,
        ),
        ..._sparkles(sw, h),
        Center(
          child: SizedBox(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: lh * 0.025),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.04),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: math.max(12.0, w * 0.033),
                        vertical: math.max(7.0, w * 0.015),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: math.min(15.0, w * 0.034),
                            color: const Color(0xFF3D6B80),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: const Color(0xFF3D6B80),
                              fontWeight: FontWeight.w700,
                              fontSize: math.min(16.0, w * 0.037),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: lh * 0.030),
                Center(
                  child: Text(
                    'Choose Your Game',
                    style: TextStyle(
                      fontSize: math.min(36.0, w * 0.079),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A3A5C),
                    ),
                  ),
                ),
                SizedBox(height: lh * 0.007),
                Center(
                  child: Text(
                    'Pick a fun way to learn chemistry',
                    style: TextStyle(
                      fontSize: math.min(17.0, w * 0.036),
                      color: const Color(0xFF5A7A8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: lh * 0.04),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    children: [
                      _ModeCard(
                        bg: const Color(0xFFB8D4F8),
                        border: const Color(0xFF7AB0E0),
                        iconBg: const Color(0xFFD8ECFF),
                        iconPainter: const _BeakerIconPainter(),
                        title: 'Explore Mode',
                        subtitle: 'Tap elements and learn',
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (ig1, ig2, ig3) => const ExplorePage(),
                            transitionsBuilder: (ig, anim, igs, child) =>
                                SlideTransition(
                                  position:
                                      Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                  child: child,
                                ),
                            transitionDuration: const Duration(
                              milliseconds: 320,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: lh * 0.025),
                      const _ModeCard(
                        bg: Color(0xFFFFD04A),
                        border: Color(0xFFDDA800),
                        iconBg: Color(0xFFFFEA90),
                        iconPainter: _RobotIconPainter(),
                        title: 'Quiz Mode',
                        subtitle: 'Answer fun questions',
                      ),
                      SizedBox(height: lh * 0.025),
                      const _ModeCard(
                        bg: Color(0xFFCCAEF5),
                        border: Color(0xFF9B72D8),
                        iconBg: Color(0xFFE8D5FF),
                        iconPainter: _StarIconPainter(),
                        title: 'Adventure Mode',
                        subtitle: 'Earn stars and unlock levels',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cloud({
    required double size,
    required double baseLeft,
    required double top,
    required double phase,
    required double amp,
  }) {
    return Positioned(
      left: baseLeft,
      top: top,
      child: AnimatedBuilder(
        animation: _cloudCtrl,
        builder: (_, child) {
          final dx = math.sin((_cloudCtrl.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.38),
            color: Colors.white.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }

  List<Widget> _sparkles(double w, double h) {
    final specs = <List<dynamic>>[
      [w * 0.04, h * 0.040, 16.0, 0xFFFFFFFF, 0.00],
      [w * 0.93, h * 0.080, 12.0, 0xFFFFE082, 0.15],
      [w * 0.07, h * 0.300, 10.0, 0xFFFFE082, 0.30],
      [w * 0.95, h * 0.350, 10.0, 0xCCFFFFFF, 0.45],
      [w * 0.05, h * 0.650, 18.0, 0xFFFFE082, 0.60],
      [w * 0.93, h * 0.700, 14.0, 0xFFFFFFFF, 0.75],
    ];
    return specs.map((s) {
      return Positioned(
        left: s[0] as double,
        top: s[1] as double,
        child: AnimatedBuilder(
          animation: _sparkleCtrl,
          builder: (_, ignored) {
            final t = (_sparkleCtrl.value + (s[4] as double)) % 1.0;
            final v = (math.sin(t * math.pi * 2) + 1) / 2;
            return Opacity(
              opacity: 0.25 + 0.75 * v,
              child: Transform.scale(
                scale: 0.5 + 0.5 * v,
                child: _Sparkle(
                  size: s[2] as double,
                  color: Color(s[3] as int),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ─── Mode card ────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final Color bg;
  final Color border;
  final Color iconBg;
  final CustomPainter iconPainter;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ModeCard({
    required this.bg,
    required this.border,
    required this.iconBg,
    required this.iconPainter,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cw = constraints.maxWidth;
        final iconSz = math.min(74.0, cw * 0.20);
        final pad = math.max(10.0, cw * 0.038);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: border.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: iconSz,
                  height: iconSz,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBg,
                  ),
                  child: CustomPaint(painter: iconPainter),
                ),
                SizedBox(width: math.max(10.0, cw * 0.04)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: math.min(21.0, cw * 0.056),
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A3A5C),
                        ),
                      ),
                      SizedBox(height: math.max(3.0, cw * 0.012)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: math.min(13.0, cw * 0.035),
                          color: const Color(0xFF3A5A70),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Icon painters ────────────────────────────────────────────────────────────

class _BeakerIconPainter extends CustomPainter {
  const _BeakerIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final body = Path()
      ..moveTo(w * 0.39, h * 0.14)
      ..lineTo(w * 0.36, h * 0.41)
      ..quadraticBezierTo(w * 0.24, h * 0.50, w * 0.14, h * 0.68)
      ..quadraticBezierTo(w * 0.13, h * 0.88, w * 0.50, h * 0.88)
      ..quadraticBezierTo(w * 0.87, h * 0.88, w * 0.86, h * 0.68)
      ..quadraticBezierTo(w * 0.76, h * 0.50, w * 0.64, h * 0.41)
      ..lineTo(w * 0.61, h * 0.14)
      ..close();

    final liquidMask = Path()..addRect(Rect.fromLTWH(0, h * 0.58, w, h));
    final deepMask = Path()..addRect(Rect.fromLTWH(0, h * 0.68, w, h));

    canvas.drawPath(body, Paint()..color = const Color(0xFFE0F2FF));
    canvas.drawPath(
      Path.combine(PathOperation.intersect, body, liquidMask),
      Paint()..color = const Color(0xFF90EEB0),
    );
    canvas.drawPath(
      Path.combine(PathOperation.intersect, body, deepMask),
      Paint()..color = const Color(0xFF4ACA70),
    );
    canvas.drawPath(
      body,
      Paint()
        ..color = const Color(0xFF4A9EE0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawLine(
      Offset(w * 0.36, h * 0.14),
      Offset(w * 0.64, h * 0.14),
      Paint()
        ..color = const Color(0xFF4A9EE0)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(w * 0.38, h * 0.74),
      w * 0.042,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    canvas.drawCircle(
      Offset(w * 0.60, h * 0.80),
      w * 0.028,
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _RobotIconPainter extends CustomPainter {
  const _RobotIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(
      Offset(w * 0.5, h * 0.52),
      w * 0.36,
      Paint()..color = const Color(0xFF6CBAD8),
    );
    canvas.drawLine(
      Offset(w * 0.5, h * 0.16),
      Offset(w * 0.5, h * 0.07),
      Paint()
        ..color = const Color(0xFF52A8C6)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.05),
      w * 0.032,
      Paint()..color = const Color(0xFF52A8C6),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.210,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.135,
      Paint()..color = const Color(0xFF4A90B8),
    );
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.50),
      w * 0.075,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.455, h * 0.470),
      w * 0.028,
      Paint()..color = Colors.white,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.38, h * 0.69)
        ..quadraticBezierTo(w * 0.5, h * 0.78, w * 0.62, h * 0.69),
      Paint()
        ..color = const Color(0xFFFF7070)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _StarIconPainter extends CustomPainter {
  const _StarIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final star = _star(Offset(w * 0.5, h * 0.44), w * 0.36, w * 0.15);
    canvas.drawPath(star, Paint()..color = const Color(0xFFFFD030));
    canvas.drawPath(
      star,
      Paint()
        ..color = const Color(0xFFDDAA00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(w * 0.405, h * 0.415),
      w * 0.036,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.595, h * 0.415),
      w * 0.036,
      Paint()..color = const Color(0xFF1A3545),
    );
    canvas.drawCircle(
      Offset(w * 0.325, h * 0.478),
      w * 0.050,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65),
    );
    canvas.drawCircle(
      Offset(w * 0.675, h * 0.478),
      w * 0.050,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.385, h * 0.495)
        ..quadraticBezierTo(w * 0.5, h * 0.572, w * 0.615, h * 0.495),
      Paint()
        ..color = const Color(0xFFCC8800)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Trophy cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.820),
          width: w * 0.28,
          height: h * 0.10,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFFD030),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.892),
          width: w * 0.36,
          height: h * 0.048,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFDDAA00),
    );
  }

  Path _star(Offset c, double outer, double inner) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = math.pi * i / 5 - math.pi / 2;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Explore Page ─────────────────────────────────────────────────────────────

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  late final AnimationController _cloudCtrl;
  late final AnimationController _sparkleCtrl;
  late final AnimationController _cardCtrl;

  @override
  void initState() {
    super.initState();
    _cloudCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _cloudCtrl.dispose();
    _sparkleCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC8B8F8), Color(0xFFDDD0FF), Color(0xFFF0E8FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(child: LayoutBuilder(builder: _buildLayout)),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final sw = bc.maxWidth;
    final h = bc.maxHeight;
    final w = math.min(sw, 960.0);
    final lh = math.min(h, w * 1.85);
    final pad = w * 0.045;

    return Stack(
      children: [
        // ── Animated clouds ────────────────────────────────────────────────
        _cloud(
          size: sw * 0.85,
          baseLeft: -sw * 0.20,
          top: h * 0.04,
          phase: 0.00,
          amp: sw * 0.05,
        ),
        _cloud(
          size: sw * 0.65,
          baseLeft: sw * 0.50,
          top: h * 0.18,
          phase: 0.33,
          amp: sw * 0.04,
        ),
        _cloud(
          size: sw * 0.55,
          baseLeft: -sw * 0.08,
          top: h * 0.70,
          phase: 0.66,
          amp: sw * 0.03,
        ),

        // ── Sparkles ──────────────────────────────────────────────────────
        ..._sparkles(sw, h),

        // ── Content centred at width w ────────────────────────────────────
        Center(
          child: SizedBox(
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: lh * 0.025),
                // Back button
                Padding(
                  padding: EdgeInsets.only(left: pad),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: math.max(12.0, w * 0.033),
                        vertical: math.max(7.0, w * 0.015),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: math.min(15.0, w * 0.034),
                            color: const Color(0xFF3D3070),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: const Color(0xFF3D3070),
                              fontWeight: FontWeight.w700,
                              fontSize: math.min(16.0, w * 0.037),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: lh * 0.028),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: Text(
                    'Choose What to Explore',
                    style: TextStyle(
                      fontSize: math.min(34.0, w * 0.075),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A1A4A),
                    ),
                  ),
                ),
                SizedBox(height: lh * 0.025),
                // 2×2 category grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _categoryCard(
                                  0,
                                  'All Elements',
                                  'Browse every element',
                                  const Color(0xFFBFE4F8),
                                  const Color(0xFF90C8E8),
                                  const _AllElementsIconPainter(),
                                  onTap: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (ig1, ig2, ig3) =>
                                          const AllElementsPage(),
                                      transitionsBuilder:
                                          (ig, anim, igs, child) =>
                                              SlideTransition(
                                                position:
                                                    Tween<Offset>(
                                                      begin: const Offset(1, 0),
                                                      end: Offset.zero,
                                                    ).animate(
                                                      CurvedAnimation(
                                                        parent: anim,
                                                        curve: Curves.easeInOut,
                                                      ),
                                                    ),
                                                child: child,
                                              ),
                                      transitionDuration: const Duration(
                                        milliseconds: 320,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: pad * 0.7),
                              Expanded(
                                child: _categoryCard(
                                  1,
                                  'Metals',
                                  'Shiny and strong elements',
                                  const Color(0xFFFFF0C0),
                                  const Color(0xFFE8D090),
                                  const _MetalsIconPainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: pad * 0.7),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _categoryCard(
                                  2,
                                  'Nonmetals',
                                  'Elements like oxygen and carbon',
                                  const Color(0xFFB8EEF0),
                                  const Color(0xFF80C8CC),
                                  const _NonmetalsIconPainter(),
                                ),
                              ),
                              SizedBox(width: pad * 0.7),
                              Expanded(
                                child: _categoryCard(
                                  3,
                                  'Noble Gases',
                                  'Special gases like helium and neon',
                                  const Color(0xFFDDD0FF),
                                  const Color(0xFFAA90E8),
                                  const _NobleGasIconPainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: pad * 0.7),
                // Element of the Day banner
                _elementOfTheDay(w, lh, pad),
                SizedBox(height: pad),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(
    int index,
    String title,
    String subtitle,
    Color bg,
    Color border,
    CustomPainter icon, {
    VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _cardCtrl,
      builder: (_, child) {
        final delay = index * 0.15;
        final t = math.max(0.0, (_cardCtrl.value - delay) / (1.0 - delay));
        final curved = Curves.easeOutBack.transform(t.clamp(0.0, 1.0));
        return Opacity(
          opacity: curved.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curved)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 2),
            boxShadow: [
              BoxShadow(
                color: border.withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, cc) {
              final cw = cc.maxWidth;
              final iconW = math.min(90.0, cw * 0.65);
              final iconH = iconW * 0.88;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: iconW,
                    height: iconH,
                    child: CustomPaint(painter: icon),
                  ),
                  SizedBox(height: cw * 0.055),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: cw * 0.08),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: math.min(17.0, cw * 0.115),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A4A),
                      ),
                    ),
                  ),
                  SizedBox(height: cw * 0.025),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: cw * 0.08),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: math.min(11.5, cw * 0.082),
                        color: const Color(0xFF4A4A7A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: cw * 0.07),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _elementOfTheDay(double w, double h, double pad) {
    return AnimatedBuilder(
      animation: _cardCtrl,
      builder: (_, child) {
        final t = Curves.easeOutBack.transform(_cardCtrl.value.clamp(0.0, 1.0));
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - t)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: pad),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0C8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8C870), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8C870).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: math.min(62.0, w * 0.16),
                    height: math.min(62.0, w * 0.16),
                    child: const CustomPaint(painter: _KawaiiStarPainter()),
                  ),
                  SizedBox(width: math.max(10.0, w * 0.035)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Element of the Day',
                          style: TextStyle(
                            fontSize: math.min(18.0, w * 0.048),
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A4A),
                          ),
                        ),
                        SizedBox(height: w * 0.010),
                        Text(
                          'Learn one special element with uses and fun facts.',
                          style: TextStyle(
                            fontSize: math.min(12.5, w * 0.034),
                            color: const Color(0xFF5A4A20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // NEW TODAY badge
            Positioned(
              top: -10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C30),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDD6800).withValues(alpha: 0.45),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'NEW TODAY!',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cloud({
    required double size,
    required double baseLeft,
    required double top,
    required double phase,
    required double amp,
  }) {
    return Positioned(
      left: baseLeft,
      top: top,
      child: AnimatedBuilder(
        animation: _cloudCtrl,
        builder: (_, child) {
          final dx = math.sin((_cloudCtrl.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.38),
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }

  List<Widget> _sparkles(double w, double h) {
    final specs = <List<dynamic>>[
      [w * 0.04, h * 0.035, 16.0, 0xFFFFFFFF, 0.00],
      [w * 0.93, h * 0.075, 13.0, 0xFFFFE082, 0.12],
      [w * 0.08, h * 0.280, 10.0, 0xFFFFE082, 0.28],
      [w * 0.94, h * 0.320, 10.0, 0xCCFFFFFF, 0.44],
      [w * 0.05, h * 0.720, 18.0, 0xFFFFE082, 0.60],
      [w * 0.93, h * 0.760, 14.0, 0xFFFFFFFF, 0.76],
      [w * 0.50, h * 0.110, 9.0, 0xFFFFE082, 0.88],
    ];
    return specs.map((s) {
      return Positioned(
        left: s[0] as double,
        top: s[1] as double,
        child: AnimatedBuilder(
          animation: _sparkleCtrl,
          builder: (_, ignored) {
            final t = (_sparkleCtrl.value + (s[4] as double)) % 1.0;
            final v = (math.sin(t * math.pi * 2) + 1) / 2;
            return Opacity(
              opacity: 0.25 + 0.75 * v,
              child: Transform.scale(
                scale: 0.5 + 0.5 * v,
                child: _Sparkle(
                  size: s[2] as double,
                  color: Color(s[3] as int),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

// ─── Category icon painters ───────────────────────────────────────────────────

class _AllElementsIconPainter extends CustomPainter {
  const _AllElementsIconPainter();

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

class _MetalsIconPainter extends CustomPainter {
  const _MetalsIconPainter();

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

class _NonmetalsIconPainter extends CustomPainter {
  const _NonmetalsIconPainter();

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

class _NobleGasIconPainter extends CustomPainter {
  const _NobleGasIconPainter();

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

class _KawaiiStarPainter extends CustomPainter {
  const _KawaiiStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    final cx = w * 0.5;
    final cy = h * 0.5;
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? w * 0.46 : w * 0.20;
      final a = math.pi * i / 5 - math.pi / 2;
      final p = Offset(cx + r * math.cos(a), cy + r * math.sin(a));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD030));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFCC9900)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(cx - w * 0.12, cy - h * 0.06),
      w * 0.065,
      Paint()..color = const Color(0xFF1A1A2A),
    );
    canvas.drawCircle(
      Offset(cx + w * 0.12, cy - h * 0.06),
      w * 0.065,
      Paint()..color = const Color(0xFF1A1A2A),
    );
    canvas.drawCircle(
      Offset(cx - w * 0.22, cy + h * 0.06),
      w * 0.07,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      Offset(cx + w * 0.22, cy + h * 0.06),
      w * 0.07,
      Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.6),
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.10, cy + h * 0.10)
        ..quadraticBezierTo(cx, cy + h * 0.20, cx + w * 0.10, cy + h * 0.10),
      Paint()
        ..color = const Color(0xFFCC8800)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── Element data ─────────────────────────────────────────────────────────────

class _Elem {
  final int z;
  final String sym, name, cat;
  final double mass;
  final String desc, fact;
  const _Elem(
    this.z,
    this.sym,
    this.name,
    this.mass,
    this.cat,
    this.desc,
    this.fact,
  );
}

Color _elemColor(String cat) {
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

const _kElements = <_Elem>[
  _Elem(
    1,
    'H',
    'Hydrogen',
    1.008,
    'nonmetal',
    'The most abundant element in the universe, making up about 75% of all matter.',
    'Hydrogen was once used to fill airships, but it is highly flammable.',
  ),
  _Elem(
    2,
    'He',
    'Helium',
    4.003,
    'noble',
    'A colorless, odorless noble gas — the second most abundant element in the universe.',
    'Helium makes your voice squeaky because sound travels faster through it.',
  ),
  _Elem(
    3,
    'Li',
    'Lithium',
    6.941,
    'alkali',
    'The lightest of all metals, used in batteries and mood-stabilizing medicine.',
    'Lithium batteries power most smartphones and electric cars.',
  ),
  _Elem(
    4,
    'Be',
    'Beryllium',
    9.012,
    'alkaline',
    'A strong, light metal used in aerospace components and X-ray equipment.',
    'Beryllium is so stiff it is used to make satellite mirrors.',
  ),
  _Elem(
    5,
    'B',
    'Boron',
    10.811,
    'metalloid',
    'A metalloid essential for plant growth and used in glass-making.',
    'Borax, a boron compound, has been used as a cleaner for centuries.',
  ),
  _Elem(
    6,
    'C',
    'Carbon',
    12.011,
    'nonmetal',
    'The building block of all life, found in every living thing on Earth.',
    'Diamonds and pencil graphite are both made of pure carbon.',
  ),
  _Elem(
    7,
    'N',
    'Nitrogen',
    14.007,
    'nonmetal',
    'Makes up 78% of Earth\'s atmosphere and is vital for all living things.',
    'Liquid nitrogen (-196°C) can instantly freeze food solid.',
  ),
  _Elem(
    8,
    'O',
    'Oxygen',
    15.999,
    'nonmetal',
    'Essential for breathing and combustion, making up 21% of Earth\'s atmosphere.',
    'Oxygen was discovered independently by two scientists in 1774.',
  ),
  _Elem(
    9,
    'F',
    'Fluorine',
    18.998,
    'halogen',
    'The most reactive element, used to make Teflon non-stick coating and toothpaste.',
    'Fluorine is so reactive it can make some noble gases form compounds.',
  ),
  _Elem(
    10,
    'Ne',
    'Neon',
    20.180,
    'noble',
    'A colorless, inert gas that glows bright orange-red in electrical discharge.',
    'Pure neon actually glows red — most "neon" signs use other gases.',
  ),
  _Elem(
    11,
    'Na',
    'Sodium',
    22.990,
    'alkali',
    'A soft, silvery metal that reacts violently with water, forming salt with chlorine.',
    'The yellow glow of street lights comes from sodium vapor lamps.',
  ),
  _Elem(
    12,
    'Mg',
    'Magnesium',
    24.305,
    'alkaline',
    'A light, strong metal used in aircraft parts and essential for plant life (chlorophyll).',
    'Magnesium burns with an intense white light, even underwater.',
  ),
  _Elem(
    13,
    'Al',
    'Aluminum',
    26.982,
    'post',
    'The most abundant metal in Earth\'s crust, lightweight and resistant to corrosion.',
    'Napoleon used aluminum cutlery for special guests — it was once rarer than gold.',
  ),
  _Elem(
    14,
    'Si',
    'Silicon',
    28.086,
    'metalloid',
    'The second most abundant element in Earth\'s crust, used to make computer chips.',
    'Silicon Valley is named after this element because of its use in microchips.',
  ),
  _Elem(
    15,
    'P',
    'Phosphorus',
    30.974,
    'nonmetal',
    'Essential for life, found in DNA, bones, and used in fertilizers.',
    'Phosphorus was first extracted from urine in 1669 by an alchemist seeking gold.',
  ),
  _Elem(
    16,
    'S',
    'Sulfur',
    32.065,
    'nonmetal',
    'A yellow solid used in gunpowder, medicine, and rubber vulcanization.',
    'Sulfur is found in pure form near volcanoes — it has a distinctive smell.',
  ),
  _Elem(
    17,
    'Cl',
    'Chlorine',
    35.453,
    'halogen',
    'A greenish-yellow gas used to disinfect water and make household cleaners.',
    'Chlorine was used as a chemical weapon in World War I.',
  ),
  _Elem(
    18,
    'Ar',
    'Argon',
    39.948,
    'noble',
    'The third most abundant gas in Earth\'s atmosphere, used in welding and light bulbs.',
    'Argon\'s name comes from the Greek for "lazy" — it rarely reacts.',
  ),
  _Elem(
    19,
    'K',
    'Potassium',
    39.098,
    'alkali',
    'An essential element for health, regulating fluid balance and nerve signals.',
    'Bananas are famously rich in potassium.',
  ),
  _Elem(
    20,
    'Ca',
    'Calcium',
    40.078,
    'alkaline',
    'The most abundant mineral in the body, found in bones, teeth, and muscles.',
    'Calcium makes up about 2% of adult body weight — mostly in your skeleton.',
  ),
  _Elem(
    21,
    'Sc',
    'Scandium',
    44.956,
    'transition',
    'A rare, silvery metal used in aerospace components and high-intensity lights.',
    'Scandium was discovered in Scandinavia — hence its name.',
  ),
  _Elem(
    22,
    'Ti',
    'Titanium',
    47.867,
    'transition',
    'A strong, lightweight metal used in aircraft, medical implants, and jewelry.',
    'Titanium is as strong as steel but 45% lighter.',
  ),
  _Elem(
    23,
    'V',
    'Vanadium',
    50.942,
    'transition',
    'A hard, silvery-grey metal used to strengthen steel alloys.',
    'Vanadium steel was used to build the Ford Model T — stronger and cheaper.',
  ),
  _Elem(
    24,
    'Cr',
    'Chromium',
    51.996,
    'transition',
    'A shiny, hard metal used to make stainless steel and chrome-plated surfaces.',
    'Chrome plating is just a thin layer of chromium for shine and rust resistance.',
  ),
  _Elem(
    25,
    'Mn',
    'Manganese',
    54.938,
    'transition',
    'A metal essential for steel production and important for brain function.',
    'Manganese is essential for the enzymes that keep your brain working.',
  ),
  _Elem(
    26,
    'Fe',
    'Iron',
    55.845,
    'transition',
    'One of Earth\'s most abundant metals, essential for blood and used to make steel.',
    'The Earth\'s core is mostly iron, which creates our planet\'s magnetic field.',
  ),
  _Elem(
    27,
    'Co',
    'Cobalt',
    58.933,
    'transition',
    'A magnetic metal used in batteries, alloys, and to create vivid blue pigments.',
    'The brilliant blue in ancient glass and ceramics comes from cobalt.',
  ),
  _Elem(
    28,
    'Ni',
    'Nickel',
    58.693,
    'transition',
    'A hard, silvery metal used in coins, stainless steel, and batteries.',
    'The US 5-cent "nickel" coin contains more copper than nickel.',
  ),
  _Elem(
    29,
    'Cu',
    'Copper',
    63.546,
    'transition',
    'An excellent conductor of electricity, used in wiring and plumbing since ancient times.',
    'The Statue of Liberty is made of copper and turned green due to oxidation.',
  ),
  _Elem(
    30,
    'Zn',
    'Zinc',
    65.38,
    'transition',
    'A bluish-white metal used to galvanize steel and essential for immune function.',
    'Zinc deficiency affects about 2 billion people worldwide.',
  ),
  _Elem(
    31,
    'Ga',
    'Gallium',
    69.723,
    'post',
    'A soft metal that melts in your hand (at 29.76°C), used in semiconductors and LEDs.',
    'Gallium melts just above room temperature — it will melt in your palm!',
  ),
  _Elem(
    32,
    'Ge',
    'Germanium',
    72.630,
    'metalloid',
    'A metalloid used in fiber optics and infrared optical systems.',
    'Germanium was predicted by Mendeleev before it was even discovered.',
  ),
  _Elem(
    33,
    'As',
    'Arsenic',
    74.922,
    'metalloid',
    'A toxic metalloid historically used as poison, now used in semiconductors.',
    'Victorian wallpapers often contained arsenic pigments — poisoning many people.',
  ),
  _Elem(
    34,
    'Se',
    'Selenium',
    78.971,
    'nonmetal',
    'A nonmetal essential in small amounts for health, used in solar cells.',
    'Selenium gives glass a red tint — it cancels out an unwanted green tint.',
  ),
  _Elem(
    35,
    'Br',
    'Bromine',
    79.904,
    'halogen',
    'One of only two elements liquid at room temperature — a reddish-brown toxic liquid.',
    'Bromine\'s name comes from Greek for "stench" due to its strong smell.',
  ),
  _Elem(
    36,
    'Kr',
    'Krypton',
    83.798,
    'noble',
    'A noble gas used in high-performance lighting and laser technology.',
    'Krypton is Superman\'s home planet — but real krypton is just a boring noble gas!',
  ),
  _Elem(
    37,
    'Rb',
    'Rubidium',
    85.468,
    'alkali',
    'A soft, silvery metal that ignites spontaneously in air.',
    'Rubidium clocks are among the most precise timekeepers in the world.',
  ),
  _Elem(
    38,
    'Sr',
    'Strontium',
    87.62,
    'alkaline',
    'An alkaline earth metal that burns with a crimson flame.',
    'Strontium compounds give fireworks their brilliant red color.',
  ),
  _Elem(
    39,
    'Y',
    'Yttrium',
    88.906,
    'transition',
    'A silvery metal used in LEDs, laser crystals, and superconductors.',
    'Yttrium, ytterbium, terbium, and erbium are all named after the same village.',
  ),
  _Elem(
    40,
    'Zr',
    'Zirconium',
    91.224,
    'transition',
    'A strong, corrosion-resistant metal used in nuclear reactors and jewelry.',
    'Cubic zirconia, a fake diamond, is made from zirconium oxide.',
  ),
  _Elem(
    41,
    'Nb',
    'Niobium',
    92.906,
    'transition',
    'A soft, grey metal used in superalloys for jet engines.',
    'Niobium is used in the Large Hadron Collider\'s superconducting magnets.',
  ),
  _Elem(
    42,
    'Mo',
    'Molybdenum',
    95.96,
    'transition',
    'A silvery metal that adds strength and hardness to steel alloys.',
    'Some bacteria use molybdenum to convert nitrogen gas into ammonia.',
  ),
  _Elem(
    43,
    'Tc',
    'Technetium',
    97.0,
    'transition',
    'The lightest element with no stable isotopes — all isotopes are radioactive.',
    'Technetium was the first artificially produced element.',
  ),
  _Elem(
    44,
    'Ru',
    'Ruthenium',
    101.07,
    'transition',
    'A rare platinum-group metal used in electrical contacts and catalysts.',
    'Ruthenium can harden platinum and palladium for use in jewelry.',
  ),
  _Elem(
    45,
    'Rh',
    'Rhodium',
    102.906,
    'transition',
    'The rarest and most expensive precious metal, used in catalytic converters.',
    'Rhodium is about 10–25 times more expensive than gold.',
  ),
  _Elem(
    46,
    'Pd',
    'Palladium',
    106.42,
    'transition',
    'A precious metal used in catalytic converters and electronics.',
    'Palladium can absorb 900 times its own volume of hydrogen gas.',
  ),
  _Elem(
    47,
    'Ag',
    'Silver',
    107.868,
    'transition',
    'A shiny precious metal with the highest electrical conductivity of all elements.',
    'Silver has been used as money for over 4,000 years.',
  ),
  _Elem(
    48,
    'Cd',
    'Cadmium',
    112.411,
    'transition',
    'A soft, bluish-white metal used in rechargeable batteries and pigments.',
    'Cadmium yellow was a favorite color of Impressionist painters like Monet.',
  ),
  _Elem(
    49,
    'In',
    'Indium',
    114.818,
    'post',
    'A soft, silvery metal used in touchscreens and flat panel displays.',
    'The touchscreen on your phone likely contains indium tin oxide.',
  ),
  _Elem(
    50,
    'Sn',
    'Tin',
    118.710,
    'post',
    'A silvery metal used since ancient times to make bronze (with copper).',
    'Tin cans are mostly steel — just coated with tin to prevent rust.',
  ),
  _Elem(
    51,
    'Sb',
    'Antimony',
    121.760,
    'metalloid',
    'A metalloid used in flame retardants and semiconductor devices.',
    'Ancient Egyptians used antimony sulfide as black eye makeup.',
  ),
  _Elem(
    52,
    'Te',
    'Tellurium',
    127.60,
    'metalloid',
    'A brittle, silver-white metalloid used in solar panels and optical discs.',
    'Tellurium is one of the rarest stable elements in Earth\'s crust.',
  ),
  _Elem(
    53,
    'I',
    'Iodine',
    126.904,
    'halogen',
    'An essential nutrient for thyroid hormones, also used as a disinfectant.',
    'Iodine\'s name comes from Greek for "violet" — its vapor is purple.',
  ),
  _Elem(
    54,
    'Xe',
    'Xenon',
    131.293,
    'noble',
    'A noble gas used in high-intensity lamps, lasers, and as an anesthetic.',
    'Xenon headlights in cars produce a distinctive bright blue-white light.',
  ),
  _Elem(
    55,
    'Cs',
    'Cesium',
    132.905,
    'alkali',
    'The softest metal and most reactive alkali metal, used in atomic clocks.',
    'The second (unit of time) is defined using cesium atomic vibrations.',
  ),
  _Elem(
    56,
    'Ba',
    'Barium',
    137.327,
    'alkaline',
    'A soft, silvery metal used in medical imaging (barium meal X-rays).',
    'Barium sulfate is swallowed by patients before stomach X-rays — it\'s non-toxic.',
  ),
  _Elem(
    57,
    'La',
    'Lanthanum',
    138.905,
    'lanthanide',
    'The first lanthanide element, used in camera lenses and hydrogen storage.',
    'Lanthanum compounds make night-vision goggles possible.',
  ),
  _Elem(
    58,
    'Ce',
    'Cerium',
    140.116,
    'lanthanide',
    'The most abundant rare earth element, used in catalytic converters and lighter flints.',
    'The sparks from a lighter flint are caused by cerium alloy.',
  ),
  _Elem(
    59,
    'Pr',
    'Praseodymium',
    140.908,
    'lanthanide',
    'A soft, silvery metal used in high-strength magnets and welder\'s goggles.',
    'Praseodymium gives glass a distinctive yellow-green color.',
  ),
  _Elem(
    60,
    'Nd',
    'Neodymium',
    144.242,
    'lanthanide',
    'Used to make the strongest permanent magnets in the world.',
    'Neodymium magnets are so powerful they can be dangerous if mishandled.',
  ),
  _Elem(
    61,
    'Pm',
    'Promethium',
    145.0,
    'lanthanide',
    'A radioactive element used in early pacemakers and spacecraft power sources.',
    'Promethium is named after Prometheus, who stole fire from the gods.',
  ),
  _Elem(
    62,
    'Sm',
    'Samarium',
    150.36,
    'lanthanide',
    'A hard, silvery metal used in magnets, cancer treatment, and lasers.',
    'Samarium-cobalt magnets work at higher temperatures than neodymium magnets.',
  ),
  _Elem(
    63,
    'Eu',
    'Europium',
    151.964,
    'lanthanide',
    'A rare earth element used in fluorescent lamps and euro banknote security features.',
    'The red and blue colors in TV screens and monitors use europium compounds.',
  ),
  _Elem(
    64,
    'Gd',
    'Gadolinium',
    157.25,
    'lanthanide',
    'Used as a contrast agent in MRI scans and in nuclear reactor control rods.',
    'Gadolinium has one of the highest neutron-capture cross-sections of all elements.',
  ),
  _Elem(
    65,
    'Tb',
    'Terbium',
    158.925,
    'lanthanide',
    'A soft, silvery rare earth metal used in solid-state devices and sonar.',
    'Terbium can expand and contract when placed in a magnetic field.',
  ),
  _Elem(
    66,
    'Dy',
    'Dysprosium',
    162.5,
    'lanthanide',
    'A rare earth metal used in electric motors of electric vehicles and wind turbines.',
    'Dysprosium\'s name comes from Greek for "hard to get."',
  ),
  _Elem(
    67,
    'Ho',
    'Holmium',
    164.930,
    'lanthanide',
    'Has the strongest magnetic moment of any naturally occurring element.',
    'Holmium is used in nuclear reactors to help control the chain reaction.',
  ),
  _Elem(
    68,
    'Er',
    'Erbium',
    167.259,
    'lanthanide',
    'A soft, silvery metal used in fiber optic cables and laser surgery.',
    'Erbium amplifiers boost signals in long-distance fiber optic cables.',
  ),
  _Elem(
    69,
    'Tm',
    'Thulium',
    168.934,
    'lanthanide',
    'A rare earth metal used in portable X-ray machines and lasers.',
    'Thulium is the rarest naturally occurring lanthanide.',
  ),
  _Elem(
    70,
    'Yb',
    'Ytterbium',
    173.054,
    'lanthanide',
    'Used in the most precise atomic clocks and as a dopant in fiber optic cables.',
    'Ytterbium clocks would lose 1 second in 10 billion years.',
  ),
  _Elem(
    71,
    'Lu',
    'Lutetium',
    174.967,
    'lanthanide',
    'The heaviest and hardest rare earth metal, used in PET scan detectors.',
    'Lutetium is named after Lutetia, the ancient Latin name for Paris.',
  ),
  _Elem(
    72,
    'Hf',
    'Hafnium',
    178.49,
    'transition',
    'A shiny, corrosion-resistant metal used in nuclear reactor control rods.',
    'Hafnium is almost always found with zirconium — they are very hard to separate.',
  ),
  _Elem(
    73,
    'Ta',
    'Tantalum',
    180.948,
    'transition',
    'A hard, corrosion-resistant metal used in electronics and surgical instruments.',
    'Tantalum capacitors are in virtually every electronic device.',
  ),
  _Elem(
    74,
    'W',
    'Tungsten',
    183.84,
    'transition',
    'The element with the highest melting point (3,422°C), used in light bulb filaments.',
    'Tungsten\'s chemical symbol W comes from its old name "wolfram."',
  ),
  _Elem(
    75,
    'Re',
    'Rhenium',
    186.207,
    'transition',
    'One of the rarest elements on Earth, used in jet engine turbine blades.',
    'Rhenium has the second highest melting point of all elements.',
  ),
  _Elem(
    76,
    'Os',
    'Osmium',
    190.23,
    'transition',
    'The densest naturally occurring element — a baseball-sized piece weighs 14 kg.',
    'Osmium tetroxide has a distinctive and dangerous pungent smell.',
  ),
  _Elem(
    77,
    'Ir',
    'Iridium',
    192.217,
    'transition',
    'The most corrosion-resistant metal, used in fountain pen nibs and spark plugs.',
    'A layer of iridium in Earth\'s crust marks the asteroid that killed the dinosaurs.',
  ),
  _Elem(
    78,
    'Pt',
    'Platinum',
    195.084,
    'transition',
    'A precious metal used in jewelry, catalytic converters, and cancer drugs.',
    'All platinum ever mined would fill a room 25 feet cubed.',
  ),
  _Elem(
    79,
    'Au',
    'Gold',
    196.967,
    'transition',
    'A shiny precious metal that never tarnishes, valued throughout human history.',
    'All gold on Earth came from meteorites — it sank to the core during formation.',
  ),
  _Elem(
    80,
    'Hg',
    'Mercury',
    200.592,
    'transition',
    'The only metal that is liquid at room temperature, used in thermometers.',
    'Mercury\'s symbol Hg comes from "hydrargyrum" — Greek for "liquid silver."',
  ),
  _Elem(
    81,
    'Tl',
    'Thallium',
    204.383,
    'post',
    'A soft, grey post-transition metal — highly toxic, once used as rat poison.',
    'Thallium was the poison of choice in several notorious murder cases.',
  ),
  _Elem(
    82,
    'Pb',
    'Lead',
    207.2,
    'post',
    'A dense, soft metal used in batteries, pipes, and radiation shielding.',
    'Ancient Romans used lead extensively in pipes, pots, and even wine sweeteners.',
  ),
  _Elem(
    83,
    'Bi',
    'Bismuth',
    208.980,
    'post',
    'The least toxic heavy metal, used in cosmetics, medicines, and as a lead substitute.',
    'Bismuth crystals form beautiful rainbow-colored geometric staircase shapes.',
  ),
  _Elem(
    84,
    'Po',
    'Polonium',
    209.0,
    'metalloid',
    'A highly radioactive metalloid famously used in a high-profile assassination.',
    'Marie Curie named polonium after her homeland, Poland.',
  ),
  _Elem(
    85,
    'At',
    'Astatine',
    210.0,
    'halogen',
    'The rarest naturally occurring element — less than 1 gram exists in Earth\'s crust.',
    'Astatine is so rare it has never been seen in bulk — only isolated atoms.',
  ),
  _Elem(
    86,
    'Rn',
    'Radon',
    222.0,
    'noble',
    'A naturally occurring radioactive gas that can accumulate in buildings.',
    'Radon is the second leading cause of lung cancer after smoking.',
  ),
  _Elem(
    87,
    'Fr',
    'Francium',
    223.0,
    'alkali',
    'The second rarest natural element and most unstable of the first 101 elements.',
    'At any moment, less than 30 grams of francium exists in Earth\'s crust.',
  ),
  _Elem(
    88,
    'Ra',
    'Radium',
    226.0,
    'alkaline',
    'A highly radioactive metal discovered by Marie Curie, once used in luminous paint.',
    '"Radium Girls" painted watch dials and suffered severe radiation poisoning.',
  ),
  _Elem(
    89,
    'Ac',
    'Actinium',
    227.0,
    'actinide',
    'A radioactive silvery metal that glows blue in the dark due to radioactivity.',
    'Actinium glows blue because it ionizes the surrounding air.',
  ),
  _Elem(
    90,
    'Th',
    'Thorium',
    232.038,
    'actinide',
    'A radioactive metal proposed as a safer alternative nuclear fuel to uranium.',
    'India has the world\'s largest deposits of thorium sand.',
  ),
  _Elem(
    91,
    'Pa',
    'Protactinium',
    231.036,
    'actinide',
    'A rare, highly radioactive element with limited practical use.',
    'Only about 125 grams of protactinium exist for research purposes worldwide.',
  ),
  _Elem(
    92,
    'U',
    'Uranium',
    238.029,
    'actinide',
    'A dense, radioactive metal used as fuel in nuclear power plants.',
    'Uranium\'s radioactivity was discovered when it accidentally fogged a photo plate.',
  ),
  _Elem(
    93,
    'Np',
    'Neptunium',
    237.0,
    'actinide',
    'The first synthetic transuranium element, produced in nuclear reactors.',
    'Neptunium is named after Neptune, just as uranium is named after Uranus.',
  ),
  _Elem(
    94,
    'Pu',
    'Plutonium',
    244.0,
    'actinide',
    'A fissile material used in nuclear weapons and as fuel in nuclear reactors.',
    'The plutonium for the first atomic bomb came from a secret city in Washington state.',
  ),
  _Elem(
    95,
    'Am',
    'Americium',
    243.0,
    'actinide',
    'A synthetic radioactive metal — tiny amounts are used in home smoke detectors.',
    'There is a tiny amount of americium in every ionization smoke detector.',
  ),
  _Elem(
    96,
    'Cm',
    'Curium',
    247.0,
    'actinide',
    'A radioactive metal named after Marie and Pierre Curie.',
    'Curium glows red hot due to its intense radioactive decay heat.',
  ),
  _Elem(
    97,
    'Bk',
    'Berkelium',
    247.0,
    'actinide',
    'A synthetic radioactive element produced in tiny amounts in nuclear reactors.',
    'Berkelium is named after Berkeley, California, where it was synthesized.',
  ),
  _Elem(
    98,
    'Cf',
    'Californium',
    251.0,
    'actinide',
    'A synthetic radioactive element used in nuclear reactors and cancer treatment.',
    'Californium-252 costs over \$27 million per gram — one of the priciest materials.',
  ),
  _Elem(
    99,
    'Es',
    'Einsteinium',
    252.0,
    'actinide',
    'A synthetic element discovered in the debris of the first hydrogen bomb test.',
    'Einsteinium was discovered secretly during the Cold War.',
  ),
  _Elem(
    100,
    'Fm',
    'Fermium',
    257.0,
    'actinide',
    'A synthetic radioactive element also found in hydrogen bomb fallout.',
    'Fermium is named after Enrico Fermi, who built the first nuclear reactor.',
  ),
  _Elem(
    101,
    'Md',
    'Mendelevium',
    258.0,
    'actinide',
    'A synthetic element named after Mendeleev, creator of the periodic table.',
    'Only a few atoms of mendelevium have ever been produced at one time.',
  ),
  _Elem(
    102,
    'No',
    'Nobelium',
    259.0,
    'actinide',
    'A synthetic radioactive element named after Alfred Nobel.',
    'Nobelium was the subject of a naming dispute between Soviet and American scientists.',
  ),
  _Elem(
    103,
    'Lr',
    'Lawrencium',
    262.0,
    'actinide',
    'The last actinide element, named after Ernest Lawrence, inventor of the cyclotron.',
    'Lawrencium completes the actinide series at atomic number 103.',
  ),
  _Elem(
    104,
    'Rf',
    'Rutherfordium',
    267.0,
    'transition',
    'A synthetic element and the first of the transactinide series.',
    'Rutherfordium is named after physicist Ernest Rutherford.',
  ),
  _Elem(
    105,
    'Db',
    'Dubnium',
    268.0,
    'transition',
    'A highly radioactive synthetic element with a very short half-life.',
    'Dubnium is named after Dubna, Russia, where it was first synthesized.',
  ),
  _Elem(
    106,
    'Sg',
    'Seaborgium',
    271.0,
    'transition',
    'Named after Glenn Seaborg — the only element named after a living person at the time.',
    'Glenn Seaborg co-discovered 10 elements — a record.',
  ),
  _Elem(
    107,
    'Bh',
    'Bohrium',
    272.0,
    'transition',
    'A radioactive synthetic element named after physicist Niels Bohr.',
    'Bohrium atoms last only fractions of a second before decaying.',
  ),
  _Elem(
    108,
    'Hs',
    'Hassium',
    277.0,
    'transition',
    'A synthetic element named after the German state of Hesse.',
    'Only a few dozen atoms of hassium have ever been produced.',
  ),
  _Elem(
    109,
    'Mt',
    'Meitnerium',
    276.0,
    'transition',
    'Named after physicist Lise Meitner, who discovered nuclear fission.',
    'Lise Meitner was nominated for the Nobel Prize multiple times but never won.',
  ),
  _Elem(
    110,
    'Ds',
    'Darmstadtium',
    281.0,
    'transition',
    'A synthetic element named after Darmstadt, Germany.',
    'Darmstadtium was first created in 1994 and exists for only milliseconds.',
  ),
  _Elem(
    111,
    'Rg',
    'Roentgenium',
    280.0,
    'transition',
    'Named after Wilhelm Röntgen, discoverer of X-rays.',
    'Roentgenium\'s most stable isotope has a half-life of only 26 seconds.',
  ),
  _Elem(
    112,
    'Cn',
    'Copernicium',
    285.0,
    'transition',
    'Named after astronomer Nicolaus Copernicus.',
    'Copernicium may behave more like a noble gas than a metal at room temperature.',
  ),
  _Elem(
    113,
    'Nh',
    'Nihonium',
    284.0,
    'post',
    'Named after Japan (Nihon) — the first element discovered in Asia.',
    'Nihonium was discovered by Japanese scientists at RIKEN in 2004.',
  ),
  _Elem(
    114,
    'Fl',
    'Flerovium',
    289.0,
    'post',
    'Named after the Flerov Laboratory of Nuclear Reactions in Russia.',
    'Flerovium may have properties more like a noble gas than a metal.',
  ),
  _Elem(
    115,
    'Mc',
    'Moscovium',
    288.0,
    'post',
    'Named after the Moscow region of Russia.',
    'Moscovium was first synthesized in 2003 in a US-Russian collaboration.',
  ),
  _Elem(
    116,
    'Lv',
    'Livermorium',
    293.0,
    'post',
    'Named after the Lawrence Livermore National Laboratory in California.',
    'Livermorium is so unstable it decays almost instantly after being created.',
  ),
  _Elem(
    117,
    'Ts',
    'Tennessine',
    294.0,
    'halogen',
    'Named after Tennessee, where key research institutions contributed to its discovery.',
    'Tennessine is the second heaviest element known.',
  ),
  _Elem(
    118,
    'Og',
    'Oganesson',
    294.0,
    'noble',
    'The heaviest and most recently named element, named after physicist Yuri Oganessian.',
    'Oganesson may not behave like a noble gas despite being in that group.',
  ),
];

// ─── All Elements Page ─────────────────────────────────────────────────────────

class AllElementsPage extends StatefulWidget {
  const AllElementsPage({super.key});
  @override
  State<AllElementsPage> createState() => _AllElementsPageState();
}

class _AllElementsPageState extends State<AllElementsPage>
    with TickerProviderStateMixin {
  late final AnimationController _cloudCtrl;
  late final AnimationController _gridCtrl;

  @override
  void initState() {
    super.initState();
    _cloudCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _gridCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _cloudCtrl.dispose();
    _gridCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC8B8F8), Color(0xFFDDD0FF), Color(0xFFF0E8FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(child: LayoutBuilder(builder: _buildLayout)),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final w = bc.maxWidth;
    final h = bc.maxHeight;
    final cols = (w / 68).floor().clamp(5, 10);
    final cardW = w / cols;

    return Stack(
      children: [
        _cloud(
          size: w * 0.70,
          baseLeft: -w * 0.15,
          top: h * 0.02,
          phase: 0.0,
          amp: w * 0.04,
        ),
        _cloud(
          size: w * 0.55,
          baseLeft: w * 0.55,
          top: h * 0.08,
          phase: 0.5,
          amp: w * 0.03,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.018, w * 0.04, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: math.max(10.0, w * 0.028),
                        vertical: math.max(6.0, w * 0.014),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: math.min(14.0, w * 0.033),
                            color: const Color(0xFF3D3070),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: const Color(0xFF3D3070),
                              fontWeight: FontWeight.w700,
                              fontSize: math.min(15.0, w * 0.036),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'All Elements',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: math.min(30.0, w * 0.072),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1A4A),
                      ),
                    ),
                  ),
                  // Mirror spacer so title stays centered
                  SizedBox(width: math.max(60.0, w * 0.18)),
                ],
              ),
            ),
            SizedBox(height: h * 0.012),
            // ── Grid ──────────────────────────────────────────────────────
            Expanded(
              child: AnimatedBuilder(
                animation: _gridCtrl,
                builder: (context, ignored) {
                  return GridView.builder(
                    padding: EdgeInsets.only(bottom: h * 0.02),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: _kElements.length,
                    itemBuilder: (context, i) {
                      final e = _kElements[i];
                      final delay = (i % (cols * 5)) * 0.007;
                      final t = math.max(
                        0.0,
                        (_gridCtrl.value - delay) / (1.0 - delay),
                      );
                      final curved = Curves.easeOutBack.transform(
                        t.clamp(0.0, 1.0),
                      );
                      return Opacity(
                        opacity: curved.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.4 + 0.6 * curved,
                          child: _ElementTile(
                            elem: e,
                            cardW: cardW,
                            onTap: () => _showDetail(context, e, w),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDetail(BuildContext context, _Elem e, double w) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, anim, sec) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, sec, ignored) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: anim,
            child: Center(
              child: _ElementDetailCard(elem: e, screenW: w),
            ),
          ),
        );
      },
    );
  }

  Widget _cloud({
    required double size,
    required double baseLeft,
    required double top,
    required double phase,
    required double amp,
  }) {
    return Positioned(
      left: baseLeft,
      top: top,
      child: AnimatedBuilder(
        animation: _cloudCtrl,
        builder: (_, child) {
          final dx = math.sin((_cloudCtrl.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.38),
            color: Colors.white.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }
}

// ─── Element tile (grid cell) ─────────────────────────────────────────────────

class _ElementTile extends StatelessWidget {
  final _Elem elem;
  final double cardW;
  final VoidCallback onTap;

  const _ElementTile({
    required this.elem,
    required this.cardW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _elemColor(elem.cat);
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

class _ElementDetailCard extends StatelessWidget {
  final _Elem elem;
  final double screenW;
  const _ElementDetailCard({required this.elem, required this.screenW});

  @override
  Widget build(BuildContext context) {
    final color = _elemColor(elem.cat);
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
