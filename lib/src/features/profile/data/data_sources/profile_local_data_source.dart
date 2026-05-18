import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import '../models/profile_model.dart';

abstract interface class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateBudgetLimit(double limit);
  Future<void> updateNickname(String name);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final DatabaseClient _dbClient;

  ProfileLocalDataSourceImpl(this._dbClient);

  @override
  Future<ProfileModel> getProfile() async {
    final db = await _dbClient.database;
    final results = await db.query('profile', limit: 1);

    if (results.isEmpty) {
      // Create a default profile if none exists
      final defaultProfile = ProfileModel(
        id: 'default',
        name: 'User',
        budgetLimit: 0.0,
      );
      await db.insert('profile', defaultProfile.toMap());
      return defaultProfile;
    }

    return ProfileModel.fromMap(results.first);
  }

  @override
  Future<void> updateBudgetLimit(double limit) async {
    final db = await _dbClient.database;
    await db.update(
      'profile',
      {'budget_limit': limit},
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }

  @override
  Future<void> updateNickname(String name) async {
    final db = await _dbClient.database;
    await db.update(
      'profile',
      {'name': name},
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }
}
