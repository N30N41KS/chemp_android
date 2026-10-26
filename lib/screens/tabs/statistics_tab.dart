import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_state.dart';
import '../../app_theme.dart';
import '../../widgets/fade_slide.dart';
import 'tab_header.dart';

class StatisticsTab extends StatelessWidget {
  final VoidCallback onMenu;
  const StatisticsTab({super.key, required this.onMenu});

  static const _week = [3.0, 5.0, 2.0, 7.0, 4.0, 6.0, 8.0];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Widget _stat(String label, double value, String prefix, IconData icon, int i) {
    return Expanded(
      child: FadeSlide(
        delay: Duration(milliseconds: 100 + i * 100),
        child: Container(
          margin: EdgeInsets.only(left: i == 0 ? 0 : 10),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            gradient: AppColors.gradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Text(
                  '$prefix${v.round()}',
                  style: ps(18, w: FontWeight.w700, color: Colors.white),
                ),
              ),
              Text(label, style: ps(9, color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabHeader(title: 'Statistics', onMenu: onMenu),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            children: [
              Row(
                children: [
                  _stat('Games', 24, '', Icons.sports_esports, 0),
                  _stat('Wins', 15, '', Icons.emoji_events, 1),
                  _stat('Earned', 1280, '\$', Icons.payments_outlined, 2),
                ],
              ),
              const SizedBox(height: 22),
              FadeSlide(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('This week', style: ps(12, w: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Games played per day', style: ps(9, color: AppColors.textMuted)),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 130,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (var i = 0; i < _week.length; i++)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0, end: _week[i] / 8),
                                      duration: Duration(milliseconds: 700 + i * 120),
                                      curve: Curves.easeOutBack,
                                      builder: (context, v, _) => Container(
                                        width: 16,
                                        height: (96 * v).clamp(0.0, 110.0).toDouble(),
                                        decoration: BoxDecoration(
                                          gradient: AppColors.gradient,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(_days[i], style: ps(9, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              FadeSlide(
                delay: const Duration(milliseconds: 550),
                child: Text(
                  'Upcoming games',
                  style: ps(13, w: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<List<ScheduledGame>>(
                valueListenable: AppState.games,
                builder: (context, games, _) {
                  if (games.isEmpty) {
                    return FadeSlide(
                      delay: const Duration(milliseconds: 650),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Пока нет запланированных игр. Нажмите «Schedule» на главной, чтобы создать первую.',
                          style: ps(10, color: AppColors.textMuted, h: 1.5),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < games.length; i++)
                        FadeSlide(
                          key: ValueKey('${games[i].name}$i'),
                          delay: Duration(milliseconds: 100 * i),
                          child: _GameTile(game: games[i]),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GameTile extends StatelessWidget {
  final ScheduledGame game;
  const _GameTile({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_esports, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.name, style: ps(12, w: FontWeight.w600)),
                Text(
                  '${game.category} • ${formatDate(game.from)}',
                  style: ps(9, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            game.price.isEmpty ? '' : '\$${game.price}',
            style: ps(12, w: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
