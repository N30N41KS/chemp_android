import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_theme.dart';
import '../../widgets/checker_avatar.dart';
import '../../widgets/fade_slide.dart';
import '../../widgets/illustration.dart';
import '../../widgets/press_scale.dart';

/// Landing Screen из макета: четыре розовые карточки.
class HomeTab extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onSchedule;
  final ValueChanged<int> onOpenTab;

  const HomeTab({
    super.key,
    required this.onMenu,
    required this.onSchedule,
    required this.onOpenTab,
  });

  @override
  Widget build(BuildContext context) {
    final cards = <_CardData>[
      _CardData(
        'Schedule',
        'Easily schedule events/games then find like minded players for battle. You up for it?',
        Icons.timer_outlined,
        'assets/images/card_schedule.png',
        onSchedule,
      ),
      _CardData(
        'Statistics',
        'All data from previous and upcoming games can be found here.',
        Icons.bar_chart_rounded,
        'assets/images/card_statistics.png',
        () => onOpenTab(1),
      ),
      _CardData(
        'Discover Combats',
        "Find out what's new and compete among players with new challenges and earn cash with game points.",
        Icons.travel_explore,
        'assets/images/card_discover.png',
        () => onOpenTab(2),
      ),
      _CardData(
        'Message Players',
        'Found the profile of a player that interests you? Start a conversation.',
        Icons.forum_outlined,
        'assets/images/card_message.png',
        () => onOpenTab(3),
      ),
    ];

    return Column(
      children: [
        FadeSlide(
          offset: const Offset(0, -0.3),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 24, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: onMenu,
                  icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
                ),
                const Spacer(),
                const CheckerAvatar(size: 26),
                const SizedBox(width: 8),
                Text('Stone Stellar', style: ps(10.5, w: FontWeight.w600)),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 120),
            itemCount: cards.length,
            separatorBuilder: (context, i) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              return FadeSlide(
                delay: Duration(milliseconds: 120 + i * 120),
                offset: const Offset(0, 0.25),
                child: _HomeCard(data: cards[i], index: i),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CardData {
  final String title;
  final String text;
  final IconData icon;
  final String image;
  final VoidCallback onTap;
  _CardData(this.title, this.text, this.icon, this.image, this.onTap);
}

class _HomeCard extends StatelessWidget {
  final _CardData data;
  final int index;
  const _HomeCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: data.onTap,
      scale: 0.97,
      child: Container(
        height: 118,
        padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: ps(12, w: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: ps(8.5, color: Colors.white.withValues(alpha: 0.92), h: 1.45),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Floaty(
              amplitude: 5,
              phase: (index * 0.25) % 1.0,
              child: SizedBox(
                width: 118,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Image.asset(
                      data.image,
                      width: 118,
                      height: 88,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stack) =>
                          Icon(data.icon, size: 40, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
