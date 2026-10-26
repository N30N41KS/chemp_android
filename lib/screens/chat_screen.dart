import 'dart:async';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/press_scale.dart';
import 'tabs/chat_tab.dart';

class _Msg {
  final String text;
  final bool mine;
  _Msg(this.text, this.mine);
}

class ChatScreen extends StatefulWidget {
  final Contact contact;
  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _msgs = [];
  bool _typing = false;
  int _replyIndex = 0;
  Timer? _timer;

  static const _replies = [
    'Haha, deal! 🎮',
    'I’m in. What time works for you?',
    'Send me the lobby code.',
    'GG, you were fast!',
    'Let’s go for the win 🔥',
  ];

  @override
  void initState() {
    super.initState();
    _msgs.add(_Msg(widget.contact.last, false));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final t = _input.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(t, true));
      _typing = true;
    });
    _input.clear();
    _scrollDown();
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      setState(() {
        _msgs.add(_Msg(_replies[_replyIndex % _replies.length], false));
        _replyIndex++;
        _typing = false;
      });
      _scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contact;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 16, 14),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Hero(
                      tag: 'avatar_${c.name}',
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Text(
                          c.name.substring(0, 1),
                          style: ps(14, w: FontWeight.w700, color: c.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: ps(13, w: FontWeight.w600, color: Colors.white)),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _typing ? 'typing…' : 'online',
                              key: ValueKey<bool>(_typing),
                              style: ps(9.5, color: Colors.white.withValues(alpha: 0.9)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.videocam_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              itemCount: _msgs.length,
              itemBuilder: (context, i) {
                final m = _msgs[i];
                return FadeSlide(
                  key: ObjectKey(m),
                  duration: const Duration(milliseconds: 350),
                  offset: Offset(m.mine ? 0.2 : -0.2, 0),
                  child: Align(
                    alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72,
                      ),
                      decoration: BoxDecoration(
                        gradient: m.mine ? AppColors.gradient : null,
                        color: m.mine ? null : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(m.mine ? 16 : 4),
                          bottomRight: Radius.circular(m.mine ? 4 : 16),
                        ),
                      ),
                      child: Text(
                        m.text,
                        style: ps(11.5, color: m.mine ? Colors.white : AppColors.textDark, h: 1.4),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _input,
                        style: ps(12),
                        cursorColor: AppColors.primary,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message…',
                          hintStyle: ps(12, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  PressScale(
                    onTap: _send,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        gradient: AppColors.gradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
