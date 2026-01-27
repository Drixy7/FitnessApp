import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/providers/plan_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/day_detail_screen.dart';
import 'package:fitness_app/widgets/status_card.dart';
import 'package:fitness_app/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO Design this to be prettier + IMPLEMENT VISUAL EFFECTS OF WORKOUT STATUS. + Implement visual difference of completed week
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();

    Future<void> navigateToDayDetail(PlanDay day) async {
      final workoutProvider = context.read<WorkoutProvider>();
      final weekSelection = planProvider.currentWeekSelection;

      if (weekSelection == null) {
        return;
      }

      await workoutProvider.getOrCreateWorkoutForDay(day, weekSelection);
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DayDetailScreen()),
        );
      }
    }

    return Scaffold(
      body: Center(
        child: planProvider.isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(
                children: [
                  SafeArea(child: StatusCard()),
                  Expanded(
                    child: ListView.builder(
                      itemCount: planProvider.daysForWeek.keys.length,
                      itemBuilder: (context, index) {
                        final day = planProvider.daysForWeek.keys
                            .toList()[index];
                        return TrainingCard(
                          day: day,
                          onTap: () {
                            navigateToDayDetail(day);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
