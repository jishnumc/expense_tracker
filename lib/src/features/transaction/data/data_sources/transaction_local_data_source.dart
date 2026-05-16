import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveCategories(List<Category> categories);
  Future<List<Category>> getCategories();
  Future<void> createCategory(Category category);
  Future<void> insertTransaction(Map<String, dynamic> transaction);
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory();
  Future<void> deleteCategory(String id);
  String generateUuid();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseClient _dbClient;

  TransactionLocalDataSourceImpl(this._dbClient);

  @override
  String generateUuid() => _dbClient.generateUuid();

  @override
  Future<void> createCategory(Category category) async {
    final db = await _dbClient.database;
    await db.insert('categories', {
      'id': category.id,
      'name': category.name,
      'is_synced': 0,
      'is_deleted': 0,
    });
  }

  @override
  Future<void> saveCategories(List<Category> categories) async {
    final db = await _dbClient.database;
    final batch = db.batch();

    for (final category in categories) {
      batch.insert('categories', {
        'id': category.id,
        'name': category.name,
        'is_synced': 1,
        'is_deleted': 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Category>> getCategories() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'is_deleted = 0',
    );

    return maps
        .map(
          (map) =>
              Category(id: map['id'] as String, name: map['name'] as String),
        )
        .toList();
  }

  @override
  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await _dbClient.database;
    await db.insert('transactions', transaction);
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    return await _dbClient.getTransactionsWithCategory();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await _dbClient.database;
    await db.update(
      'categories',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
