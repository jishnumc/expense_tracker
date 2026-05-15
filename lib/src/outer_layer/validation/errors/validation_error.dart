sealed class ValidationError {
  const ValidationError();

  String get message;
}

final class EmptyFieldError extends ValidationError {
  const EmptyFieldError();

  @override
  String get message => 'Field cannot be empty';
}

final class InvalidPhoneError extends ValidationError {
  const InvalidPhoneError();

  @override
  String get message => 'Invalid phone number';
}

final class InvalidOtpError extends ValidationError {
  const InvalidOtpError();

  @override
  String get message => 'Invalid OTP';
}

final class InvalidLengthError extends ValidationError {
  const InvalidLengthError();

  @override
  String get message => 'Invalid length';
}
