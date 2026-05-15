import 'package:chopper/chopper.dart';

part 'transaction_service.chopper.dart';

@ChopperApi(baseUrl: '/')
abstract class TransactionService extends ChopperService {
  static TransactionService create([ChopperClient? client]) =>
      _$TransactionService(client);

  @GET(path: 'categories/')
  Future<Response> getCategories();
}
