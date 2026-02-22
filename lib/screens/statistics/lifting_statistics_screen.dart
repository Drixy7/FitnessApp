import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/plan.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/lifting_statistics_provider.dart';
//todo přepsat, isarservice se bude starat o poskytnutí initial dat ohledně plánů, statistics provider bude získávat valid exercises, přidat bottomSheet pro filtrování tréninků jako transakcí v bance, přidat statistiky podle modelů

// ---------------------------------------------------------------------------
// SCREEN
// ---------------------------------------------------------------------------

class LiftingStatisticsScreen extends StatefulWidget {
  const LiftingStatisticsScreen({super.key});

  @override
  State<LiftingStatisticsScreen> createState() =>
      _LiftingStatisticsScreenState();
}

class _LiftingStatisticsScreenState extends State<LiftingStatisticsScreen> {
  // ------- MOCK: replace these with provider.plans, provider.exercises etc. -------

  List<Plan> _plans = [];
  List<Exercise> _exercises = [];

  // Selected plan/exercise state – drive from provider.selectedPlan etc.
  late Plan _selectedPlan;
  late Exercise _selectedExercise;

  // Mock aggregate stats – swap with provider.totalTonnage etc.
  final String _totalTonnage = '45,200 kg';
  final String _totalReps = '1,240';
  final String _workoutsCompleted = '24';
  final String _avgWorkoutTime = '65 min';

  // Mock exercise stats – swap with provider.*
  final String _bestSetDisplay = '130 kg × 6';
  final String _bestSetDate = 'Achieved on 14 Jun 2025';
  final bool _hasReal1RM = true; // toggle to see both UI states
  final String _oneRMDisplay = '142 kg';
  final String _oneRMDate = 'Logged on 2 May 2025';
  final String _progressGain = '+15 kg on 1RM';

  @override
  void initState() {
    super.initState();
    final isarService = context.read<IsarService>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _plans = await isarService.findAllValidPlans();
      _selectedPlan = _plans.first;
      _exercises = await isarService.findExercisesForPlan(_selectedPlan);
      _selectedExercise = _exercises.first;
    });
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiftingStatisticsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifting Statistics'),
        centerTitle: false,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  _PlanSelector(
                    plans: _plans,
                    selected: _selectedPlan,
                    onChanged: (p) => setState(() => _selectedPlan = p),
                  ),
                  const SizedBox(height: 16),
                  _EgoDashboard(
                    totalTonnage: _totalTonnage,
                    totalReps: _totalReps,
                    workoutsCompleted: _workoutsCompleted,
                    avgWorkoutTime: _avgWorkoutTime,
                  ),
                  const SizedBox(height: 20),
                  const _SectionDivider(label: 'Exercise Progress'),
                  const SizedBox(height: 16),
                  _ExerciseSelector(
                    exercises: _exercises,
                    selected: _selectedExercise,
                    onChanged: (e) => setState(() => _selectedExercise = e),
                  ),
                  const SizedBox(height: 12),
                  _BestSetCard(display: _bestSetDisplay, date: _bestSetDate),
                  const SizedBox(height: 10),
                  _OneRMCard(
                    hasReal1RM: _hasReal1RM,
                    display: _oneRMDisplay,
                    date: _oneRMDate,
                  ),
                  const SizedBox(height: 10),
                  _ProgressCard(gain: _progressGain),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// PLAN SELECTOR
// ---------------------------------------------------------------------------

class _PlanSelector extends StatelessWidget {
  final List<Plan> plans;
  final Plan selected;
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

// ---------------------------------------------------------------------------
// EGO DASHBOARD  –  2 × 2 stat grid
// ---------------------------------------------------------------------------

class _EgoDashboard extends StatelessWidget {
  final String totalTonnage;
  final String totalReps;
  final String workoutsCompleted;
  final String avgWorkoutTime;

  const _EgoDashboard({
    required this.totalTonnage,
    required this.totalReps,
    required this.workoutsCompleted,
    required this.avgWorkoutTime,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        icon: Icons.monitor_weight_rounded,
        label: 'Total Tonnage',
        value: totalTonnage,
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
  final List<Exercise> exercises;
  final Exercise selected;
  final ValueChanged<Exercise> onChanged;

  const _ExerciseSelector({
    required this.exercises,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Exercise>(
      initialValue: selected,
      decoration: InputDecoration(
        labelText: 'Exercise',
        prefixIcon: const Icon(Icons.sports_gymnastics_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLow,
      ),
      items: exercises
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: (e) {
        if (e != null) onChanged(e);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// BEST SET CARD
// ---------------------------------------------------------------------------

class _BestSetCard extends StatelessWidget {
  final String display;
  final String date;
  const _BestSetCard({required this.display, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                display,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                date,
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

// ---------------------------------------------------------------------------
// 1RM CARD  –  conditional: estimated vs true
// ---------------------------------------------------------------------------

class _OneRMCard extends StatelessWidget {
  final bool hasReal1RM;
  final String display;
  final String date;

  const _OneRMCard({
    required this.hasReal1RM,
    required this.display,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Gold palette that works in both light & dark
    const goldLight = Color(0xFFFFF8E1);
    const goldDark = Color(0xFF3E2E00);
    const goldBorder = Color(0xFFFFCA28);

    final isGold = hasReal1RM;
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
                        isGold ? 'True 1RM' : 'Est. 1RM',
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
                            style: theme.textTheme.labelSmall?.copyWith(
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
                    display,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isGold ? const Color(0xFF7A5800) : null,
                    ),
                  ),
                  Text(
                    date,
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
  final String gain;
  const _ProgressCard({required this.gain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = gain.startsWith('+');
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
                gain,
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

// ---------------------------------------------------------------------------
// SHARED DETAIL CARD WRAPPER
// ---------------------------------------------------------------------------

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
