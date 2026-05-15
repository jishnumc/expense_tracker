import 'package:chopper/chopper.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '/auth')
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @POST(path: '/send-otp/')
  Future<Response> sendOtp(@Body() Map<String, dynamic> body);

  @POST(path: '/create-account/')
  Future<Response> createAccount(@Body() Map<String, dynamic> body);
}
