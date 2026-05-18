import 'package:expense_tracker/src/features/profile/domain/entities/profile.dart';
import 'package:expense_tracker/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository _profileRepository;

  ProfileBloc({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileState.initial()) {
    on<ProfileFetched>(_onProfileFetched);
    on<ProfileBudgetLimitUpdated>(_onBudgetLimitUpdated);
    on<ProfileNicknameUpdated>(_onNicknameUpdated);
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    try {
      final profile = await _profileRepository.getProfile();
      emit(ProfileState.success(profile));
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }

  Future<void> _onBudgetLimitUpdated(
    ProfileBudgetLimitUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.updateBudgetLimit(event.limit);
      add(const ProfileEvent.fetched());
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }

  Future<void> _onNicknameUpdated(
    ProfileNicknameUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.updateNickname(event.name);
      add(const ProfileEvent.fetched());
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }
}
