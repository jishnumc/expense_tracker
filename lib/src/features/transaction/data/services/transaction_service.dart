import 'package:chopper/chopper.dart';

part 'transaction_service.chopper.dart';

@ChopperApi(baseUrl: '/')
abstract class TransactionService extends ChopperService {
  static TransactionService create([ChopperClient? client]) =>
      _$TransactionService(client);

  @GET(path: 'categories/')
  Future<Response> getCategories();

  @POST(path: 'categories/add/')
  Future<Response> addCategory(@Body() Map<String, dynamic> body);

  @DELETE(path: 'categories/delete/')
  Future<Response> deleteCategories(@Body() Map<String, dynamic> body);

  @POST(path: 'transactions/add/')
  Future<Response> addTransactions(@Body() Map<String, dynamic> body);

  @DELETE(path: 'transactions/delete/')
  Future<Response> deleteTransactions(@Body() Map<String, dynamic> body);
}
