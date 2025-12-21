import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/day_detail_screen.dart';
import 'package:fitness_app/widgets/status_card.dart';
import 'package:fitness_app/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the main screen of our app. It's the "container" for other widgets.
class HomeScreen extends StatelessWidget {
  // const means this widget's properties will never change.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
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
                          onTap: () async {
                            final planProvider = context.read<PlanProvider>();
                            final workoutProvider = context
                                .read<WorkoutProvider>();
                            final weekSelection =
                                planProvider.currentWeekSelection;

                            if (weekSelection == null) {
                              return;
                            }

                            await workoutProvider.getOrCreateWorkoutForDay(
                              day,
                              weekSelection,
                            );
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const DayDetailScreen(),
                                ),
                              );
                            }
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
