import 'dart:math';

import 'package:fitness_app/models/weight_log.dart';

enum BodyPart {
  abs,
  back,
  biceps,
  triceps,
  shoulders,
  chest,
  glutes,
  hamstrings,
  quads,
  calves,
  forearms,
}

enum Difficulty { beginner, intermediate, advanced }

enum Rating { veryEasy, easy, neutral, hard, veryHard }

enum RepRange {
  lowRep, //0-5
  strength, //6-8
  hypertrophy, //8-12
  extendedHypertrophy, //12-15
  highRep, //15+
}

enum WorkoutStatus { planned, inProgress, completed, skipped }

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
// models/statistics_models.dart

class WeeklyWeightSegment {
  final int weekNumber;
  final DateTime startDate;
  final DateTime endDate;
  double averageWeight;
  double minWeight;
  double maxWeight;
  List<WeightLog> dailyLogs;

  WeeklyWeightSegment({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.averageWeight,
    required this.minWeight,
    required this.maxWeight,
    required this.dailyLogs,
  });
  void recalculateInternalStats() {
    double sum = 0;
    double max = double.minPositive;
    double min = double.maxFinite;

    for (var log in dailyLogs) {
      sum += log.weight;
      if (log.weight < min) min = log.weight;
      if (log.weight > max) max = log.weight;
    }
    averageWeight = sum / dailyLogs.length;
    minWeight = min;
    maxWeight = max;
  }
}

class WeightSummary {
  final double lowestInRange;
  final double highestInRange;
  final double averageWeeklyChange;
  final double startWeight;
  final double currentWeight;

  WeightSummary({
    this.lowestInRange = 0,
    this.highestInRange = 0,
    this.averageWeeklyChange = 0,
    this.startWeight = 0,
    this.currentWeight = 0,
  });
}

enum BodyWeightButtonResult { average, daily, all }
