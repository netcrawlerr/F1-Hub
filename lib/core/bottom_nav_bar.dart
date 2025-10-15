import 'package:f1_hub/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:f1_hub/core/styles/app_styles.dart';
import 'package:f1_hub/screens/news/news_screen.dart';
import 'package:provider/provider.dart';
import '../screens/schedule/schedule_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/standing/standing_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String teamName;
  const BottomNavBar({super.key, required this.teamName});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NewsScreen(),
    ScheduleScreen(),
    StandingScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final team = context.watch<TeamProvider>().selectedTeam;
    final flagColor = AppStyles.getFlagColor(team);

    return Scaffold(
      backgroundColor: isDark ? AppStyles.bgColorDark : AppStyles.bgColorLight,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: flagColor,
          unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey[600],
          backgroundColor:
              isDark ? AppStyles.bgColorDark : AppStyles.darkModeTextColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppStyles.bottomBarSelectedLabel,
          unselectedLabelStyle: AppStyles.bottomBarUnselectedLabel,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined),
              label: 'Standings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
