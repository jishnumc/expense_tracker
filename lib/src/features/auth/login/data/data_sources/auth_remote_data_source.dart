import 'package:expense_tracker/src/features/auth/login/data/models/auth_response_dto.dart';
import 'package:expense_tracker/src/features/auth/login/data/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> sendOtp(String phone);
  Future<AuthResponseDto> createAccount(String phone, String nickname);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSourceImpl(this._authService);

  String _formatPhone(String phone) {
    if (phone.startsWith('+')) return phone;
    return '+91$phone';
  }

  @override
  Future<AuthResponseDto> sendOtp(String phone) async {
    final response = await _authService.sendOtp({'phone': _formatPhone(phone)});
    if (response.isSuccessful && response.body != null) {
      return AuthResponseDto.fromJson(response.body);
    } else {
      throw Exception('Failed to send OTP: ${response.error}');
    }
  }

  @override
  Future<AuthResponseDto> createAccount(String phone, String nickname) async {
    final response = await _authService.createAccount({
      'phone': _formatPhone(phone),
      'nickname': nickname,
    });
    if (response.isSuccessful && response.body != null) {
      return AuthResponseDto.fromJson(response.body);
    } else {
      throw Exception('Failed to create account: ${response.error}');
    }
  }
}
