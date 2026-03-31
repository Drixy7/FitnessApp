import 'package:fitness_app/models/body_weight_statistics_models.dart';
import 'package:fitness_app/models/weight_log.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:week_of_year/week_of_year.dart';

class BodyWeightStatisticsProvider extends ChangeNotifier {
  final IsarService _isarService;

  // -- STATE --
  bool isLoading = false;
  List<WeeklyWeightSegment> _allWeeklySegments = [];
  List<WeeklyWeightSegment> _validWeeklySegments = [];
  WeightSummary _summary = WeightSummary();
  DateTime rangeStart;
  DateTime rangeEnd;

  List<WeeklyWeightSegment> get allWeeklySegments => _allWeeklySegments;
  List<WeeklyWeightSegment> get validWeeklySegments => _validWeeklySegments;

  WeightSummary get summary => _summary;

  BodyWeightStatisticsProvider(this._isarService)
    : rangeEnd = DateTime.now(),
      rangeStart = DateTime.now() {
    final now = DateTime.now();

    rangeEnd = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 8 - now.weekday))
        .subtract(const Duration(milliseconds: 1));

    final thirtyDaysAgo = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 30));
    rangeStart = thirtyDaysAgo.subtract(
      Duration(days: thirtyDaysAgo.weekday - 1),
    );
  }

  Future<void> loadBodyWeightStats() async {
    isLoading = true;
    notifyListeners();
    final rawLogs = await _isarService.findWeightLogsForDateRange(
      rangeStart,
      rangeEnd,
    );
    _calculateWeeklySegments(rawLogs, rangeStart, rangeEnd);
    _summary = _calculateSummary(rawLogs, _validWeeklySegments);
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    rangeStart = DateTime(
      start.year,
      start.month,
      start.day,
    ).subtract(Duration(days: start.weekday - 1));
    rangeEnd = DateTime(end.year, end.month, end.day)
        .add(Duration(days: 8 - end.weekday))
        .subtract(const Duration(milliseconds: 1));
    await loadBodyWeightStats();
  }

  void _calculateWeeklySegments(
    List<WeightLog> logs,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    List<WeeklyWeightSegment> allSegments = [];
    List<WeeklyWeightSegment> validSegments = [];

    Map<int, List<WeightLog>> logsByWeek = {};
    for (var log in logs) {
      final key = (log.date.year * 100) + log.date.weekOfYear;
      logsByWeek.putIfAbsent(key, () => []).add(log);
    }

    while (rangeStart.isBefore(rangeEnd)) {
      final int weekNum = rangeStart.weekOfYear;
      final int year = rangeStart.year;
      final int weekKey = (year * 100) + weekNum;

      final List<WeightLog> weekLogs = logsByWeek[weekKey] ?? [];

      if (weekLogs.isEmpty) {
        allSegments.add(
          WeeklyWeightSegment(
            weekNumber: weekKey,
            startDate: rangeStart,
            endDate: rangeStart.add(
              const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
            ),
            averageWeight: 0,
            minWeight: 0,
            maxWeight: 0,
            dailyLogs: [],
          ),
        );
      } else {
        double sum = 0;
        double min = double.maxFinite;
        double max = double.minPositive;

        for (var log in weekLogs) {
          sum += log.weight;
          if (log.weight < min) min = log.weight;
          if (log.weight > max) max = log.weight;
        }

        final segment = WeeklyWeightSegment(
          weekNumber: weekKey,
          startDate: rangeStart,
          endDate: rangeStart.add(
            const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
          ),
          averageWeight: sum / weekLogs.length,
          minWeight: min,
          maxWeight: max,
          dailyLogs: weekLogs..sort((a, b) => a.date.compareTo(b.date)),
        );

        allSegments.add(segment);
        validSegments.add(segment);
      }

      rangeStart = rangeStart.add(const Duration(days: 7));
    }
    _allWeeklySegments = allSegments;
    _validWeeklySegments = validSegments;
  }

  WeightSummary _calculateSummary(
    List<WeightLog> allLogs,
    List<WeeklyWeightSegment> segments,
  ) {
    if (segments.isEmpty || allLogs.isEmpty) {
      return WeightSummary(
        lowestInRange: 0,
        highestInRange: 0,
        averageWeeklyChange: 0,
        startWeight: 0,
        currentWeight: 0,
      );
    }

    double globalMin = segments
        .map((e) => e.minWeight)
        .reduce((a, b) => a < b ? a : b);
    double globalMax = segments
        .map((e) => e.maxWeight)
        .reduce((a, b) => a > b ? a : b);

    double avgChange = 0;
    int n = segments.length;

    if (n >= 2) {
      double sumX = 0;
      double sumY = 0;
      double sumXY = 0;
      double sumXX = 0;

      for (int i = 0; i < n; i++) {
        double x = i.toDouble();
        double y = segments[i].averageWeight;

        sumX += x;
        sumY += y;
        sumXY += (x * y);
        sumXX += (x * x);
      }

      double denominator = (n * sumXX) - (sumX * sumX);

      if (denominator != 0) {
        avgChange = ((n * sumXY) - (sumX * sumY)) / denominator;
      }
    }

    return WeightSummary(
      lowestInRange: globalMin,
      highestInRange: globalMax,
      averageWeeklyChange: avgChange,
      startWeight: allLogs.first.weight,
      currentWeight: allLogs.last.weight,
    );
  }

  Future<void> updateSingleLog(WeightLog updatedLog) async {
    final weekKey = (updatedLog.date.year * 100) + updatedLog.date.weekOfYear;
    final segment = _findWeekSegmentToUpdate(
      weekKey,
      _validWeeklySegments,
      0,
      _validWeeklySegments.length - 1,
    );

    if (segment == null) {
      return await loadBodyWeightStats();
    }
    final index = segment.dailyLogs.indexWhere((l) => l.id == updatedLog.id);

    if (index != -1) {
      segment.dailyLogs[index] = updatedLog;
    } else {
      segment.dailyLogs.add(updatedLog);
    }
    segment.recalculateInternalStats();
    final logs = await _isarService.findWeightLogsForDateRange(
      rangeStart,
      rangeEnd,
    );

    _summary = _calculateSummary(logs, _validWeeklySegments);
    notifyListeners();
  }

  WeeklyWeightSegment? _findWeekSegmentToUpdate(
    int weekKey,
    List<WeeklyWeightSegment> segments,
    int startIndex,
    int endIndex,
  ) {
    if (startIndex > endIndex) return null;
    final midIndex = startIndex + (endIndex - startIndex) ~/ 2;
    final segmentInMiddle = segments[midIndex];

    if (segmentInMiddle.weekNumber == weekKey) {
      return segments[midIndex];
    }

    if (segmentInMiddle.weekNumber > weekKey) {
      return _findWeekSegmentToUpdate(
        weekKey,
        segments,
        startIndex,
        midIndex - 1,
      );
    }

    return _findWeekSegmentToUpdate(weekKey, segments, midIndex + 1, endIndex);
  }
}
