import 'package:fitness_app/utils/datatypes.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//TODO Make the week selection prettier and more easily readable
class WeekChooserView extends StatefulWidget {
  final DateTime firstAvailableDate;
  final DateTime? lastAvailableDate;
  final WeekSelectionResult? initialWeekSelection;

  const WeekChooserView({
    super.key,
    required this.firstAvailableDate,
    this.initialWeekSelection,
    this.lastAvailableDate,
  });

  @override
  State<WeekChooserView> createState() => _WeekChooserViewState();
}

class _WeekChooserViewState extends State<WeekChooserView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _rangeStart;
  late DateTime _rangeEnd;
  late int? _selectedTotalWeek;

  @override
  void initState() {
    super.initState();
    DateTime? initialDate = widget.initialWeekSelection?.startOfWeek.add(
      Duration(days: DateTime.now().weekday - 1),
    );

    _focusedDay = initialDate ?? DateTime.now();
    _selectedDay = initialDate ?? DateTime.now();
    _rangeStart =
        widget.initialWeekSelection?.startOfWeek ??
        _getStartOfWeek(DateTime.now());
    _rangeEnd =
        widget.initialWeekSelection?.endOfWeek ?? _getEndOfWeek(DateTime.now());
    _selectedTotalWeek = widget.initialWeekSelection?.selectedTotalWeek;
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getEndOfWeek(DateTime date) {
    return _getStartOfWeek(date).add(const Duration(days: 6));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      _rangeStart = _getStartOfWeek(selectedDay);
      _rangeEnd = _getEndOfWeek(selectedDay);

      final initialStartOfWeek = widget.initialWeekSelection?.startOfWeek;
      if (initialStartOfWeek != null && _selectedTotalWeek != null) {
        final daysDifference = _rangeStart
            .difference(initialStartOfWeek)
            .inDays;
        final weekOffset = (daysDifference / 7).round();
        _selectedTotalWeek = _selectedTotalWeek! + weekOffset;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar(
          firstDay: widget.firstAvailableDate,
          lastDay:
              widget.lastAvailableDate ??
              widget.firstAvailableDate.add(Duration(days: 365 * 10)),
          focusedDay: _focusedDay,
          currentDay: DateTime.now(),
          startingDayOfWeek: StartingDayOfWeek.monday,

          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          // Selection Logic
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          rangeSelectionMode:
              RangeSelectionMode.enforced, // Highlights the whole range

          onDaySelected: _onDaySelected,

          calendarStyle: CalendarStyle(
            rangeHighlightColor: Theme.of(context).primaryColor,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Select This Week"),
            onPressed: () {
              Object result;
              if (widget.initialWeekSelection != null) {
                result = WeekSelectionResult(
                  selectedTotalWeek: _selectedTotalWeek ?? -1,
                  startOfWeek: _rangeStart,
                  endOfWeek: _rangeEnd,
                );
              } else {
                result = WeekSelectionResult(
                  selectedTotalWeek: -1,
                  startOfWeek: _rangeStart,
                  endOfWeek: _rangeEnd,
                  selectedDay: _selectedDay,
                );
              }
              Navigator.of(context).pop(result);
            },
          ),
        ),
      ],
    );
  }
}
