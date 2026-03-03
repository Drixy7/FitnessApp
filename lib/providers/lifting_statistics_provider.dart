import 'dart:async';

import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/lifting_statistics_models.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../models/workout_set.dart';

//todo udělej tady metodu co updatuje ui po výběru v dropboxu, metodu pro výpočty statistik podle modelů
class LiftingStatisticsProvider extends ChangeNotifier {
  final IsarService _isarService;
  Timer? _debounceTimer;
  bool exerciseLoading = true;
  bool planLoading = true;

  List<Plan> validPlans = [];
  Plan? selectedPlan;
  Map<String, List<Exercise>> groupedExercises = {};
  Exercise? selectedExercise;

  StreamSubscription<void>? _planSubscription;
  ExerciseSummary? exerciseSummary;
  PlanSummary? planSummary;
  bool get hasValidPlan => validPlans.isNotEmpty;

  LiftingStatisticsProvider(this._isarService) {
    _init();
    _listenToDatabaseChanges();
  }

  Future<void> _init() async {
    validPlans = await _isarService.findAllValidPlans();
    selectedPlan ??= validPlans.firstOrNull;
    if (selectedPlan != null) {
      await _loadGroupedExercises(selectedPlan!);
    }
    planLoading = false;
    exerciseLoading = false;
    notifyListeners();
  }

  void _listenToDatabaseChanges() {
    _planSubscription = _isarService.watchPlanChanges().listen((_) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        _init();
      });
    });
  }

  @override
  void dispose() {
    _planSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadDataForExercise() async {
    if (selectedExercise == null) return;
    exerciseLoading = true;
    notifyListeners();
    try {
      final allSets = await _isarService.findAllWorkoutSetsForExercise(
        selectedExercise!,
      );
      if (allSets.isEmpty) {
        return;
      }
      WorkoutSet? maxSet;
      double oneRepMax = double.minPositive;
      final WorkoutSet firstSet = allSets.first;
      WorkoutSet bestSet = firstSet;
      int skippedCount = 0;
      int repClamp;
      await firstSet.exercise.load();
      final RepRange setRepRange = firstSet.exercise.value!.targetReps;

      switch (setRepRange) {
        case RepRange.lowRep:
          repClamp = 6;
        case RepRange.strength:
          repClamp = 10;
        case RepRange.hypertrophy:
          repClamp = 13;
        case RepRange.extendedHypertrophy:
          repClamp = 16;
        case RepRange.highRep:
          repClamp = 20;
      }
      for (final set in allSets) {
        if (set.reps > repClamp) {
          continue;
        }
        final erm = set.weight * (1 + set.reps / 30);
        if (erm > oneRepMax) {
          oneRepMax = erm;
          bestSet = set;
        }
        if (set.reps == 1) maxSet = set;
        if (set.isSkipped) skippedCount++;
      }
      exerciseSummary = ExerciseSummary(
        bestSet: bestSet,
        oneRepMax: oneRepMax,
        maxSet: maxSet,
        skippedCount: skippedCount,
        progress: await _calculateLinearProgress(allSets, repClamp),
      );
    } finally {
      exerciseLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDataForPlan() async {
    if (selectedPlan == null) return;
    planLoading = true;
    notifyListeners();
    try {
      final allSets = await _isarService.findValidWorkoutSetsForPlan(
        selectedPlan!,
      );
      final allWorkouts = await _isarService.findAllWorkoutsForPlan(
        selectedPlan!,
      );
      double totalVolume = 0;
      int totalReps = 0;
      int workoutsCompleted = 0;
      int workoutsSkipped = 0;
      final int workoutConsistency;
      int numberOfCompletedWorkouts = 0;
      int sumOfWorkoutTime = 0;

      for (final set in allSets) {
        totalReps += set.reps;
        totalVolume += set.reps * set.weight;
      }

      for (final w in allWorkouts) {
        switch (w.status) {
          case WorkoutStatus.completed:
            workoutsCompleted++;
            sumOfWorkoutTime += w.durationInSeconds;
            numberOfCompletedWorkouts++;
          case WorkoutStatus.skipped:
            workoutsSkipped++;
          default:
            continue;
        }
      }

      workoutConsistency = ((workoutsCompleted / allWorkouts.length) * 100)
          .toInt();
      planSummary = PlanSummary(
        weightVolume: totalVolume,
        avgWorkoutTime: numberOfCompletedWorkouts == 0
            ? 0
            : (sumOfWorkoutTime / numberOfCompletedWorkouts).toInt(),
        totalReps: totalReps,
        workoutConsistency: workoutConsistency,
        workoutsCompleted: workoutsCompleted,
        workoutsSkipped: workoutsSkipped,
      );
      await _loadGroupedExercises(selectedPlan!);
    } finally {
      planLoading = false;
      notifyListeners();
    }
  }

  void setSelectedExercise(Exercise e) {
    selectedExercise = e;
    loadDataForExercise();
  }

  void setSelectedPlan(Plan p) {
    selectedPlan = p;
    loadDataForPlan();
  }

  Future<void> _loadGroupedExercises(Plan p) async {
    groupedExercises = await _isarService.findExercisesForPlan(p);
    selectedExercise = groupedExercises.values.first.firstOrNull;
    await loadDataForExercise();
  }

  Future<double?> _calculateLinearProgress(
    List<WorkoutSet> sets,
    int repClamp,
  ) async {
    final Map<DateTime, double> dailyMax = {};

    // 1. Seskupení na "Jeden nejlepší e1RM za den" (Odfiltrování lehčích sérií ze stejného dne)
    for (final set in sets) {
      if (set.isSkipped || set.reps > repClamp) continue;

      await set.workout.load();
      final workout = set.workout.value;
      if (workout == null) continue;

      final date = DateTime(
        workout.date.year,
        workout.date.month,
        workout.date.day,
      );
      final erm = set.weight * (1 + set.reps / 30);

      if (!dailyMax.containsKey(date) || dailyMax[date]! < erm) {
        dailyMax[date] = erm;
      }
    }
    if (dailyMax.length < 2) {
      return null;
    }
    final entries = dailyMax.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final firstDate = entries.first.key;
    final lastDate = entries.last.key;

    final int n = entries.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (final entry in entries) {
      final double x = entry.key
          .difference(firstDate)
          .inDays
          .toDouble(); // Osa X: Dny
      final double y = entry.value; // Osa Y: e1RM

      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    final double denominator = (n * sumX2) - (sumX * sumX);
    if (denominator == 0) return null;

    final double slope = ((n * sumXY) - (sumX * sumY)) / denominator;
    final double totalDays = lastDate.difference(firstDate).inDays.toDouble();

    return slope * totalDays; // Vrátí reálný celkový přírůstek/úbytek síly v kg
  }
}
