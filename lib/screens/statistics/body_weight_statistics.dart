//todo It should implements a way to show bodyWeight data by default there should be visible a week determined by Datetime.now() -> when showing data it should always show them segmented by weeks and at the end of each segment there should be Weekly average of weight, also there should be a place where should be the lowest value in selected range, highest value in selected range, average weekly gain/loose -> counted from weekly averages for example 1: 85.5 2: 86 3: 85 4: 87 -> 0.375 average gain, there should also be a switch button to determine if the statistics should show only show Week averages or raw data for each day (without averages)
import 'package:fitness_app/models/weight_log.dart';
import 'package:fitness_app/providers/statistics_provider.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/pickers/bodyweight_logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//todo maybe add Streak,

class BodyWeightStatsScreen extends StatefulWidget {
  final DateTime rangeStart;
  final DateTime rangeEnd;
  const BodyWeightStatsScreen({
    super.key,
    required this.rangeStart,
    required this.rangeEnd,
  });

  @override
  State<BodyWeightStatsScreen> createState() => _BodyWeightStatsScreenState();
}

class _BodyWeightStatsScreenState extends State<BodyWeightStatsScreen> {
  BodyWeightButtonResult _bodyWeightData = BodyWeightButtonResult.daily;
  late DateTime _rangeStart = widget.rangeStart;
  late DateTime _rangeEnd = widget.rangeEnd;

  Future<WeightLog?> showWeightLogger(WeightLog? weightLog) async {
    final result = await showModalBottomSheet<WeightLog>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: BodyWeightLogger(initialWeightLog: weightLog),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatisticsProvider>();
    final summary = stats.summary;
    final allSegments = stats.allWeeklySegments;
    final validSegments = stats.validWeeklySegments;

    return Scaffold(
      appBar: AppBar(title: const Text("Bodyweight Stats")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildControlBar(),
          _buildSummaryCards(
            min: summary.lowestInRange,
            max: summary.highestInRange,
            avgChange: summary.averageWeeklyChange,
          ),
          const SizedBox(height: 5),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _bodyWeightData == BodyWeightButtonResult.all
                  ? allSegments.length
                  : validSegments.length,
              itemBuilder: (context, index) {
                return _buildWeekSegment(
                  weekIndex: index + 1,
                  segment: _bodyWeightData == BodyWeightButtonResult.all
                      ? allSegments[index]
                      : validSegments[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.chevron_left),
              Text(
                " Current Month ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
          SizedBox(height: 10),
          // Toggle Button (Daily / Weekly)
          SegmentedButton<BodyWeightButtonResult>(
            segments: [
              ButtonSegment(
                value: BodyWeightButtonResult.daily,
                label: Text("Daily"),
                icon: Icon(Icons.calendar_view_day),
              ),
              ButtonSegment(
                value: BodyWeightButtonResult.average,
                label: Text("Avg"),
                icon: Icon(Icons.show_chart),
              ),
              ButtonSegment(
                value: BodyWeightButtonResult.all,
                label: Text("All"),
                icon: Icon(
                  _bodyWeightData != BodyWeightButtonResult.all
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye,
                ),
              ),
            ],
            selected: {_bodyWeightData},
            onSelectionChanged: (Set<BodyWeightButtonResult> newSelection) {
              setState(() {
                _bodyWeightData = newSelection.first;
              });
            },
            showSelectedIcon: false,
            style: ButtonStyle(visualDensity: VisualDensity.comfortable),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards({
    required double min,
    required double max,
    required double avgChange,
  }) {
    Widget statCard(String label, String value, Color color, IconData icon) {
      final theme = Theme.of(context);
      return Expanded(
        child: Card(
          elevation: 2,
          color: theme.colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 16, color: color),
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          statCard("Lowest", "$min kg", Colors.green, Icons.arrow_downward),
          const SizedBox(width: 8),
          statCard("Highest", "$max kg", Colors.red, Icons.arrow_upward),
          const SizedBox(width: 8),
          statCard(
            "Avg Change",
            "${avgChange > 0 ? '+' : ''}${avgChange.toStringAsFixed(2)}",
            Colors.blue,
            avgChange > 0 ? Icons.trending_up : Icons.trending_down,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSegment({
    required int weekIndex,
    required WeeklyWeightSegment segment,
  }) {
    final theme = Theme.of(context);
    final Map<int, WeightLog> dayMap = {
      for (var log in segment.dailyLogs) log.date.weekday: log,
    };
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Week ${segment.weekNumber.toString().substring(4)} - ${segment.weekNumber.toString().substring(0, 4)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    "Avg: ${segment.averageWeight.toStringAsFixed(2)} kg",
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          if (_bodyWeightData != BodyWeightButtonResult.average)
            ...List.generate(7, (dayIndex) {
              final dayDate = segment.startDate.add(Duration(days: dayIndex));
              final log = dayMap[dayIndex + 1];
              if (_bodyWeightData == BodyWeightButtonResult.daily &&
                  log == null) {
                return const SizedBox.shrink();
              }
              return ListTile(
                dense: true,
                titleAlignment: ListTileTitleAlignment.center,
                minLeadingWidth: 210,
                leading: Text(
                  DateFormat("EEE - MMM d").format(dayDate),
                  style: theme.textTheme.labelMedium,
                ),
                title: log != null
                    ? Text(
                        "${log.weight} kg",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                        "No Data",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[400],
                        ),
                      ),
                trailing: IconButton(
                  icon: Icon(
                    log != null ? Icons.edit : Icons.add_circle_outline,
                    size: 25,
                    color: log != null
                        ? Colors.grey
                        : theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  onPressed: () async {
                    final statisticsProvider = context
                        .read<StatisticsProvider>();
                    final WeightLog weightLog;
                    if (log != null) {
                      weightLog = log;
                    } else {
                      weightLog = WeightLog()
                        ..date = dayDate
                        ..weight = 0.0;
                    }
                    final result = await showWeightLogger(weightLog);
                    if (result != null && context.mounted) {
                      debugPrint("something");
                      await statisticsProvider.updateSingleLog(
                        result,
                        _rangeStart,
                        _rangeEnd,
                      );
                    }
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}
