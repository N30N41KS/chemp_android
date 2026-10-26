import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_theme.dart';
import '../../widgets/fade_slide.dart';
import '../../widgets/press_scale.dart';
import 'tab_header.dart';

class _Combat {
  final String title;
  final String category;
  final int prize;
  final int players;
  final int max;
  final IconData icon;
  const _Combat(this.title, this.category, this.prize, this.players, this.max, this.icon);
}

class DiscoverTab extends StatefulWidget {
  final VoidCallback onMenu;
  const DiscoverTab({super.key, required this.onMenu});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  static const _filters = ['All', 'Action', 'Sports', 'Puzzle'];
  static const _all = [
    _Combat('Night Raid Arena', 'Action', 250, 12, 20, Icons.local_fire_department),
    _Combat('FIFA Weekend Cup', 'Sports', 400, 14, 16, Icons.sports_soccer),
    _Combat('Block Masters', 'Puzzle', 120, 6, 10, Icons.extension),
    _Combat('Sniper Alley', 'Action', 300, 9, 12, Icons.gps_fixed),
    _Combat('Hoops Showdown', 'Sports', 180, 7, 8, Icons.sports_basketball),
    _Combat('Brain Duel', 'Puzzle', 90, 3, 6, Icons.psychology),
  ];

  String _filter = 'All';
  final Set<String> _joined = <String>{};

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'All'
        ? _all
        : _all.where((c) => c.category == _filter).toList();

    return Column(
      children: [
        TabHeader(title: 'Discover Combat', onMenu: widget.onMenu),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _filters.length,
            separatorBuilder: (context, i) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final f = _filters[i];
              final sel = f == _filter;
              return PressScale(
                onTap: () => setState(() => _filter = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColors.gradient : null,
                    color: sel ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f,
                    style: ps(
                      11,
                      w: FontWeight.w600,
                      color: sel ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              key: ValueKey<String>(_filter),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final c = list[i];
                final joined = _joined.contains(c.title);
                return FadeSlide(
                  delay: Duration(milliseconds: 70 * i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(c.icon, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title, style: ps(12, w: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(
                                '${c.category} • ${joined ? c.players + 1 : c.players}/${c.max} players',
                                style: ps(9, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Prize \$${c.prize}',
                                style: ps(10, w: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        PressScale(
                          onTap: () {
                            setState(() {
                              if (joined) {
                                _joined.remove(c.title);
                              } else {
                                _joined.add(c.title);
                                toast(context, 'Вы записаны: ${c.title}');
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: joined ? null : AppColors.gradient,
                              color: joined ? AppColors.blob : null,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                joined ? 'Joined' : 'Join',
                                key: ValueKey<bool>(joined),
                                style: ps(
                                  10,
                                  w: FontWeight.w600,
                                  color: joined ? AppColors.primary : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
