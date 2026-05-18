import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/amount_validator.dart';
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  bool _isExpense = true;
  String? _selectedCategoryId;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<CategoryBloc>()..add(const CategoryEvent.fetched()),
        ),
      ],
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              ETSnackBar.show(
                context,
                message: 'Transaction saved successfully!',
                type: ETSnackBarType.success,
              );
              Navigator.pop(context);
            },
            error: (message) {
              ETSnackBar.show(
                context,
                message: message,
                type: ETSnackBarType.error,
              );
            },
            orElse: () {},
          );
        },
        child: Builder(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A), // Match the dark sheet color
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: _formKey,
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
                    _SegmentedControl(
                      isExpense: _isExpense,
                      onChanged: (value) => setState(() => _isExpense = value),
                    ),
                    const SizedBox(height: 24),
                    ETTextField(
                      controller: _noteController,
                      hintText: 'Note',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a note';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ETTextField(
                      controller: _amountController,
                      hintText: 'Amount (₹)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        final result = const AmountValidator().validate(value);
                        if (result is ValidationFailure) {
                          return result.error.message;
                        }
                        return null;
                      },
                    ),
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
                    _CategoryList(
                      selectedCategoryId: _selectedCategoryId,
                      onSelected: (id) =>
                          setState(() => _selectedCategoryId = id),
                    ),
                    const SizedBox(height: 24),
                    const _InfoBox(),
                    const SizedBox(height: 32),
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        return ETPrimaryButton(
                          label: state.maybeWhen(
                            loading: () => 'SAVING...',
                            orElse: () => 'Save',
                          ),
                          onPressed: state.maybeWhen(
                            loading: () => null,
                            orElse: () => () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (_selectedCategoryId == null) {
                                  ETSnackBar.show(
                                    context,
                                    message: 'Please select a category',
                                    type: ETSnackBarType.error,
                                  );
                                  return;
                                }
                                context.read<TransactionBloc>().add(
                                  TransactionEvent.created(
                                    amount: double.parse(
                                      _amountController.text,
                                    ),
                                    note: _noteController.text.trim(),
                                    type: _isExpense ? 'debit' : 'credit',
                                    categoryId: _selectedCategoryId!,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({required this.isExpense, required this.onChanged});

  final bool isExpense;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: 'Expense',
              isSelected: isExpense,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _SegmentItem(
              label: 'Income',
              isSelected: !isExpense,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.incomeSecondary : Colors.transparent,
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
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final String? selectedCategoryId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return state.maybeWhen(
          success: (categories) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = selectedCategoryId == cat.id;
                  return GestureDetector(
                    onTap: () => onSelected(cat.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.9)
                              : colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        cat.name,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colors.white
                              : colors.white.withValues(alpha: 0.5),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const _CategoryShimmer(),
          error: (message) =>
              Text(message, style: const TextStyle(color: Colors.red)),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Category'),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.incomePrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.incomePrimary.withValues(alpha: 0.9)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Everything you add here is saved only on your device.',
              style: textTheme.bodySmall?.copyWith(color: colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
