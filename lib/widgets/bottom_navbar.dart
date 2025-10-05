import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:sports_app/screens/profile_screen.dart';
import 'package:sports_app/screens/skills_screen.dart';
import 'package:sports_app/screens/progress_screen.dart';
import 'package:sports_app/models/skills.dart';
import 'package:sports_app/provider/theme_provider.dart';

class BottomNavBarr extends StatefulWidget {
  const BottomNavBarr({super.key});

  @override
  State<BottomNavBarr> createState() => _BottomNavBarrState();
}

class _BottomNavBarrState extends State<BottomNavBarr>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Skill> allSkills = [];

  void updateSkills(List<Skill> skills) {
    setState(() {
      allSkills = skills;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final List<Widget> _screens = [
      SkillsScreen(onSkillsLoaded: updateSkills),
      ProgressScreen(skills: allSkills),
      ProfileScreen(skills: allSkills),
    ];

    final icons = [
      FontAwesome.person_running_solid,
      Bootstrap.bar_chart_fill,
      AntDesign.user_outline,
    ];

    final Color navColor = isDark ? Colors.grey.shade900 : Colors.white;
    final Color activeIconColor =
        isDark ? Colors.tealAccent : const Color(0xFF1e3c72);
    final Color inactiveIconColor =
        isDark ? Colors.white70 : Colors.blueGrey.shade400;

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Container(
          key: ValueKey<int>(_page),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [
                      Color(0xFF0f2027),
                      Color(0xFF203a43),
                      Color(0xFF2c5364)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFa1c4fd), Color(0xFFc2e9fb)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: SafeArea(child: _screens[_page]),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 65.0,
        color: navColor,
        buttonBackgroundColor: navColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        items: List.generate(icons.length, (index) {
          final isActive = index == _page;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(isActive ? 4 : 8),
            decoration: BoxDecoration(
              color: isActive
                  ? (isDark
                      ? Colors.tealAccent.withOpacity(0.15)
                      : const Color(0xFFe0f7fa))
                  : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeIconColor.withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: AnimatedScale(
              scale: isActive ? 1.25 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icons[index],
                size: 30,
                color: isActive ? activeIconColor : inactiveIconColor,
              ),
            ),
          );
        }),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
