import 'package:expense_tracker/src/features/transaction/data/data_sources/category_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import 'package:sqflite/sqflite.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseClient _dbClient;

  CategoryLocalDataSourceImpl(this._dbClient);

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
  Future<void> deleteCategory(String id) async {
    final db = await _dbClient.database;
    await db.update(
      'categories',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getDeletedCategories() async {
    final db = await _dbClient.database;
    return await db.query('categories', where: 'is_deleted = 1');
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
    return await db.query(
      'categories',
      where: 'is_synced = 0 AND is_deleted = 0',
    );
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
  Future<int> getCategoriesCount() async {
    final db = await _dbClient.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM categories',
    );
    return (result.first['count'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<bool> hasUnsyncedData() async {
    final db = await _dbClient.database;
    final catResult = await db.rawQuery(
      "SELECT count(*) as count FROM categories WHERE is_synced = 0",
    );
    final catCount = Sqflite.firstIntValue(catResult) ?? 0;
    return catCount > 0;
  }
}
