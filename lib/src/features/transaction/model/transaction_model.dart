import 'package:flutter/material.dart';

class Transaction {
  const Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.icon,
  });

  final String title;
  final String category;
  final double amount;
  final String date;
  final bool isExpense;
  final IconData icon;
}
