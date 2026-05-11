import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationCard extends StatelessWidget {
  final String type; // warning, success, info
  final String title;
  final String description;
  final String? timestamp;

  const NotificationCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    this.timestamp,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case 'warning':
        return const Color(0xFFFEE2E2);
      case 'success':
        return const Color(0xFFDCFCE7);
      case 'info':
      default:
        return const Color(0xFFDEF2FF);
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case 'warning':
        return const Color(0xFFFECACA);
      case 'success':
        return const Color(0xFFA7F3D0);
      case 'info':
      default:
        return const Color(0xFFBAE6FD);
    }
  }

  Color _getTitleColor() {
    switch (type) {
      case 'warning':
        return const Color(0xFF7F1D1D);
      case 'success':
        return const Color(0xFF065F46);
      case 'info':
      default:
        return const Color(0xFF0C4A6E);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case 'warning':
        return const Color(0xFFB91C1C);
      case 'success':
        return const Color(0xFF059669);
      case 'info':
      default:
        return const Color(0xFF0369A1);
    }
  }

  IconData _getIcon() {
    switch (type) {
      case 'warning':
        return Icons.error_outline;
      case 'success':
        return Icons.check_circle_outline;
      case 'info':
      default:
        return Icons.info_outline;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIcon(),
            color: _getTextColor(),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getTitleColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: _getTextColor(),
                  ),
                ),
                if (timestamp != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    timestamp!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
