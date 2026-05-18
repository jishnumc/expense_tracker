part of 'transaction_summary_bloc.dart';

@freezed
class TransactionSummaryEvent with _$TransactionSummaryEvent {
  const factory TransactionSummaryEvent.fetched() = TransactionSummaryFetched;
  const factory TransactionSummaryEvent.deleted(String id) =
      TransactionSummaryDeleted;
}
