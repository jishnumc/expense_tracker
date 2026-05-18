import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETSyncProgressDialog extends StatelessWidget {
  final double progress;
  final String statusMessage;

  const ETSyncProgressDialog({
    required this.progress,
    required this.statusMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;
    final percent = (progress * 100).toInt();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sync,
                    color: colors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cloud Sync',
                        style: textTheme.titleLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Synchronizing your offline data...',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Progress Bar & Percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$percent%',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: colors.white.withValues(alpha: 0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Step-by-Step indicators
            _buildSyncStep(
              context,
              label: 'Uploading transactions',
              isActive: progress >= 0.0 && progress < 1.0,
              isCompleted: progress == 1.0,
            ),
            const SizedBox(height: 14),
            _buildSyncStep(
              context,
              label: 'Finalizing sync status',
              isActive: progress == 1.0,
              isCompleted: progress == 1.0,
            ),
            const SizedBox(height: 28),
            // Action status message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      statusMessage,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.white.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildSyncStep(
    BuildContext context, {
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    Color iconColor = colors.white.withValues(alpha: 0.2);
    IconData icon = Icons.radio_button_unchecked;

    if (isCompleted) {
      iconColor = colors.success;
      icon = Icons.check_circle;
    } else if (isActive) {
      iconColor = colors.primary;
      icon = Icons.sync;
    }

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 14),
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            color: isCompleted
                ? colors.white
                : (isActive ? colors.primary : colors.white.withValues(alpha: 0.4)),
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
