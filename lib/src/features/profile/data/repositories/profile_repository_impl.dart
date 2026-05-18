import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._localDataSource);

  @override
  Future<Profile> getProfile() {
    return _localDataSource.getProfile();
  }

  @override
  Future<void> updateBudgetLimit(double limit) {
    return _localDataSource.updateBudgetLimit(limit);
  }

  @override
  Future<void> updateNickname(String name) {
    return _localDataSource.updateNickname(name);
  }
}
