import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETTransactionTile extends StatelessWidget {
  const ETTransactionTile({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.icon,
    super.key,
  });

  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isExpense;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isExpense ? '-' : '+'}₹${amount.toInt()}',
                style: textTheme.titleMedium?.copyWith(
                  color: isExpense ? colors.error : colors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.delete,
            color: Colors.red.shade900,
            size: 24,
          ),
        ],
      ),
    );
  }
}
