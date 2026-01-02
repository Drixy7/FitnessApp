/* enables user to choose from premade training plans, in later implementation enables also creation of training plan */
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plan_provider.dart';

class PlanChooserScreen extends StatelessWidget {
  const PlanChooserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = context.read<IsarService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Plan"), centerTitle: true),
      // Use of a FutureBuilder to handle the asynchronous data fetching.
      body: FutureBuilder<List<Plan>>(
        future: isarService.findAllPlans(),
        builder: (context, snapshot) {
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
                    context.read<PlanProvider>().startPlan(plan);
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
