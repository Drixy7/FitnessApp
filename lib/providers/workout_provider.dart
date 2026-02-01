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

  late DateTime weekRangeStart;
  late DateTime weekRangeEnd;

  WorkoutProvider(this._isarService, this._planProvider);
  // --- Public Methods ---
  Future<void> getOrCreateWorkoutForDay(
    PlanDay planDay,
    WeekSelectionResult weekSelection,
  ) async {
    weekRangeStart = weekSelection.startOfWeek;
    weekRangeEnd = weekSelection.endOfWeek;

    final existingWorkout = await _isarService.findWorkoutForDay(
      planDay,
      weekRangeStart,
      weekRangeEnd,
    );
    if (existingWorkout != null) {
      activeWorkout = existingWorkout;
    } else {
      final targetDate = weekRangeStart.add(
        Duration(days: planDay.dayOrder - 1),
      );
      final newWorkout = Workout()
        ..date = targetDate
        ..planDay.value = planDay
        ..planSession.value = _planProvider.activeSession;
      final savedWorkout = await _isarService.saveWorkout(newWorkout);
      activeWorkout = savedWorkout;
    }

    _planProvider.updateDayMapping(planDay, activeWorkout!);
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
    if (!isWorkoutActive) {
      throw Exception("logging Sets failed there is no active workout");
    }
    List<WorkoutSet>? setsForExercise = loggedSets[exerciseOrder];
    if (setsForExercise == null || setsForExercise.isEmpty) return;

    bool hasAtLeastOneValidSet = false;

    for (final set in setsForExercise) {
      final performance = workoutSets[set.setNumber];

      final isExplicitlySkipped = skippedSets.contains(set.setNumber);

      final isImplicitlySkipped = !_isValidPerformance(performance);

      if (isExplicitlySkipped || isImplicitlySkipped) {
        set.isSkipped = true;
      } else {
        set.isSkipped = false;
        set.weight = performance!.$1;
        set.reps = performance.$2;
        hasAtLeastOneValidSet = true;
      }
    }

    if (!hasAtLeastOneValidSet) {
      await _isarService.markExerciseAsSkipped(setsForExercise);
      loggedSets[exerciseOrder] = [setsForExercise.first];
    } else {
      await _isarService.createWorkoutSets(setsForExercise);
    }
  }

  void cancelLoggingSets(PlanDayExercise pde) {
    if (!isWorkoutActive) throw Exception();
    loggedSets.remove(pde.orderIndex);
    notifyListeners();
  }

  void addSetToActiveWorkout({
    required PlanDayExercise planDayExercise,
    required int setNumber,
    required int reps,
    required double weight,
  }) {
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
    loggedSets[planDayExercise.orderIndex]!.add(newSet);
    notifyListeners();
  }

  void removeSetFromWorkout({
    required PlanDayExercise planDayExercise,
    required int setNumber,
  }) {
    if (!isWorkoutActive || loggedSets[planDayExercise.orderIndex] == null) {
      throw Exception();
    }
    loggedSets[planDayExercise.orderIndex]!.removeWhere(
      (workoutSet) => workoutSet.setNumber == setNumber,
    );
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

  bool _isValidPerformance((double, int)? performance) {
    if (performance == null) return false;
    return performance.$1 > 0 || performance.$2 > 0;
  }

  Future<void> finishWorkout() async {
    if (!isWorkoutActive) {
      throw Exception("No workout Active -> finish Workout");
    }
    // --- STEP 1: ANALYZE DATA ---
    bool hasAnyActivity = false;
    bool isFullyCompleted = true;

    for (final exercise in workoutExercises) {
      final sets = loggedSets[exercise.orderIndex];
      if (sets == null || sets.isEmpty) {
        isFullyCompleted = false;
      } else {
        hasAnyActivity = true;
      }
    }
    WorkoutStatus newStatus;

    if (!hasAnyActivity) {
      // Case A: Planned (User just peeked, didn't open any exercise accordion)
      activeWorkout!.status == WorkoutStatus.skipped
          ? newStatus = WorkoutStatus.skipped
          : newStatus = WorkoutStatus.planned;
    } else if (isFullyCompleted) {
      // Case B: Completed (All exercises have valid data)
      newStatus = WorkoutStatus.completed;
    } else {
      // Case C: In Progress (Some exercises touched, or touched but left empty)
      newStatus = WorkoutStatus.inProgress;
    }

    activeWorkout!.status = newStatus;
    await _isarService.saveWorkout(activeWorkout!);

    // --- STEP 4: TRIGGER PLAN LOGIC (If Completed) ---
    if (newStatus == WorkoutStatus.completed ||
        newStatus == WorkoutStatus.inProgress) {
      _planProvider.updateDayMapping(
        activeWorkout!.planDay.value!,
        activeWorkout!,
      );
    }
    activeWorkout = null;
    lastWorkout = null;
    lastCycleWorkout = null;
    lastCycleWorkoutSets.clear();
    lastWorkoutSets.clear();
    loggedSets.clear();
    notifyListeners();
  }
}
