import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextStyle ps(
  double size, {
  FontWeight w = FontWeight.w400,
  Color color = AppColors.textDark,
  double? ls,
  double? h,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: w,
    color: color,
    letterSpacing: ls,
    height: h,
  );
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
}

void toast(BuildContext context, String message) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      content: Text(message, style: ps(12, color: Colors.white)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
