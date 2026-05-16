import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';

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

  Future<List<Map<String, dynamic>>> getLocalTransactions() async {
    return await _localDataSource.getTransactionsWithCategory();
  }
}
