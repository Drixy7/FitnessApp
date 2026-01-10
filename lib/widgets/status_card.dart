import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:fitness_app/widgets/pickers/week_chooser_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();

    void showWeekPicker() async {
      final WeekSelectionResult? result =
          await showModalBottomSheet<WeekSelectionResult>(
            isScrollControlled: true,
            context: context,
            builder: (ctx) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: WeekChooserView(
                  firstAvailableDate: planProvider.activeSession!.startTime,
                  initialWeekSelection: planProvider.currentWeekSelection,
                ),
              );
            },
          );
      if (result != null) {
        planProvider.currentWeekSelection = result;
        planProvider.goToAnyWeek(result.selectedTotalWeek);
      }
    }

    return Card(
      margin: EdgeInsetsGeometry.directional(top: 30),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    planProvider.goToPreviousWeek();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: showWeekPicker,
                    child: Column(
                      children: [
                        Text(
                          "WEEK ${planProvider.isViewingForeignSession ? "unknown" : planProvider.currentWeekInCycle}",
                          style: AppTextStyles.pageMainTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(planProvider.formattedDateRange),
                        const SizedBox(height: 4),
                        Text(
                          "Cycle ${planProvider.isViewingForeignSession ? "unknown" : planProvider.currentCycle}",
                          style: AppTextStyles.pageSubTitle,
                        ),
                      ],
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    planProvider.goToNextWeek();
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              planProvider.activeSession?.plan.value?.name ?? 'Loading Plan...',
              style: AppTextStyles.listTitle,
            ),
          ],
        ),
      ),
    );
  }
}
