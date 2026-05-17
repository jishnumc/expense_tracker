import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionLocalDataSource {
  Future<void> saveCategories(List<Category> categories);
  Future<List<Category>> getCategories();
  Future<void> createCategory(Category category);
  Future<void> insertTransaction(Map<String, dynamic> transaction);
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory();
  Future<List<Map<String, dynamic>>> getAllTransactions();
  Future<double> getTotalIncomeForCurrentMonth();
  Future<double> getTotalExpensesForCurrentMonth();
  Future<List<Map<String, dynamic>>> getRecentTransactions(int limit);
  Future<bool> hasUnsyncedData();
  Future<void> deleteCategory(String id);
  Future<void> deleteTransaction(String id);
  String generateUuid();
  Future<List<Map<String, dynamic>>> getDeletedTransactions();
  Future<List<Map<String, dynamic>>> getDeletedCategories();
  Future<void> hardDeleteTransactions(List<String> ids);
  Future<void> hardDeleteCategories(List<String> ids);
  Future<List<Map<String, dynamic>>> getUnsyncedCategories();
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions();
  Future<void> markCategoriesAsSynced(List<String> ids);
  Future<void> markTransactionsAsSynced(List<String> ids);
  Future<int> getCategoriesCount();
  Future<int> getTransactionsCount();
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
  Future<double> getTotalIncomeForCurrentMonth() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM transactions 
      WHERE type = 'credit' 
      AND is_deleted = 0 
      AND strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now', 'localtime')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalExpensesForCurrentMonth() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM transactions 
      WHERE type = 'debit' 
      AND is_deleted = 0 
      AND strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now', 'localtime')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await _dbClient.database;
    return await db.rawQuery('''
      SELECT t.*, c.name as category_name 
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
      ORDER BY t.created_at DESC
    ''');
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentTransactions(int limit) async {
    final db = await _dbClient.database;
    return await db.rawQuery(
      '''
      SELECT t.*, c.name as category_name 
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
      ORDER BY t.created_at DESC
      LIMIT ?
    ''',
      [limit],
    );
  }

  @override
  Future<bool> hasUnsyncedData() async {
    final db = await _dbClient.database;
    final txResult = await db.rawQuery(
      "SELECT count(*) as count FROM transactions WHERE is_synced = 0 AND is_deleted = 0",
    );
    final catResult = await db.rawQuery(
      "SELECT count(*) as count FROM categories WHERE is_synced = 0 AND is_deleted = 0",
    );

    final txCount = Sqflite.firstIntValue(txResult) ?? 0;
    final catCount = Sqflite.firstIntValue(catResult) ?? 0;

    return txCount > 0 || catCount > 0;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await _dbClient.database;
    await db.update(
      'transactions',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
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

  @override
  Future<List<Map<String, dynamic>>> getDeletedTransactions() async {
    final db = await _dbClient.database;
    return await db.query('transactions', where: 'is_deleted = 1');
  }

  @override
  Future<List<Map<String, dynamic>>> getDeletedCategories() async {
    final db = await _dbClient.database;
    return await db.query('categories', where: 'is_deleted = 1');
  }

  @override
  Future<void> hardDeleteTransactions(List<String> ids) async {
    final db = await _dbClient.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.delete('transactions', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> hardDeleteCategories(List<String> ids) async {
    final db = await _dbClient.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.delete('categories', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedCategories() async {
    final db = await _dbClient.database;
    return await db.query('categories', where: 'is_synced = 0 AND is_deleted = 0');
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions() async {
    final db = await _dbClient.database;
    return await db.query('transactions', where: 'is_synced = 0 AND is_deleted = 0');
  }

  @override
  Future<void> markCategoriesAsSynced(List<String> ids) async {
    final db = await _dbClient.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'categories',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> markTransactionsAsSynced(List<String> ids) async {
    final db = await _dbClient.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.update(
        'transactions',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<int> getCategoriesCount() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM categories');
    return (result.first['count'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<int> getTransactionsCount() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM transactions');
    return (result.first['count'] as num?)?.toInt() ?? 0;
  }
}
