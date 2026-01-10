import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/day_detail_screen.dart';
import 'package:fitness_app/widgets/status_card.dart';
import 'package:fitness_app/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();

    Future<void> navigateToDayDetail(PlanDay day) async {
      final workoutProvider = context.read<WorkoutProvider>();
      final weekSelection = planProvider.currentWeekSelection;

      if (weekSelection == null) {
        return;
      }

      await workoutProvider.getOrCreateWorkoutForDay(day, weekSelection);
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DayDetailScreen()),
        );
      }
    }

    if (planProvider.isViewingForeignSession ||
        planProvider.sessionInView == null) {
      return Scaffold(
        body: Column(
          children: [
            StatusCard(),
            Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 48, color: Colors.orange),
                    const SizedBox(height: 10),
                    Text(
                      planProvider.activeSession == null
                          ? "Different Training Phase"
                          : "No Session For This Week Found",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      planProvider.activeSession == null
                          ? "In this week, you were training under plan: "
                          : "Please Return To Valid Week:"
                                "${planProvider.sessionInView?.plan.value?.name ?? ''}",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        planProvider.goToAnyWeek(
                          planProvider
                                  .activeSession!
                                  .lastCompletedAbsoluteWeek +
                              1,
                        );
                      },
                      child: const Text("Return to Current Week"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: planProvider.isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(
                children: [
                  StatusCard(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: planProvider.daysForWeek.length,
                      itemBuilder: (context, index) {
                        final day = planProvider.daysForWeek[index];
                        return TrainingCard(
                          day: day,
                          onTap: () {
                            navigateToDayDetail(day);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
