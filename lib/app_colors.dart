import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE94560);
  static const Color primaryDark = Color(0xFFD63A60);
  static const Color background = Color(0xFFEDEDEF);
  static const Color blob = Color(0xFFF3D6DC);
  static const Color textDark = Color(0xFF1E1E2D);
  static const Color textMuted = Color(0xFF8F92A1);
  static const Color fieldBorder = Color(0xFFD3D3DA);

  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0607F), Color(0xFFD93A5F)],
  );

  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF0587E), Color(0xFFD63A60)],
  );
}
