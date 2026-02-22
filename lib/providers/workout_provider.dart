import 'package:fitness_app/models/custom_data_package_models.dart';
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
  bool _isFinishing = false;
  Map<int, List<WorkoutSet>> loggedSets =
      {}; // Int represents orderIndex of pde
  Map<int, List<WorkoutSet>> lastWorkoutSets = {};
  Map<int, List<WorkoutSet>> lastCycleWorkoutSets = {};
  List<PlanDayExercise> workoutExercises = [];
  double currentCompletion = 0;
  int stopwatchInSeconds = 0;

  late DateTime weekRangeStart;
  late DateTime weekRangeEnd;

  WorkoutProvider(this._isarService, this._planProvider);

  // --- Public Methods ---
  Future<void> getOrCreateWorkoutForDay(PlanDay planDay) async {
    weekRangeStart = _planProvider.currentWeekSelection!.startOfWeek;
    weekRangeEnd = _planProvider.currentWeekSelection!.endOfWeek;

    final existingWorkout = await _isarService.findWorkoutForDay(
      planDay,
      weekRangeStart,
      weekRangeEnd,
    );
    if (existingWorkout != null) {
      activeWorkout = existingWorkout;
      stopwatchInSeconds = existingWorkout.durationInSeconds;
      final sets = existingWorkout.sets.toList();
      loggedSets = _populateLoggedSets(sets);
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
    _calculateWorkoutProgress();

    notifyListeners();
  }

  Future<WorkoutSummaryData> getHistoricalDataForWorkout(
    Workout pastWorkout,
  ) async {
    final exercises = await _fetchExercisesForWorkout(pastWorkout);
    final sets = pastWorkout.sets.toList();
    final historicalSets = _populateLoggedSets(sets);

    return WorkoutSummaryData(
      workout: pastWorkout,
      exercises: exercises,
      workoutSets: historicalSets,
    );
  }

  Future<void> skipWorkout(Workout? workout, PlanDay planDay) async {
    weekRangeStart = _planProvider.currentWeekSelection!.startOfWeek;
    weekRangeEnd = _planProvider.currentWeekSelection!.endOfWeek;
    Workout newWorkout;
    if (workout != null) {
      await _isarService.skipWorkout(workout);
      newWorkout = workout;
    } else {
      final targetDate = weekRangeStart.add(
        Duration(days: planDay.dayOrder - 1),
      );
      newWorkout = Workout()
        ..date = targetDate
        ..planDay.value = planDay
        ..planSession.value = _planProvider.activeSession;
      await _isarService.skipWorkout(newWorkout);
    }
    _planProvider.updateDayMapping(planDay, newWorkout);
    notifyListeners();
  }

  Future<void> unSkipWorkout(Workout workout, PlanDay planDay) async {
    workout.status = WorkoutStatus.planned;
    _planProvider.updateDayMapping(planDay, workout);
    await _isarService.saveWorkout(workout);
    notifyListeners();
  }

  Future<void> reverseSetSkip(WorkoutSet set) async {
    if (!isWorkoutActive || !set.isSkipped) return;
    set.weight = 0.0;
    set.reps = 0;
    set.isSkipped = false;
    await _isarService.saveWorkoutSet(set);
  }

  Future<void> getOrCreateWorkoutSets(PlanDayExercise exercise) async {
    if (!isWorkoutActive) return;
    final existingSets = await _isarService.findWorkoutSetsForExercise(
      activeWorkout!,
      exercise,
    );
    if (existingSets.isNotEmpty) {
      loggedSets[exercise.orderIndex] = existingSets;
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
      loggedSets[exercise.orderIndex] = newSets;
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
    if (setsForExercise == null || setsForExercise.isEmpty) {
      final newSet = WorkoutSet()
        ..setNumber = 1
        ..reps = -1
        ..weight = -1
        ..workout.value = activeWorkout
        ..exercise.value = workoutExercises
            .where((pde) => pde.orderIndex == exerciseOrder)
            .first;
      await skipExercise([newSet], exerciseOrder);
      _calculateWorkoutProgress();
      notifyListeners();
      return;
    }

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
      await skipExercise(setsForExercise, exerciseOrder);
    } else {
      await _isarService.saveWorkoutSets(setsForExercise);
    }
    _calculateWorkoutProgress();
    notifyListeners();
  }

  void cancelLoggingSets(PlanDayExercise pde) {
    if (!isWorkoutActive) throw Exception();
    loggedSets[pde.orderIndex]!.clear();
    notifyListeners();
  }

  Future<void> skipExercise(List<WorkoutSet> sets, int exerciseOrder) async {
    await _isarService.markExerciseAsSkipped(sets);
    loggedSets[exerciseOrder] = [sets.first];
    _calculateWorkoutProgress();
    notifyListeners();
  }

  void addNoteToActiveWorkout({required String note}) {
    if (!isWorkoutActive) return;
    activeWorkout!.note = note;
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

  Future<void> removeSetFromActiveWorkout({
    required PlanDayExercise planDayExercise,
    required int setNumber,
  }) async {
    if (!isWorkoutActive || loggedSets[planDayExercise.orderIndex] == null) {
      throw Exception();
    }
    await _isarService.deleteWorkoutSet(
      activeWorkout!,
      setNumber,
      planDayExercise,
    );
    loggedSets[planDayExercise.orderIndex]!.removeWhere(
      (workoutSet) => workoutSet.setNumber == setNumber,
    );
    notifyListeners();
  }

  Future<void> updateWorkoutDuration(int newDuration) async {
    if (!isWorkoutActive) return; //user already saved time
    activeWorkout!.durationInSeconds = newDuration;
    await _isarService.saveWorkout(activeWorkout!);
  }

  void updateStopwatchSilently(int seconds) {
    stopwatchInSeconds = seconds;
  }

  Future<void> finishWorkout() async {
    if (!isWorkoutActive || _isFinishing) {
      return;
    }
    _isFinishing = true;
    final currentWorkout = activeWorkout!;
    bool hasAnyActivity = false;
    bool isFullyCompleted = true;
    bool isFullySkipped = true;

    for (final exercise in workoutExercises) {
      final sets = loggedSets[exercise.orderIndex];
      if (sets == null || sets.isEmpty) {
        isFullyCompleted = false;
      } else {
        hasAnyActivity = true;
        if (sets.any((workoutSet) => !workoutSet.isSkipped)) {
          isFullySkipped = false;
        }
      }
    }
    WorkoutStatus newStatus;

    if (!hasAnyActivity) {
      // Case A: Planned (User just peeked, didn't log any exercise accordion)
      activeWorkout!.status == WorkoutStatus.skipped
          ? newStatus = WorkoutStatus.skipped
          : newStatus = WorkoutStatus.planned;
    } else if (isFullyCompleted && !isFullySkipped) {
      // Case B: Completed (All exercises have valid data)
      newStatus = WorkoutStatus.completed;
    } else if (isFullySkipped) {
      // Case C: Skipped (All exercises are skipped)
      newStatus = WorkoutStatus.skipped;
    } else {
      // Case D: In Progress (Some exercises touched, or touched but left empty)
      newStatus = WorkoutStatus.inProgress;
    }

    currentWorkout.status = newStatus;
    currentWorkout.durationInSeconds = stopwatchInSeconds;
    await _isarService.saveWorkout(currentWorkout);

    _planProvider.updateDayMapping(
      activeWorkout!.planDay.value!,
      activeWorkout!,
    );
    _planProvider.checkAndUpdateWeekCompletion();

    clearActiveWorkout();
  }

  void clearActiveWorkout() {
    activeWorkout = null;
    lastWorkout = null;
    lastCycleWorkout = null;
    currentCompletion = 0.0;
    lastCycleWorkoutSets.clear();
    lastWorkoutSets.clear();
    loggedSets.clear();
    notifyListeners();
  }

  //Helper methods:
  void _calculateWorkoutProgress() {
    if (loggedSets.values.isEmpty) {
      currentCompletion = 0.0;
      return;
    }

    final totalExercises = workoutExercises.length;

    int completedExercises = 0;
    for (final entry in loggedSets.values) {
      if (entry.isNotEmpty) {
        completedExercises++;
      }
    }

    currentCompletion = completedExercises / totalExercises;
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

  Map<int, List<WorkoutSet>> _populateLoggedSets(List<WorkoutSet> workoutSets) {
    if (!isWorkoutActive) {
      throw Exception("Do not invoke while there is no workout active");
    }
    Map<int, List<WorkoutSet>> result = {};

    for (WorkoutSet w in workoutSets) {
      final exercise = w.exercise.value;
      if (exercise != null) {
        final int index = exercise.orderIndex;
        if (!result.containsKey(index)) {
          result[index] = [];
        }
        result[index]!.add(w);
      } else {
        throw Exception("Database inconsistency");
      }
    }

    for (var sets in result.values) {
      sets.sort((a, b) => a.setNumber.compareTo(b.setNumber));
    }

    return result;
  }

  bool _isValidPerformance((double, int)? performance) {
    if (performance == null) return false;
    return performance.$1 > 0 || performance.$2 > 0;
  }
}
