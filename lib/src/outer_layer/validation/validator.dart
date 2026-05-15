import 'validation_result.dart';

abstract interface class Validator<T> {
  ValidationResult validate(T value);
}
