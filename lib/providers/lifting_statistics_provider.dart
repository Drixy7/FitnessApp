import 'dart:async';

import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/lifting_statistics_models.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/plan.dart';

//todo udělej tady metodu co updatuje ui po výběru v dropboxu, metodu pro výpočty statistik podle modelů
class LiftingStatisticsProvider extends ChangeNotifier {
  final IsarService _isarService;
  bool isLoading = true;

  List<Plan> validPlans = [];
  Plan? selectedPlan;
  List<Exercise> exercisesForSelectedPlan = [];

  StreamSubscription<void>? _planSubscription;
  late final ExerciseSummary exerciseSummary;
  late final PlanSummary planSummary;
  bool get hasValidPlan => validPlans.isNotEmpty;

  LiftingStatisticsProvider(this._isarService) {
    _init();
    _listenToDatabaseChanges();
  }

  Future<void> _init() async {
    validPlans = await _isarService.findAllValidPlans();
    selectedPlan = validPlans.firstOrNull;
    if (selectedPlan != null) {
      exercisesForSelectedPlan = await _isarService.findExercisesForPlan(
        selectedPlan!,
      );
    }
    isLoading = false;
    notifyListeners();
  }

  void _listenToDatabaseChanges() {
    _planSubscription = _isarService.watchPlanChanges().listen((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _planSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadDataForExercise(Exercise exercise) async {}
  Future<void> loadDataForPlan(Plan plan, Exercise firstExercise) async {
    isLoading = true;
  }
}
