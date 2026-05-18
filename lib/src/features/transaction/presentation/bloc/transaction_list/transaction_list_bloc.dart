import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_list_event.dart';
part 'transaction_list_state.dart';
part 'transaction_list_bloc.freezed.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  final ITransactionRepository _transactionRepository;

  TransactionListBloc({
    required ITransactionRepository transactionRepository,
  }) : _transactionRepository = transactionRepository,
       super(const TransactionListState.initial()) {
    on<TransactionListFetched>(_onFetched);
    on<TransactionListDeleted>(_onDeleted);
  }

  Future<void> _onFetched(
    TransactionListFetched event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(const TransactionListState.loading());
    try {
      final transactions = await _transactionRepository.getAllTransactions();
      emit(TransactionListState.success(transactions: transactions));
    } catch (e) {
      emit(TransactionListState.error(e.toString()));
    }
  }

  Future<void> _onDeleted(
    TransactionListDeleted event,
    Emitter<TransactionListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionListSuccess) {
      final updatedTransactions = currentState.transactions
          .where((t) => t.id != event.id)
          .toList();

      emit(TransactionListSuccess(transactions: updatedTransactions));

      try {
        await _transactionRepository.deleteTransaction(event.id);
        add(const TransactionListEvent.fetched());
      } catch (e) {
        add(const TransactionListEvent.fetched());
      }
    }
  }
}
