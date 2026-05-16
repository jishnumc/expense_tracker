import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/features/home/widgets/et_monthly_limit_card.dart';
import 'package:expense_tracker/src/features/home/widgets/et_summary_card.dart';
import 'package:expense_tracker/src/features/home/widgets/et_transaction_tile.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/transaction_summary_bloc.dart';
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionSummaryBloc>()
        ..add(const TransactionSummaryEvent.fetched()),
      child: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () {
              context.read<TransactionSummaryBloc>().add(
                const TransactionSummaryEvent.fetched(),
              );
            },
            orElse: () {},
          );
        },
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: ETFloatingActionButton(
          onPressed: () => context.push('/add-transaction'),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<TransactionSummaryBloc, TransactionSummaryState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (income, expense, limit, recentTransactions) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final nickname = state.maybeWhen(
                            authenticated: (user) => user.nickname,
                            orElse: () => 'User',
                          );
                          return Text(
                            'Welcome, $nickname',
                            style: textTheme.headlineSmall?.copyWith(
                              color: colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ETSummaryCard(
                              title: 'Total Income',
                              amount: currencyFormat.format(income).replaceAll('₹', ''),
                              isIncome: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ETSummaryCard(
                              title: 'Total Expense',
                              amount: currencyFormat.format(expense).replaceAll('₹', ''),
                              isIncome: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ETMonthlyLimitCard(
                        spentAmount: expense,
                        totalLimit: limit,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Recent Transactions',
                        style: textTheme.titleLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: recentTransactions.isEmpty
                            ? Center(
                              child: Text(
                                'No transactions yet',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: recentTransactions.length,
                              padding: const EdgeInsets.only(bottom: 120),
                              itemBuilder: (context, index) {
                                final tx = recentTransactions[index];
                                return ETTransactionTile(
                                  title: tx.note,
                                  category: tx.categoryName ?? 'Other',
                                  amount: tx.amount,
                                  date: DateFormat('d MMMM y').format(tx.createdAt),
                                  isExpense: tx.type == 'debit',
                                  icon: _getIconForCategory(tx.categoryName),
                                );
                              },
                            ),
                      ),
                    ],
                  );
                },
                loading: () => Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Center(child: Text('Loading dashboard...')),
                    ],
                  ),
                ),
                error: (message) => Center(child: Text(message)),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
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
