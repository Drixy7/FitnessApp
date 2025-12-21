import 'package:fitness_app/utils/constants.dart';
import 'package:fitness_app/utils/formatters.dart';
import 'package:fitness_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekChooserView extends StatefulWidget {
  final DateTime planStartDate;
  final int weeksPerCycle;
  final int initialTotalWeek;

  const WeekChooserView({
    super.key,
    required this.planStartDate,
    required this.weeksPerCycle,
    required this.initialTotalWeek,
  });

  @override
  State<WeekChooserView> createState() => _WeekChooserViewState();
}

class _WeekChooserViewState extends State<WeekChooserView> {
  late int _selectedTotalWeek;
  late DateTime _currentDateInView;

  int get _displayCycle =>
      cycleFromAbsoluteWeek(_selectedTotalWeek, widget.weeksPerCycle);

  int get _displayWeek =>
      weekFromAbsoluteWeek(_selectedTotalWeek, widget.weeksPerCycle);

  @override
  void initState() {
    super.initState();
    _selectedTotalWeek = widget.initialTotalWeek;
    _currentDateInView = widget.planStartDate.add(
      Duration(days: (_selectedTotalWeek - 1) * 7),
    );
  }

  // Helper function to get the start and end dates of the current week
  String _getWeekDisplayString(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return "${DateFormat.yMMMd().format(startOfWeek)} - ${DateFormat.yMMMd().format(endOfWeek)}";
  }

  void _goToPreviousWeek() {
    if (_selectedTotalWeek > 1) {
      setState(() {
        _selectedTotalWeek--;
        _currentDateInView = _currentDateInView.subtract(
          const Duration(days: 7),
        );
      });
    }
  }

  void _goToNextWeek() {
    setState(() {
      _selectedTotalWeek++;
      _currentDateInView = _currentDateInView.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _goToPreviousWeek,
            ),
            Text(
              "Week $_displayWeek, Cycle: $_displayCycle",
              style: AppTextStyles.listTitle,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _goToNextWeek,
            ),
          ],
        ),
        Text(
          _getWeekDisplayString(_currentDateInView),
          style: AppTextStyles.description,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text("Select Week"),
          onPressed: () {
            final startOfWeek = _currentDateInView.subtract(
              Duration(days: _currentDateInView.weekday - 1),
            );
            final endOfWeek = startOfWeek.add(const Duration(days: 6));
            final result = WeekSelectionResult(
              selectedTotalWeek: _selectedTotalWeek,
              startOfWeek: startOfWeek,
              endOfWeek: endOfWeek,
            );
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}
