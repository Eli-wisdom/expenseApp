import 'package:expense_app/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── THEME COLORS ──────────────────────────────────────────────────────────────
const Color kNeon = Color(0xFFBF00FF);
const Color kSurface = Color(0xFF2D2D2D);
const Color kVoid = Color(0xFF080808);
const Color kNeonDim = Color(0x44BF00FF);
const Color kNeonMid = Color(0x88BF00FF);

// ─── ALL WORLD CURRENCIES ──────────────────────────────────────────────────────

// ─── APP ───────────────────────────────────────────────────────────────────────

// ─── MAIN SCREEN ───────────────────────────────────────────────────────────────
class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyFormScreenState();
}

class _CurrencyFormScreenState extends State<CurrencyScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  Map<String, String>? _selected;
  late AnimationController _glitch;
  bool _emailFocused = false;

  @override
  void initState() {
    super.initState();
    _glitch = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _emailFocus.addListener(
      () => setState(() => _emailFocused = _emailFocus.hasFocus),
    );
  }

  @override
  void dispose() {
    _glitch.dispose();
    _emailCtrl.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _openCurrencyDialog() async {
    debugPrint("################ check currency ");
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) => CurrencyDialog(currentSelection: _selected),
    );
    if (result != null) setState(() => _selected = result);
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      HapticFeedback.heavyImpact();
      _showToast('INVALID EMAIL ADDRESS', isError: true);
      return;
    }
    HapticFeedback.lightImpact();
    _showToast('INITIALIZED — ${_selected?['code'] ?? 'NO CURRENCY'}');
  }

  void _showToast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: kSurface,
            border: Border.all(color: isError ? Colors.redAccent : kNeon),
          ),
          child: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: isError ? Colors.redAccent : kNeon,
                size: 15,
              ),
              const SizedBox(width: 10),
              Text(
                msg,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: isError ? Colors.redAccent : kNeon,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kVoid,
      body: Stack(
        children: [
          CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
          AnimatedBuilder(
            animation: _glitch,
            builder:
                (_, __) => CustomPaint(
                  painter: _ScanlinePainter(_glitch.value),
                  child: const SizedBox.expand(),
                ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _glitch,
          builder:
              (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(_glitch.value * 3, 0),
                    child: Text(
                      'CYPHER',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: kNeon.withOpacity(0.3),
                        letterSpacing: 12,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-_glitch.value * 2, 0),
                    child: const Text(
                      'CYPHER',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: kNeon,
                        letterSpacing: 12,
                      ),
                    ),
                  ),
                ],
              ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 40, height: 1, color: kNeonMid),
            const SizedBox(width: 12),
            const Text(
              'EXCHANGE PROTOCOL v2.4',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: kNeonMid,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 40, height: 1, color: kNeonMid),
          ],
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: kSurface.withOpacity(0.85),
        border: Border.all(color: kNeonDim, width: 1),
        boxShadow: [
          BoxShadow(
            color: kNeon.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kNeonDim)),
              color: kVoid,
            ),
            child: Row(
              children: [
                Container(width: 8, height: 8, color: kNeon),
                const SizedBox(width: 10),
                const Text(
                  'IDENTITY REGISTRATION',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: kNeon,
                    letterSpacing: 3,
                  ),
                ),
                const Spacer(),
                _PulseDot(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('// EMAIL ADDRESS'),
                const SizedBox(height: 8),
                _emailField(),
                const SizedBox(height: 28),
                _label('// PREFERRED CURRENCY'),
                const SizedBox(height: 8),
                _currencySelector(),
                const SizedBox(height: 32),
                _submitButton(),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'ENCRYPTED · DECENTRALIZED · SECURE',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: kNeon.withOpacity(0.35),
                      letterSpacing: 2,
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

  Widget _label(String t) => Text(
    t,
    style: TextStyle(
      fontFamily: 'monospace',
      fontSize: 10,
      color: kNeon.withOpacity(0.6),
      letterSpacing: 2,
    ),
  );

  Widget _emailField() => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    decoration: BoxDecoration(
      color: kVoid,
      border: Border.all(
        color: _emailFocused ? kNeon : kNeonDim,
        width: _emailFocused ? 1.5 : 1,
      ),
      boxShadow:
          _emailFocused
              ? [BoxShadow(color: kNeon.withOpacity(0.15), blurRadius: 12)]
              : [],
    ),
    child: TextField(
      controller: _emailCtrl,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        color: Colors.white,
        letterSpacing: 1,
      ),
      cursorColor: kNeon,
      decoration: InputDecoration(
        hintText: 'operator@domain.net',
        hintStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Colors.white.withOpacity(0.2),
          letterSpacing: 1,
        ),
        prefixIcon: Icon(
          Icons.alternate_email,
          size: 16,
          color: kNeon.withOpacity(0.6),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    ),
  );

  Widget _currencySelector() => GestureDetector(
    onTap: _openCurrencyDialog,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kVoid,
        border: Border.all(color: kNeonDim),
      ),
      child: Row(
        children: [
          Icon(
            Icons.currency_exchange,
            size: 16,
            color: kNeon.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                _selected == null
                    ? Text(
                      'SELECT CURRENCY',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.2),
                        letterSpacing: 1,
                      ),
                    )
                    : Row(
                      children: [
                        Text(
                          _selected!['symbol']!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 16,
                            color: kNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _selected!['code']!,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${_selected!['name']}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: kNeon.withOpacity(0.6),
            size: 18,
          ),
        ],
      ),
    ),
  );

  Widget _submitButton() => GestureDetector(
    onTap: _submit,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kNeon,
        boxShadow: [
          BoxShadow(
            color: kNeon.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        'INITIALIZE CONNECTION',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: kVoid,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
        ),
      ),
    ),
  );
}

// ─── CURRENCY DIALOG ───────────────────────────────────────────────────────────
class CurrencyDialog extends StatefulWidget {
  final Map<String, String>? currentSelection;
  const CurrencyDialog({super.key, this.currentSelection});

  @override
  State<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<CurrencyDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  final TextEditingController _search = TextEditingController();
  List<Map<String, String>> _filtered = kCurrencies;
  Map<String, String>? _hovered;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered =
          q.isEmpty
              ? kCurrencies
              : kCurrencies
                  .where(
                    (c) =>
                        c['code']!.toLowerCase().contains(q) ||
                        c['name']!.toLowerCase().contains(q) ||
                        c['symbol']!.toLowerCase().contains(q),
                  )
                  .toList();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _search.dispose();
    super.dispose();
  }

  void _select(Map<String, String> c) {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop(c);
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
            decoration: BoxDecoration(
              color: kSurface,
              border: Border(
                top: BorderSide(color: kNeon, width: 2),
                left: BorderSide(color: kNeonDim, width: 1),
                right: BorderSide(color: kNeonDim, width: 1),
                bottom: BorderSide(color: kNeonDim, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: kNeon.withOpacity(0.22),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: kNeon.withOpacity(0.08),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildSearch(),
                Flexible(child: _buildList()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    decoration: const BoxDecoration(
      color: kVoid,
      border: Border(bottom: BorderSide(color: kNeonDim)),
    ),
    child: Row(
      children: [
        Container(
          width: 7,
          height: 7,
          color: kNeon,
          margin: const EdgeInsets.only(right: 10),
        ),
        const Text(
          'SELECT CURRENCY NODE',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: kNeon,
            letterSpacing: 3,
          ),
        ),
        const Spacer(),
        Text(
          '${_filtered.length} FOUND',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 9,
            color: kNeon.withOpacity(0.45),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: _close,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(border: Border.all(color: kNeonDim)),
            child: Icon(Icons.close, size: 13, color: kNeon.withOpacity(0.7)),
          ),
        ),
      ],
    ),
  );

  Widget _buildSearch() => Container(
    decoration: const BoxDecoration(
      color: kVoid,
      border: Border(bottom: BorderSide(color: kNeonDim)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: Row(
      children: [
        Icon(Icons.search, size: 14, color: kNeon.withOpacity(0.55)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _search,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            cursorColor: kNeon,
            decoration: InputDecoration(
              hintText: 'SEARCH...',
              hintStyle: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.white.withOpacity(0.2),
                letterSpacing: 1.5,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'NO NODES FOUND',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: kNeon.withOpacity(0.35),
              letterSpacing: 3,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _filtered.length,
      itemBuilder: (context, i) {
        final c = _filtered[i];
        final isActive = widget.currentSelection?['code'] == c['code'];
        final isLast = i == _filtered.length - 1;

        return _CurrencyTile(
          currency: c,
          isActive: isActive,
          isLast: isLast,
          onTap: () => _select(c),
        );
      },
    );
  }

  Widget _buildFooter() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    decoration: const BoxDecoration(
      color: kVoid,
      border: Border(top: BorderSide(color: kNeonDim)),
    ),
    child: Row(
      children: [
        Text(
          'CYPHER EXCHANGE v2.4',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 8,
            color: kNeon.withOpacity(0.28),
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _close,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: kNeonDim)),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: kNeon.withOpacity(0.55),
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── CURRENCY TILE ─────────────────────────────────────────────────────────────
class _CurrencyTile extends StatefulWidget {
  final Map<String, String> currency;
  final bool isActive;
  final bool isLast;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.currency,
    required this.isActive,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_CurrencyTile> createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<_CurrencyTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hover = true),
      onTapUp: (_) {
        setState(() => _hover = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color:
              _hover || widget.isActive
                  ? kNeon.withOpacity(widget.isActive ? 0.12 : 0.06)
                  : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: widget.isActive ? kNeon : Colors.transparent,
              width: 2,
            ),
            bottom: BorderSide(
              color:
                  widget.isLast
                      ? Colors.transparent
                      : kNeonDim.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            // Symbol badge
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kVoid,
                border: Border.all(
                  color: widget.isActive ? kNeonMid : kNeonDim,
                ),
              ),
              child: Text(
                widget.currency['symbol']!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: kNeon,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Code + name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currency['code']!,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: widget.isActive ? kNeon : Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.currency['name']!,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: Colors.white.withOpacity(0.38),
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            widget.isActive
                ? const Icon(Icons.check, color: kNeon, size: 14)
                : Icon(
                  Icons.chevron_right,
                  color: kNeon.withOpacity(0.25),
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}

// ─── PULSE DOT ────────────────────────────────────────────────────────────────
class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder:
        (_, __) => Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kNeon.withOpacity(0.4 + 0.6 * _ctrl.value),
            boxShadow: [
              BoxShadow(
                color: kNeon.withOpacity(_ctrl.value * 0.8),
                blurRadius: 6,
              ),
            ],
          ),
        ),
  );
}

// ─── PAINTERS ─────────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p =
        Paint()
          ..color = kNeon.withOpacity(0.04)
          ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ScanlinePainter extends CustomPainter {
  final double t;
  _ScanlinePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final scanY = size.height * t;
    final p =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              kNeon.withOpacity(0.03),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(0, scanY - 60, size.width, 120));
    canvas.drawRect(Rect.fromLTWH(0, scanY - 60, size.width, 120), p);
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => old.t != t;
}
