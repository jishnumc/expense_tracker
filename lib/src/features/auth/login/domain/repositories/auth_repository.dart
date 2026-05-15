import 'package:expense_tracker/src/features/auth/login/data/models/auth_response_dto.dart';
import 'package:expense_tracker/src/features/auth/login/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<AuthResponseDto> sendOtp(String phone);
  Future<User> createAccount(String phone, String nickname);
  Future<void> saveUser(User user);
  Future<User?> getSavedUser();
  Future<void> logout();
}
