import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETMonthlyLimitCard extends StatelessWidget {
  const ETMonthlyLimitCard({
    required this.spentAmount,
    required this.totalLimit,
    super.key,
  });

  final double spentAmount;
  final double totalLimit;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;
    final progress = (spentAmount / totalLimit).clamp(0.0, 1.0);
    final remainingPercentage = ((1 - progress) * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY LIMIT',
            style: textTheme.labelMedium?.copyWith(
              color: colors.white.withValues(alpha: 0.5),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '₹${spentAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      ' / ₹${totalLimit.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(colors.success),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$remainingPercentage% Remaining',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
