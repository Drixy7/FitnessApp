import 'package:fitness_app/providers/lifting_statistics_provider.dart';
import 'package:fitness_app/screens/statistics/body_weight_statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/body_weight_statistics_provider.dart';
import 'lifting_statistics_screen.dart';

class StatisticsNavigationScreen extends StatelessWidget {
  const StatisticsNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final liftingProvider = context.watch<LiftingStatisticsProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your fitness journey',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatCard(
                        icon: Icons.monitor_weight_outlined,
                        title: 'Body Weight',
                        subtitle: 'Track your weight progress over time',
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primaryContainer,
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                        onTap: () async {
                          await context
                              .read<BodyWeightStatisticsProvider>()
                              .loadBodyWeightStats();
                          if (context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    BodyWeightStatisticsScreen(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      _StatCard(
                        icon: Icons.fitness_center_outlined,
                        title: 'Lifting Progress',
                        subtitle:
                            (liftingProvider.exerciseLoading ||
                                liftingProvider.planLoading)
                            ? "Loading data..."
                            : (liftingProvider.hasValidPlan
                                  ? 'Analyze your strength gains and performance'
                                  : "No lifting data to show yet."),
                        gradient: liftingProvider.hasValidPlan
                            ? LinearGradient(
                                colors: [
                                  theme.colorScheme.secondaryContainer,
                                  theme.colorScheme.secondary.withOpacity(0.8),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade400,
                                  Colors.grey.shade700,
                                ],
                              ),

                        onTap: liftingProvider.hasValidPlan
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LiftingStatisticsScreen(),
                                  ),
                                );
                                liftingProvider.loadDataForPlan();
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onTap == null;

    return Material(
      elevation: isDisabled ? 1 : 4,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isDisabled ? 0.6 : 1.0,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!isDisabled)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
