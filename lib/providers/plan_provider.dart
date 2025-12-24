import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_session.dart';
import 'package:fitness_app/utils/constants.dart';
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
  List<PlanDay> daysForWeek = [];
  WeekSelectionResult? currentWeekSelection;

  PlanProvider(this._isarService) {
    _initialize();
  }

  // -- LOGIC TO FETCH DATA --
  Future<void> _initialize() async {
    isLoading = true;
    notifyListeners();

    activeSession = await _isarService.getActivePlanSession();

    if (activeSession == null) {
      isLoading = false;
      notifyListeners();
      return;
      // TODO: REFACTOR THIS AFTER PLAN CHOOSER WILL BE IMPLEMENTED
    }
    await activeSession!.plan.load();
    _activePlan = activeSession!.plan.value;

    if (_activePlan == null) {
      isLoading = false;
      notifyListeners();
      return;
      // TODO: REFACTOR THIS AFTER PLAN CHOOSER WILL BE IMPLEMENTED
    }
    await _updateForWeek(activeSession!.lastCompletedAbsoluteWeek + 1);
    await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _updateForWeek(int totalWeek) async {
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
    await _fetchDaysForWeek(week);
    notifyListeners();
  }

  void goToNextWeek() async {
    if (_activePlan != null) {
      _updateForWeek(currentWeekSelection!.selectedTotalWeek + 1);
      await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
      notifyListeners();
    }
  }

  void goToPreviousWeek() async {
    if (currentWeekSelection!.selectedTotalWeek > 1 && _activePlan != null) {
      _updateForWeek(currentWeekSelection!.selectedTotalWeek - 1);
      await _fetchDaysForWeek(currentWeekSelection!.selectedTotalWeek);
      notifyListeners();
    }
  }

  int get currentWeekInCycle {
    if (_activePlan == null) return 1;
    return weekFromAbsoluteWeek(
      currentWeekSelection!.selectedTotalWeek,
      _activePlan!.weeksPerCycle,
    );
  }

  int get currentCycle {
    if (_activePlan == null) return 1;
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
    // Format both dates and combine them into a single string.
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
}
