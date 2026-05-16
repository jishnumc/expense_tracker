import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';

abstract interface class ITransactionRepository {
  Future<List<Category>> getCategories();
  Future<void> createCategory(String name);
  Future<void> deleteCategory(String id);
}
