import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/models/workout_set.dart';

import '../utils/datatypes.dart';

class WorkoutSummaryData {
  final Workout workout;
  final List<PlanDayExercise> exercises;
  final Map<int, List<WorkoutSet>> workoutSets;

  WorkoutSummaryData({
    required this.workout,
    required this.exercises,
    required this.workoutSets,
  });
}

class WeekSelectionResult {
  final int selectedTotalWeek;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final DateTime? selectedDay;

  const WeekSelectionResult({
    required this.selectedTotalWeek,
    required this.startOfWeek,
    required this.endOfWeek,
    this.selectedDay,
  });
}

class PlanPersonalizationResult {
  final Map<String, int>? dayOrder;
  final DateTime selectedStartDate;
  final DateTime firstWeekStart;

  const PlanPersonalizationResult({
    this.dayOrder,
    required this.selectedStartDate,
    required this.firstWeekStart,
  });
}

class BlueprintEntry {
  final String exerciseName;
  final int sets;
  final RepRange reps;

  const BlueprintEntry({
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });
}
