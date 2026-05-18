import 'package:expense_tracker/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_summary_event.dart';
part 'transaction_summary_state.dart';
part 'transaction_summary_bloc.freezed.dart';

class TransactionSummaryBloc
    extends Bloc<TransactionSummaryEvent, TransactionSummaryState> {
  final ITransactionRepository _transactionRepository;
  final IProfileRepository _profileRepository;

  TransactionSummaryBloc({
    required ITransactionRepository transactionRepository,
    required IProfileRepository profileRepository,
  }) : _transactionRepository = transactionRepository,
       _profileRepository = profileRepository,
       super(const TransactionSummaryState.initial()) {
    on<TransactionSummaryFetched>(_onFetched);
    on<TransactionSummaryDeleted>(_onDeleted);
  }

  Future<void> _onDeleted(
    TransactionSummaryDeleted event,
    Emitter<TransactionSummaryState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionSummarySuccess) {
      // Immediate UI update: Filter out the deleted transaction
      final updatedTransactions = currentState.recentTransactions
          .where((t) => t.id != event.id)
          .toList();

      emit(currentState.copyWith(recentTransactions: updatedTransactions));

      try {
        await _transactionRepository.deleteTransaction(event.id);
        // Refresh to update totals
        add(const TransactionSummaryEvent.fetched());
      } catch (e) {
        // Refresh to restore state on error
        add(const TransactionSummaryEvent.fetched());
      }
    }
  }

  Future<void> _onFetched(
    TransactionSummaryFetched event,
    Emitter<TransactionSummaryState> emit,
  ) async {
    emit(const TransactionSummaryState.loading());
    try {
      final results = await Future.wait([
        _transactionRepository.getTotalIncomeForCurrentMonth(),
        _transactionRepository.getTotalExpensesForCurrentMonth(),
        _profileRepository.getProfile().then((p) => p.budgetLimit),
        _transactionRepository.getRecentTransactions(limit: 10),
      ]);

      emit(
        TransactionSummaryState.success(
          totalIncome: results[0] as double,
          totalExpense: results[1] as double,
          budgetLimit: results[2] as double,
          recentTransactions: results[3] as List<Transaction>,
        ),
      );
    } catch (e) {
      emit(TransactionSummaryState.error(e.toString()));
    }
  }
}
