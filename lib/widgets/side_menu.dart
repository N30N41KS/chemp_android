import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import 'checker_avatar.dart';

/// Боковое меню. Элементы появляются каскадом по значению [anim] (0..1).
class SideMenu extends StatelessWidget {
  final Animation<double> anim;
  final VoidCallback onClose;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const SideMenu({
    super.key,
    required this.anim,
    required this.onClose,
    required this.onSelect,
    required this.onLogout,
  });

  static const _icons = <IconData>[
    Icons.person_outline,
    Icons.edit_calendar_outlined,
    Icons.equalizer_rounded,
    Icons.location_on_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.language,
    Icons.palette_outlined,
  ];
  static const _labels = <String>[
    'My Profile',
    'Schedule',
    'Statistics',
    'Discover Combat',
    'Chat',
    'Change Language',
    'Change App Skin',
  ];

  double _t(int i) {
    final begin = 0.2 + i * 0.07;
    final end = math.min(1.0, begin + 0.4);
    return Interval(begin, end, curve: Curves.easeOutCubic).transform(anim.value);
  }

  Widget _stagger(int i, Widget child) {
    final t = _t(i);
    return Opacity(
      opacity: t.clamp(0.0, 1.0).toDouble(),
      child: Transform.translate(offset: Offset(-28 * (1 - t), 0), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEAEAEC),
      elevation: 16,
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(28)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkResponse(
                  onTap: onClose,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.4),
                    ),
                    child: const Icon(Icons.close, size: 14, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _stagger(
                0,
                Row(
                  children: [
                    const CheckerAvatar(size: 46),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stone Stellar',
                          style: ps(13, w: FontWeight.w700, color: AppColors.primary),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 12, color: Color(0xFFFFB400)),
                            const SizedBox(width: 3),
                            Text('Gold Player', style: ps(9, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              for (var i = 0; i < _labels.length; i++)
                _stagger(
                  i + 1,
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onSelect(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
                      child: Row(
                        children: [
                          Icon(_icons[i], size: 18, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Text(_labels[i], style: ps(11.5, w: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              _stagger(
                8,
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onLogout,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 18, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Text('Logout', style: ps(11.5, w: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
