import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_local_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/models/auth_response_dto.dart';
import 'package:expense_tracker/src/features/auth/login/domain/entities/user.dart';
import 'package:expense_tracker/src/features/auth/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<AuthResponseDto> sendOtp(String phone) {
    return _remoteDataSource.sendOtp(phone);
  }

  @override
  Future<User> createAccount(String phone, String nickname) async {
    final dto = await _remoteDataSource.createAccount(phone, nickname);
    final user = User(
      nickname: dto.nickname ?? nickname,
      token: dto.token ?? '',
      phone: phone,
    );
    await saveUser(user);
    return user;
  }

  @override
  Future<void> saveUser(User user) async {
    await _localDataSource.saveToken(user.token);
    await _localDataSource.saveNickname(user.nickname);
    await _localDataSource.savePhone(user.phone);
  }

  @override
  Future<User?> getSavedUser() async {
    final token = _localDataSource.getToken();
    final nickname = _localDataSource.getNickname();
    final phone = _localDataSource.getPhone();

    if (token != null && nickname != null && phone != null) {
      return User(nickname: nickname, token: token, phone: phone);
    }
    return null;
  }

  @override
  Future<void> logout() {
    return _localDataSource.clearAuthData();
  }
}
