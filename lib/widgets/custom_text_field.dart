import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

InputDecoration fieldDecoration(String label, {Widget? suffix}) {
  return InputDecoration(
    labelText: label,
    labelStyle: ps(12, color: AppColors.textMuted),
    floatingLabelStyle: ps(12, color: AppColors.primary, w: FontWeight.w500),
    errorStyle: ps(10, color: AppColors.primary),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    suffixIcon: suffix,
    suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 32),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.fieldBorder),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 1.6),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 1.6),
    ),
  );
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscure = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted,
      cursorColor: AppColors.primary,
      style: ps(13),
      decoration: fieldDecoration(label, suffix: suffix),
    );
  }
}

/// Поле пароля с анимированным «глазом».
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.controller,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      controller: widget.controller,
      obscure: _hide,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      suffix: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => setState(() => _hide = !_hide),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            _hide ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            key: ValueKey<bool>(_hide),
            size: 18,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
