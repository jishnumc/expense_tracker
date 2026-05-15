part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.otpSent({
    required String phone,
    required String otp,
    required bool userExists,
    String? nickname,
    String? token,
  }) = AuthOtpSent;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.nicknameRequired({required String phone}) = AuthNicknameRequired;
  const factory AuthState.error(String message) = AuthError;
}
