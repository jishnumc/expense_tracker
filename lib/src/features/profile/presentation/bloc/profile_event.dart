part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.fetched() = ProfileFetched;
  const factory ProfileEvent.budgetLimitUpdated(double limit) = ProfileBudgetLimitUpdated;
}
