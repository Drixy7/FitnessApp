import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_session.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/plan.dart';
import 'isar_service.dart';

//TODO refactor so when Plan Session is terminated it only is accessible as an history object
class PlanProvider extends ChangeNotifier {
  final IsarService _isarService;

  // -- STATE VARIABLES --
  Plan? _activePlan;
  PlanSession? activeSession;
  bool isLoading = true;
  Map<PlanDay, Workout?> daysForWeek = {};
  WeekSelectionResult? currentWeekSelection;

  PlanProvider(this._isarService) {
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();

    activeSession = await _isarService.findActivePlanSession();

    if (activeSession != null) {
      await _loadDataForActiveSession();
    }

    isLoading = false;
    notifyListeners();
  }

  // -- LOGIC TO FETCH DATA --
  Future<void> _loadDataForActiveSession() async {
    if (activeSession == null) throw Exception();

    if (activeSession!.plan.value == null) {
      await activeSession!.plan.load();
    }
    _activePlan = activeSession!.plan.value;
    if (_activePlan == null) throw Exception("plan bound to session not found");
    await _updateForWeek(activeSession!.lastCompletedAbsoluteWeek + 1);
    isLoading = false;
    notifyListeners();
  }

  Future<void> endPlanSession() async {
    if (activeSession == null) return;
    isLoading = true;
    notifyListeners(); //TODO REFACTOR THIS TO USE THE SUNDAY OF THE LAST COUNTED WEEK
    final now = DateTime.now();
    activeSession!.endDate = DateTime(now.year, now.month, now.day);
    await _isarService.createOrSaveSession(activeSession!);
    _activePlan!.isActive = false;
    await _isarService.savePlan(_activePlan!);
    activeSession = null;
    _activePlan = null;
    currentWeekSelection = null;
    daysForWeek = {};
    isLoading = false;
    notifyListeners();
  }

  Future<void> startPlanSession(
    Plan plan,
    PlanPersonalizationResult personalization,
  ) async {
    //TODO Implement workout skip logic depending on personalization.selectedStartDate
    isLoading = true;
    notifyListeners();
    plan.isActive = true;
    await _isarService.savePlan(plan);
    PlanSession newSession = PlanSession()
      ..plan.value = plan
      ..startDate = personalization.firstWeekStart
      ..lastCompletedAbsoluteWeek = 0;
    activeSession = await _isarService.createOrSaveSession(newSession);

    if (personalization.dayOrder != null) {
      await _isarService.personalisePlan(plan, personalization.dayOrder!);
    }

    await _loadDataForActiveSession();
    isLoading = false;
    notifyListeners();
  }

  Future<void> renewPlanSession(Plan plan, PlanSession planSession) async {
    isLoading = true;
    notifyListeners();

    plan.isActive = true;
    await _isarService.savePlan(plan);
    planSession.endDate = null;
    activeSession = await _isarService.createOrSaveSession(planSession);
    await _loadDataForActiveSession();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _updateForWeek(int totalWeek) async {
    //TODO Implement adding logged workouts to a List<>
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
    final planDaysForWeek = await _isarService.findDaysForWeek(weekNumber);
    final workoutsInWeek = await _isarService.findWorkoutsForWeek(
      startOfWeek,
      endOfWeek,
    );

    daysForWeek = {
      for (var day in planDaysForWeek)
        day: workoutsInWeek.cast<Workout?>().firstWhere(
          (workout) => workout?.date.weekday == day.dayOrder,
          orElse: () => null,
        ),
    };
  }

  void updateDayMapping(PlanDay day, Workout workout) {
    daysForWeek[day] = workout;
    notifyListeners();
  }

  void goToAnyWeek(int week) async {
    await _updateForWeek(week);
    notifyListeners();
  }

  void goToNextWeek() async {
    //TODO ADD future limiters
    if (currentWeekSelection != null && _activePlan != null) {
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek + 1);
      notifyListeners();
    }
  }

  void goToPreviousWeek() async {
    //TODO ADD Limiter for going into past further than PlanStartDate
    if (currentWeekSelection != null &&
        currentWeekSelection!.selectedTotalWeek != 1) {
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek - 1);
      notifyListeners();
    }
  }

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

  DateTime? get planStartDate {
    return _activePlan?.startedAt;
  }
}
