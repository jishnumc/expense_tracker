import 'package:chopper/chopper.dart';
import 'package:expense_tracker/src/features/auth/login/data/services/auth_service.dart';
import 'package:expense_tracker/src/outer_layer/network/json_response_converter.dart';
import 'package:expense_tracker/src/system/environment.dart';
import 'package:expense_tracker/src/system/utils/logger.dart';
import 'package:talker_chopper_logger/talker_chopper_logger.dart';

class ApiClient {
  ApiClient({String? baseUrl})
    : _client = ChopperClient(
        baseUrl: Uri.parse(Environment.baseUrl),
        services: [AuthService.create()],
        converter: const JsonResponseConverter(),
        interceptors: [TalkerChopperLogger(talker: talker)],
      );

  final ChopperClient _client;

  T getService<T extends ChopperService>() => _client.getService<T>();
}
