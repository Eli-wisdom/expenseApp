import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/analysis');
        break;
      case 2:
        context.go('/share');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Shared container styles for the "No-Line" precision aesthetic.
    // The background grid lines are typically layered behind the scaffold.
    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          
          // structural grid lines
          Positioned(
            left: MediaQuery.of(context).size.width * 0.05,
            top: 0,
            bottom: 0,
            width: 1,
            child: Container(color: CyberTheme.outlineVariant.withValues(alpha: 0.1)),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.05,
            top: 0,
            bottom: 0,
            width: 1,
            child: Container(color: CyberTheme.outlineVariant.withValues(alpha: 0.1)),
          ),

          // Main Content
          SafeArea(bottom: false, child: widget.child).animate().fadeIn(duration: 300.ms),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: CyberTheme.surface.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: CyberTheme.outlineVariant.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          boxShadow: [
             BoxShadow(
              color: CyberTheme.primaryContainer.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, -4),
            )
          ]
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.account_balance_wallet_outlined, 'WALLET', Icons.account_balance_wallet, context),
                _buildNavItem(1, Icons.analytics_outlined, 'ANALYSIS', Icons.analytics, context),
                _buildNavItem(2, Icons.hub_outlined, 'PORTAL', Icons.hub, context),
                _buildNavItem(3, Icons.inventory_2_outlined, 'ARCHIVE', Icons.inventory_2, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconOutlined, String label, IconData iconFilled, BuildContext context) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? CyberTheme.primary : CyberTheme.onSurfaceVariant;
    final bgColor = isSelected ? CyberTheme.primaryContainer.withValues(alpha: 0.1) : Colors.transparent;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index, context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? iconFilled : iconOutlined,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.getFont('Space Grotesk', 
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF514254).withValues(alpha: 0.05)
      ..strokeWidth = 1;
    
    const double step = 40;
    
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

