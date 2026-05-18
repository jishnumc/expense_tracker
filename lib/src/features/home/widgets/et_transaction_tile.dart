import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/system/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ETTransactionTile extends StatelessWidget {
  const ETTransactionTile({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.icon,
    this.onDelete,
    super.key,
  });

  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isExpense;
  final IconData icon;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(
                  title.toCapitalized(),
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category.toCapitalized(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
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
                  fontSize: 22,
                  color: isExpense ? colors.expenseSecondary : colors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onDelete,
            child: Icon(Icons.delete, color: colors.expenseSecondary, size: 22),
          ),
        ],
      ),
    );
  }
}
