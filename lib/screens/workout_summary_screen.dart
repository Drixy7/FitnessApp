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
        title: const Text('Workout Summary'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Čistší vzhled
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- MODERNÍ HERO KARTA ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Card(
              elevation: 0, // Necháme to ploché, hrajeme si s barvami
              color: theme.colorScheme.secondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      workout.planDay.value?.name ?? "Workout",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMiniStat(
                          context,
                          icon: Icons.calendar_today_rounded,
                          value: _formatDate(workout.date),
                          label: "Date",
                        ),
                        // Jemná dělící čára uprostřed
                        Container(
                          height: 40,
                          width: 1,
                          color: theme.colorScheme.onSecondaryContainer
                              .withOpacity(0.2),
                        ),
                        _buildMiniStat(
                          context,
                          icon: Icons.timer_outlined,
                          value: _formatWorkoutDuration(
                            workout.durationInSeconds,
                          ),
                          label: "Duration",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- SEZNAM CVIKŮ ---
          Expanded(
            child: exercises.isEmpty
                ? const Center(child: Text('No exercises in this workout'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: exercises.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final sets = workoutSets[exercise.orderIndex] ?? [];
                      return _ExerciseCard(exercise: exercise, sets: sets);
                    },
                  ),
          ),
          SizedBox(height: 80),
        ],
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

Widget _buildMiniStat(
  BuildContext context, {
  required IconData icon,
  required String value,
  required String label,
}) {
  final theme = Theme.of(context);
  return Column(
    children: [
      Icon(icon, color: theme.colorScheme.primary, size: 22),
      const SizedBox(height: 8),
      Text(
        value,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
        ),
      ),
    ],
  );
}

String _formatWorkoutDuration(int totalSeconds) {
  if (totalSeconds == 0) return "--";

  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  } else {
    return '${seconds}s';
  }
}
