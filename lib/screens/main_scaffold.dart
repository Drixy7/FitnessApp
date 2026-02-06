// lib/screens/main_scaffold.dart
// ... other imports
import 'package:fitness_app/providers/navigation_provider.dart'; // Import the new provider
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/screens/dashboard.dart';
import 'package:fitness_app/screens/plan_chooser.dart';
import 'package:fitness_app/screens/settings.dart';
import 'package:fitness_app/screens/statistics/statistics_navigation.dart';
import 'package:fitness_app/widgets/navigation_bar.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:provider/provider.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final currentIndex = navProvider.currentIndex;

    final planProvider = context.watch<PlanProvider>();

    Widget homeTab;
    if (planProvider.isLoading) {
      homeTab = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (planProvider.activeSession != null) {
      homeTab = const Dashboard();
    } else {
      homeTab = const PlanChooser();
    }

    final List<Widget> screens = [
      homeTab,
      const StatisticsNavigation(),
      const Settings(),
    ];

    return Scaffold(
      extendBody: true,

      body: IndexedStack(index: currentIndex, children: screens),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.read<NavigationProvider>().setIndex(index);
        },
      ),

      bottomNavigationBar: null,
    );
  }
}
