import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import 'package:sqflite/sqflite.dart';

abstract class TransactionLocalDataSource {
  Future<void> insertTransaction(Map<String, dynamic> transaction);
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions);
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory();
  Future<List<Map<String, dynamic>>> getAllTransactions();
  Future<double> getTotalIncomeForCurrentMonth();
  Future<double> getTotalExpensesForCurrentMonth();
  Future<List<Map<String, dynamic>>> getRecentTransactions(int limit);
  Future<bool> hasUnsyncedData();
  Future<void> deleteTransaction(String id);
  String generateUuid();
  Future<List<Map<String, dynamic>>> getDeletedTransactions();
  Future<void> hardDeleteTransactions(List<String> ids);
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions();
  Future<void> markTransactionsAsSynced(List<String> ids);
  Future<int> getTransactionsCount();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseClient _dbClient;

  TransactionLocalDataSourceImpl(this._dbClient);

  @override
  String generateUuid() => _dbClient.generateUuid();

  @override
  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await _dbClient.database;
    await db.insert('transactions', transaction);
  }

  @override
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    final db = await _dbClient.database;
    final batch = db.batch();

    for (final transaction in transactions) {
      batch.insert('transactions', transaction);
    }

    await batch.commit(noResult: true);
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
      "SELECT count(*) as count FROM transactions WHERE is_synced = 0",
    );
    final txCount = Sqflite.firstIntValue(txResult) ?? 0;
    return txCount > 0;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await _dbClient.database;
    await db.update(
      'transactions',
      {
        'is_deleted': 1,
        'is_synced': 0,
      },
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
  Future<void> hardDeleteTransactions(List<String> ids) async {
    final db = await _dbClient.database;
    final batch = db.batch();
    for (final id in ids) {
      batch.delete('transactions', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedTransactions() async {
    final db = await _dbClient.database;
    return await db.query('transactions', where: 'is_synced = 0 AND is_deleted = 0');
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
  Future<int> getTransactionsCount() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM transactions');
    return (result.first['count'] as num?)?.toInt() ?? 0;
  }
}
