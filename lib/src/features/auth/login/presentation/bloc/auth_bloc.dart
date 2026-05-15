import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_tracker/src/features/auth/login/domain/entities/user.dart';
import 'package:expense_tracker/src/features/auth/login/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState.initial()) {
    on<AuthSendOtpRequested>(_onSendOtpRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSendOtpRequested(
    AuthSendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final response = await _authRepository.sendOtp(event.phone);
      emit(
        AuthState.otpSent(
          phone: event.phone,
          otp: response.otp ?? '',
          userExists: response.userExists ?? false,
          nickname: response.nickname,
          token: response.token,
        ),
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    // In this flow, Step 2 is user enters OTP.
    // If userExists == true, we already have nickname and token from sendOtp.
    // If userExists == false, we need to go to register screen.

    if (event.userExists) {
      if (event.token != null && event.nickname != null) {
        final user = User(
          nickname: event.nickname!,
          token: event.token!,
          phone: event.phone,
        );
        await _authRepository.saveUser(user);
        emit(AuthState.authenticated(user));
      } else {
        emit(
          const AuthState.error('Missing token or nickname for existing user'),
        );
      }
    } else {
      emit(AuthState.nicknameRequired(phone: event.phone));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.createAccount(
        event.phone,
        event.nickname,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.getSavedUser();
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.initial());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState.initial());
  }
}
