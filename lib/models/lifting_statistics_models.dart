import 'package:fitness_app/models/workout_set.dart';

class PlanSummary {
  final double weightVolume;
  final int totalReps;
  final int workoutsCompleted;
  final int workoutsSkipped;
  final int workoutConsistency;
  final int averageWorkoutDuration;

  PlanSummary({
    required this.weightVolume,
    required this.totalReps,
    required this.workoutsCompleted,
    required this.workoutsSkipped,
    required this.workoutConsistency,
    required this.averageWorkoutDuration,
  });
}

class ExerciseSummary {
  final WorkoutSet bestSet;
  final double oneRepMax;
  final WorkoutSet? maxSet;
  final double progress;
  final int skippedCount;
  bool get isEstimated => maxSet == null;

  ExerciseSummary({
    required this.bestSet,
    required this.oneRepMax,
    this.maxSet,
    required this.progress,
    required this.skippedCount,
  });
}
