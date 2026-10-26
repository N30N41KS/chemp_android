import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/fade_slide.dart';
import '../widgets/gradient_button.dart';
import '../widgets/illustration.dart';
import 'main_shell.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _user = TextEditingController();
  final _code = TextEditingController(text: '+234');
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_name, _user, _code, _phone, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) =>
      (v ?? '').trim().isEmpty ? 'Обязательное поле' : null;

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(const MainShell(), ms: 600),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  ),
                ),
                FadeSlide(
                  child: Center(
                    child: Illustration(
                      asset: 'assets/images/create_account.png',
                      kind: SceneKind.join,
                      size: 190,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeSlide(
                  delay: const Duration(milliseconds: 120),
                  child: Text(
                    'Create Account',
                    style: ps(18, w: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 2),
                FadeSlide(
                  delay: const Duration(milliseconds: 180),
                  child: Text('Hi, kindly fill in the form to proceed combat',
                      style: ps(9.5)),
                ),
                const SizedBox(height: 10),
                FadeSlide(
                  delay: const Duration(milliseconds: 240),
                  child: CustomTextField(
                    label: 'Full Name',
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    label: 'User Name',
                    controller: _user,
                    textInputAction: TextInputAction.next,
                    validator: _required,
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 360),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 56,
                        child: CustomTextField(
                          label: 'Code',
                          controller: _code,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Your Phone',
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: _required,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 420),
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
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 480),
                  child: PasswordField(
                    controller: _pass,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        (v ?? '').length < 4 ? 'Минимум 4 символа' : null,
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlide(
                  delay: const Duration(milliseconds: 540),
                  child: PasswordField(
                    label: 'Confirm Password',
                    controller: _confirm,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    validator: (v) =>
                        v != _pass.text ? 'Пароли не совпадают' : null,
                  ),
                ),
                const SizedBox(height: 26),
                FadeSlide(
                  delay: const Duration(milliseconds: 620),
                  child: GradientButton(
                    label: 'Create Account',
                    loading: _loading,
                    onTap: _submit,
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlide(
                  delay: const Duration(milliseconds: 700),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Column(
                        children: [
                          Text('Already have an account?', style: ps(9.5)),
                          Text(
                            'Login',
                            style: ps(9.5, w: FontWeight.w700, color: AppColors.primary),
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
