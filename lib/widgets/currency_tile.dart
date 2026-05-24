import 'package:expense_app/widgets/currencies.dart';
import 'package:flutter/material.dart';

class CurrencyTile extends StatefulWidget {
  final Map<String, String> currency;
  final index;
  final bool isActive;
  final bool isLast;
  final VoidCallback onTap;

  const CurrencyTile({
    required this.index,
    required this.currency,
    required this.isActive,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<CurrencyTile> createState() => CurrencyTileState();
}

class CurrencyTileState extends State<CurrencyTile> {
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
