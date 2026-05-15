import 'package:expense_tracker/src/outer_layer/validation/errors/validation_error.dart';
import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';
import 'package:expense_tracker/src/outer_layer/validation/validator.dart';

final class OtpValidator implements Validator<String> {
  @override
  ValidationResult validate(String value) {
    if (value.isEmpty) {
      return ValidationFailure(const EmptyFieldError());
    }

    if (value.length != 6) {
      return ValidationFailure(const InvalidOtpError());
    }

    return const ValidationSuccess();
  }
}
