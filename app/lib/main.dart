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
    _cloudCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    _floatCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _sparkleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _btnCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
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
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: LayoutBuilder(builder: _buildLayout),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final w = bc.maxWidth;
    final h = bc.maxHeight;
    final cardSz = math.min(w * 0.22, 90.0);

    return Stack(
      children: [
        // ── Moving cloud blobs ────────────────────────────────────────────
        _cloud(size: w * 0.9,  baseLeft: -w * 0.22, top: h * 0.04,  phase: 0.00, amp: w * 0.05),
        _cloud(size: w * 0.70, baseLeft:  w * 0.43, top: h * 0.22,  phase: 0.50, amp: w * 0.04),
        _cloud(size: w * 0.58, baseLeft: -w * 0.06, top: h * 0.62,  phase: 0.25, amp: w * 0.03),

        // ── Twinkling sparkles ─────────────────────────────────────────────
        ..._sparkles(w, h),

        // ── Main content ──────────────────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.030),
            _OutlinedTitle(fontSize: math.min(42.0, w * 0.11)),
            SizedBox(height: h * 0.008),
            Text(
              'Learn Chemistry the Fun Way!',
              style: TextStyle(
                fontSize: math.min(15.0, w * 0.039),
                color: const Color(0xFF3D6B80),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: h * 0.012),
            Expanded(
              child: // Inside _buildLayout, rearrange the order:

Stack(
  alignment: Alignment.center,
  clipBehavior: Clip.none,
  children: [
    _robot(w, h), // Move the robot to the FIRST position in this sub-stack
    
    // Now all cards will render ON TOP of the robot
    _card(w: w, h: h, sz: cardSz, left: true,  top: false,
          num: 7, sym: 'N',  name: 'Nitrogen',
          color: const Color(0xFF5BBD70), angle: -0.10, phase: 0.50),
    _card(w: w, h: h, sz: cardSz, left: false, top: false,
          num: 2, sym: 'He', name: 'Helium',
          color: const Color(0xFF8B6EC7), angle:  0.10, phase: 0.75),
    _card(w: w, h: h, sz: cardSz, left: true,  top: true,
          num: 1, sym: 'H',  name: 'Hydrogen',
          color: const Color(0xFFF5C030), angle: -0.12, phase: 0.00),
    _card(w: w, h: h, sz: cardSz, left: false, top: true,
          num: 8, sym: 'O',  name: 'Oxygen',
          color: const Color(0xFF9C7BD4), angle:  0.12, phase: 0.25),
  ],
),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.10, 0, w * 0.10, h * 0.032),
              child: _startButton(context),
            ),
          ],
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
      [w * 0.66, h * 0.013,  9.0, 0xFFFFE082, 0.30],
      [w * 0.07, h * 0.710, 24.0, 0xFFFFE082, 0.40],
      [w * 0.92, h * 0.730, 18.0, 0xFFFFFFFF, 0.50],
      [w * 0.44, h * 0.730, 11.0, 0xFFFFE082, 0.60],
      [w * 0.56, h * 0.690, 10.0, 0xCCFFFFFF, 0.70],
      [w * 0.02, h * 0.440, 11.0, 0xFFFFE082, 0.80],
      [w * 0.97, h * 0.490, 13.0, 0xCCFFFFFF, 0.90],
    ];

    return specs.map((s) {
      return Positioned(
        left:  s[0] as double,
        top:   s[1] as double,
        child: AnimatedBuilder(
          animation: _sparkleCtrl,
          builder: (_, ignored) {
            final t = (_sparkleCtrl.value + (s[4] as double)) % 1.0;
            final v = (math.sin(t * math.pi * 2) + 1) / 2;
            return Opacity(
              opacity: 0.25 + 0.75 * v,
              child: Transform.scale(
                scale: 0.5 + 0.5 * v,
                child: _Sparkle(size: s[2] as double, color: Color(s[3] as int)),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  // ── Floating element card ──────────────────────────────────────────────────

  Widget _card({
    required double w, required double h, required double sz,
    required bool left, required bool top,
    required int num, required String sym, required String name,
    required Color color, required double angle, required double phase,
  }) {
    return Positioned(
      left:  left ? (top ? w * 0.015 : -w * 0.12) : null, 
      right: left ? null : (top ? w * 0.015 : -w * 0.12), 
      
      // Lower the top value so they sit near the robot's hands/sides
      top:   top  ? h * 0.010 : h * 0.420,
      child: AnimatedBuilder(
        animation: _floatCtrl,
        builder: (_, child) {
          final dy = -7.0 * math.sin((_floatCtrl.value + phase) * math.pi * 2);
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: Transform.rotate(
          angle: angle,
          child: _ElementCard(atomicNumber: num, symbol: sym, name: name,
                              color: color, size: sz),
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
        width:  w * 0.60,
        height: h * 0.63,
        child: const CustomPaint(painter: _RobotPainter()),
      ),
    );
  }

  // ── Start button with press animation ─────────────────────────────────────

  Widget _startButton(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _btnCtrl.forward(),
      onTapUp:     (_) => _btnCtrl.reverse(),
      onTapCancel: ()  => _btnCtrl.reverse(),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ignored1, ignored2, ignored3) => const GameModePage(),
          transitionsBuilder: (ignored, anim, ignoredSec, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
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
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFDD55), Color(0xFFFFAA1A)],
            ),
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(color: Color(0xFFCC7700), blurRadius: 0, offset: Offset(0, 5)),
              BoxShadow(color: Color(0x55FF9900), blurRadius: 18, offset: Offset(0, 8)),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'START GAME',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7A4800),
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
        Text(text, style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.w900,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 9
            ..strokeJoin = StrokeJoin.round
            ..color = const Color(0xFFFFD080),
        )),
        Text(text, style: TextStyle(
          fontSize: fontSize, fontWeight: FontWeight.w900,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeJoin = StrokeJoin.round
            ..color = const Color(0xFFCC8820),
        )),
        Text(text, style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF8B5E1A),
        )),
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
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size,
               child: CustomPaint(painter: _SparklePainter(color)));
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
    required this.atomicNumber, required this.symbol,
    required this.name, required this.color, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final w = size;
    final h = size * 1.10;
    final light = Color.lerp(color, Colors.white, 0.28)!;
    final dark  = Color.lerp(color, Colors.black, 0.18)!;

    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [light, color, dark],
          stops: const [0.0, 0.45, 1.0],
        ),
        borderRadius: BorderRadius.circular(w * 0.14),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 12, offset: const Offset(0, 7)),
          BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 2, offset: const Offset(-1, -1)),
        ],
      ),
      child: Stack(
        children: [
          // Gloss sheen at top
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: h * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.14)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withValues(alpha: 0.30), Colors.transparent],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(w * 0.10, w * 0.07, w * 0.07, w * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$atomicNumber',
                    style: TextStyle(fontSize: w * 0.14, fontWeight: FontWeight.w700,
                                     color: Colors.white, height: 1.0)),
                Expanded(
                  child: Center(
                    child: Text(symbol,
                        style: TextStyle(fontSize: w * 0.44, fontWeight: FontWeight.w900,
                                          color: Colors.white, height: 1.0)),
                  ),
                ),
                Center(
                  child: Text(name,
                      style: TextStyle(fontSize: w * 0.115, fontWeight: FontWeight.w600,
                                        color: Colors.white)),
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
    const cMid   = Color(0xFF6CBAD8);
    const cDark  = Color(0xFF52A8C6);

    // ── Ground shadow ──────────────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.945), width: w * 0.52, height: h * 0.04),
      Paint()
        ..color = const Color(0x33207090)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // ── Legs ──────────────────────────────────────────────────────────────
    _rr(canvas, Rect.fromCenter(center: Offset(w * 0.345, h * 0.895), width: w * 0.185, height: h * 0.135), w * 0.092, Paint()..color = cDark);
    _rr(canvas, Rect.fromCenter(center: Offset(w * 0.655, h * 0.895), width: w * 0.185, height: h * 0.135), w * 0.092, Paint()..color = cDark);

    // Leg highlight strip
    _rr(canvas, Rect.fromCenter(center: Offset(w * 0.345, h * 0.875), width: w * 0.08,  height: h * 0.03),  w * 0.015, Paint()..color = Colors.white.withValues(alpha: 0.35));
    _rr(canvas, Rect.fromCenter(center: Offset(w * 0.655, h * 0.875), width: w * 0.08,  height: h * 0.03),  w * 0.015, Paint()..color = Colors.white.withValues(alpha: 0.35));

    // ── Arms ──────────────────────────────────────────────────────────────
    _rotRR(canvas, Offset(w * 0.075, h * 0.565), w * 0.13, h * 0.225, w * 0.065, -0.30, Paint()..color = cMid);
    _rotRR(canvas, Offset(w * 0.925, h * 0.565), w * 0.13, h * 0.225, w * 0.065,  0.30, Paint()..color = cMid);

    // ── Body ──────────────────────────────────────────────────────────────
    final bodyRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.515), width: w * 0.72, height: h * 0.61,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.30)),
      Paint()..shader = const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [cLight, cMid, cDark], stops: [0.0, 0.45, 1.0],
      ).createShader(bodyRect),
    );

    // Body gloss sheen
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.245), width: w * 0.24, height: h * 0.09),
      Paint()..color = Colors.white.withValues(alpha: 0.38),
    );

    // ── Antenna ───────────────────────────────────────────────────────────
    canvas.drawLine(
      Offset(w * 0.5, h * 0.205), Offset(w * 0.5, h * 0.075),
      Paint()..color = cDark..style = PaintingStyle.stroke
             ..strokeWidth = w * 0.024..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(Offset(w * 0.5, h * 0.050), w * 0.044, Paint()..color = cDark);
    canvas.drawCircle(Offset(w * 0.488, h * 0.042), w * 0.016, Paint()..color = Colors.white.withValues(alpha: 0.65));

    // ── Eye sclera ────────────────────────────────────────────────────────
    canvas.drawCircle(Offset(w * 0.5, h * 0.385), w * 0.247,
        Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.5, h * 0.385), w * 0.247,
        Paint()..color = const Color(0xFFBBDEEF)
               ..style = PaintingStyle.stroke..strokeWidth = 2.5);

    // Iris
    canvas.drawCircle(Offset(w * 0.5, h * 0.385), w * 0.160,
        Paint()..color = const Color(0xFF4A90B8));

    // Pupil
    canvas.drawCircle(Offset(w * 0.5, h * 0.385), w * 0.093,
        Paint()..color = const Color(0xFF1A3545));

    // Highlights
    canvas.drawCircle(Offset(w * 0.454, h * 0.366), w * 0.037, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.553, h * 0.416), w * 0.019, Paint()..color = Colors.white);

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

    // ── Test tube in left hand ─────────────────────────────────────────────
    canvas.save();
    canvas.translate(w * 0.152, h * 0.592);
    canvas.rotate(0.18);
    final tubePaint = Paint()..color = Colors.white.withValues(alpha: 0.88);
    _rr(canvas, Rect.fromCenter(center: Offset.zero, width: w * 0.053, height: h * 0.168), w * 0.027, tubePaint);
    canvas.drawCircle(Offset(0, -(h * 0.168 / 2 + w * 0.027)), w * 0.027, tubePaint);
    canvas.restore();
  }

  void _rr(Canvas canvas, Rect rect, double r, Paint paint) =>
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);

  void _rotRR(Canvas canvas, Offset c, double bw, double bh, double r, double angle, Paint paint) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    _rr(canvas, Rect.fromCenter(center: Offset.zero, width: bw, height: bh), r, paint);
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
    _sparkleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _cloudCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
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
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: LayoutBuilder(builder: _buildLayout),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, BoxConstraints bc) {
    final w = bc.maxWidth;
    final h = bc.maxHeight;

    return Stack(
      children: [
        _cloud(size: w * 0.9,  baseLeft: -w * 0.22, top: h * 0.05, phase: 0.00, amp: w * 0.05),
        _cloud(size: w * 0.70, baseLeft:  w * 0.43, top: h * 0.60, phase: 0.50, amp: w * 0.04),
        ..._sparkles(w, h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.025),
            Padding(
              padding: EdgeInsets.only(left: w * 0.04),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios, size: 13, color: Color(0xFF3D6B80)),
                      SizedBox(width: 3),
                      Text('Back', style: TextStyle(color: Color(0xFF3D6B80),
                          fontWeight: FontWeight.w700, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.030),
            Center(
              child: Text('Choose Your Game',
                  style: TextStyle(fontSize: math.min(30.0, w * 0.079),
                      fontWeight: FontWeight.w900, color: const Color(0xFF1A3A5C))),
            ),
            SizedBox(height: h * 0.007),
            Center(
              child: Text('Pick a fun way to learn chemistry',
                  style: TextStyle(fontSize: math.min(14.0, w * 0.036),
                      color: const Color(0xFF5A7A8A), fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: h * 0.04),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                children: [
                  const _ModeCard(
                    bg: Color(0xFFB8D4F8), border: Color(0xFF7AB0E0),
                    iconBg: Color(0xFFD8ECFF),
                    iconPainter: _BeakerIconPainter(),
                    title: 'Explore Mode', subtitle: 'Tap elements and learn',
                  ),
                  SizedBox(height: h * 0.025),
                  const _ModeCard(
                    bg: Color(0xFFFFD04A), border: Color(0xFFDDA800),
                    iconBg: Color(0xFFFFEA90),
                    iconPainter: _RobotIconPainter(),
                    title: 'Quiz Mode', subtitle: 'Answer fun questions',
                  ),
                  SizedBox(height: h * 0.025),
                  const _ModeCard(
                    bg: Color(0xFFCCAEF5), border: Color(0xFF9B72D8),
                    iconBg: Color(0xFFE8D5FF),
                    iconPainter: _StarIconPainter(),
                    title: 'Adventure Mode', subtitle: 'Earn stars and unlock levels',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cloud({
    required double size, required double baseLeft,
    required double top, required double phase, required double amp,
  }) {
    return Positioned(
      left: baseLeft, top: top,
      child: AnimatedBuilder(
        animation: _cloudCtrl,
        builder: (_, child) {
          final dx = math.sin((_cloudCtrl.value + phase) * math.pi * 2) * amp;
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: Container(
          width: size, height: size * 0.58,
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
        left: s[0] as double, top: s[1] as double,
        child: AnimatedBuilder(
          animation: _sparkleCtrl,
          builder: (_, ignored) {
            final t = (_sparkleCtrl.value + (s[4] as double)) % 1.0;
            final v = (math.sin(t * math.pi * 2) + 1) / 2;
            return Opacity(
              opacity: 0.25 + 0.75 * v,
              child: Transform.scale(scale: 0.5 + 0.5 * v,
                  child: _Sparkle(size: s[2] as double, color: Color(s[3] as int))),
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

  const _ModeCard({
    required this.bg, required this.border, required this.iconBg,
    required this.iconPainter, required this.title, required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 2.5),
          boxShadow: [
            BoxShadow(color: border.withValues(alpha: 0.35),
                blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 74, height: 74,
              decoration: BoxDecoration(shape: BoxShape.circle, color: iconBg),
              child: CustomPaint(painter: iconPainter),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 21,
                      fontWeight: FontWeight.w800, color: Color(0xFF1A3A5C))),
                  const SizedBox(height: 5),
                  Text(subtitle, style: const TextStyle(fontSize: 13,
                      color: Color(0xFF3A5A70), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
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
    final deepMask   = Path()..addRect(Rect.fromLTWH(0, h * 0.68, w, h));

    canvas.drawPath(body, Paint()..color = const Color(0xFFE0F2FF));
    canvas.drawPath(Path.combine(PathOperation.intersect, body, liquidMask),
        Paint()..color = const Color(0xFF90EEB0));
    canvas.drawPath(Path.combine(PathOperation.intersect, body, deepMask),
        Paint()..color = const Color(0xFF4ACA70));
    canvas.drawPath(body,
        Paint()..color = const Color(0xFF4A9EE0)..style = PaintingStyle.stroke
          ..strokeWidth = 2.5..strokeJoin = StrokeJoin.round);
    canvas.drawLine(Offset(w * 0.36, h * 0.14), Offset(w * 0.64, h * 0.14),
        Paint()..color = const Color(0xFF4A9EE0)..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(w * 0.38, h * 0.74), w * 0.042,
        Paint()..color = Colors.white.withValues(alpha: 0.75));
    canvas.drawCircle(Offset(w * 0.60, h * 0.80), w * 0.028,
        Paint()..color = Colors.white.withValues(alpha: 0.75));
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

    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.36,
        Paint()..color = const Color(0xFF6CBAD8));
    canvas.drawLine(Offset(w * 0.5, h * 0.16), Offset(w * 0.5, h * 0.07),
        Paint()..color = const Color(0xFF52A8C6)..strokeWidth = 2.2
          ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(w * 0.5, h * 0.05), w * 0.032,
        Paint()..color = const Color(0xFF52A8C6));
    canvas.drawCircle(Offset(w * 0.5, h * 0.50), w * 0.210,
        Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.5, h * 0.50), w * 0.135,
        Paint()..color = const Color(0xFF4A90B8));
    canvas.drawCircle(Offset(w * 0.5, h * 0.50), w * 0.075,
        Paint()..color = const Color(0xFF1A3545));
    canvas.drawCircle(Offset(w * 0.455, h * 0.470), w * 0.028,
        Paint()..color = Colors.white);
    canvas.drawPath(
      Path()..moveTo(w * 0.38, h * 0.69)
            ..quadraticBezierTo(w * 0.5, h * 0.78, w * 0.62, h * 0.69),
      Paint()..color = const Color(0xFFFF7070)..style = PaintingStyle.stroke
            ..strokeWidth = 2.2..strokeCap = StrokeCap.round,
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
    canvas.drawPath(star,
        Paint()..color = const Color(0xFFDDAA00)..style = PaintingStyle.stroke
          ..strokeWidth = 2.0..strokeJoin = StrokeJoin.round);

    canvas.drawCircle(Offset(w * 0.405, h * 0.415), w * 0.036,
        Paint()..color = const Color(0xFF1A3545));
    canvas.drawCircle(Offset(w * 0.595, h * 0.415), w * 0.036,
        Paint()..color = const Color(0xFF1A3545));
    canvas.drawCircle(Offset(w * 0.325, h * 0.478), w * 0.050,
        Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65));
    canvas.drawCircle(Offset(w * 0.675, h * 0.478), w * 0.050,
        Paint()..color = const Color(0xFFFFB0A0).withValues(alpha: 0.65));
    canvas.drawPath(
      Path()..moveTo(w * 0.385, h * 0.495)
            ..quadraticBezierTo(w * 0.5, h * 0.572, w * 0.615, h * 0.495),
      Paint()..color = const Color(0xFFCC8800)..style = PaintingStyle.stroke
            ..strokeWidth = 2.0..strokeCap = StrokeCap.round,
    );

    // Trophy cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.820),
            width: w * 0.28, height: h * 0.10),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFFD030),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.892),
            width: w * 0.36, height: h * 0.048),
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
