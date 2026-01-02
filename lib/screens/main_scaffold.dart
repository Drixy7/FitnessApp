// lib/screens/main_scaffold.dart
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/screens/dashboard_screen.dart';
import 'package:fitness_app/screens/plan_chooser_screen.dart';
import 'package:fitness_app/screens/settings_screen.dart';
import 'package:fitness_app/screens/statistics_screen.dart';
import 'package:fitness_app/widgets/navigation_bar.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:provider/provider.dart';
// ... other imports

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();

    Widget homeTab;
    if (planProvider.isLoading) {
      homeTab = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (planProvider.activeSession != null) {
      homeTab = const DashboardScreen();
    } else {
      homeTab = const PlanChooserScreen();
    }

    final List<Widget> screens = [
      homeTab,
      const StatisticsScreen(),
      const SettingsScreen(),
    ];
    final bool isNavVisible = true;

    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: _currentIndex, children: screens),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isNavVisible
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,

      bottomNavigationBar: null,
    );
  }
}
