part of 'transaction_list_bloc.dart';

@freezed
class TransactionListEvent with _$TransactionListEvent {
  const factory TransactionListEvent.fetched() = TransactionListFetched;
  const factory TransactionListEvent.deleted(String id) = TransactionListDeleted;
}
