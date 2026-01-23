import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/providers/workout_provider.dart';
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
  List<TextEditingController> _weightControllers = [];
  List<TextEditingController> _repsControllers = [];
  Map<int, (double, int)> _loggedSets = {};
  List<int> _skippedSets = [];

  @override
  void initState() {
    super.initState();
    _initializeSetData();
  }

  Future<bool> _showWarningDialog() async {
    final bool? result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
            "This set and its data will be permanently removed. Do you agree?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("I Agree"),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _addNewSet() async {
    final workoutProvider = context.read<WorkoutProvider>();
    await workoutProvider.addSetToActiveWorkout(
      planDayExercise: widget.planDayExercise,
      setNumber: _weightControllers.length + 1,
      reps: 0,
      weight: 0,
    );
    setState(() {
      final newSetNumber = _weightControllers.length + 1;

      final weightController = TextEditingController(text: "0.0");
      final repsController = TextEditingController(text: "0.0");

      weightController.addListener(() {
        final weight = double.tryParse(weightController.text) ?? 0.0;
        final reps = _loggedSets[newSetNumber]?.$2 ?? 0;
        _loggedSets[newSetNumber] = (weight, reps);
      });

      repsController.addListener(() {
        final reps = int.tryParse(repsController.text) ?? 0;
        final weight = _loggedSets[newSetNumber]?.$1 ?? 0.0;
        _loggedSets[newSetNumber] = (weight, reps);
      });

      _weightControllers.add(weightController);
      _repsControllers.add(repsController);
      _loggedSets[newSetNumber] = (0.0, 0);
    });
  }

  void _skipBaseSet(int index) {
    setState(() {
      if (!_skippedSets.contains(index + 1)) _skippedSets.add(index + 1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Set ${index + 1} is now marked as skipped")),
    );
  }

  Future<bool> _confirmDeleteSet(int index) async {
    final workoutProvider = context.read<WorkoutProvider>();
    bool isConfirmed = await _showWarningDialog();
    if (!isConfirmed) {
      return false;
    }
    await workoutProvider.removeSetFromWorkout(
      planDayExercise: widget.planDayExercise,
      setNumber: index + 1,
    );

    setState(() {
      _weightControllers[index].dispose();
      _repsControllers[index].dispose();
      _weightControllers.removeAt(index);
      _repsControllers.removeAt(index);
      _rebuildLoggedSetsMap();
    });
    return true;
  }

  void _rebuildLoggedSetsMap() {
    Map<int, (double, int)> newMap = {};
    for (int i = 0; i < _weightControllers.length; i++) {
      final w = double.tryParse(_weightControllers[i].text) ?? 0.0;
      final r = int.tryParse(_repsControllers[i].text) ?? 0;
      newMap[i + 1] = (w, r);
    }
    _loggedSets = newMap;
  }

  void _initializeSetData() {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Set", style: Theme.of(context).textTheme.titleMedium),
                Text(
                  "Weight (kg)",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text("Reps", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(),
            Column(
              children: List.generate(_weightControllers.length, (index) {
                final bool isBaseSet =
                    index < widget.planDayExercise.targetSets;
                return Dismissible(
                  key: ValueKey(index),
                  direction: DismissDirection.endToStart,

                  background: Container(
                    color: isBaseSet ? Colors.orange : Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          isBaseSet ? Icons.skip_next : Icons.delete_forever,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          isBaseSet ? "SKIP SET" : "DELETE SET",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),

                  confirmDismiss: (direction) async {
                    if (!isBaseSet) {
                      return await _confirmDeleteSet(index);
                    } else {
                      _skipBaseSet(index);
                      return false;
                    }
                  },

                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "${index + 1}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
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
                      ),
                      if (_skippedSets.contains(index + 1))
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _skippedSets.remove(index + 1);
                                    _weightControllers[index].text = "0.0";
                                    _repsControllers[index].text = "0";
                                    _loggedSets[index + 1] = (0.0, 0);
                                  });
                                },
                                icon: const Icon(
                                  Icons.undo,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "REVERSE SKIP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await _addNewSet();
                },
                label: Text(
                  "ADD SET",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.green),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 25),
                style: TextButton.styleFrom(foregroundColor: Colors.green),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    workoutProvider.logSetsForExercise(
                      widget.planDayExercise.orderIndex,
                      _loggedSets,
                      _skippedSets,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text("Log Sets"),
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 20),
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
      ),
    );
  }
}
