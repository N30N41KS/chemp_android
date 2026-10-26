import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_theme.dart';

class TabHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMenu;
  const TabHeader({super.key, required this.title, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 24, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenu,
            icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: ps(18, w: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
