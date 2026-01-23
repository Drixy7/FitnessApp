import 'package:fitness_app/models/workout_set.dart';
import 'package:flutter/material.dart';

class PerformanceHistory extends StatelessWidget {
  // 1. You need to declare the list as a field of the class
  final List<WorkoutSet> loggedSets;
  final VoidCallback? copyToCurrent;

  const PerformanceHistory({
    super.key,
    required this.loggedSets,
    this.copyToCurrent,
  });

  @override
  Widget build(BuildContext context) {
    if (loggedSets.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No performance data available.",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Set",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Weight (kg)",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Reps",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
        const Divider(),

        Column(
          children: List.generate(loggedSets.length, (index) {
            final set = loggedSets[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      set.setNumber.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      set.weight.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      set.reps.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: copyToCurrent,
              icon: Icon(Icons.copy_all_outlined),
              label: const Text("Copy To current Workout"),
            ),
          ),
        ),
      ],
    );
  }
}
