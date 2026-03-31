import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/day_detail_screen.dart';
import 'package:fitness_app/screens/workout_summary_screen.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/dialogs/warning_dialog.dart';
import 'package:fitness_app/widgets/status_card.dart';
import 'package:fitness_app/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _navigateToDayDetail(PlanDay day, BuildContext context) async {
    final workoutProvider = context.read<WorkoutProvider>();
    await workoutProvider.getOrCreateWorkoutForDay(day);
    if (context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const DayDetailScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (!planProvider.isLoading || planProvider.daysForWeek.isNotEmpty)
              GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  double velocity = details.primaryVelocity ?? 0;

                  if (velocity > 300) {
                    planProvider.goToPreviousWeek();
                  } else if (velocity < -300) {
                    planProvider.goToNextWeek();
                  }
                },
                child: Column(
                  children: [
                    SafeArea(child: const StatusCard()),
                    Expanded(
                      child: ListView.builder(
                        itemCount: planProvider.daysForWeek.keys.length,
                        itemBuilder: (context, index) {
                          final day = planProvider.daysForWeek.values
                              .toList()[index]
                              .$1;
                          final workout =
                              planProvider.daysForWeek[day.dayOrder]?.$2;
                          return TrainingCard(
                            day: day,
                            workout: workout,
                            onShowStats: () async {
                              if (workout == null) return;
                              final data = await workoutProvider
                                  .getHistoricalDataForWorkout(workout);
                              if (context.mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutSummaryScreen(
                                      workout: workout,
                                      workoutSets: data.workoutSets,
                                      exercises: data.exercises,
                                    ),
                                  ),
                                );
                              }
                            },
                            onSkip: () async {
                              await workoutProvider.skipWorkout(workout, day);
                            },
                            onUnSkip: () async {
                              await workoutProvider.unSkipWorkout(
                                workout!,
                                day,
                              );
                            },
                            onTap: () async {
                              if (workout == null ||
                                  workout.status != WorkoutStatus.completed) {
                                _navigateToDayDetail(day, context);
                                return;
                              }

                              final result = await showWarningDialog(
                                "Editing completed workout",
                                "You're trying to edit a completed workout. Proceed only if you wish to correct mistakes made in previous logging.",
                                context,
                              );

                              if (result && context.mounted) {
                                _navigateToDayDetail(day, context);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    /*
                      ElevatedButton(
                        child: const Text('Vygenerovat testovací historii'),
                        onPressed: () async {
                          final isarService = context.read<IsarService>();
                          final planProvider = context.read<PlanProvider>();

                          if (planProvider.activePlan != null &&
                              planProvider.activeSession != null) {
                            await isarService.seedHistoricalData(
                              activePlan: planProvider.activePlan!,
                              activeSession: planProvider.activeSession!,
                              weeksBack: 6,
                              weekSelection: planProvider.currentWeekSelection!,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Historie vygenerována!'),
                                ),
                              );
                            }
                          }
                        },
                      ),*/
                    SizedBox(height: 80),
                  ],
                ),
              ),
            if (planProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.1), // Jemné ztmavení pozadí
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
