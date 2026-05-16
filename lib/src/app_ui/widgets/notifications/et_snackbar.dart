import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum ETSnackBarType { success, error, info }

class ETSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    ETSnackBarType type = ETSnackBarType.info,
  }) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (type) {
      case ETSnackBarType.success:
        backgroundColor = colors.success.withValues(alpha: 0.1);
        icon = Icons.check_circle_outline;
        iconColor = colors.success;
        break;
      case ETSnackBarType.error:
        backgroundColor = colors.error.withValues(alpha: 0.1);
        icon = Icons.error_outline;
        iconColor = colors.error;
        break;
      case ETSnackBarType.info:
        backgroundColor = colors.primary.withValues(alpha: 0.1);
        icon = Icons.info_outline;
        iconColor = colors.primary;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: backgroundColor.withValues(alpha: 0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
