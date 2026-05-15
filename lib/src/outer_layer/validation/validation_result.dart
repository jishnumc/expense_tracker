import 'errors/validation_error.dart';

sealed class ValidationResult {
  const ValidationResult();
}

final class ValidationSuccess extends ValidationResult {
  const ValidationSuccess();
}

final class ValidationFailure extends ValidationResult {
  final ValidationError error;

  const ValidationFailure(this.error);
}
