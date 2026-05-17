import 'package:expense_tracker/src/features/profile/domain/repositories/sync_repository.dart';
import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/services/transaction_service.dart';

class FreshDatabaseException implements Exception {
  final String message;
  const FreshDatabaseException([this.message = 'Nothing to sync']);
  @override
  String toString() => message;
}

class AlreadySyncedException implements Exception {
  final String message;
  const AlreadySyncedException([this.message = 'Data is up to date']);
  @override
  String toString() => message;
}

class SyncRepositoryImpl implements ISyncRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionService _apiService;

  SyncRepositoryImpl(this._localDataSource, this._apiService);

  @override
  Future<void> syncData({
    required void Function(double progress, String message) onProgress,
  }) async {
    // ------------------------------------------------------------------
    // Pre-sync Checks
    // ------------------------------------------------------------------
    onProgress(0.02, 'Checking database status...');

    final totalCategories = await _localDataSource.getCategoriesCount();
    final totalTransactions = await _localDataSource.getTransactionsCount();

    if (totalCategories == 0 && totalTransactions == 0) {
      throw const FreshDatabaseException();
    }

    final deletedTransactions = await _localDataSource.getDeletedTransactions();
    final deletedCategories = await _localDataSource.getDeletedCategories();
    final unsyncedCategories = await _localDataSource.getUnsyncedCategories();
    final unsyncedTransactions = await _localDataSource.getUnsyncedTransactions();

    if (deletedTransactions.isEmpty &&
        deletedCategories.isEmpty &&
        unsyncedCategories.isEmpty &&
        unsyncedTransactions.isEmpty) {
      throw const AlreadySyncedException();
    }

    // ------------------------------------------------------------------
    // Step A: Clean up Deletions (Cloud Purge)
    // ------------------------------------------------------------------
    onProgress(0.1, 'Locating deleted records...');

    final deletedTxIds = deletedTransactions.map((t) => t['id'] as String).toList();
    final deletedCatIds = deletedCategories.map((c) => c['id'] as String).toList();

    if (deletedTxIds.isNotEmpty) {
      onProgress(0.2, 'Deleting ${deletedTxIds.length} transactions from cloud...');
      final response = await _apiService.deleteTransactions({'ids': deletedTxIds});
      if (response.isSuccessful) {
        onProgress(0.3, 'Purging deleted transactions locally...');
        await _localDataSource.hardDeleteTransactions(deletedTxIds);
      } else {
        throw Exception('Failed to delete transactions from cloud: ${response.error}');
      }
    }

    if (deletedCatIds.isNotEmpty) {
      onProgress(0.4, 'Deleting ${deletedCatIds.length} categories from cloud...');
      final response = await _apiService.deleteCategories({'ids': deletedCatIds});
      if (response.isSuccessful) {
        onProgress(0.5, 'Purging deleted categories locally...');
        await _localDataSource.hardDeleteCategories(deletedCatIds);
      } else {
        throw Exception('Failed to delete categories from cloud: ${response.error}');
      }
    }

    // ------------------------------------------------------------------
    // Step B: Upload New Data (Cloud Backup)
    // ------------------------------------------------------------------
    onProgress(0.6, 'Scanning unsynced categories...');

    // 1. Sync Categories First
    if (unsyncedCategories.isNotEmpty) {
      final successIds = <String>[];
      for (var i = 0; i < unsyncedCategories.length; i++) {
        final categoryMap = unsyncedCategories[i];
        final id = categoryMap['id'] as String;
        final name = categoryMap['name'] as String;
        
        onProgress(
          0.6 + (0.15 * (i / unsyncedCategories.length)),
          'Uploading category "$name"...',
        );

        final response = await _apiService.addCategory({
          'category_id': id,
          'name': name,
        });

        if (response.isSuccessful) {
          successIds.add(id);
        } else {
          throw Exception('Failed to upload category "$name": ${response.error}');
        }
      }

      if (successIds.isNotEmpty) {
        await _localDataSource.markCategoriesAsSynced(successIds);
      }
    }

    onProgress(0.75, 'Scanning unsynced transactions...');

    // 2. Sync Transactions Second
    if (unsyncedTransactions.isNotEmpty) {
      onProgress(0.8, 'Uploading ${unsyncedTransactions.length} transactions to cloud...');
      
      final txList = unsyncedTransactions.map((t) {
        return {
          'id': t['id'] as String,
          'amount': t['amount'] as num,
          'note': t['note'] as String?,
          'type': t['type'] as String,
          'category_id': t['category_id'] as String?,
          'timestamp': t['created_at'] as String,
        };
      }).toList();

      final response = await _apiService.addTransactions({
        'transactions': txList,
      });

      if (response.isSuccessful) {
        final successIds = unsyncedTransactions.map((t) => t['id'] as String).toList();
        onProgress(0.9, 'Finalizing sync status locally...');
        await _localDataSource.markTransactionsAsSynced(successIds);
      } else {
        throw Exception('Failed to upload transactions to cloud: ${response.error}');
      }
    }

    onProgress(1.0, 'Sync completed successfully!');
  }
}
