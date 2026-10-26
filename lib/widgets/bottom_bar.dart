import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// Нижняя панель с изогнутым выступом под центральной кнопкой (как в макете).
class AppBottomBar extends StatelessWidget {
  /// 0 - главная (центральная кнопка), 1..4 - вкладки.
  final int current;
  final ValueChanged<int> onTap;

  const AppBottomBar({super.key, required this.current, required this.onTap});

  static const double _barHeight = 64;
  static const double _bump = 22;

  Widget _item(int index, IconData icon, String label) {
    final selected = current == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: AnimatedScale(
          scale: selected ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            opacity: selected ? 1.0 : 0.65,
            duration: const Duration(milliseconds: 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: ps(9, w: FontWeight.w500, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).padding.bottom;
    final total = _barHeight + _bump + inset;
    return SizedBox(
      height: total,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: _BarPainter())),
          Positioned(
            left: 0,
            right: 0,
            bottom: inset,
            height: _barHeight,
            child: Row(
              children: [
                _item(1, Icons.equalizer_rounded, 'Statistics'),
                _item(2, Icons.location_on_outlined, 'Discover'),
                const Expanded(child: SizedBox()),
                _item(3, Icons.chat_bubble_outline_rounded, 'Chat'),
                _item(4, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
          Positioned(
            top: -6,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => onTap(0),
                child: AnimatedScale(
                  scale: current == 0 ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: current == 0
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_calendar_outlined,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cx = w / 2;
    const top = AppBottomBar._bump;
    final path = Path()
      ..moveTo(0, top)
      ..lineTo(cx - 62, top)
      ..cubicTo(cx - 36, top, cx - 38, 0, cx, 0)
      ..cubicTo(cx + 38, 0, cx + 36, top, cx + 62, top)
      ..lineTo(w, top)
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 8, false);
    final paint = Paint()
      ..shader = AppColors.gradient.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
