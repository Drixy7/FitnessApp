/*shows current week at top, shows current training_day name, shows exercises in current training,
enables making an entry to a working_set database, */

import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/workout_set_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO SHOULD REACT IF EXERCISE IS MARKED AS SKIPPED AND WOULDNT LET USER ACCESS IT UNLESS HE REVERSE THE SKIP + IMPLEMENT SKIP BUTTON + MAKE WIDGET THAT SHOWS THE EXERCISE
// This is the screen we will navigate to.
class DayDetailScreen extends StatelessWidget {
  const DayDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    if (!workoutProvider.isWorkoutActive) {
      return Scaffold();
    }

    final activeWorkout = workoutProvider.activeWorkout!;
    final exercises = workoutProvider.workoutExercises;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          workoutProvider.finishWorkout();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(activeWorkout.planDay.value?.name ?? "Workout"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<WorkoutProvider>().finishWorkout();
              },
              child: const Text("FINISH"),
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(
                  exercises[index].exercise.value?.name ?? "Not - found",
                ),
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          return;
                        },
                        icon: Icon(Icons.info_outline),
                      ),
                      IconButton(
                        onPressed: () async {
                          final planDayExercise = exercises[index];
                          await workoutProvider.getOrCreateWorkoutSets(
                            planDayExercise,
                          );
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkoutSetScreen(
                                  planDayExercise: planDayExercise,
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
