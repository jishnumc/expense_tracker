import '../errors/validation_error.dart';
import '../validation_result.dart';
import '../validator.dart';

final class CategoryValidator implements Validator<String> {
  final List<String> existingNames;

  const CategoryValidator(this.existingNames);

  @override
  ValidationResult validate(String value) {
    final name = value.trim();
    if (name.isEmpty) {
      return const ValidationFailure(EmptyFieldError());
    }

    final exists = existingNames.any(
      (existing) => existing.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      return const ValidationFailure(DuplicateCategoryError());
    }

    return const ValidationSuccess();
  }
}
