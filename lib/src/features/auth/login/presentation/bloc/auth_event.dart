part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.sendOtpRequested(String phone) = AuthSendOtpRequested;
  
  const factory AuthEvent.verifyOtpRequested({
    required String phone,
    required String otp,
    required bool userExists,
    String? nickname,
    String? token,
  }) = AuthVerifyOtpRequested;

  const factory AuthEvent.registerRequested({
    required String phone,
    required String nickname,
  }) = AuthRegisterRequested;

  const factory AuthEvent.checkStatusRequested() = AuthCheckStatusRequested;
  
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
}
