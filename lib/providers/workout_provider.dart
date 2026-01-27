import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/models/workout_set.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:flutter/material.dart';

class WorkoutProvider extends ChangeNotifier {
  final IsarService _isarService;
  final PlanProvider _planProvider;
  // -- State Variables --
  Workout? activeWorkout;
  Workout? lastWorkout;
  Workout? lastCycleWorkout;

  bool get isWorkoutActive => activeWorkout != null;
  Map<int, List<WorkoutSet>> loggedSets =
      {}; // Int represents orderIndex of pde
  Map<int, List<WorkoutSet>> lastWorkoutSets = {};
  Map<int, List<WorkoutSet>> lastCycleWorkoutSets = {};
  List<PlanDayExercise> workoutExercises = [];

  DateTime? weekRangeStart;
  DateTime? weekRangeEnd;

  WorkoutProvider(this._isarService, this._planProvider);
  //todo implement updating of dayMap in planProvider.
  // --- Public Methods ---
  Future<void> getOrCreateWorkoutForDay(
    PlanDay planDay,
    WeekSelectionResult weekSelection,
  ) async {
    weekRangeStart = weekSelection.startOfWeek;
    weekRangeEnd = weekSelection.endOfWeek;

    final existingWorkout = await _isarService.findWorkoutForDay(
      planDay,
      weekRangeStart!,
      weekRangeEnd!,
    );
    if (existingWorkout != null) {
      activeWorkout = existingWorkout;
    } else {
      final targetDate = weekRangeStart!.add(
        Duration(days: planDay.dayOrder - 1),
      );
      final newWorkout = Workout()
        ..date = targetDate
        ..planDay.value = planDay;
      final savedWorkout = await _isarService.saveWorkout(newWorkout);
      activeWorkout = savedWorkout;
    }

    workoutExercises = await _fetchExercisesForWorkout(activeWorkout);
    lastCycleWorkout = await _fetchLastCycleWorkout(planDay);
    lastWorkout = await _fetchLastWorkout(planDay);
    lastWorkoutSets = await _fetchWorkoutSetsForWorkout(lastWorkout);
    lastCycleWorkoutSets = await _fetchWorkoutSetsForWorkout(lastCycleWorkout);

    notifyListeners();
  }

  Future<void> getOrCreateWorkoutSets(PlanDayExercise exercise) async {
    if (!isWorkoutActive) return;
    final existingSets = await _isarService.findWorkoutSetsForExercise(
      activeWorkout!,
      exercise,
    );
    if (existingSets.isNotEmpty) {
      loggedSets.putIfAbsent(exercise.orderIndex, () => existingSets);
    } else {
      List<WorkoutSet> newSets = [];
      for (int i = 0; i < exercise.targetSets; i++) {
        final newSet = WorkoutSet()
          ..reps = 0
          ..weight = 0
          ..setNumber = i + 1
          ..exercise.value = exercise
          ..workout.value = activeWorkout;
        await _isarService.saveWorkoutSet(newSet);
        newSets.add(newSet);
      }
      loggedSets.putIfAbsent(exercise.orderIndex, () => newSets);
    }
  }

  Future<void> logSetsForExercise(
    int exerciseOrder,
    Map<int, (double, int)> workoutSets,
    List<int?> skippedSets,
  ) async {
    if (!isWorkoutActive) return;
    List<WorkoutSet>? setsForExercise = loggedSets[exerciseOrder];
    if (setsForExercise == null) return;

    if (skippedSets.length == workoutSets.length) {
      await _isarService.markExerciseAsSkipped(setsForExercise);
      return;
    }

    for (final set in setsForExercise) {
      final performance = workoutSets[set.setNumber];
      if (performance != null && !skippedSets.contains(set.setNumber)) {
        set.weight = performance.$1;
        set.reps = performance.$2;
      } else {
        await _isarService.markSetAsSkipped(set);
      }
    }
    await _isarService.updateWorkoutSets(setsForExercise);
  }

  Future<void> addSetToActiveWorkout({
    required PlanDayExercise planDayExercise,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    if (!isWorkoutActive) return;
    final newSet = WorkoutSet()
      ..setNumber = setNumber
      ..weight = weight
      ..reps = reps
      ..exercise.value = planDayExercise
      ..workout.value = activeWorkout;
    if (loggedSets[planDayExercise.orderIndex] == null) {
      throw Exception();
    }
    loggedSets[planDayExercise.orderIndex]?.add(newSet);
    await _isarService.saveWorkoutSet(newSet);
    await fetchSetsForExercise(planDayExercise);
    notifyListeners();
  }

  Future<void> removeSetFromWorkout({
    required PlanDayExercise planDayExercise,
    required int setNumber,
  }) async {
    if (!isWorkoutActive || loggedSets[planDayExercise.orderIndex] == null) {
      throw Exception();
    }
    loggedSets[planDayExercise.orderIndex]!.removeWhere(
      (workoutSet) => workoutSet.setNumber == setNumber,
    );
    await _isarService.deleteWorkoutSet(
      activeWorkout!,
      setNumber,
      planDayExercise,
    );
    notifyListeners();
  }

  Future<void> fetchSetsForExercise(PlanDayExercise exercise) async {
    if (!isWorkoutActive) return;
    final sets = await _isarService.findSetsForExercise(
      exercise.id,
      activeWorkout!.id,
    );
    loggedSets[exercise.orderIndex] = sets;
    notifyListeners();
  }

  Future<Map<int, List<WorkoutSet>>> _fetchWorkoutSetsForWorkout(
    Workout? workout,
  ) async {
    if (workout == null) {
      return {};
    }
    final exercisesForWorkout = await _fetchExercisesForWorkout(workout);

    if (exercisesForWorkout.isEmpty) {
      return {};
    }

    Map<int, List<WorkoutSet>> result = {};

    for (final exercise in exercisesForWorkout) {
      final sets = await _isarService.findWorkoutSetsForExercise(
        workout,
        exercise,
      );
      result.putIfAbsent(exercise.orderIndex, () => sets);
    }

    return result;
  }

  Future<List<PlanDayExercise>> _fetchExercisesForWorkout(
    Workout? workout,
  ) async {
    if (workout == null) {
      return [];
    }
    final day = workout.planDay.value;

    if (day == null) {
      return [];
    }

    return day.exercises.toList();
  }

  Future<Workout?> _fetchLastWorkout(PlanDay day) async {
    if (!isWorkoutActive) {
      return null;
    }

    return await _isarService.findPreviousWorkout(day, activeWorkout!.date);
  }

  Future<Workout?> _fetchLastCycleWorkout(PlanDay day) async {
    if (!isWorkoutActive) {
      return null;
    }

    await day.plan.load();
    final plan = day.plan.value;

    if (plan == null) {
      return null;
    }

    final cycleDurationInDays = plan.weeksPerCycle * 7;
    final targetDateInPast = activeWorkout!.date.subtract(
      Duration(days: cycleDurationInDays),
    );
    final result = await _isarService.findWorkoutForDate(targetDateInPast);
    return result;
  }

  void finishWorkout() {
    activeWorkout = null;
    lastWorkout = null;
    lastCycleWorkout = null;
    lastCycleWorkoutSets.clear();
    lastWorkoutSets.clear();
    loggedSets.clear();
    notifyListeners();
  }
}
