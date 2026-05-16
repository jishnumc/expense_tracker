import 'package:expense_tracker/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/src/outer_layer/notifications/notification_client.dart';
import 'package:expense_tracker/src/system/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';
part 'transaction_bloc.freezed.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ITransactionRepository _transactionRepository;
  final IProfileRepository _profileRepository;
  final INotificationClient _notificationClient;

  TransactionBloc({
    required ITransactionRepository transactionRepository,
    required IProfileRepository profileRepository,
    required INotificationClient notificationClient,
  }) : _transactionRepository = transactionRepository,
       _profileRepository = profileRepository,
       _notificationClient = notificationClient,
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

      // Budget Alert Logic
      if (event.type == 'debit') {
        final totalExpenses = await _transactionRepository.getTotalExpensesForCurrentMonth();
        final profile = await _profileRepository.getProfile();

        talker.debug(
          'Budget Check: Total Expenses: ₹$totalExpenses, Limit: ₹${profile.budgetLimit}',
        );

        if (profile.budgetLimit > 0 && totalExpenses > profile.budgetLimit) {
          talker.info('Triggering Budget Notification');
          // Fire and forget to avoid hanging transaction save
          unawaited(_notificationClient.showNotification(
            id: DateTime.now().millisecondsSinceEpoch % 100000,
            title: 'Budget Limit Exceeded!',
            body:
                'You have spent ₹${totalExpenses.toStringAsFixed(2)}, which is over your limit of ₹${profile.budgetLimit.toStringAsFixed(2)}.',
          ));
        }
      }

      talker.debug('Transaction Saved Successfully');
      emit(const TransactionState.success());
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }
}
