import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_remote_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/models/category_response_dto.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final dto = await _remoteDataSource.getCategories();
    return dto.categories?.map((c) => c.toEntity()).toList() ?? [];
  }
}
