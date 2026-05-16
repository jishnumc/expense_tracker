part of 'transaction_summary_bloc.dart';

@freezed
class TransactionSummaryState with _$TransactionSummaryState {
  const factory TransactionSummaryState.initial() = TransactionSummaryInitial;
  const factory TransactionSummaryState.loading() = TransactionSummaryLoading;
  const factory TransactionSummaryState.success({
    required double totalIncome,
    required double totalExpense,
    required double budgetLimit,
    required List<Transaction> recentTransactions,
  }) = TransactionSummarySuccess;
  const factory TransactionSummaryState.error(String message) = TransactionSummaryError;
}
