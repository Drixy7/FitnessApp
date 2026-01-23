import 'package:fitness_app/models/plan.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onTap;
  final bool isResuming;

  const PlanCard({
    super.key,
    required this.onTap,
    required this.plan,
    required this.isResuming,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ExpansionTile(
        leading: Icon(
          Icons.fitness_center,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          plan.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: Text(
          plan.description ?? "No description available",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoColumn(
                      "${plan.weeksPerCycle} Weeks",
                      "Per Cycle",
                      context,
                    ),
                    _buildInfoColumn(
                      "${plan.daysPerWeek} Days",
                      "Per Week",
                      context,
                    ),
                    _buildInfoColumn(
                      plan.difficulty.name,
                      "Difficulty",
                      context,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    child: Text(
                      isResuming ? "Resume This Plan" : "Select This Plan",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String value, String label, BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
