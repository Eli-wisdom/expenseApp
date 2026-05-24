import 'dart:async';
import 'dart:math' as math;
import 'package:expense_app/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Colors ──────────────────────────────────────────────────────────────────

const kBg = Color(0xFF080808);
const kSurface = Color(0xFF2D2D2D);
const kAccent = Color(0xFFBF00FF);

// ─── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isFocused = false;
  bool _isLoading = false;

  late final AnimationController _entryCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  late final StreamSubscription<AuthState> _authsubscription;

  @override
  void initState() {
    super.initState();

    _authsubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      event,
    ) {
      final session = event.session;
      if (session != null) {
        debugPrint("Supabase: display account");
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _authsubscription.cancel();
    _entryCtrl.dispose();
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_emailController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 56),
                    _buildHeader(),
                    const SizedBox(height: 52),
                    _buildEmailField(),
                    const SizedBox(height: 32),
                    _buildContinueButton(),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildMagicLinkButton(),
                    const SizedBox(height: 36),
                    _buildSignUpRow(),
                    const SizedBox(height: 28),
                    _buildSecurityBadge(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent bar
        Container(
          width: 32,
          height: 2,
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 22),

        const Text(
          'Welcome\nback.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          'Enter your email to continue',
          style: TextStyle(
            color: Colors.white.withOpacity(0.38),
            fontSize: 15,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ── Email Field ───────────────────────────────────────────────────────────

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMAIL',
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 10,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 10),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  _isFocused ? kAccent.withOpacity(0.55) : Colors.transparent,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              _MailIcon(
                color:
                    _isFocused
                        ? kAccent.withOpacity(0.8)
                        : Colors.white.withOpacity(0.28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.2,
                  ),
                  cursorColor: kAccent,
                  cursorWidth: 1.5,
                  decoration: InputDecoration(
                    hintText: 'you@domain.com',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.22),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'END-TO-END ENCRYPTED',
          style: TextStyle(
            color: Colors.white.withOpacity(0.2),
            fontSize: 9,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // ── Continue Button ───────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () async {
          try {
            final email = _emailController.text.trim();
            await Supabase.instance.client.auth.signInWithOtp(
              email: email,
              emailRedirectTo:
                  'io.supabase.flutterquickstart://login-callback/',
            );

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please check your email")),
              );
            }
          } on AuthApiException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please check your email"),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("supabase: Error occured plese"),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          disabledBackgroundColor: kAccent.withOpacity(0.55),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1.5,
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 17),
                  ],
                ),
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────────────────────

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 0.5, color: Colors.white.withOpacity(0.09)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white.withOpacity(0.22),
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 0.5, color: Colors.white.withOpacity(0.09)),
        ),
      ],
    );
  }

  // ── Magic Link Button ─────────────────────────────────────────────────────

  Widget _buildMagicLinkButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kSurface, width: 1),
          foregroundColor: Colors.white.withOpacity(0.45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 15),
            const SizedBox(width: 8),
            Text(
              'Send magic link',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.45),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sign Up Row ───────────────────────────────────────────────────────────

  Widget _buildSignUpRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No account?  ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.28),
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Create one →',
              style: TextStyle(
                color: kAccent.withOpacity(0.78),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Security Badge ────────────────────────────────────────────────────────

  Widget _buildSecurityBadge() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_rounded,
            size: 11,
            color: Colors.white.withOpacity(0.22),
          ),
          const SizedBox(width: 6),
          Text(
            'SECURED · AES-256',
            style: TextStyle(
              color: Colors.white.withOpacity(0.2),
              fontSize: 9,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mail Icon Widget ─────────────────────────────────────────────────────────

class _MailIcon extends StatelessWidget {
  final Color color;
  const _MailIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _MailPainter(color: color)),
    );
  }
}

class _MailPainter extends CustomPainter {
  final Color color;
  _MailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Envelope body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0.5,
          size.height * 0.18,
          size.width - 1,
          size.height * 0.65,
        ),
        const Radius.circular(2.5),
      ),
      paint,
    );

    // Chevron flap
    canvas.drawPath(
      Path()
        ..moveTo(0.5, size.height * 0.28)
        ..lineTo(size.width / 2, size.height * 0.62)
        ..lineTo(size.width - 0.5, size.height * 0.28),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MailPainter old) => old.color != color;
}
