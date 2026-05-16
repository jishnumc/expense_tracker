import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/home/widgets/et_transaction_tile.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/transaction_list_bloc.dart';
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionListBloc>()
        ..add(const TransactionListEvent.fetched()),
      child: const _TransactionContentView(),
    );
  }
}

class _TransactionContentView extends StatelessWidget {
  const _TransactionContentView();

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocBuilder<TransactionListBloc, TransactionListState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => Skeletonizer(
                  enabled: true,
                  child: _buildList(context, _mockTransactions),
                ),
                success: (transactions) => _buildList(context, transactions),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colors.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(color: colors.white),
                      ),
                      const SizedBox(height: 24),
                      ETSecondaryButton(
                        label: 'Retry',
                        onPressed: () => context
                            .read<TransactionListBloc>()
                            .add(const TransactionListEvent.fetched()),
                      ),
                    ],
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Transaction> transactions) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Transactions",
          style: textTheme.headlineMedium?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                    'No transactions found',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  padding: const EdgeInsets.only(bottom: 120),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return ETTransactionTile(
                      title: tx.note,
                      category: tx.categoryName ?? 'Other',
                      amount: tx.amount,
                      date: DateFormat('d MMMM y').format(tx.createdAt),
                      isExpense: tx.type == 'debit',
                      icon: _getIconForCategory(tx.categoryName),
                      onDelete: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => ETAlertDialog(
                            title: 'Delete Transaction',
                            content:
                                'Are you sure you want to delete this transaction for ₹${tx.amount.toInt()}? This action cannot be undone.',
                            cancelLabel: 'Cancel',
                            confirmLabel: 'Delete',
                            isDestructive: true,
                          ),
                        );

                        if (shouldDelete == true && context.mounted) {
                          context.read<TransactionListBloc>().add(
                                TransactionListEvent.deleted(tx.id),
                              );
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
        return Icons.directions_car;
      case 'health':
        return Icons.medical_services;
      case 'salary':
        return Icons.payments;
      case 'bills':
        return Icons.receipt_long;
      default:
        return Icons.category;
    }
  }
}

final List<Transaction> _mockTransactions = List.generate(
  5,
  (index) => Transaction(
    id: index.toString(),
    amount: 1000.0,
    note: 'Transaction $index',
    type: 'debit',
    categoryId: '1',
    categoryName: 'Food',
    createdAt: DateTime.now(),
  ),
);
