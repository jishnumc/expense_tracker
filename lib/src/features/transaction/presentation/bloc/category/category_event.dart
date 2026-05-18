part of 'category_bloc.dart';

@freezed
class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.fetched() = CategoryFetched;
  const factory CategoryEvent.created(String name) = CategoryCreated;
  const factory CategoryEvent.deleted(String id) = CategoryDeleted;
}
