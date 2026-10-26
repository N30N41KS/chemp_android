import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Плавно «парящий» виджет (вверх-вниз).
class Floaty extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration period;
  final double phase;

  const Floaty({
    super.key,
    required this.child,
    this.amplitude = 8,
    this.period = const Duration(seconds: 3),
    this.phase = 0,
  });

  @override
  State<Floaty> createState() => _FloatyState();
}

class _FloatyState extends State<Floaty> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.period);
    _c.value = widget.phase.clamp(0.0, 1.0).toDouble();
    _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final v = (Curves.easeInOut.transform(_c.value) - 0.5) * 2;
        return Transform.translate(
          offset: Offset(0, v * widget.amplitude),
          child: child,
        );
      },
    );
  }
}

enum SceneKind { play, schedule, chat, welcome, join }

class _Badge {
  final IconData icon;
  final Color color;
  final Alignment at;
  final double phase;
  const _Badge(this.icon, this.color, this.at, this.phase);
}

/// Иллюстрация, нарисованная кодом: розовое «пятно» + карточка + парящие значки.
/// Если из Figma экспортированы PNG, используйте [Illustration].
class HeroScene extends StatelessWidget {
  final SceneKind kind;
  final double size;

  const HeroScene({super.key, required this.kind, this.size = 240});

  IconData get _center {
    switch (kind) {
      case SceneKind.play:
        return Icons.sports_esports;
      case SceneKind.schedule:
        return Icons.calendar_month;
      case SceneKind.chat:
        return Icons.forum;
      case SceneKind.welcome:
        return Icons.videogame_asset;
      case SceneKind.join:
        return Icons.group_add;
    }
  }

  List<_Badge> get _badges {
    switch (kind) {
      case SceneKind.play:
        return const [
          _Badge(Icons.monetization_on, Color(0xFFFFB400), Alignment(0.85, -0.7), 0.0),
          _Badge(Icons.star_rounded, Color(0xFF7C5CFF), Alignment(-0.85, -0.5), 0.4),
          _Badge(Icons.emoji_events, Color(0xFFFF8A00), Alignment(-0.8, 0.7), 0.7),
          _Badge(Icons.bolt, Color(0xFF00B894), Alignment(0.8, 0.75), 0.2),
        ];
      case SceneKind.schedule:
        return const [
          _Badge(Icons.alarm, Color(0xFF7C5CFF), Alignment(0.85, -0.65), 0.1),
          _Badge(Icons.groups, Color(0xFF00B894), Alignment(-0.85, -0.4), 0.5),
          _Badge(Icons.check_circle, Color(0xFFFFB400), Alignment(-0.7, 0.8), 0.8),
          _Badge(Icons.sports_esports, Color(0xFFE94560), Alignment(0.8, 0.7), 0.3),
        ];
      case SceneKind.chat:
        return const [
          _Badge(Icons.headset_mic, Color(0xFF7C5CFF), Alignment(-0.85, -0.6), 0.0),
          _Badge(Icons.videocam, Color(0xFF00B894), Alignment(0.85, -0.5), 0.5),
          _Badge(Icons.mic, Color(0xFFFFB400), Alignment(0.75, 0.8), 0.3),
          _Badge(Icons.favorite, Color(0xFFE94560), Alignment(-0.75, 0.75), 0.7),
        ];
      case SceneKind.welcome:
        return const [
          _Badge(Icons.star_rounded, Color(0xFFFFB400), Alignment(0.85, -0.6), 0.2),
          _Badge(Icons.headset, Color(0xFF7C5CFF), Alignment(-0.85, -0.45), 0.6),
          _Badge(Icons.emoji_events, Color(0xFFFF8A00), Alignment(0.7, 0.8), 0.4),
        ];
      case SceneKind.join:
        return const [
          _Badge(Icons.person_add, Color(0xFF7C5CFF), Alignment(0.85, -0.6), 0.3),
          _Badge(Icons.sports_esports, Color(0xFFE94560), Alignment(-0.85, -0.5), 0.6),
          _Badge(Icons.local_fire_department, Color(0xFFFF8A00), Alignment(-0.7, 0.8), 0.1),
          _Badge(Icons.star_rounded, Color(0xFFFFB400), Alignment(0.8, 0.75), 0.8),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final badges = _badges;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, v, child) {
        return Transform.scale(
          scale: v.clamp(0.0, 1.2).toDouble(),
          child: Opacity(opacity: v.clamp(0.0, 1.0).toDouble(), child: child),
        );
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Floaty(
                amplitude: 4,
                period: const Duration(seconds: 4),
                child: CustomPaint(painter: _BlobPainter()),
              ),
            ),
            Center(
              child: Floaty(
                amplitude: 6,
                child: Container(
                  width: size * 0.46,
                  height: size * 0.46,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(size * 0.12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(_center, size: size * 0.26, color: Colors.white),
                ),
              ),
            ),
            for (final b in badges)
              Align(
                alignment: b.at,
                child: Floaty(
                  amplitude: 7,
                  phase: b.phase,
                  period: Duration(milliseconds: 2200 + (b.phase * 1500).round()),
                  child: Container(
                    padding: EdgeInsets.all(size * 0.035),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(b.icon, size: size * 0.1, color: b.color),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.12, h * 0.45)
      ..cubicTo(w * 0.0, h * 0.2, w * 0.3, h * 0.0, w * 0.55, h * 0.08)
      ..cubicTo(w * 0.85, h * 0.15, w * 1.0, h * 0.35, w * 0.92, h * 0.62)
      ..cubicTo(w * 0.85, h * 0.88, w * 0.55, h * 1.0, w * 0.3, h * 0.9)
      ..cubicTo(w * 0.12, h * 0.82, w * 0.2, h * 0.65, w * 0.12, h * 0.45)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.blob);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Берёт PNG из assets (экспорт из Figma); если файла нет - рисует [HeroScene].
class Illustration extends StatelessWidget {
  final String asset;
  final SceneKind kind;
  final double size;

  const Illustration({
    super.key,
    required this.asset,
    required this.kind,
    this.size = 240,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) =>
          HeroScene(kind: kind, size: size),
    );
  }
}
