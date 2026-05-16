import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseClient {
  static Database? _database;
  static const _uuid = Uuid();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Categories Table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0,
        is_deleted INTEGER DEFAULT 0
      )
    ''');

    // Transactions Table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        note TEXT,
        type TEXT CHECK(type IN ('credit', 'debit')),
        category_id TEXT,
        is_synced INTEGER DEFAULT 0,
        is_deleted INTEGER DEFAULT 0,
        created_at TEXT DEFAULT (datetime('now','localtime')),
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Profile Table
    await db.execute('''
      CREATE TABLE profile (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        budget_limit REAL DEFAULT 0.0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE profile (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          budget_limit REAL DEFAULT 0.0
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN created_at TEXT DEFAULT (datetime("now","localtime"))',
      );
    }
  }

  String generateUuid() => _uuid.v4();

  // Helper method for the SQL JOIN challenge
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        t.*, 
        c.name as category_name 
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE t.is_deleted = 0
    ''');
  }
}
