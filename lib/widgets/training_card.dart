import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/utils/theme.dart';
import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final PlanDay day;
  final VoidCallback onTap;

  const TrainingCard({super.key, required this.day, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.blueAccent),
        title: Text(day.name, style: AppTextStyles.listTitle),
        subtitle: Text(
          "Week ${day.weekNumber}",
          style: AppTextStyles.listSubtitle,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
