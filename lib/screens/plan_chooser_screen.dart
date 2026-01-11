/* enables user to choose from premade training plans, in later implementation enables also creation of training plan */
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/widgets/pickers/plan_personalization.dart';
import 'package:fitness_app/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plan_provider.dart';

class PlanChooserScreen extends StatelessWidget {
  const PlanChooserScreen({super.key});

  Future<void> _personalisePlan(
    BuildContext context,
    Plan plan,
    bool isResuming,
  ) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: PlanPersonalization(
            plan: plan,
            isDayOrderDisabled: isResuming,
          ),
        );
      },
    );
    if (context.mounted && result != null) {
      context.read<PlanProvider>().startPlan(plan, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isarService = context.read<IsarService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Plan"), centerTitle: true),
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
                return FutureBuilder(
                  future: isarService.findIfSessionExist(plan),
                  builder: (context, sessionSnapshot) {
                    if (sessionSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final bool isResuming = sessionSnapshot.data ?? false;

                    return PlanCard(
                      plan: plan,
                      isResuming: isResuming,
                      onTap: () async {
                        await _personalisePlan(context, plan, isResuming);
                      },
                    );
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
