// lib/screens/main_scaffold.dart
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/settings.dart';
import 'package:fitness_app/screens/statistics.dart';
import 'package:fitness_app/widgets/navigation_bar.dart';
import 'package:flutter/material.dart' hide NavigationBar;
// ... other imports

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Statistics(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isNavVisible = true;

    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: _currentIndex, children: _screens),

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
