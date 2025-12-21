import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/utils/theme.dart';
import 'package:fitness_app/widgets/performance_history.dart';
import 'package:fitness_app/widgets/value_incrementer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout_set.dart'; // Needed for input formatters

// 1. Convert to a StatefulWidget to manage the TextControllers
class WorkoutSetScreen extends StatefulWidget {
  final PlanDayExercise planDayExercise;
  const WorkoutSetScreen({super.key, required this.planDayExercise});

  @override
  State<WorkoutSetScreen> createState() => _WorkoutSetScreenState();
}

class _WorkoutSetScreenState extends State<WorkoutSetScreen> {
  // We'll need lists to hold the controllers for each text field
  List<TextEditingController> _weightControllers = [];
  List<TextEditingController> _repsControllers = [];
  Map<int, (double, int)> _loggedSets = {};

  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSetData();
    });
  }

  Future<void> _initializeSetData() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final existingSets =
        workoutProvider.loggedSets[widget.planDayExercise.orderIndex];

    final int plannedSets = widget.planDayExercise.targetSets;
    final int actualSets = existingSets?.length ?? 0;
    final int setCount = (actualSets > plannedSets) ? actualSets : plannedSets;

    _weightControllers = List.generate(
      setCount,
      (_) => TextEditingController(),
    );
    _repsControllers = List.generate(setCount, (_) => TextEditingController());
    _loggedSets = {for (int i = 1; i <= setCount; i++) i: (0.0, 0)};

    if (existingSets != null && existingSets.isNotEmpty) {
      for (final set in existingSets) {
        if (set.setNumber > 0 && set.setNumber <= setCount) {
          final int index = set.setNumber - 1;
          _weightControllers[index].text = set.weight.toString();
          _repsControllers[index].text = set.reps.toString();
          _loggedSets[set.setNumber] = (set.weight, set.reps);
        }
      }
    }
    for (int i = 0; i < setCount; i++) {
      final int setNumber = i + 1;
      _weightControllers[i].addListener(() {
        final weight = double.tryParse(_weightControllers[i].text) ?? 0.0;
        final reps = _loggedSets[setNumber]?.$2 ?? 0;
        _loggedSets[setNumber] = (weight, reps);
      });
      _repsControllers[i].addListener(() {
        final reps = int.tryParse(_repsControllers[i].text) ?? 0;
        final weight = _loggedSets[setNumber]?.$1 ?? 0.0;
        _loggedSets[setNumber] = (weight, reps);
      });
    }
    setState(() {
      _isInitializing = false;
    });
  }

  void _copyHistoricalWorkoutSets(List<WorkoutSet> workoutSets) {
    setState(() {
      for (final set in workoutSets) {
        final setNumber = set.setNumber;

        if (setNumber > 0 && setNumber <= _weightControllers.length) {
          final int index = setNumber - 1;

          _weightControllers[index].text = set.weight.toString();
          _repsControllers[index].text = set.weight.toString();
        }
      }
    });
  }

  @override
  void dispose() {
    // 3. IMPORTANT: Always dispose of your controllers to prevent memory leaks.
    for (final controller in _weightControllers) {
      controller.removeListener(() {});
      controller.dispose();
    }
    for (final controller in _repsControllers) {
      controller.removeListener(() {});
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planDayExercise.exercise.value?.name ?? "WTF"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Distributes space evenly
            children: [
              Text("Set", style: AppTextStyles.listTitle),
              Text("Weight (kg)", style: AppTextStyles.listTitle),
              Text("Reps", style: AppTextStyles.listTitle),
            ],
          ),
          const Divider(),
          if (_isInitializing)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Column(
              children: List.generate(_weightControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${index + 1}", style: AppTextStyles.pageMainTitle),
                      Expanded(
                        child: ValueIncrementer(
                          controller: _weightControllers[index],
                          incrementValue: 2.5,
                          isDecimal: true,
                        ),
                      ),
                      Expanded(
                        child: ValueIncrementer(
                          controller: _repsControllers[index],
                          incrementValue: 1,
                          isDecimal: false,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  workoutProvider.logSetForExercise(
                    widget.planDayExercise.orderIndex,
                    _loggedSets,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text("Log Sets"),
              ),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              ExpansionTile(
                title: Text("Last week performance"),
                children: [
                  PerformanceHistory(
                    loggedSets:
                        workoutProvider.lastWorkoutSets[widget
                            .planDayExercise
                            .orderIndex] ??
                        [],
                    copyToCurrent: () => {
                      _copyHistoricalWorkoutSets(
                        workoutProvider.lastWorkoutSets[widget
                                .planDayExercise
                                .orderIndex] ??
                            [],
                      ),
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Last Cycle performance"),
                children: [
                  PerformanceHistory(
                    loggedSets:
                        workoutProvider.lastCycleWorkoutSets[widget
                            .planDayExercise
                            .orderIndex] ??
                        [],
                    copyToCurrent: () => {
                      _copyHistoricalWorkoutSets(
                        workoutProvider.lastCycleWorkoutSets[widget
                                .planDayExercise
                                .orderIndex] ??
                            [],
                      ),
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
