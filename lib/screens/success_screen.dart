import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/press_scale.dart';

/// Полупрозрачный маршрут: форма расписания видна под размытием.
Route<String> successRoute() {
  return PageRouteBuilder<String>(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondary) => const SuccessScreen(),
    transitionsBuilder: (context, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ring = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
    );
    final check = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
    );
    final burst = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: AppColors.primary.withValues(alpha: 0.82)),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _c,
                    builder: (context, _) {
                      return SizedBox(
                        width: 220,
                        height: 220,
                        child: CustomPaint(
                          painter: _SuccessPainter(
                            ring: ring.value.clamp(0.0, 1.2).toDouble(),
                            check: check.value,
                            burst: burst.value,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  FadeSlide(
                    delay: const Duration(milliseconds: 700),
                    child: Text(
                      'Published\nSuccessful',
                      textAlign: TextAlign.center,
                      style: ps(18, w: FontWeight.w700, color: Colors.white, h: 1.25),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeSlide(
                    delay: const Duration(milliseconds: 850),
                    child: Text(
                      'Wanna change/edit your\nscheduled games before it begins?',
                      textAlign: TextAlign.center,
                      style: ps(10.5, color: Colors.white.withValues(alpha: 0.9), h: 1.5),
                    ),
                  ),
                  const SizedBox(height: 22),
                  FadeSlide(
                    delay: const Duration(milliseconds: 1000),
                    child: PressScale(
                      onTap: () => Navigator.of(context).pop('stats'),
                      child: Container(
                        width: 190,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Statistics',
                          style: ps(13, w: FontWeight.w600, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessPainter extends CustomPainter {
  final double ring;
  final double check;
  final double burst;

  _SuccessPainter({required this.ring, required this.check, required this.burst});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const r = 56.0;

    // искры
    if (burst > 0) {
      final p = Paint()
        ..color = Colors.white.withValues(alpha: (1 - burst).clamp(0.0, 1.0).toDouble());
      for (var i = 0; i < 14; i++) {
        final a = i * (math.pi * 2 / 14);
        final dist = r + 14 + burst * 38;
        canvas.drawCircle(
          c + Offset(math.cos(a) * dist, math.sin(a) * dist),
          3.2 * (1 - burst * 0.5),
          p,
        );
      }
    }

    // расходящаяся волна
    if (burst > 0) {
      canvas.drawCircle(
        c,
        r + burst * 46,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: (0.6 * (1 - burst)).clamp(0.0, 1.0).toDouble()),
      );
    }

    // внешнее кольцо и белый круг
    canvas.drawCircle(
      c,
      (r + 10) * ring,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );
    canvas.drawCircle(
      c,
      r * ring,
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );

    // галочка рисуется по прогрессу
    final path = Path()
      ..moveTo(c.dx - 22, c.dy + 2)
      ..lineTo(c.dx - 6, c.dy + 18)
      ..lineTo(c.dx + 24, c.dy - 16);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 7
      ..color = Colors.white;
    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * check), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessPainter old) =>
      old.ring != ring || old.check != check || old.burst != burst;
}
