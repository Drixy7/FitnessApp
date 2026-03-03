import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/models/workout_set.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/lifting_statistics_provider.dart';
//todo přepsat, přidat bottomSheet pro filtrování tréninků jako transakcí v bance, přidat statistiky podle modelů

class LiftingStatisticsScreen extends StatelessWidget {
  const LiftingStatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiftingStatisticsProvider>();
    final plans = provider.validPlans;
    final exercises = provider.groupedExercises;
    final selectedPlan = provider.selectedPlan;
    final selectedExercise = provider.selectedExercise;
    final planSummary = provider.planSummary;
    final exerciseSummary = provider.exerciseSummary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting Statistics'),
        centerTitle: false,
      ),
      body: (provider.exerciseLoading || provider.planLoading)
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  _PlanSelector(
                    plans: plans,
                    selected: selectedPlan,
                    onChanged: (p) {
                      provider.setSelectedPlan(p);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (provider.planLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    planSummary == null
                        ? Center(child: CircularProgressIndicator())
                        : _EgoDashboard(
                            wightVolume: planSummary.weightVolume.toString(),
                            totalReps: planSummary.totalReps.toString(),
                            workoutsCompleted: planSummary.workoutsCompleted
                                .toString(),
                            avgWorkoutTime: planSummary.avgWorkoutTime
                                .toString(),
                            workoutConsistency: planSummary.workoutConsistency
                                .toString(),
                            workoutsSkipped: planSummary.workoutsSkipped
                                .toString(),
                          ),
                  const SizedBox(height: 20),
                  const _SectionDivider(label: 'Exercise Progress'),
                  const SizedBox(height: 16),
                  _ExerciseSelector(
                    groupedExercises: exercises,
                    selected: selectedExercise,
                    onChanged: (e) {
                      provider.setSelectedExercise(e);
                    },
                  ),
                  if (provider.exerciseLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    exerciseSummary == null
                        ? _NoDataCard(
                            message: "Complete this exercise to show data",
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              _BestSetCard(set: exerciseSummary.bestSet),
                              const SizedBox(height: 10),
                              _OneRMCard(
                                isEstimated: exerciseSummary.isEstimated,
                                weight: exerciseSummary.oneRepMax,
                                maxSet: exerciseSummary.maxSet,
                              ),
                              const SizedBox(height: 10),
                              exerciseSummary.progress != null
                                  ? _ProgressCard(
                                      gain: exerciseSummary.progress!,
                                    )
                                  : _NoDataCard(
                                      message:
                                          "Not enough data for progression statistics",
                                    ),
                              const SizedBox(height: 24),
                            ],
                          ),
                ],
              ),
            ),
    );
  }
}

class _PlanSelector extends StatelessWidget {
  //todo refactor
  final List<Plan> plans;
  final Plan? selected;
  final ValueChanged<Plan> onChanged;

  const _PlanSelector({
    required this.plans,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Plan>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: 'Workout Plan',
        prefixIcon: const Icon(Icons.fitness_center_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLow,
      ),
      items: plans
          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
          .toList(),
      onChanged: (p) {
        if (p != null) onChanged(p);
      },
    );
  }
}

class _EgoDashboard extends StatelessWidget {
  final String wightVolume;
  final String totalReps;
  final String workoutsCompleted;
  final String workoutsSkipped;
  final String workoutConsistency;
  final String avgWorkoutTime;

  const _EgoDashboard({
    required this.wightVolume,
    required this.totalReps,
    required this.workoutsCompleted,
    required this.avgWorkoutTime,
    required this.workoutsSkipped,
    required this.workoutConsistency,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        icon: Icons.monitor_weight_rounded,
        label: 'Total Tonnage',
        value: wightVolume,
        color: Colors.blueAccent,
      ),
      _StatItem(
        icon: Icons.repeat_rounded,
        label: 'Total Reps',
        value: totalReps,
        color: Colors.purpleAccent,
      ),
      _StatItem(
        icon: Icons.check_circle_outline_rounded,
        label: 'Workouts',
        value: workoutsCompleted,
        color: Colors.greenAccent,
      ),
      _StatItem(
        icon: Icons.timer_outlined,
        label: 'Avg. Duration',
        value: avgWorkoutTime,
        color: Colors.orangeAccent,
      ),
      _StatItem(
        icon: Icons.skip_next_outlined,
        label: 'workouts Skipped',
        value: workoutsSkipped,
        color: Colors.grey.shade600,
      ),
      _StatItem(
        icon: Icons.local_fire_department_outlined,
        label: 'Workout Consistency',
        value: workoutConsistency,
        color: Colors.deepOrangeAccent,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => _StatCard(item: item)).toList(),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(item.icon, color: item.color, size: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  item.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECTION DIVIDER
// ---------------------------------------------------------------------------

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.outlineVariant,
            endIndent: 12,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        Expanded(
          child: Divider(color: theme.colorScheme.outlineVariant, indent: 12),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// EXERCISE SELECTOR
// ---------------------------------------------------------------------------

class _ExerciseSelector extends StatelessWidget {
  final Map<String, List<Exercise>> groupedExercises;
  final Exercise? selected;
  final ValueChanged<Exercise> onChanged;

  const _ExerciseSelector({
    required this.groupedExercises,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int? selectedId = selected?.id;

    final List<Exercise> allExercises = groupedExercises.values
        .expand((exerciseList) => exerciseList)
        .toList();

    final bool idExist = allExercises.any((e) => e.id == selectedId);
    final int? safeInitialValue = idExist ? selectedId : null;

    final List<DropdownMenuItem<int>> dropdownItems = [];
    int headerFakeId = -1;
    groupedExercises.forEach((dayName, dailyExercises) {
      dropdownItems.add(
        DropdownMenuItem<int>(
          value: headerFakeId--,
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (headerFakeId < -2) const Divider(height: 8),
              Text(
                dayName.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      );
      for (final exercise in dailyExercises) {
        dropdownItems.add(
          DropdownMenuItem<int>(
            value: exercise.id,
            child: Text(
              exercise.name,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    });

    return DropdownButtonFormField<int>(
      initialValue: safeInitialValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Exercise',
        prefixIcon: const Icon(Icons.sports_gymnastics_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLow,
      ),
      items: dropdownItems,
      onChanged: (int? newId) {
        if (newId != null) {
          final Exercise selectedExercise = allExercises.firstWhere(
            (e) => e.id == newId,
          );
          onChanged(selectedExercise);
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// BEST SET CARD
// ---------------------------------------------------------------------------

class _BestSetCard extends StatelessWidget {
  final WorkoutSet? set;
  const _BestSetCard({required this.set});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (set == null) {
      return _NoDataCard();
    } //todo refactor
    return _DetailCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Best Set',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                "${set!.weight.toStringAsFixed(1)} x ${set!.reps.toString()}",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (set!.workout.value != null)
                Text(
                  DateFormat("yMMMd").format(set!.workout.value!.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OneRMCard extends StatelessWidget {
  final bool isEstimated;
  final double weight;
  final WorkoutSet? maxSet;

  const _OneRMCard({
    required this.isEstimated,
    required this.weight,
    required this.maxSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Gold palette that works in both light & dark
    const goldLight = Color(0xFFFFF8E1);
    const goldDark = Color(0xFF3E2E00);
    const goldBorder = Color(0xFFFFCA28);

    final isGold = !isEstimated;
    final cardColor = isGold
        ? (theme.brightness == Brightness.dark ? goldDark : goldLight)
        : theme.colorScheme.surfaceContainerLow;
    final borderColor = isGold
        ? goldBorder
        : theme.colorScheme.outlineVariant.withValues(alpha: 0.4);
    final iconColor = isGold ? const Color(0xFFFFB300) : Colors.blueAccent;

    return Card(
      elevation: isGold ? 2 : 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isGold ? 1.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isGold ? '🏆' : '⚡',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isGold ? 'True 1RM' : 'Estimated 1RM',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isGold
                              ? const Color(0xFFB8860B)
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isGold) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: goldBorder.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'VERIFIED',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFFB8860B),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    isEstimated
                        ? weight.toStringAsFixed(2)
                        : maxSet!.weight.toString(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isGold ? const Color(0xFF7A5800) : null,
                    ),
                  ),
                  if (maxSet != null && maxSet!.workout.value != null)
                    Text(
                      DateFormat("yMMMd").format(maxSet!.workout.value!.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isGold
                            ? const Color(0xFFB8860B)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROGRESS CARD
// ---------------------------------------------------------------------------

class _ProgressCard extends StatelessWidget {
  final double gain;
  const _ProgressCard({required this.gain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = gain.isNegative;
    final color = isPositive ? Colors.green : theme.colorScheme.error;

    return _DetailCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Progress',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                gain.toStringAsFixed(2),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                'During this plan',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Widget child;
  const _DetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _NoDataCard extends StatelessWidget {
  final String? message;
  const _NoDataCard({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'No Data Available',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message ?? 'Complete a workout to see your statistics here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
