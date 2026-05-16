part of 'transaction_bloc.dart';

@freezed
abstract class TransactionEvent with _$TransactionEvent {
  const factory TransactionEvent.created({
    required double amount,
    required String note,
    required String type,
    required String categoryId,
  }) = TransactionCreated;
}
