import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/src/features/transaction/data/models/transaction_model.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  final TransactionLocalDataSource _localDataSource;

  TransactionRepositoryImpl(this._localDataSource);

  @override
  Future<List<Category>> getCategories() async {
    return await _localDataSource.getCategories();
  }

  @override
  Future<void> createCategory(String name) async {
    final id = _localDataSource.generateUuid();
    final category = Category(id: id, name: name);
    await _localDataSource.createCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      note: transaction.note,
      type: transaction.type,
      categoryId: transaction.categoryId,
      isSynced: transaction.isSynced,
      isDeleted: transaction.isDeleted,
      createdAt: transaction.createdAt,
    );
    await _localDataSource.insertTransaction(model.toMap());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _localDataSource.deleteTransaction(id);
  }

  @override
  Future<double> getTotalIncomeForCurrentMonth() async {
    return await _localDataSource.getTotalIncomeForCurrentMonth();
  }

  @override
  Future<double> getTotalExpensesForCurrentMonth() async {
    return await _localDataSource.getTotalExpensesForCurrentMonth();
  }

  @override
  Future<List<Transaction>> getRecentTransactions({int limit = 10}) async {
    final maps = await _localDataSource.getRecentTransactions(limit);
    return maps.map((map) {
      final model = TransactionModel.fromMap(map);
      return Transaction(
        id: model.id,
        amount: model.amount,
        note: model.note,
        type: model.type,
        categoryId: model.categoryId,
        categoryName: map['category_name'] as String?,
        isSynced: model.isSynced,
        isDeleted: model.isDeleted,
        createdAt: model.createdAt,
      );
    }).toList();
  }

  @override
  Future<bool> hasUnsyncedData() async {
    return await _localDataSource.hasUnsyncedData();
  }

  Future<List<Map<String, dynamic>>> getLocalTransactions() async {
    return await _localDataSource.getTransactionsWithCategory();
  }
}
