import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';

part 'category_response_dto.freezed.dart';
part 'category_response_dto.g.dart';

@freezed
abstract class CategoryResponseDto with _$CategoryResponseDto {
  const factory CategoryResponseDto({
    String? status,
    List<CategoryDto>? categories,
  }) = _CategoryResponseDto;

  factory CategoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseDtoFromJson(json);
}

@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({String? id, String? name}) =
      _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

extension CategoryDtoX on CategoryDto {
  Category toEntity() => Category(
        id: id ?? '',
        name: name ?? '',
      );
}
