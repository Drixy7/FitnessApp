import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/day_detail_screen.dart';
import 'package:fitness_app/widgets/status_card.dart';
import 'package:fitness_app/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the main screen of our app. It's the "container" for other widgets.
class DashboardScreen extends StatelessWidget {
  // const means this widget's properties will never change.
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

    if (planProvider.isViewingForeignSession) {
      return Center(
        child: Card(
          color: Colors.amber.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusCard(),
                const Icon(Icons.history, size: 48, color: Colors.orange),
                const SizedBox(height: 10),
                Text(
                  "Different Training Phase",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 5),
                Text(
                  "In this week, you were training under plan: "
                  "${planProvider.sessionInView?.plan.value?.name ?? 'Unknown'}",
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    planProvider.goToAnyWeek(
                      planProvider.activeSession!.lastCompletedAbsoluteWeek + 1,
                    );
                  },
                  child: const Text("Return to Current Week"),
                ),
              ],
            ),
          ),
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
