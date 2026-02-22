import 'package:fitness_app/models/custom_data_package_models.dart';
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/widgets/pickers/week_chooser_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlanPersonalization extends StatefulWidget {
  final Plan plan;
  const PlanPersonalization({super.key, required this.plan});

  @override
  State<PlanPersonalization> createState() => _PlanPersonalizationState();
}

class _PlanPersonalizationState extends State<PlanPersonalization> {
  bool _isLoading = true;
  Map<String, int> _dayOrder = {};
  List<int> _initialDayOrderValues = [];
  final _daysInWeek = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];
  late DateTime _selectedStartDate;
  late DateTime _firstWeekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    _selectedStartDate = now;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDays();
    });
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _showWarningDialog(PlanPersonalizationResult result, context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Selection"),
          content: const Text(
            "This change is irreversible. Once you start this plan session, you cannot change the initial day order settings. Do you agree?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(result);
              },
              child: const Text("I Agree"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeDays() async {
    await widget.plan.days.load();
    final planDays = widget.plan.days.toList();
    final relevantDays = planDays.take(widget.plan.daysPerWeek);

    final dayOrderMap = {
      for (final day in relevantDays) day.name: day.dayOrder,
    };
    _initialDayOrderValues = dayOrderMap.values.toList();

    setState(() {
      _dayOrder = dayOrderMap;
      _isLoading = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = today;
    final daysUntilEndOfWeek = 7 - today.weekday;
    final lastDate = today.add(Duration(days: daysUntilEndOfWeek + 7));

    final WeekSelectionResult? pickedDate =
        await showModalBottomSheet<WeekSelectionResult>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsetsGeometry.all(16.0),
              child: WeekChooserView(
                leadingText: "Select your first workout day",
                firstAvailableDate: firstDate,
                lastAvailableDate: lastDate,
              ),
            );
          },
        );

    if (pickedDate != null && pickedDate.selectedDay != _selectedStartDate) {
      setState(() {
        _selectedStartDate = pickedDate.selectedDay!;
        _firstWeekStart = _getWeekStart(_selectedStartDate);
      });
    }
  }

  bool _hasDayOrderChanged() {
    final currentValues = _dayOrder.values.toList();
    if (currentValues.length != _initialDayOrderValues.length) return true;

    for (int i = 0; i < currentValues.length; i++) {
      if (currentValues[i] != _initialDayOrderValues[i]) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final weekDayOptions = List.generate(7, (index) => index + 1);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personalize Your Plan",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(),
          const SizedBox(height: 24),

          Text(
            "When will you start your first workout?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _selectStartDate(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, dd.MM.yyyy').format(_selectedStartDate),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Icon(Icons.calendar_month),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          ...[
            // --- DAY ORDER PERSONALIZATION ---
            Text(
              "Personalize workout days",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ..._dayOrder.entries.map((entry) {
              String dayName = entry.key;
              int currentWeekDay = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dayName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    DropdownButton<int>(
                      value: currentWeekDay,
                      items: weekDayOptions.map((dayNum) {
                        return DropdownMenuItem<int>(
                          value: dayNum,
                          child: Text(_daysInWeek[dayNum - 1]),
                        );
                      }).toList(),
                      onChanged: (newWeekDay) {
                        if (newWeekDay != null &&
                            newWeekDay != currentWeekDay) {
                          setState(() {
                            final otherEntry = _dayOrder.entries
                                .cast<
                                  MapEntry<String, int>?
                                >() // Helper for firstWhereOrNull logic
                                .firstWhere(
                                  (e) => e!.value == newWeekDay,
                                  orElse: () => null,
                                );
                            if (otherEntry != null) {
                              _dayOrder[otherEntry.key] = currentWeekDay;
                            }
                            _dayOrder[dayName] = newWeekDay;
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 32),
          // --- ACTION BUTTONS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final Map<String, int>? dayOrderResult =
                        _hasDayOrderChanged() ? _dayOrder : null;
                    final result = PlanPersonalizationResult(
                      dayOrder: dayOrderResult,
                      selectedStartDate: _selectedStartDate,
                      firstWeekStart: _firstWeekStart,
                    );
                    _showWarningDialog(result, context);
                  },
                  child: const Text("Start Plan"),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
