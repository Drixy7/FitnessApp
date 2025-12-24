import 'package:fitness_app/utils/constants.dart';
import 'package:fitness_app/utils/formatters.dart';
import 'package:fitness_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _rangeStart;
  late DateTime _rangeEnd;
  late int _selectedTotalWeek;

  int get _displayCycle =>
      cycleFromAbsoluteWeek(_selectedTotalWeek, widget.weeksPerCycle);

  int get _displayWeek =>
      weekFromAbsoluteWeek(_selectedTotalWeek, widget.weeksPerCycle);

  @override
  void initState() {
    super.initState();
    _selectedTotalWeek = widget.initialTotalWeek;
    final initialDate = widget.planStartDate.add(
      Duration(days: (_selectedTotalWeek - 1) * 7),
    );

    _focusedDay = initialDate;
    _selectedDay = initialDate;
    _rangeStart = _getStartOfWeek(initialDate);
    _rangeEnd = _getEndOfWeek(initialDate);
  }
  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getEndOfWeek(DateTime date) {
    return _getStartOfWeek(date).add(const Duration(days: 6));
  }

  /// Logic to handle clicking a day on the calendar
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      // 1. Snap to the full week (Mon-Sun)
      _rangeStart = _getStartOfWeek(selectedDay);
      _rangeEnd = _getEndOfWeek(selectedDay);

      // 2. Calculate the "Total Week" number based on the Plan Start Date
      // We compare the start of the selected week vs start of the plan's first week
      final planStartOfWeek = _getStartOfWeek(widget.planStartDate);
      final daysDifference = _rangeStart.difference(planStartOfWeek).inDays;

      // Formula: (Days difference / 7) + 1 = Week Number
      _selectedTotalWeek = (daysDifference / 7).floor() + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Header Information
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                "Week $_displayWeek, Cycle: $_displayCycle",
                style: AppTextStyles.listTitle,
              ),
              const SizedBox(height: 5),
              Text(
                "${DateFormat.yMMMd().format(_rangeStart)} - ${DateFormat.yMMMd().format(_rangeEnd)}",
                style: AppTextStyles.description,
              ),
            ],
          ),
        ),

        const Divider(),

        // 2. The Calendar
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          currentDay: DateTime.now(),
          startingDayOfWeek: StartingDayOfWeek.monday,

          // Visual Settings
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          // Selection Logic
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          rangeSelectionMode: RangeSelectionMode.enforced, // Highlights the whole range

          onDaySelected: _onDaySelected,

          // Optional: styling to make the range look like a single bar
          calendarStyle: CalendarStyle(
            rangeHighlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. Confirm Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Select This Week"),
            onPressed: () {
              // Return the calculated data
              final result = WeekSelectionResult(
                selectedTotalWeek: _selectedTotalWeek,
                startOfWeek: _rangeStart,
                endOfWeek: _rangeEnd,
              );
              Navigator.of(context).pop(result);
            },
          ),
        ),
      ],
    );
  }
}