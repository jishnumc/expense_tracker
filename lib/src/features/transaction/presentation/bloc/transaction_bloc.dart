import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';
part 'transaction_bloc.freezed.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ITransactionRepository _transactionRepository;

  TransactionBloc({required ITransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(const TransactionState.initial()) {
    on<TransactionCreated>(_onTransactionCreated);
  }

  Future<void> _onTransactionCreated(
    TransactionCreated event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    try {
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: event.amount,
        note: event.note,
        type: event.type,
        categoryId: event.categoryId,
        createdAt: DateTime.now(),
      );
      await _transactionRepository.createTransaction(transaction);
      emit(const TransactionState.success());
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }
}
