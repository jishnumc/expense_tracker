import '../errors/validation_error.dart';
import '../validation_result.dart';
import '../validator.dart';

final class AmountValidator implements Validator<String> {
  const AmountValidator();

  @override
  ValidationResult validate(String value) {
    if (value.trim().isEmpty) {
      return const ValidationFailure(EmptyFieldError());
    }

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return const ValidationFailure(InvalidAmountError());
    }

    return const ValidationSuccess();
  }
}
