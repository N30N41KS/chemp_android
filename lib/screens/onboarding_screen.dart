import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/gradient_button.dart';
import '../widgets/illustration.dart';
import '../widgets/press_scale.dart';
import 'login_screen.dart';

class _Page {
  final String title;
  final String text;
  final String asset;
  final SceneKind kind;
  const _Page(this.title, this.text, this.asset, this.kind);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const _pages = [
    _Page(
      'Get Paid! Playing\nVideo Game',
      'Earn points and real cash when you win a battle with no delay in cashing out',
      'assets/images/onboarding1.png',
      SceneKind.play,
    ),
    _Page(
      'Schedule Games\nWith Friends',
      'Easily create an upcoming event and get ready for battle. Yeah! real combat fella.',
      'assets/images/onboarding2.png',
      SceneKind.schedule,
    ),
    _Page(
      'Text, Audio and\nVideo Chat',
      'Intuitive real life experience on mobile. Chat with fellow gamers before and after combat for free!',
      'assets/images/onboarding3.png',
      SceneKind.chat,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() {
    Navigator.of(context).pushReplacement(fadeRoute(const LoginScreen()));
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  double _pageValue() {
    if (_controller.hasClients && _controller.position.haveDimensions) {
      return _controller.page ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final delta = i - _pageValue();
                      final fade = (1 - delta.abs()).clamp(0.0, 1.0).toDouble();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: fade,
                              child: Transform.translate(
                                offset: Offset(delta * 160, 0),
                                child: Transform.scale(
                                  scale: 1 - 0.2 * delta.abs().clamp(0.0, 1.0).toDouble(),
                                  child: Illustration(
                                    asset: p.asset,
                                    kind: p.kind,
                                    size: 270,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Opacity(
                              opacity: fade,
                              child: Transform.translate(
                                offset: Offset(delta * 70, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      p.title,
                                      textAlign: TextAlign.center,
                                      style: ps(
                                        18,
                                        w: FontWeight.w700,
                                        color: AppColors.primary,
                                        h: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      p.text,
                                      textAlign: TextAlign.center,
                                      style: ps(
                                        11.5,
                                        color: AppColors.textDark,
                                        h: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: _index == i
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 76,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim),
                      child: child,
                    ),
                  ),
                  child: last
                      ? Align(
                          key: const ValueKey('start'),
                          alignment: Alignment.topCenter,
                          child: GradientButton(
                            label: "Let's Combat!",
                            width: 190,
                            onTap: _goLogin,
                          ),
                        )
                      : Row(
                          key: const ValueKey('nav'),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: _goLogin,
                              child: Text(
                                'Skip',
                                style: ps(
                                  12,
                                  w: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            PressScale(
                              onTap: _next,
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
