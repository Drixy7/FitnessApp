import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_session.dart';
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
  List<PlanDay> daysForWeek = [];
  WeekSelectionResult? currentWeekSelection;

  PlanProvider(this._isarService) {
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();

    activeSession = await _isarService.getActivePlanSession();

    if (activeSession != null) {
      await _loadDataForActiveSession();
    }

    isLoading = false;
    notifyListeners();
  }

  // -- LOGIC TO FETCH DATA --
  Future<void> _loadDataForActiveSession() async {
    if (activeSession == null) return;

    if (activeSession!.plan.value == null) {
      await activeSession!.plan.load();
    }
    _activePlan = activeSession!.plan.value;
    if (_activePlan == null) return;
    await _updateForWeek(activeSession!.lastCompletedAbsoluteWeek + 1);
    await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
    isLoading = false;
    notifyListeners();
  }

  Future<void> endPlanSession() async {
    if (activeSession == null) return;
    isLoading = true;
    notifyListeners();
    final now = DateTime.now();
    activeSession!.endDate = DateTime(now.year, now.month, now.day);
    await _isarService.createOrSaveSession(activeSession!);
    activeSession = null;
    _activePlan = null;
    currentWeekSelection = null;
    daysForWeek = [];
    isLoading = false;
    notifyListeners();
  }

  Future<void> startPlan(
    Plan plan,
    PlanPersonalizationResult personalization,
  ) async {
    //TODO Implement workout skip logic depending on personalization.selectedStartDate
    isLoading = true;
    notifyListeners();

    PlanSession? previousSession = await _isarService.getLastPlanSession(plan);
    plan.isActive = true;

    if (previousSession != null &&
        previousSession.startTime == personalization.firstWeekStart) {
      activeSession = previousSession;
    } else {
      PlanSession newSession = PlanSession()
        ..plan.value = plan
        ..startTime = personalization.firstWeekStart
        ..lastCompletedAbsoluteWeek =
            previousSession?.lastCompletedAbsoluteWeek ?? 0;

      activeSession = await _isarService.createOrSaveSession(newSession);
    }
    if (personalization.dayOrder != null) {
      await _isarService.personalisePlan(plan, personalization.dayOrder!);
    }

    await _loadDataForActiveSession();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _updateForWeek(int totalWeek) async {
    //TODO Implement creating of workouts after accessing a week?
    if (_activePlan == null || activeSession == null) return;

    final dateInSelectedWeek = activeSession!.startTime.add(
      Duration(days: (totalWeek - 1) * 7),
    );
    final startOfWeekUnstripped = dateInSelectedWeek.subtract(
      Duration(days: dateInSelectedWeek.weekday - 1),
    );

    final startOfWeek = DateTime(
      startOfWeekUnstripped.year,
      startOfWeekUnstripped.month,
      startOfWeekUnstripped.day,
    );
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    currentWeekSelection = WeekSelectionResult(
      selectedTotalWeek: totalWeek,
      startOfWeek: startOfWeek,
      endOfWeek: endOfWeek,
    );
  }

  Future<void> _fetchDaysForWeek(int absoluteWeekNumber) async {
    if (_activePlan != null && absoluteWeekNumber >= 1) {
      int weekNumber = weekFromAbsoluteWeek(
        absoluteWeekNumber,
        _activePlan!.weeksPerCycle,
      );
      daysForWeek = await _isarService.getDaysForWeek(weekNumber);
    }
  }

  void goToAnyWeek(int week) async {
    await _updateForWeek(week);
    await _fetchDaysForWeek(week);
    notifyListeners();
  }

  void goToNextWeek() async {
    //TODO ADD future limiters
    if (currentWeekSelection != null && _activePlan != null) {
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek + 1);
      await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
      notifyListeners();
    }
  }

  void goToPreviousWeek() async {
    //TODO ADD Limiter for going into past further than PlanStartDate
    if (currentWeekSelection != null &&
        currentWeekSelection!.selectedTotalWeek != 1) {
      await _updateForWeek(currentWeekSelection!.selectedTotalWeek - 1);
      await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
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
