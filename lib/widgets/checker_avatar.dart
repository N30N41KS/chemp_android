import 'package:flutter/material.dart';

/// Шахматный аватар «Stone Stellar» из макета.
class CheckerAvatar extends StatelessWidget {
  final double size;
  const CheckerAvatar({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: size * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: CustomPaint(painter: _CheckerPainter())),
    );
  }
}

class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const n = 4;
    final cell = size.width / n;
    final dark = Paint()..color = const Color(0xFF111111);
    final light = Paint()..color = Colors.white;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        canvas.drawRect(
          Rect.fromLTWH(c * cell, r * cell, cell, cell),
          (r + c) % 2 == 0 ? dark : light,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
