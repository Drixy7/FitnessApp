import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/workout.dart'; // Ensure enum WorkoutStatus is here
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final PlanDay day;
  final Workout? workout; // Nullable: If null, state is "Planned"

  // -- Actions --
  final VoidCallback onTap; // Main tap (Start workout / View Details)
  final VoidCallback onSkip; // Logic to create skipped workout
  final VoidCallback onUnSkip; // Logic to delete/reset skipped workout
  final VoidCallback onShowStats; // Logic to view completed stats

  const TrainingCard({
    super.key,
    required this.day,
    required this.workout,
    required this.onTap,
    required this.onSkip,
    required this.onUnSkip,
    required this.onShowStats,
  });

  // -- Helper to determine current state --
  WorkoutStatus get _status {
    if (workout == null) return WorkoutStatus.planned;
    return workout!.status;
  }

  bool get _isSkipped => _status == WorkoutStatus.skipped;
  bool get _isCompleted => _status == WorkoutStatus.completed;

  // -- Helper for weekday names --
  String get _weekdayName {
    const days = {
      1: 'MON',
      2: 'TUE',
      3: 'WED',
      4: 'THU',
      5: 'FRI',
      6: 'SAT',
      7: 'SUN',
    };
    return days[day.dayOrder] ?? 'DAY ${day.dayOrder}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. DYNAMIC STYLING
    Color cardColor;
    Color textColor;
    double elevation;

    if (_isSkipped) {
      cardColor = colors.surfaceContainerHighest.withOpacity(0.5); // Grayed out
      textColor = colors.onSurface.withOpacity(0.5);
      elevation = 0;
    } else if (_isCompleted) {
      cardColor = colors
          .surfaceContainerHighest; // Or use a custom green from your theme
      textColor = colors.onSurface; // Text on green
      elevation = 2;
    } else {
      // Planned (Default)
      cardColor = colors.surfaceContainerHighest;
      textColor = colors.onSurface;
      elevation = 4;
    }

    return Card(
      elevation: elevation,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: InkWell(
        onTap: _isSkipped
            ? null
            : onTap, // Disable main tap if skipped? Or keep it.
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ROW 1: HEADER & BADGE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weekday Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isCompleted
                          ? Colors.white.withOpacity(0.3)
                          : colors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _weekdayName,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isCompleted
                            ? textColor
                            : colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  // Exercise Count Badge
                  if (!_isSkipped)
                    Text(
                      "${day.exercises.length} Exercises",
                      style: textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // --- ROW 2: MAIN TITLE ---
              Text(
                day.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  decoration: _isSkipped ? TextDecoration.lineThrough : null,
                ),
              ),

              const SizedBox(height: 16),

              const Divider(height: 1),

              const SizedBox(height: 8),

              _buildActionRow(context, textColor, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    Color textColor,
    ColorScheme colors,
  ) {
    // STATE: SKIPPED
    if (_isSkipped) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Skipped",
            style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onUnSkip,
            icon: const Icon(Icons.restore),
            label: const Text("Unskip"),
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: textColor.withOpacity(0.5)),
            ),
          ),
        ],
      );
    }

    // STATE: COMPLETED
    if (_isCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, size: 20, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                "Completed",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: onShowStats,
            icon: const Icon(Icons.bar_chart),
            label: const Text("Stats"),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: textColor,
              elevation: 0,
            ),
          ),
        ],
      );
    }

    // STATE: PLANNED (Default)
    return Row(
      children: [
        const Spacer(),

        // Skip Button
        TextButton(
          onPressed: () async {
            final bool result = await showWarningDialog(
              "Skipping Workout",
              "Are you sure you want to skip this workout, all entered data will be lost. This process is irreversible",
              context,
            );
            if (result) {
              onSkip();
            }
          },
          style: TextButton.styleFrom(foregroundColor: colors.error),
          child: const Text("Skip"),
        ),

        const SizedBox(width: 8),

        // Start Button
        FilledButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start"),
        ),
      ],
    );
  }
}
