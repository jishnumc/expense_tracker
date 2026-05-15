import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_local_data_source.dart';

class AuthInterceptor implements Interceptor {
  final AuthLocalDataSource _authLocalDataSource;

  AuthInterceptor(this._authLocalDataSource);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final token = _authLocalDataSource.getToken();
    final request = chain.request;

    if (token != null && token.isNotEmpty) {
      final updatedRequest = applyHeader(request, 'Authorization', 'Bearer $token');
      return chain.proceed(updatedRequest);
    }

    return chain.proceed(request);
  }
}
