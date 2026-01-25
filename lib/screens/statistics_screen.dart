import 'package:fitness_app/widgets/icon_card.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: IconCard(
                icon: Icons.monitor_weight_outlined,
                label: "Body Weight Statistics",
                leading: "Examine your body weight progress",
                onTap: () {},
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: IconCard(
                icon: Icons.fitness_center_outlined,
                label: "Lifting Statistics",
                leading: "Examine your progress on different plans",
                onTap: () {},
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
