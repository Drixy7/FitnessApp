import 'package:fitness_app/widgets/performance_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/plan_day_exercise.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final Workout workout;
  final List<PlanDayExercise> exercises;
  final Map<int, List<WorkoutSet>> workoutSets;

  const WorkoutSummaryScreen({
    super.key,
    required this.workout,
    required this.exercises,
    required this.workoutSets,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (workoutSets.isEmpty || exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Summary'),
          backgroundColor: theme.colorScheme.surface,
        ),
        body: const Center(child: Text('No workout data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_formatDate(workout.date)} - ${workout.planDay.value?.name}",
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: exercises.isEmpty
          ? const Center(child: Text('No exercises in this workout'))
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final sets = workoutSets[exercise.orderIndex] ?? [];
                return _ExerciseCard(exercise: exercise, sets: sets);
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yMMMd');
    return formatter.format(date);
  }
}

class _ExerciseCard extends StatefulWidget {
  final PlanDayExercise exercise;
  final List<WorkoutSet> sets;

  const _ExerciseCard({required this.exercise, required this.sets});

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.exercise.value?.name ?? 'Unknown',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSummaryText(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: PerformanceHistory(
                loggedSets: widget.sets,
                targetReps: widget.exercise.targetReps,
              ),
            ),
        ],
      ),
    );
  }

  String _getSummaryText() {
    if (widget.sets.isEmpty) {
      return 'No sets logged';
    }

    if (widget.sets.length == 1 && widget.sets.first.isSkipped) {
      return 'Exercise skipped';
    }

    final completedSets = widget.sets.where((s) => !s.isSkipped).length;
    return '$completedSets ${completedSets == 1 ? 'set' : 'sets'} completed';
  }
}
