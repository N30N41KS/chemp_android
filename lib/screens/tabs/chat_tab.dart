import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_theme.dart';
import '../../routes.dart';
import '../../widgets/fade_slide.dart';
import '../chat_screen.dart';
import 'tab_header.dart';

class Contact {
  final String name;
  final String last;
  final String time;
  final int unread;
  final Color color;
  const Contact(this.name, this.last, this.time, this.unread, this.color);
}

const List<Contact> kContacts = [
  Contact('Alex Rider', 'Ready for tonight’s combat?', '09:41', 2, Color(0xFF7C5CFF)),
  Contact('Kemi Ade', 'GG! Rematch tomorrow?', '08:15', 0, Color(0xFF00B894)),
  Contact('Dayo', 'Sent you the lobby code', 'Yesterday', 1, Color(0xFFFF8A00)),
  Contact('Mira Stone', 'Nice play in the last round', 'Mon', 0, Color(0xFFE5483B)),
  Contact('Tobi', 'Let’s team up for the cup', 'Sun', 0, Color(0xFF3B6BC9)),
];

class ChatTab extends StatelessWidget {
  final VoidCallback onMenu;
  const ChatTab({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabHeader(title: 'Chat', onMenu: onMenu),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            itemCount: kContacts.length,
            itemBuilder: (context, i) {
              final c = kContacts[i];
              return FadeSlide(
                delay: Duration(milliseconds: 80 * i),
                offset: const Offset(0.15, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).push(slideRoute(ChatScreen(contact: c))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'avatar_${c.name}',
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: c.color,
                            child: Text(
                              c.name.substring(0, 1),
                              style: ps(16, w: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: ps(12, w: FontWeight.w600)),
                              Text(
                                c.last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ps(10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(c.time, style: ps(9, color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            if (c.unread > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.gradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${c.unread}',
                                  style: ps(9, w: FontWeight.w700, color: Colors.white),
                                ),
                              )
                            else
                              const SizedBox(height: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
