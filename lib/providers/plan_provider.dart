import 'package:fitness_app/models/custom_data_package_models.dart';
import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_session.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/plan.dart';
import 'isar_service.dart';

class PlanProvider extends ChangeNotifier {
  final IsarService _isarService;

  // -- STATE VARIABLES --
  Plan? _activePlan;
  PlanSession? activeSession;
  bool isLoading = true;
  Map<int, (PlanDay, Workout?)> daysForWeek =
      {}; //int represents PlanDay.dayOrder
  WeekSelectionResult? currentWeekSelection;
  double currentCompletion = 0;

  PlanProvider(this._isarService) {
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();
    try {
      activeSession = await _isarService.findActivePlanSession();

      if (activeSession != null) {
        await _loadDataForActiveSession();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> endPlanSession() async {
    if (activeSession == null) return;
    isLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      activeSession!.endDate = today
          .subtract(Duration(days: today.weekday - 1))
          .add(Duration(days: 6));

      await _isarService.savePlanSession(activeSession!);
      _activePlan!.isActive = false;
      await _isarService.savePlan(_activePlan!);

      activeSession = null;
      _activePlan = null;
      currentWeekSelection = null;
      daysForWeek = {};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startPlanSession(
    Plan plan,
    PlanPersonalizationResult personalization,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      plan.isActive = true;
      await _isarService.savePlan(plan);
      PlanSession newSession = PlanSession()
        ..plan.value = plan
        ..startDate = personalization.firstWeekStart
        ..lastCompletedAbsoluteWeek = 0;
      activeSession = await _isarService.savePlanSession(newSession);

      if (personalization.dayOrder != null) {
        await _isarService.personalisePlan(plan, personalization.dayOrder!);
      }

      final firstWorkoutDay = personalization.selectedStartDate.weekday;
      await plan.days.load();
      final allPlanDays = plan.days.toList();
      final firstWeekDays = allPlanDays
          .where((day) => day.weekNumber == 1)
          .toList();
      for (final planDay in firstWeekDays) {
        if (planDay.dayOrder < firstWorkoutDay) {
          final DateTime missedDate = personalization.firstWeekStart.add(
            Duration(days: planDay.dayOrder - 1),
          );
          final skippedWorkout = Workout()
            ..date = missedDate
            ..planSession.value = activeSession
            ..status = WorkoutStatus.skipped
            ..planDay.value = planDay;
          await _isarService.saveWorkout(skippedWorkout);
        }
      }

      await _loadDataForActiveSession();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> renewPlanSession(Plan plan, PlanSession planSession) async {
    isLoading = true;
    notifyListeners();
    try {
      plan.isActive = true;
      await _isarService.savePlan(plan);
      planSession.endDate = null;
      activeSession = await _isarService.savePlanSession(planSession);
      await _loadDataForActiveSession();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void checkAndUpdateWeekCompletion() {
    if (activeSession == null || currentWeekSelection == null) return;
    final thisSelectedWeek = currentWeekSelection!.selectedTotalWeek;
    final lastCompletedWeek = activeSession!.lastCompletedAbsoluteWeek;

    if (thisSelectedWeek <= lastCompletedWeek) return;

    final allDaysCompleted = daysForWeek.values.every((entry) {
      final workout = entry.$2;
      return workout != null &&
          (workout.status == WorkoutStatus.completed ||
              workout.status == WorkoutStatus.skipped);
    });

    if (allDaysCompleted && thisSelectedWeek > lastCompletedWeek) {
      activeSession!.lastCompletedAbsoluteWeek = thisSelectedWeek;
      _isarService.savePlanSession(activeSession!);
    }
  }

  void updateDayMapping(PlanDay day, Workout workout) {
    daysForWeek[day.dayOrder] = (day, workout);
    _calculateWeeklyCompletion();
    notifyListeners();
  }

  void goToAnyWeek(int week) async {
    await _updateForWeek(week);
    notifyListeners();
  }

  void goToNextWeek() async {
    if (currentWeekSelection != null) {
      checkAndUpdateWeekCompletion();
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek + 1);
      notifyListeners();
    }
  }

  void goToPreviousWeek() async {
    if (currentWeekSelection != null) {
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek - 1);
      notifyListeners();
    }
  }

  // Helper methods
  Future<void> _updateForWeek(int totalWeek) async {
    if (_activePlan == null || activeSession == null) throw Exception();

    final dateInSelectedWeek = activeSession!.startDate.add(
      Duration(days: (totalWeek - 1) * 7),
    );
    final startOfWeek = dateInSelectedWeek.subtract(
      Duration(days: dateInSelectedWeek.weekday - 1),
    );

    final endOfWeek = startOfWeek.add(Duration(days: 6));
    currentWeekSelection = WeekSelectionResult(
      selectedTotalWeek: totalWeek,
      startOfWeek: startOfWeek,
      endOfWeek: endOfWeek,
    );
    int weekNumber = weekFromAbsoluteWeek(
      totalWeek,
      _activePlan!.weeksPerCycle,
    );
    final planDaysForWeek = await _isarService.findDaysForWeek(
      weekNumber,
      _activePlan!,
    );
    final workoutsInWeek = await _isarService.findWorkoutsForWeek(
      startOfWeek,
      endOfWeek,
      _activePlan!,
    );

    daysForWeek = {
      for (var day in planDaysForWeek)
        day.dayOrder: (
          day,
          workoutsInWeek.cast<Workout?>().firstWhere(
            (workout) => workout?.date.weekday == day.dayOrder,
            orElse: () => null,
          ),
        ),
    };
    _calculateWeeklyCompletion();
  }

  void _calculateWeeklyCompletion() {
    if (daysForWeek.isEmpty) {
      currentCompletion = 0.0;
      return;
    }

    final totalDays = daysForWeek.length;

    int completedDays = 0;
    for (final entry in daysForWeek.values) {
      if (entry.$2 != null && entry.$2?.status == WorkoutStatus.completed ||
          entry.$2?.status == WorkoutStatus.skipped) {
        completedDays++;
      }
    }

    currentCompletion = completedDays / totalDays;
  }

  Future<void> _loadDataForActiveSession() async {
    if (activeSession == null) throw Exception();

    if (activeSession!.plan.value == null) {
      await activeSession!.plan.load();
    }
    _activePlan = activeSession!.plan.value;
    if (_activePlan == null) throw Exception("plan bound to session not found");
    await _updateForWeek(activeSession!.lastCompletedAbsoluteWeek + 1);
  }

  // getters
  int get currentWeekInCycle {
    if (_activePlan == null || currentWeekSelection == null) return -1;
    return weekFromAbsoluteWeek(
      currentWeekSelection!.selectedTotalWeek,
      _activePlan!.weeksPerCycle,
    );
  }

  int get currentCycle {
    if (_activePlan == null || currentWeekSelection == null) return -1;
    return cycleFromAbsoluteWeek(
      currentWeekSelection!.selectedTotalWeek,
      _activePlan!.weeksPerCycle,
    );
  }

  String get formattedDateRange {
    if (currentWeekSelection == null) {
      return 'Loading date...';
    }

    final formatter = DateFormat('yMMMd');

    final start = currentWeekSelection!.startOfWeek;
    final end = currentWeekSelection!.endOfWeek;
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
}
