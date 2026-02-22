import 'package:fitness_app/models/workout_set.dart';
import 'package:flutter/material.dart';

class PerformanceHistory extends StatelessWidget {
  final List<WorkoutSet> loggedSets;
  final VoidCallback? copyToCurrent;

  const PerformanceHistory({
    super.key,
    required this.loggedSets,
    this.copyToCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (loggedSets.isEmpty) {
      return _buildEmptyState(theme);
    }

    if (loggedSets.length == 1 && loggedSets.first.isSkipped) {
      return _buildSkippedState(theme);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSetsList(theme),
          if (copyToCurrent != null) _buildCopyButton(theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            "No Performance History",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Complete this exercise to see your performance data",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkippedState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(
            Icons.skip_next_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            "Exercise Skipped",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "This exercise was skipped in this workout",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsList(ThemeData theme) {
    final bestSet = _findBestSet();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Set",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Weight",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Reps",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          itemCount: loggedSets.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final set = loggedSets[index];
            final isBest = set == bestSet;
            return _buildSetRow(theme, set, isBest);
          },
        ),
      ],
    );
  }

  Widget _buildSetRow(ThemeData theme, WorkoutSet set, bool isBest) {
    if (set.isSkipped) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                set.setNumber.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Skipped",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: isBest
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isBest
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.1),
          width: isBest ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  set.setNumber.toString(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                    color: isBest ? theme.colorScheme.primary : null,
                  ),
                ),
                if (isBest) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 14, color: theme.colorScheme.primary),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${set.weight} kg",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isBest ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              set.reps.toString(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isBest ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.tonalIcon(
          onPressed: copyToCurrent,
          icon: const Icon(Icons.copy_all_outlined, size: 20),
          label: const Text("Copy to Current Workout"),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ),
    );
  }

  WorkoutSet? _findBestSet() {
    final completedSets = loggedSets.where((s) => !s.isSkipped).toList();
    if (completedSets.isEmpty) return null;

    return completedSets.reduce((best, current) {
      final bestScore = best.weight * (1 + best.reps / 30);
      final currentScore = current.weight * (1 + current.reps / 30);
      return currentScore > bestScore ? current : best;
    });
  }
}
