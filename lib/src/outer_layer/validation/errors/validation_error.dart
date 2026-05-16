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

final class DuplicateCategoryError extends ValidationError {
  const DuplicateCategoryError();

  @override
  String get message => 'Category already exists';
}

final class InvalidAmountError extends ValidationError {
  const InvalidAmountError();

  @override
  String get message => 'Please enter a valid amount greater than 0';
}
