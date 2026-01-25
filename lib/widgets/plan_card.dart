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
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      borderOnForeground: true,
      color: colors.primaryContainer,
      child: ExpansionTile(
        leading: Icon(Icons.fitness_center, color: colors.primary),
        title: Text(plan.name, style: textStyle.headlineSmall),
        subtitle: Text(
          plan.description ?? "No description available",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoColumn(
                      "${plan.weeksPerCycle} Weeks",
                      "Per Cycle",
                      textStyle,
                      colors,
                      context,
                    ),
                    _buildInfoColumn(
                      "${plan.daysPerWeek} Days",
                      "Per Week",
                      textStyle,
                      colors,
                      context,
                    ),
                    _buildInfoColumn(
                      plan.difficulty.name,
                      "Difficulty",
                      textStyle,
                      colors,
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

  Widget _buildInfoColumn(
    String value,
    String label,
    TextTheme textStyle,
    ColorScheme colors,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.onPrimaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              value,
              style: textStyle.titleMedium?.copyWith(color: colors.onPrimary),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textStyle.bodyLarge?.copyWith(
            color: colors.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
