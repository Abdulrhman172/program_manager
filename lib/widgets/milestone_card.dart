import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MilestoneCard extends StatelessWidget {
  final String stage;
  final String status; // completed, in-progress, pending
  final String date;
  final String? description;

  const MilestoneCard({
    Key? key,
    required this.stage,
    required this.status,
    required this.date,
    this.description,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (status) {
      case 'completed':
        return const Color(0xFFDCFCE7);
      case 'in-progress':
        return const Color(0xFFDEF2FF);
      case 'pending':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case 'completed':
        return const Color(0xFFA7F3D0);
      case 'in-progress':
        return const Color(0xFFBAE6FD);
      case 'pending':
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'in-progress':
        return AppColors.primary;
      case 'pending':
      default:
        return AppColors.gray700;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case 'completed':
        return 'مكتمل';
      case 'in-progress':
        return 'قيد الإنجاز';
      case 'pending':
      default:
        return 'قادم';
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'in-progress':
        return Icons.schedule;
      case 'pending':
      default:
        return Icons.calendar_today;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(color: _getBorderColor()),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stage,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 12,
                      color: _getTextColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusLabel(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.gray400,
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          // Description
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
