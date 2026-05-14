import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  bool _isExpense = true;
  String _selectedCategory = 'Bills';

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Match the dark sheet color
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Transaction',
                style: textTheme.headlineSmall?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSegmentedControl(colors, textTheme),
          const SizedBox(height: 24),
          const ETTextField(hintText: 'Title'),
          const SizedBox(height: 16),
          const ETTextField(hintText: 'Amount (₹)'),
          const SizedBox(height: 24),
          Text(
            'CATEGORY',
            style: textTheme.labelMedium?.copyWith(
              color: colors.white.withValues(alpha: 0.5),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryList(colors, textTheme),
          const SizedBox(height: 24),
          _buildInfoBox(colors, textTheme),
          const SizedBox(height: 32),
          ETPrimaryButton(
            label: 'Save',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24), // Space for system navigation bar
        ],
      ),
    );
  }

  Widget _buildSegmentedControl(AppColors colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSegmentItem('Expense', _isExpense, colors, textTheme)),
          Expanded(child: _buildSegmentItem('Income', !_isExpense, colors, textTheme)),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(String label, bool isSelected, AppColors colors, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => setState(() => _isExpense = label == 'Expense'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? (label == 'Expense' ? colors.incomePrimary : colors.primary) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              color: colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(AppColors colors, TextTheme textTheme) {
    final categories = ['Food', 'Bills', 'Transport', 'Shopping'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                cat,
                style: textTheme.bodyMedium?.copyWith(
                  color: isSelected ? colors.white : colors.white.withValues(alpha: 0.5),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoBox(AppColors colors, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.incomePrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.incomePrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.incomePrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Everything you add here is saved only on your device.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
