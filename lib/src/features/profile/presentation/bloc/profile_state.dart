part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.success(Profile profile) = ProfileSuccess;
  const factory ProfileState.error(String message) = ProfileError;
}
