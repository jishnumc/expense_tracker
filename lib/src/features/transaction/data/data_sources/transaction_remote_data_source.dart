import 'package:expense_tracker/src/features/transaction/data/models/category_response_dto.dart';
import 'package:expense_tracker/src/features/transaction/data/services/transaction_service.dart';

abstract interface class TransactionRemoteDataSource {
  Future<CategoryResponseDto> getCategories();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final TransactionService _service;

  TransactionRemoteDataSourceImpl(this._service);

  @override
  Future<CategoryResponseDto> getCategories() async {
    final response = await _service.getCategories();
    if (response.isSuccessful && response.body != null) {
      return CategoryResponseDto.fromJson(response.body);
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
