import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ITransactionRepository _transactionRepository;

  CategoryBloc({required ITransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(const CategoryState.initial()) {
    on<CategoryFetched>(_onCategoryFetched);
    on<CategoryCreated>(_onCategoryCreated);
    on<CategoryDeleted>(_onCategoryDeleted);
  }

  Future<void> _onCategoryDeleted(
    CategoryDeleted event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await _transactionRepository.deleteCategory(event.id);
      add(const CategoryEvent.fetched());
    } catch (e) {
      emit(CategoryState.error(e.toString()));
      add(const CategoryEvent.fetched());
    }
  }

  Future<void> _onCategoryCreated(
    CategoryCreated event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await _transactionRepository.createCategory(event.name);
      add(const CategoryEvent.fetched());
    } catch (e) {
      emit(CategoryState.error(e.toString()));
      add(const CategoryEvent.fetched());
    }
  }

  Future<void> _onCategoryFetched(
    CategoryFetched event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    try {
      final categories = await _transactionRepository.getCategories();
      emit(CategoryState.success(categories));
    } catch (e) {
      emit(CategoryState.error(e.toString()));
    }
  }
}
