import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/models/plan_session.dart'; // Import your Session model
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/widgets/pickers/plan_personalization.dart';
import 'package:fitness_app/widgets/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plan_provider.dart';

class PlanChooser extends StatefulWidget {
  const PlanChooser({super.key});

  @override
  State<PlanChooser> createState() => _PlanChooserState();
}

class _PlanChooserState extends State<PlanChooser> {
  late Future<Map<Plan, PlanSession?>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = context.read<IsarService>().findPlansWithLatestSession();
  }

  bool _shouldRenewSession(DateTime sessionEndDate) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    if (!todayDate.isAfter(sessionEndDate)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _personalisePlan(BuildContext context, Plan plan) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: PlanPersonalization(plan: plan),
        );
      },
    );

    if (context.mounted && result != null) {
      await context.read<PlanProvider>().startPlanSession(plan, result);
    }
  }

  Future<void> _renewSession(Plan plan, PlanSession latestSession) async {
    await context.read<PlanProvider>().renewPlanSession(plan, latestSession);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Plan"), centerTitle: true),
      body: FutureBuilder<Map<Plan, PlanSession?>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No workout plans found."));
          } else {
            final dataMap = snapshot.data!;
            final plans = dataMap.keys.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                final latestSession = dataMap[plan];
                final bool isResuming;
                if (latestSession != null && latestSession.endDate != null) {
                  isResuming = _shouldRenewSession(latestSession.endDate!);
                } else {
                  isResuming = false;
                }
                return PlanCard(
                  plan: plan,
                  isResuming: isResuming,
                  // Optional: Pass the session to the card to show "Last workout: 2 days ago"
                  // lastSessionDate: latestSession?.endTime,
                  onTap: () async {
                    if (isResuming) {
                      await _renewSession(plan, latestSession!);
                    } else {
                      await _personalisePlan(context, plan);
                    }
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
