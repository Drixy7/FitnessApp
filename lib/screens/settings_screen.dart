import 'package:fitness_app/providers/navigation_provider.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // --- Helper methods to keep build() clean ---
  //todo implement better about
  //todo find yourself an Icon.

  void _showPlanDialog(BuildContext context) {
    //Variables for dynamic show of content
    final planProvider = context.read<PlanProvider>();
    final isPlanSelected = planProvider.activeSession != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Plan"),
        content: Text(
          !isPlanSelected
              ? "You currently don't have any Plan selected."
              : "This will end your current Plan session. Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isPlanSelected) {
                planProvider.endPlanSession();
              }
              context.read<NavigationProvider>().resetToHome();
            },
            child: Text(!isPlanSelected ? "Go to Plan Selection" : " I agree"),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(themeProvider.isDarkMode ? "Dark" : "Light"),
              leading: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleThemeMode();
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ColorOption(
                  color: Color(0xff8b4a62),
                  isSelected: themeProvider.appStyle == AppStyle.pink,
                  onTap: () => themeProvider.setAppStyle(AppStyle.pink),
                ),
                SizedBox(width: 20),
                _ColorOption(
                  color: Color(0xff415f91),
                  isSelected: themeProvider.appStyle == AppStyle.blue,
                  onTap: () => themeProvider.setAppStyle(AppStyle.blue),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Fitness App",
      applicationVersion: "1.0.0",
      applicationIcon: const FlutterLogo(size: 40),
      children: [
        const Text(
          "This app helps you track your workouts and follow personalized plans.",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        children: [
          // 1. Change Plan
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Change Plan"),
            subtitle: const Text("Switch to a different workout program"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPlanDialog(context),
          ),
          const Divider(height: 1),

          // 2. Change Theme
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("Change Theme"),
            subtitle: const Text("Switch between light and dark mode"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(height: 1),

          // 3. About APP
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About APP"),
            subtitle: const Text("Information about version and credits"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 28)
            : null,
      ),
    );
  }
}
