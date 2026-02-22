import 'weight_log.dart';

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
