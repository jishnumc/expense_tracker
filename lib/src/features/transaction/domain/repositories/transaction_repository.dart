import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';

abstract interface class ITransactionRepository {
  Future<List<Category>> getCategories();
  Future<void> createCategory(String name);
  Future<void> deleteCategory(String id);
  Future<void> createTransaction(Transaction transaction);
  Future<double> getTotalIncomeForCurrentMonth();
  Future<double> getTotalExpensesForCurrentMonth();
  Future<List<Transaction>> getRecentTransactions({int limit = 10});
}
