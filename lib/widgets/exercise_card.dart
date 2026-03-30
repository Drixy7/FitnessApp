import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/models/workout_set.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/exercise_detail_screen.dart';

class ExerciseCard extends StatelessWidget {
  final PlanDayExercise planDayExercise;
  final int index;

  const ExerciseCard({
    super.key,
    required this.planDayExercise,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);

    final sets = workoutProvider.loggedSets[planDayExercise.orderIndex];

    final bool isSkipped =
        sets != null &&
        sets.isNotEmpty &&
        sets.first.isSkipped &&
        sets.length == 1;
    final bool isCompleted = sets != null && sets.isNotEmpty && !isSkipped;

    // 2. Styling based on State
    final cardColor = isSkipped
        ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
        : theme.colorScheme.surface;

    final textColor = isSkipped
        ? theme.colorScheme.onSurface.withOpacity(0.4)
        : theme.colorScheme.onSurface;

    return Card(
      elevation: isSkipped ? 0 : 2,
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCompleted
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isSkipped ? null : () => _navigateToSetScreen(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- EXERCISE NAME ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planDayExercise.exercise.value?.name ??
                              "Unknown Exercise",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            decoration: isSkipped
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${planDayExercise.targetSets} Sets • ${_formatTargetReps(planDayExercise)}",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: textColor.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- ACTION MENU (Info, Skip) ---
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: textColor),
                    onSelected: (value) async {
                      switch (value) {
                        case 'info':
                          final bool result = await showWarningDialog(
                            "Redirection Warning",
                            "You will be redirected to external site (www.musclewiki.com), you must have a browser installed on your device. Do you want to proceed?",
                            context,
                          );
                          if (result && context.mounted) {
                            _launchInfoUrl(
                              context,
                              planDayExercise
                                  .exercise
                                  .value
                                  ?.moreInformationURL,
                            );
                          }
                          break;

                        case 'skip':
                          if (isSkipped) {
                            _toggleSkip(context, isSkipped);
                          } else {
                            final bool result = await showWarningDialog(
                              "Skipping Exercise",
                              "Are you sure you want to skip this exercise? All already filled sets will be lost. This action is irreversible.",
                              context,
                            );

                            if (result && context.mounted) {
                              _toggleSkip(context, isSkipped);
                            }
                          }
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'info',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 8),
                                Text('More Information'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'skip',
                            child: Row(
                              children: [
                                Icon(
                                  isSkipped ? Icons.restore : Icons.block,
                                  color: isSkipped ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSkipped
                                      ? 'Unskip Exercise'
                                      : 'Skip Exercise',
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (isSkipped)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _toggleSkip(context, isSkipped),
                    icon: const Icon(Icons.restore),
                    label: const Text("RESTORE EXERCISE"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _navigateToSetScreen(context),
                    icon: Icon(isCompleted ? Icons.edit : Icons.add),
                    label: Text(isCompleted ? "EDIT LOGS" : "LOG SETS"),
                    style: FilledButton.styleFrom(
                      backgroundColor: isCompleted
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToSetScreen(BuildContext context) async {
    final workoutProvider = context.read<WorkoutProvider>();

    await workoutProvider.getOrCreateWorkoutSets(planDayExercise);

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ExerciseDetailScreen(planDayExercise: planDayExercise),
        ),
      );
    }
  }

  void _toggleSkip(BuildContext context, bool currentSkipState) async {
    final workoutProvider = context.read<WorkoutProvider>();
    List<WorkoutSet>? sets =
        workoutProvider.loggedSets[planDayExercise.orderIndex];
    if (sets == null || sets.isEmpty) {
      final newSet = WorkoutSet()
        ..setNumber = 1
        ..workout.value = workoutProvider.activeWorkout!
        ..reps = -1
        ..weight = -1
        ..exercise.value = planDayExercise
        ..isSkipped = true;
      sets = [newSet];
    }
    if (currentSkipState) {
      await workoutProvider.removeSetFromActiveWorkout(
        planDayExercise: planDayExercise,
        setNumber: 1,
      );
    } else {
      await workoutProvider.skipExercise(sets, planDayExercise.orderIndex);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(currentSkipState ? "Restored" : "Skipped")),
      );
    }
  }

  String _formatTargetReps(PlanDayExercise exercise) {
    switch (exercise.targetReps) {
      case RepRange.lowRep:
        return "Target: 0-5 Reps";
      case RepRange.strength:
        return "Target: 6-8 Reps";
      case RepRange.hypertrophy:
        return "Target: 8-12 Reps";
      case RepRange.extendedHypertrophy:
        return "Target: 12-15 Reps";
      case RepRange.highRep:
        return "Target: 15+ Reps";
    }
  }

  void _launchInfoUrl(BuildContext context, String? urlString) async {
    final theme = Theme.of(context);
    if (urlString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'There was a mistake loading more info url',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
      return;
    }

    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'There was an error opening browser, check if you have one installed',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onError,
                ),
              ),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'FATAL ERROR',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onError,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }
}
