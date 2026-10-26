import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_state.dart';
import '../app_theme.dart';
import '../routes.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/option_sheet.dart';
import '../widgets/side_menu.dart';
import 'login_screen.dart';
import 'schedule_game_screen.dart';
import 'tabs/chat_tab.dart';
import 'tabs/discover_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/statistics_tab.dart';

/// Каркас приложения: вкладки + нижняя панель + боковое меню.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  /// 0 главная, 1 статистика, 2 поиск, 3 чат, 4 профиль
  int _tab = 0;
  bool _menuOpen = false;
  late final AnimationController _menu;

  @override
  void initState() {
    super.initState();
    _menu = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
  }

  @override
  void dispose() {
    _menu.dispose();
    super.dispose();
  }

  void _openMenu() {
    setState(() => _menuOpen = true);
    _menu.forward();
  }

  void _closeMenu() {
    setState(() => _menuOpen = false);
    _menu.reverse();
  }

  void _setTab(int i) {
    if (i == _tab) return;
    setState(() => _tab = i);
  }

  Future<void> _openSchedule() async {
    final result = await Navigator.of(context)
        .push<String>(slideRoute(const ScheduleGameScreen()));
    if (!mounted) return;
    if (result == 'stats') _setTab(1);
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(const LoginScreen(), ms: 600),
      (route) => false,
    );
  }

  Future<void> _pickLanguage() async {
    final v = await showOptionSheet(
      context,
      title: 'Change Language',
      options: const ['English', 'Русский', 'Français'],
      selected: AppState.language.value,
    );
    if (v == null || !mounted) return;
    AppState.language.value = v;
    toast(context, 'Язык: $v (в прототипе тексты не переводятся)');
  }

  Future<void> _pickSkin() async {
    final v = await showOptionSheet(
      context,
      title: 'Change App Skin',
      options: const ['Combat Pink', 'Night Mode', 'Ocean'],
      selected: AppState.skin.value,
    );
    if (v == null || !mounted) return;
    AppState.skin.value = v;
    toast(context, 'Скин: $v (в прототипе оформление не меняется)');
  }

  void _onMenuSelect(int i) {
    _closeMenu();
    switch (i) {
      case 0:
        _setTab(4);
        break;
      case 1:
        _openSchedule();
        break;
      case 2:
        _setTab(1);
        break;
      case 3:
        _setTab(2);
        break;
      case 4:
        _setTab(3);
        break;
      case 5:
        _pickLanguage();
        break;
      case 6:
        _pickSkin();
        break;
    }
  }

  Widget _buildTab() {
    switch (_tab) {
      case 1:
        return StatisticsTab(onMenu: _openMenu);
      case 2:
        return DiscoverTab(onMenu: _openMenu);
      case 3:
        return ChatTab(onMenu: _openMenu);
      case 4:
        return ProfileTab(
          onMenu: _openMenu,
          onLogout: _logout,
          onLanguage: _pickLanguage,
          onSkin: _pickSkin,
        );
      default:
        return HomeTab(
          onMenu: _openMenu,
          onSchedule: _openSchedule,
          onOpenTab: _setTab,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_menuOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _closeMenu();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey<int>(_tab),
                    child: _buildTab(),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomBar(current: _tab, onTap: _setTab),
            ),
            IgnorePointer(
              ignoring: !_menuOpen,
              child: AnimatedBuilder(
                animation: _menu,
                builder: (context, _) {
                  final t = Curves.easeOutCubic.transform(_menu.value);
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _closeMenu,
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.4 * _menu.value),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionalTranslation(
                          translation: Offset(-1 + t, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.82,
                            height: double.infinity,
                            child: SideMenu(
                              anim: _menu,
                              onClose: _closeMenu,
                              onSelect: _onMenuSelect,
                              onLogout: _logout,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
