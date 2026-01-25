import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? leading;
  final GestureTapCallback onTap;
  const IconCard({
    super.key,
    required this.icon,
    required this.onTap,
    required this.label,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors.outline, width: 2),
          borderRadius: BorderRadius.circular(18),
          color: colors.secondaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsetsGeometry.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(color: colors.outline, width: 5),
                ),
                child: Icon(
                  icon,
                  size: 125,
                  color: colors.onSecondaryContainer,
                ),
              ), //TODO change for some picture?
              Text(
                label,
                style: textStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              Text(
                leading ?? "",
                style: textStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
