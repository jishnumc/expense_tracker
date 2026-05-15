import 'package:expense_tracker/src/outer_layer/clients/storage_client.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> saveNickname(String nickname);
  String? getNickname();
  Future<void> savePhone(String phone);
  String? getPhone();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageClient _storageClient;

  AuthLocalDataSourceImpl(this._storageClient);

  static const String _tokenKey = 'auth_token';
  static const String _nicknameKey = 'user_nickname';
  static const String _phoneKey = 'user_phone';

  @override
  Future<void> saveToken(String token) => _storageClient.save(_tokenKey, token);

  @override
  String? getToken() => _storageClient.read<String>(_tokenKey);

  @override
  Future<void> saveNickname(String nickname) => _storageClient.save(_nicknameKey, nickname);

  @override
  String? getNickname() => _storageClient.read<String>(_nicknameKey);

  @override
  Future<void> savePhone(String phone) => _storageClient.save(_phoneKey, phone);

  @override
  String? getPhone() => _storageClient.read<String>(_phoneKey);

  @override
  Future<void> clearAuthData() async {
    await _storageClient.delete(_tokenKey);
    await _storageClient.delete(_nicknameKey);
    await _storageClient.delete(_phoneKey);
  }
}
