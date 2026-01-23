import 'package:fitness_app/models/plan_day.dart';
import 'package:flutter/material.dart';

//TODO Make it more wide/ maybe implement image?
class TrainingCard extends StatelessWidget {
  final PlanDay day;
  final VoidCallback onTap;

  const TrainingCard({super.key, required this.day, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.blueAccent),
        title: Text(day.name, style: Theme.of(context).textTheme.headlineSmall),
        subtitle: Text(
          "Week ${day.weekNumber}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
