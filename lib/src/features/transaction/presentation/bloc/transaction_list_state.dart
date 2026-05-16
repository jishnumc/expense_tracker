part of 'transaction_list_bloc.dart';

@freezed
class TransactionListState with _$TransactionListState {
  const factory TransactionListState.initial() = TransactionListInitial;
  const factory TransactionListState.loading() = TransactionListLoading;
  const factory TransactionListState.success({
    required List<Transaction> transactions,
  }) = TransactionListSuccess;
  const factory TransactionListState.error(String message) = TransactionListError;
}
