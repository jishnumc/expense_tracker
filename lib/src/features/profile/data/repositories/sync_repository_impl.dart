import 'package:expense_tracker/src/features/profile/domain/repositories/sync_repository.dart';
import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/services/transaction_service.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';

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
    final unsyncedTransactions = await _localDataSource
        .getUnsyncedTransactions();

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

    final deletedTxIds = deletedTransactions
        .map((t) => t['id'] as String)
        .toList();
    final deletedCatIds = deletedCategories
        .map((c) => c['id'] as String)
        .toList();

    if (deletedTxIds.isNotEmpty) {
      onProgress(
        0.2,
        'Deleting ${deletedTxIds.length} transactions from cloud...',
      );
      final response = await _apiService.deleteTransactions({
        'ids': deletedTxIds,
      });
      if (response.isSuccessful) {
        onProgress(0.3, 'Purging deleted transactions locally...');
        await _localDataSource.hardDeleteTransactions(deletedTxIds);
      } else {
        throw Exception(
          'Failed to delete transactions from cloud: ${response.error}',
        );
      }
    }

    if (deletedCatIds.isNotEmpty) {
      onProgress(
        0.4,
        'Deleting ${deletedCatIds.length} categories from cloud...',
      );
      final response = await _apiService.deleteCategories({
        'ids': deletedCatIds,
      });
      if (response.isSuccessful) {
        onProgress(0.5, 'Purging deleted categories locally...');
        await _localDataSource.hardDeleteCategories(deletedCatIds);
      } else {
        throw Exception(
          'Failed to delete categories from cloud: ${response.error}',
        );
      }
    }

    // ------------------------------------------------------------------
    // Step B: Upload New Data (Cloud Backup)
    // ------------------------------------------------------------------
    onProgress(0.6, 'Scanning unsynced categories...');

    // 1. Sync Categories First
    // if (unsyncedCategories.isNotEmpty) {
    //   final successIds = <String>[];
    //   for (var i = 0; i < unsyncedCategories.length; i++) {
    //     final categoryMap = unsyncedCategories[i];
    //     final id = categoryMap['id'] as String;
    //     final name = categoryMap['name'] as String;
    //
    //     onProgress(
    //       0.6 + (0.15 * (i / unsyncedCategories.length)),
    //       'Uploading category "$name"...',
    //     );
    //
    //     final response = await _apiService.addCategory({
    //       'category_id': id,
    //       'name': name,
    //     });
    //
    //     if (response.isSuccessful) {
    //       successIds.add(id);
    //     } else {
    //       throw Exception('Failed to upload category "$name": ${response.error}');
    //     }
    //   }
    //
    //   if (successIds.isNotEmpty) {
    //     await _localDataSource.markCategoriesAsSynced(successIds);
    //   }
    // }

    onProgress(0.75, 'Scanning unsynced transactions...');

    // 2. Sync Transactions Second
    if (unsyncedTransactions.isNotEmpty) {
      onProgress(
        0.8,
        'Uploading ${unsyncedTransactions.length} transactions to cloud...',
      );

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
        final successIds = unsyncedTransactions
            .map((t) => t['id'] as String)
            .toList();
        onProgress(0.9, 'Finalizing sync status locally...');
        await _localDataSource.markTransactionsAsSynced(successIds);
      } else {
        throw Exception(
          'Failed to upload transactions to cloud: ${response.error}',
        );
      }
    }

    onProgress(1.0, 'Sync completed successfully!');
  }

  @override
  Future<void> restoreDataFromServer() async {
    // 1. Fetch categories
    final categoryResponse = await _apiService.getCategories();
    final categoriesList = <Category>[];
    final categoryNameToId = <String, String>{};

    if (categoryResponse.isSuccessful) {
      final data = categoryResponse.body as Map<String, dynamic>?;
      if (data != null && data['status'] == 'success') {
        final List<dynamic> categories = data['categories'] ?? [];
        for (final cat in categories) {
          final id = (cat['category_id'] ?? cat['id']) as String;
          final name = cat['name'] as String;
          categoriesList.add(Category(id: id, name: name));
          categoryNameToId[name.toLowerCase()] = id;
        }
      }
    } else {
      throw Exception(
        'Failed to restore categories: ${categoryResponse.error}',
      );
    }

    // 2. Fetch transactions
    final transactionResponse = await _apiService.getTransactions();
    final transactionsList = <Map<String, dynamic>>[];

    if (transactionResponse.isSuccessful) {
      final data = transactionResponse.body as Map<String, dynamic>?;
      if (data != null && data['status'] == 'success') {
        final List<dynamic> transactions = data['transactions'] ?? [];
        for (final tx in transactions) {
          final id = tx['id'] as String;
          final amount = (tx['amount'] as num).toDouble();
          final note = tx['note'] as String? ?? '';
          final type = tx['type'] as String;
          final catName = tx['category'] as String?;
          final timestamp =
              tx['timestamp'] as String? ?? DateTime.now().toIso8601String();

          String? categoryId;
          if (catName != null && catName.isNotEmpty) {
            final lowerName = catName.toLowerCase();
            if (categoryNameToId.containsKey(lowerName)) {
              categoryId = categoryNameToId[lowerName];
            } else {
              // Create dynamic category reference so SQL schema integrity is perfectly preserved
              final newId = _localDataSource.generateUuid();
              categoryNameToId[lowerName] = newId;
              categoriesList.add(Category(id: newId, name: catName));
              categoryId = newId;
            }
          }

          transactionsList.add({
            'id': id,
            'amount': amount,
            'note': note,
            'type': type,
            'category_id': categoryId,
            'is_synced': 1,
            'is_deleted': 0,
            'created_at': timestamp,
          });
        }
      }
    } else {
      throw Exception(
        'Failed to restore transactions: ${transactionResponse.error}',
      );
    }

    // 3. Save to local DB
    if (categoriesList.isNotEmpty) {
      await _localDataSource.saveCategories(categoriesList);
    }
    if (transactionsList.isNotEmpty) {
      await _localDataSource.saveTransactions(transactionsList);
    }
  }
}
