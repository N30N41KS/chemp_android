import 'package:flutter/material.dart';

Route<T> fadeRoute<T>(Widget page, {int ms = 500}) {
  return PageRouteBuilder<T>(
    transitionDuration: Duration(milliseconds: ms),
    reverseTransitionDuration: Duration(milliseconds: ms),
    pageBuilder: (context, animation, secondary) => page,
    transitionsBuilder: (context, animation, secondary, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

Route<T> slideRoute<T>(Widget page, {int ms = 450}) {
  return PageRouteBuilder<T>(
    transitionDuration: Duration(milliseconds: ms),
    reverseTransitionDuration: Duration(milliseconds: ms),
    pageBuilder: (context, animation, secondary) => page,
    transitionsBuilder: (context, animation, secondary, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
