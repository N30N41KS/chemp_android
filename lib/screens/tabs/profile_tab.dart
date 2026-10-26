import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_state.dart';
import '../../app_theme.dart';
import '../../widgets/checker_avatar.dart';
import '../../widgets/fade_slide.dart';
import 'tab_header.dart';

class ProfileTab extends StatefulWidget {
  final VoidCallback onMenu;
  final VoidCallback onLogout;
  final VoidCallback onLanguage;
  final VoidCallback onSkin;

  const ProfileTab({
    super.key,
    required this.onMenu,
    required this.onLogout,
    required this.onLanguage,
    required this.onSkin,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notify = true;

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: ps(16, w: FontWeight.w700, color: AppColors.primary)),
          Text(label, style: ps(9, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(title, style: ps(12, w: FontWeight.w500)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabHeader(title: 'Profile', onMenu: widget.onMenu),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 120),
            children: [
              FadeSlide(
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.6, end: 1.0),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutBack,
                      builder: (context, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: const CheckerAvatar(size: 92),
                    ),
                    const SizedBox(height: 12),
                    Text('Stone Stellar', style: ps(16, w: FontWeight.w700)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB400)),
                        const SizedBox(width: 4),
                        Text('Gold Player', style: ps(10, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FadeSlide(
                delay: const Duration(milliseconds: 150),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _stat('24', 'Games'),
                      _stat('15', 'Wins'),
                      _stat('\$1,280', 'Earned'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeSlide(
                delay: const Duration(milliseconds: 250),
                child: Column(
                  children: [
                    _tile(Icons.edit_outlined, 'Edit Profile',
                        onTap: () => toast(context, 'Редактирование профиля — демо')),
                    _tile(
                      Icons.notifications_none,
                      'Notifications',
                      trailing: Switch(
                        value: _notify,
                        activeThumbColor: AppColors.primary,
                        onChanged: (v) => setState(() => _notify = v),
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: AppState.language,
                      builder: (context, lang, _) => _tile(
                        Icons.language,
                        'Language: $lang',
                        onTap: widget.onLanguage,
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: AppState.skin,
                      builder: (context, skin, _) => _tile(
                        Icons.palette_outlined,
                        'Skin: $skin',
                        onTap: widget.onSkin,
                      ),
                    ),
                    _tile(Icons.logout, 'Logout', onTap: widget.onLogout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
