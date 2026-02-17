/*shows current week at top, shows current training_day name, shows exercises in current training,
enables making an entry to a working_set database, */

import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/widgets/exercise_card.dart';
import 'package:fitness_app/widgets/workout_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:url_launcher/url_launcher.dart';

class DayDetail extends StatelessWidget {
  const DayDetail({super.key});

  // UX Feature: Simple Dialog to add a global workout note
  void _showNoteDialog(BuildContext context) {
    final workoutProvider = context.read<WorkoutProvider>();
    final controller = TextEditingController();
    controller.text = workoutProvider.activeWorkout?.note ?? "";
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Workout Note"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "How are you feeling today?",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              workoutProvider.addNoteToActiveWorkout(note: controller.text);
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    if (!workoutProvider.isWorkoutActive) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          title: Column(
            children: [
              Text(
                activeWorkout.planDay.value?.name ?? "Workout",
                style: textStyles.titleMedium,
              ),
              const WorkoutTimer(),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.note_add_outlined),
              tooltip: "Add Note",
              onPressed: () => _showNoteDialog(context),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<WorkoutProvider>().finishWorkout();
              },
              style: TextButton.styleFrom(foregroundColor: colors.error),
              child: const Text("FINISH"),
            ),
          ],
        ),
        body: Column(
          children: [
            if (exercises.isNotEmpty)
              LinearProgressIndicator(
                value: workoutProvider.currentCompletion,
                minHeight: 4,
                backgroundColor: colors.surfaceContainerHighest,
              ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(
                    planDayExercise: exercises[index],
                    index: index,
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
