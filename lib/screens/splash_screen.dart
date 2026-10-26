import 'dart:async';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/illustration.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _timer = Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        fadeRoute(const OnboardingScreen(), ms: 700),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  Widget _deco(IconData icon, double size, Alignment at, double phase,
      {double alpha = 0.55}) {
    return Align(
      alignment: at,
      child: Floaty(
        amplitude: 9,
        phase: phase,
        period: Duration(milliseconds: 2400 + (phase * 1600).round()),
        child: Icon(icon, size: size, color: Colors.white.withValues(alpha: alpha)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logo = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
    );
    final title = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.35, 0.8, curve: Curves.easeOutCubic),
    );
    final tag = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splash),
        child: Stack(
          children: [
            _deco(Icons.star_rounded, 18, const Alignment(-0.7, 0.55), 0.1),
            _deco(Icons.favorite, 16, const Alignment(-0.25, 0.8), 0.5),
            _deco(Icons.circle_outlined, 22, const Alignment(0.55, 0.62), 0.3),
            _deco(Icons.mail_outline, 22, const Alignment(0.8, 0.85), 0.8),
            _deco(Icons.check_circle_outline, 20, const Alignment(0.9, 0.35), 0.6),
            _deco(Icons.star_border_rounded, 26, const Alignment(-0.9, 0.9), 0.9),
            _deco(Icons.lightbulb_outline, 18, const Alignment(-0.45, 0.65), 0.4),
            Center(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: logo.value.clamp(0.0, 1.3).toDouble(),
                        child: Opacity(
                          opacity: logo.value.clamp(0.0, 1.0).toDouble(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 78,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Icon(
                                  Icons.sports_esports,
                                  size: 34,
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Opacity(
                        opacity: title.value,
                        child: Transform.translate(
                          offset: Offset(0, 14 * (1 - title.value)),
                          child: Text(
                            'GAAMETIIME',
                            style: ps(
                              24,
                              w: FontWeight.w700,
                              color: Colors.white,
                              ls: 10 - 8 * title.value,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Opacity(
                        opacity: tag.value,
                        child: Text(
                          'CONNECT WITH YOUR REALITY',
                          style: ps(
                            8,
                            w: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                            ls: 1.6,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
