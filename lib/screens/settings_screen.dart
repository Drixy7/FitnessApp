import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/theme_provider.dart';
import 'package:fitness_app/widgets/color_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // --- Helper methods to keep build() clean ---

  void _showPlanDialog(BuildContext context) {
    //Variables for dynamic show of content
    final planProvider = context.read<PlanProvider>();
    final actionsWhenSelected = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Close"),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          context.read<PlanProvider>().endPlanSession();
        },
        child: const Text("I agree"),
      ),
    ];

    final actionsNotSelected = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Close"),
      ),
      TextButton(
        onPressed: () =>
            Navigator.pop(context), //TODO implement navigation provider later
        child: const Text("Go to Plan Selection"),
      ),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Plan"),
        content: Text(
          planProvider.activeSession == null
              ? "You currently don't have any Plan selected."
              : "This will end your current Plan session. Are you sure you want to continue?",
        ),
        actions: planProvider.activeSession == null
            ? actionsNotSelected
            : actionsWhenSelected,
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                themeProvider.toggleThemeMode();
              },
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorOption(
                  color: Color(0xff8b4a62),
                  isSelected: themeProvider.appStyle == AppStyle.pink,
                  onTap: () => themeProvider.setAppStyle(AppStyle.pink),
                ),
                SizedBox(width: 20),
                ColorOption(
                  color: Color(0xffd6e3ff),
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
    final themeProvider = context.watch<ThemeProvider>();
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
            onTap: () => _showThemeDialog(context, themeProvider),
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
