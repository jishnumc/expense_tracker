import '../errors/validation_error.dart';
import '../validation_result.dart';
import '../validator.dart';

final class PhoneValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.trim().isEmpty) {
      return ValidationFailure(const EmptyFieldError());
    }

    if (value.length < 10) {
      return ValidationFailure(const InvalidPhoneError());
    }

    return const ValidationSuccess();
  }
}
