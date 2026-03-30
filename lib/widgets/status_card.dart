import 'package:fitness_app/models/custom_data_package_models.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/widgets/pickers/week_chooser_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  bool _checkViewingCurrentWeek(PlanProvider provider) {
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    if (provider.currentWeekSelection == null) {
      return true;
    }
    return provider.currentWeekSelection!.startOfWeek == monday;
  }

  void _showWeekPicker(BuildContext context) async {
    final planProvider = context.read<PlanProvider>();
    if (planProvider.activeSession == null) return;

    final WeekSelectionResult? result =
        await showModalBottomSheet<WeekSelectionResult>(
          isScrollControlled: true,
          context: context,
          builder: (ctx) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: WeekChooserView(
                leadingText: "Select a week to view or edit",
                firstAvailableDate: planProvider.activeSession!.startDate,
                initialWeekSelection: planProvider.currentWeekSelection,
              ),
            );
          },
        );
    if (result != null) {
      planProvider.goToAnyWeek(result.selectedTotalWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final textThemes = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    // -- Data Extraction & Null Safety --
    final planName =
        planProvider.activeSession?.plan.value?.name ?? 'Loading...';
    final weekNum = planProvider.currentWeekInCycle;
    final cycleNum = planProvider.currentCycle;
    final dateRange = planProvider.formattedDateRange;
    final completion = planProvider.currentCompletion.clamp(0.0, 1.0);
    final isViewingCurrentWeek = _checkViewingCurrentWeek(planProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsetsGeometry.directional(start: 12, end: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                planName.toUpperCase(),
                style: textThemes.titleMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  onPressed:
                      planProvider.currentWeekSelection?.selectedTotalWeek == 1
                      ? null
                      : planProvider.goToPreviousWeek,
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: "Previous Week",
                ),
                GestureDetector(
                  onTap: () {
                    _showWeekPicker(context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 12,
                          color: colors.surfaceContainerHighest,
                        ),
                      ),

                      SizedBox(
                        width: 110,
                        height: 110,
                        child: CircularProgressIndicator(
                          value: completion,
                          strokeWidth: 12,
                          strokeCap: StrokeCap.round,
                          color: colors.primary,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "WEEK",
                            style: textThemes.labelSmall?.copyWith(
                              color: colors.outline,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            "$weekNum",
                            style: textThemes.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Cycle $cycleNum",
                              style: textThemes.labelMedium?.copyWith(
                                color: colors.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                IconButton.filledTonal(
                  onPressed: planProvider.goToNextWeek,
                  icon: const Icon(Icons.chevron_right_rounded),
                  tooltip: "Next Week",
                ),
              ],
            ),
            // Add this block below the Row containing the circular indicators
            const SizedBox(height: 8),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isViewingCurrentWeek ? 0.0 : 1.0,
              child: Visibility(
                visible: !isViewingCurrentWeek,
                maintainState: true,
                maintainAnimation: true,
                maintainSize:
                    true, // Zabrání tomu, aby se UI "scvrklo", když tlačítko zmizí
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: colors.primary,
                  ),
                  onPressed: planProvider.goToCurrentWeek,
                  icon: const Icon(Icons.history_rounded, size: 18),
                  label: const Text("Back to current week"),
                ),
              ),
            ),

            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                _showWeekPicker(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateRange,
                    style: textThemes.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
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
