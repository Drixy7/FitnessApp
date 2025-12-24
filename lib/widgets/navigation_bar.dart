import 'package:fitness_app/widgets/pickers/bodyweight_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weight_log.dart';
import '../providers/isar_service.dart';

class NavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void showWeightLogger(WeightLog? weightLog) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: BodyWeightLogger(initialWeightLog: weightLog),
          );
        },
      );
    }

    return Container(
      // 1. The Floating Pill Shape
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh, // High contrast background
        borderRadius: BorderRadius.circular(32), // Fully rounded pill
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarIcon(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: "Home",
            isSelected: selectedIndex == 0,
            onTap: () => onDestinationSelected(0),
          ),
          const SizedBox(width: 16),
          _NavBarIcon(
            icon: Icons.monitor_weight_outlined,
            selectedIcon: Icons.monitor_weight,
            label: "Log Weight",
            isSelected: false,
            onTap: () async {
              final WeightLog? weightLog = await context
                  .read<IsarService>()
                  .findWeightLogForDate(DateTime.now());
              showWeightLogger(weightLog);
            },
          ),
          const SizedBox(width: 16),
          _NavBarIcon(
            icon: Icons.auto_graph_outlined,
            selectedIcon: Icons.auto_graph,
            label: "Statistics",
            isSelected: selectedIndex == 1,
            onTap: () => onDestinationSelected(1),
          ),
          const SizedBox(width: 16),
          _NavBarIcon(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: "Settings",
            isSelected: selectedIndex == 2,
            onTap: () => onDestinationSelected(2),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: colorScheme.primaryContainer, // Highlight active tab
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
