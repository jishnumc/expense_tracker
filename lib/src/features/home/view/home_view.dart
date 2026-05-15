import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/home/widgets/et_monthly_limit_card.dart';
import 'package:expense_tracker/src/features/home/widgets/et_summary_card.dart';
import 'package:expense_tracker/src/features/home/widgets/et_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome, User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.zAppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(
                    child: ETSummaryCard(
                      title: 'Total Income',
                      amount: '90,000',
                      isIncome: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ETSummaryCard(
                      title: 'Total Expense',
                      amount: '36,345',
                      isIncome: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ETMonthlyLimitCard(spentAmount: 7324, totalLimit: 10000),
              const SizedBox(height: 24),
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: context.zAppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _mockTransactions.length,
                  padding: const EdgeInsets.only(
                    bottom: 50,
                  ), // Space for bottom nav
                  itemBuilder: (context, index) {
                    final tx = _mockTransactions[index];
                    return ETTransactionTile(
                      title: tx.title,
                      category: tx.category,
                      amount: tx.amount,
                      date: tx.date,
                      isExpense: tx.isExpense,
                      icon: tx.icon,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _mockTransactions = [
  (
    title: 'Grocery Store',
    category: 'Food',
    amount: 36345.0,
    date: '12th Dec 2026',
    isExpense: true,
    icon: Icons.shopping_cart,
  ),
  (
    title: 'Electricity Bill',
    category: 'Bills',
    amount: 379.0,
    date: '12th Dec 2026',
    isExpense: false,
    icon: Icons.water_drop,
  ),
  (
    title: 'Uber Ride',
    category: 'Transport',
    amount: 150.0,
    date: '11th Dec 2026',
    isExpense: true,
    icon: Icons.directions_car,
  ),
  (
    title: 'Salary',
    category: 'Income',
    amount: 90000.0,
    date: '1st Dec 2026',
    isExpense: false,
    icon: Icons.account_balance_wallet,
  ),
];
