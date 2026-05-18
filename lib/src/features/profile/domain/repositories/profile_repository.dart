import '../entities/profile.dart';

abstract interface class IProfileRepository {
  Future<Profile> getProfile();
  Future<void> updateBudgetLimit(double limit);
  Future<void> updateNickname(String name);
}
