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
