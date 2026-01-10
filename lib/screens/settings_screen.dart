import 'package:fitness_app/providers/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // --- Helper methods to keep build() clean ---

  void _showPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Plan"),
        content: const Text(
          "This will end your current Plan session. Are you sure you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PlanProvider>().endPlanSession();
            },
            child: const Text("I agree"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Theme"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text("Light Mode"),
            ),
            ListTile(leading: Icon(Icons.dark_mode), title: Text("Dark Mode")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
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
