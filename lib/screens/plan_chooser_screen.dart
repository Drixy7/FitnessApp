/* enables user to choose from premade training plans, in later implementation enables also creation of training plan */
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/screens/dashboard_screen.dart'; // Import HomeScreen for navigation
import 'package:fitness_app/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanChooserScreen extends StatelessWidget {
  const PlanChooserScreen({super.key});

  // --- Helper method for navigation and state creation ---
  void _selectPlanAndNavigate(BuildContext context, Plan plan) async {
    final isarService = context.read<IsarService>();
    await isarService.createDefaultPlanSession(plan);
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const DashboardScreen()),
        (route) => false, // This predicate removes all previous routes.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isarService = context.read<IsarService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Plan"), centerTitle: true),
      // Use of a FutureBuilder to handle the asynchronous data fetching.
      body: FutureBuilder<List<Plan>>(
        future: isarService.findAllPlans(),
        builder: (context, snapshot) {
          // --- Handle the different states of the Future ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No workout plans found."));
          } else {
            final plans = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return PlanCard(
                  plan: plan,
                  onTap: () {
                    _selectPlanAndNavigate(context, plan);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
