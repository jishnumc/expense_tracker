class Transaction {
  final String id;
  final double amount;
  final String note;
  final String type; // 'credit' or 'debit'
  final String categoryId;
  final int isSynced;
  final int isDeleted;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryId,
    this.isSynced = 0,
    this.isDeleted = 0,
    required this.createdAt,
  });
}
