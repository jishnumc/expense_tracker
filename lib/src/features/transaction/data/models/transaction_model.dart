import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.amount,
    required super.note,
    required super.type,
    required super.categoryId,
    super.categoryName,
    super.isSynced,
    super.isDeleted,
    required super.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      type: map['type'] as String,
      categoryId: map['category_id'] as String,
      categoryName: map['category_name'] as String?,
      isSynced: map['is_synced'] as int,
      isDeleted: map['is_deleted'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'type': type,
      'category_id': categoryId,
      'is_synced': isSynced,
      'is_deleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
