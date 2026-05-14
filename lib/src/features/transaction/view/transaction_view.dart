import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/home/widgets/et_transaction_tile.dart';
import 'package:expense_tracker/src/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Transactions",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _mockTransactions.length,
                  padding: const EdgeInsets.only(bottom: 100),
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

final List<Transaction> _mockTransactions = [
  const Transaction(
    title: 'Grocery Store',
    category: 'Food',
    amount: 36345.0,
    date: '12th Dec 2026',
    isExpense: true,
    icon: Icons.shopping_cart,
  ),
  const Transaction(
    title: 'Electricity Bill',
    category: 'Bills',
    amount: 379.0,
    date: '12th Dec 2026',
    isExpense: false,
    icon: Icons.water_drop,
  ),
  const Transaction(
    title: 'Uber Ride',
    category: 'Transport',
    amount: 150.0,
    date: '11th Dec 2026',
    isExpense: true,
    icon: Icons.directions_car,
  ),
  const Transaction(
    title: 'Salary',
    category: 'Income',
    amount: 90000.0,
    date: '1st Dec 2026',
    isExpense: false,
    icon: Icons.account_balance_wallet,
  ),
  const Transaction(
    title: 'Movie Tickets',
    category: 'Entertainment',
    amount: 800.0,
    date: '10th Dec 2026',
    isExpense: true,
    icon: Icons.movie,
  ),
];
