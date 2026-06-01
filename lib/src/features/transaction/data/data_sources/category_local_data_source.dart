import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> saveCategories(List<Category> categories);
  Future<List<Category>> getCategories();
  Future<void> createCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<List<Map<String, dynamic>>> getDeletedCategories();
  Future<void> hardDeleteCategories(List<String> ids);
  Future<List<Map<String, dynamic>>> getUnsyncedCategories();
  Future<void> markCategoriesAsSynced(List<String> ids);
  Future<int> getCategoriesCount();
  Future<bool> hasUnsyncedData();
  String generateUuid();
}
