import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import 'press_scale.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final double height;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.height = 46,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: loading ? null : onTap,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(height),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: loading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                  style: ps(14, w: FontWeight.w600, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
