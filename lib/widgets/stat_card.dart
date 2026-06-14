import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int? change;
  final String? changeLabel;
  final String color; // blue, green, orange, red

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.change,
    this.changeLabel,
    this.color = 'blue',
  });

  Color _getBackgroundColor() {
    switch (color) {
      case 'green':
        return const Color(0xFFDCFCE7);
      case 'orange':
        return const Color(0xFFFEF3C7);
      case 'red':
        return const Color(0xFFFEE2E2);
      case 'blue':
      default:
        return const Color(0xFFDEF2FF);
    }
  }

  Color _getIconColor() {
    switch (color) {
      case 'green':
        return AppColors.success;
      case 'orange':
        return AppColors.warning;
      case 'red':
        return AppColors.error;
      case 'blue':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = change != null && change! >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: _getIconColor(),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),

            // Label
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),

            // Value and Change
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                if (change != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isPositive
                              ? AppColors.success
                              : AppColors.error,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${change!.abs()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isPositive
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            // Change Label
            if (changeLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                changeLabel!,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
