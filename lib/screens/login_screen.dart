import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/fade_slide.dart';
import '../widgets/gradient_button.dart';
import '../widgets/illustration.dart';
import '../widgets/press_scale.dart';
import 'create_account_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(const MainShell(), ms: 600),
      (route) => false,
    );
  }

  Widget _social(String text, Color color) {
    return PressScale(
      onTap: () =>
          toast(context, 'Вход через соцсети — в этом прототипе не подключён'),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Text(
          text,
          style: ps(12, w: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 4, 32, 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeSlide(
                  child: Center(
                    child: Illustration(
                      asset: 'assets/images/login.png',
                      kind: SceneKind.welcome,
                      size: 210,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    'Welcome Back!',
                    style: ps(20, w: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 2),
                FadeSlide(
                  delay: const Duration(milliseconds: 220),
                  child: Text(
                    'Hi, Kindly login to continue battle',
                    style: ps(10.5),
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlide(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    label: 'Email',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return 'Введите email';
                      if (!t.contains('@') || !t.contains('.')) {
                        return 'Некорректный email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlide(
                  delay: const Duration(milliseconds: 380),
                  child: PasswordField(
                    controller: _pass,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    validator: (v) {
                      if ((v ?? '').length < 4) return 'Минимум 4 символа';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 6),
                FadeSlide(
                  delay: const Duration(milliseconds: 440),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => toast(context, 'Сброс пароля — демо'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text('Forgot Password?', style: ps(9.5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlide(
                  delay: const Duration(milliseconds: 520),
                  child: GradientButton(
                    label: "Let's Combat!",
                    loading: _loading,
                    onTap: _submit,
                  ),
                ),
                const SizedBox(height: 26),
                FadeSlide(
                  delay: const Duration(milliseconds: 600),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Connect With:',
                          style: ps(
                            10,
                            w: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _social('G+', const Color(0xFFE5483B)),
                            const SizedBox(width: 14),
                            _social('f', const Color(0xFF3B6BC9)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                FadeSlide(
                  delay: const Duration(milliseconds: 680),
                  child: Center(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context)
                              .push(slideRoute(const CreateAccountScreen())),
                      child: Column(
                        children: [
                          Text("Don't have an account?", style: ps(10)),
                          Text(
                            'Create Account',
                            style: ps(
                              10,
                              w: FontWeight.w700,
                              color: AppColors.primary,
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
        ),
      ),
    );
  }
}
