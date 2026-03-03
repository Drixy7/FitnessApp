import 'package:fitness_app/models/body_weight_statistics_models.dart';
import 'package:fitness_app/models/custom_data_package_models.dart';
import 'package:fitness_app/models/weight_log.dart';
import 'package:fitness_app/providers/body_weight_statistics_provider.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/pickers/bodyweight_logger.dart';
import 'package:fitness_app/widgets/pickers/week_chooser_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//todo maybe add Streak,

class BodyWeightStatisticsScreen extends StatefulWidget {
  const BodyWeightStatisticsScreen({super.key});

  @override
  State<BodyWeightStatisticsScreen> createState() =>
      _BodyWeightStatisticsScreenState();
}

class _BodyWeightStatisticsScreenState
    extends State<BodyWeightStatisticsScreen> {
  BodyWeightButtonResult _bodyWeightData = BodyWeightButtonResult.daily;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<BodyWeightStatisticsProvider>().loadBodyWeightStats();
    });
  }

  Future<WeightLog?> _showWeightLogger(WeightLog? weightLog) async {
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

  Future<void> _showWeekRangePicker() async {
    WeekSelectionResult? lastWeekResult;
    final provider = context.read<BodyWeightStatisticsProvider>();
    final now = DateTime.now();
    final lastAvailableDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: 7 - now.weekday));

    final firstWeekResult = await showModalBottomSheet<WeekSelectionResult>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: WeekChooserView(
            firstAvailableDate: DateTime(2025),
            lastAvailableDate: lastAvailableDate,
            leadingText: "Choose first week in range",
          ),
        );
      },
    );
    if (mounted && firstWeekResult != null) {
      lastWeekResult = await showModalBottomSheet<WeekSelectionResult>(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: WeekChooserView(
              firstAvailableDate: DateTime(2025),
              lastAvailableDate: lastAvailableDate,
              leadingText: "Choose last week in range",
            ),
          );
        },
      );
    }
    if (firstWeekResult != null && lastWeekResult != null && mounted) {
      await provider.updateDateRange(
        firstWeekResult.startOfWeek,
        lastWeekResult.endOfWeek,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<BodyWeightStatisticsProvider>();
    final summary = stats.summary;
    final allSegments = stats.allWeeklySegments;
    final validSegments = stats.validWeeklySegments;

    return Scaffold(
      appBar: AppBar(title: const Text("Bodyweight Statistics")),
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
          stats.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(120.0),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Expanded(
                  child:
                      _bodyWeightData != BodyWeightButtonResult.all &&
                          validSegments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 64,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No weight data in selected range",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _bodyWeightData =
                                        BodyWeightButtonResult.all;
                                  });
                                },
                                icon: const Icon(Icons.remove_red_eye),
                                label: const Text("Switch to All view"),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              _bodyWeightData == BodyWeightButtonResult.all
                              ? allSegments.length
                              : validSegments.length,
                          itemBuilder: (context, index) {
                            return _buildWeekSegment(
                              weekIndex: index + 1,
                              segment:
                                  _bodyWeightData == BodyWeightButtonResult.all
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
    final provider = context.read<BodyWeightStatisticsProvider>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await provider.updateDateRange(
                    provider.rangeStart.subtract(Duration(days: 28)),
                    provider.rangeEnd.subtract(Duration(days: 28)),
                  );
                },
                icon: Icon(Icons.chevron_left),
                iconSize: 30,
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 5),
                    Text(
                      "${DateFormat("yMMMd").format(provider.rangeStart)} - ${DateFormat("yMMMd").format(provider.rangeEnd)}",
                    ),
                  ],
                ),
                onTap: () {
                  _showWeekRangePicker();
                },
              ),

              IconButton(
                onPressed: () async {
                  await provider.updateDateRange(
                    provider.rangeStart.add(Duration(days: 28)),
                    provider.rangeEnd.add(Duration(days: 28)),
                  );
                },
                icon: Icon(Icons.chevron_right),
                iconSize: 30,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  "${DateFormat("MMM d ''yy ").format(segment.startDate)} - ${DateFormat("MMM d ''yy ").format(segment.endDate)}",
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
                        .read<BodyWeightStatisticsProvider>();
                    final WeightLog weightLog;
                    if (log != null) {
                      weightLog = log;
                    } else {
                      weightLog = WeightLog()
                        ..date = dayDate
                        ..weight = 0.0;
                    }
                    final result = await _showWeightLogger(weightLog);
                    if (result != null && context.mounted) {
                      debugPrint("something");
                      await statisticsProvider.updateSingleLog(result);
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
