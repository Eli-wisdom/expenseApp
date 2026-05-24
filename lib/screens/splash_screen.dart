import 'dart:math';
import 'package:expense_app/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _redirect();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _redirect() async {
    debugPrint("supabasex   in _redirect");
    await Future.delayed(Duration.zero);
    final session = Supabase.instance.client.auth.currentSession;
    final userId = supabase.auth.currentUser!.id;
    try {
      final response =
          await Supabase.instance.client
              .from('profiles')
              .select('id')
              .eq('id', userId)
              .maybeSingle();

      //if (!mounted) return;
      context.go('/home');

      // if (response != null) {
      //   debugPrint("supabasex  Display account");
      //   context.go('/home');
      // } else if (session != null) {
      //   context.go('/account');
      // } else {
      //   debugPrint("supabasex  Display login");
      //   context.go('/login');
      // }
    } catch (error) {
      debugPrint("supabasex " + error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXUS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF080808),
        fontFamily: 'Courier',
      ),
      home: const CyberSplashScreen(),
    );
  }
}

// ─── Color palette ───────────────────────────────────────────────────────────
const kPurple = Color(0xFFBF00FF);
const kDark = Color(0xFF2D2D2D);
const kBlack = Color(0xFF080808);

// ─── Main screen ─────────────────────────────────────────────────────────────
class CyberSplashScreen extends StatefulWidget {
  const CyberSplashScreen({super.key});

  @override
  State<CyberSplashScreen> createState() => _CyberSplashScreenState();
}

class _CyberSplashScreenState extends State<CyberSplashScreen>
    with SingleTickerProviderStateMixin {
  // Only the rotate controller remains
  late final AnimationController _rotateController;

  final TextEditingController _emailCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  bool _inputFocused = false;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _emailFocus.addListener(() {
      setState(() => _inputFocused = _emailFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _emailCtrl.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          // Grid background (static)
          const Positioned.fill(child: _CyberGrid()),

          // Corner brackets (static)
          ..._buildCorners(),

          // Status bar (static)
          _buildStatusBar(),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo ring — only animation in the screen
                    _LogoRing(rotateController: _rotateController),
                    const SizedBox(height: 20),

                    Text(
                      '// SYSTEM ACCESS //',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 9,
                        letterSpacing: 4,
                        color: kPurple.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ShaderMask(
                      shaderCallback:
                          (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFE0AAFF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                      child: const Text(
                        'SPLASH',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'SECURE PROTOCOL v2.4',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 9,
                        letterSpacing: 3,
                        color: kPurple,
                      ),
                    ),
                    const SizedBox(height: 28),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 9,
                          letterSpacing: 2,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        children: [
                          const TextSpan(text: 'ENCRYPTED CHANNEL  ·  '),
                          TextSpan(
                            text: 'AES-256',
                            style: TextStyle(color: kPurple.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 22.0;
    const offset = 20.0;
    return [
      Positioned(
        top: offset,
        left: offset,
        child: _Corner(size, [_Side.top, _Side.left]),
      ),
      Positioned(
        top: offset,
        right: offset,
        child: _Corner(size, [_Side.top, _Side.right]),
      ),
      Positioned(
        bottom: offset,
        left: offset,
        child: _Corner(size, [_Side.bottom, _Side.left]),
      ),
      Positioned(
        bottom: offset,
        right: offset,
        child: _Corner(size, [_Side.bottom, _Side.right]),
      ),
    ];
  }

  Widget _buildStatusBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SYS_ONLINE',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 8,
                letterSpacing: 1,
                color: kPurple.withOpacity(0.4),
              ),
            ),
            Text(
              '00:00',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 8,
                letterSpacing: 1,
                color: kPurple.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid background ──────────────────────────────────────────────────────────
class _CyberGrid extends StatelessWidget {
  const _CyberGrid();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GridPainter());
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = kPurple.withOpacity(0.055)
          ..strokeWidth = 0.7;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Corner bracket ───────────────────────────────────────────────────────────
enum _Side { top, bottom, left, right }

class _Corner extends StatelessWidget {
  const _Corner(this.size, this.sides);
  final double size;
  final List<_Side> sides;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _CornerPainter(sides)),
  );
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter(this.sides);
  final List<_Side> sides;

  @override
  void paint(Canvas canvas, Size size) {
    final p =
        Paint()
          ..color = kPurple.withOpacity(0.7)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    if (sides.contains(_Side.top))
      canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
    if (sides.contains(_Side.bottom))
      canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width, size.height),
        p,
      );
    if (sides.contains(_Side.left))
      canvas.drawLine(Offset.zero, Offset(0, size.height), p);
    if (sides.contains(_Side.right))
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        p,
      );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Logo ring ────────────────────────────────────────────────────────────────
class _LogoRing extends StatelessWidget {
  const _LogoRing({required this.rotateController});
  final AnimationController rotateController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Static outer ring
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kPurple, width: 1.5),
            ),
          ),
          // Rotating dashed ring — the sole animation
          AnimatedBuilder(
            animation: rotateController,
            builder:
                (_, __) => Transform.rotate(
                  angle: rotateController.value * 2 * pi,
                  child: CustomPaint(
                    size: const Size(62, 62),
                    painter: _DashedCirclePainter(),
                  ),
                ),
          ),
          // Static hexagon
          CustomPaint(size: const Size(36, 36), painter: _HexPainter()),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p =
        Paint()
          ..color = kPurple.withOpacity(0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    const dashCount = 18;
    final r = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < dashCount; i++) {
      final start = (2 * pi / dashCount) * i;
      final sweep = (pi / dashCount) * 0.6;
      canvas.drawPath(
        Path()..arcTo(
          Rect.fromCircle(center: center, radius: r),
          start,
          sweep,
          true,
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _HexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    List<Offset> pts(double radius) => List.generate(
      6,
      (i) => Offset(
        cx + radius * cos(pi / 6 + (pi / 3) * i),
        cy + radius * sin(pi / 6 + (pi / 3) * i),
      ),
    );

    Path poly(List<Offset> p) {
      final path = Path()..moveTo(p[0].dx, p[0].dy);
      for (final o in p.skip(1)) path.lineTo(o.dx, o.dy);
      return path..close();
    }

    canvas.drawPath(poly(pts(r)), Paint()..color = kPurple.withOpacity(0.08));
    canvas.drawPath(
      poly(pts(r)),
      Paint()
        ..color = kPurple
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      poly(pts(r * 0.62)),
      Paint()
        ..color = kPurple.withOpacity(0.4)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      4,
      Paint()..color = kPurple.withOpacity(0.9),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Glowing divider ─────────────────────────────────────────────────────────
class _GlowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    child: CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _GlowDividerPainter(),
    ),
  );
}

class _GlowDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset.zero,
      Offset(size.width, 0),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            kPurple.withOpacity(0.5),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, 1)),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Cyber text field ─────────────────────────────────────────────────────────
class _CyberTextField extends StatelessWidget {
  const _CyberTextField({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isFocused ? kPurple.withOpacity(0.05) : kDark.withOpacity(0.6),
        border: Border(
          top: BorderSide(color: kDark, width: 1),
          left: BorderSide(color: kDark, width: 1),
          right: BorderSide(color: kDark, width: 1),
          bottom: BorderSide(color: kPurple, width: 1),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '>',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
                color: kPurple,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                color: Colors.white,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                hintText: 'user@domain.net',
                hintStyle: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.2),
                  letterSpacing: 1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
              cursorColor: kPurple,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cyber button (static) ────────────────────────────────────────────────────
class _CyberButton extends StatelessWidget {
  const _CyberButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
            color: Color(0xFF080808),
          ),
        ),
      ),
    );
  }
}
