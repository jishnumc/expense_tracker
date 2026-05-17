import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../data/repositories/sync_repository_impl.dart';

sealed class CloudSyncEvent {
  const CloudSyncEvent();
}

class SyncTriggered extends CloudSyncEvent {
  const SyncTriggered();
}

sealed class CloudSyncState {
  const CloudSyncState();
}

class CloudSyncInitial extends CloudSyncState {
  const CloudSyncInitial();
}

class CloudSyncProgress extends CloudSyncState {
  final double progress;
  final String message;

  const CloudSyncProgress({required this.progress, required this.message});
}

class CloudSyncSuccess extends CloudSyncState {
  const CloudSyncSuccess();
}

class CloudSyncNoDataToSync extends CloudSyncState {
  const CloudSyncNoDataToSync();
}

class CloudSyncAlreadySynced extends CloudSyncState {
  const CloudSyncAlreadySynced();
}

class CloudSyncFailure extends CloudSyncState {
  final String error;

  const CloudSyncFailure(this.error);
}

class CloudSyncBloc extends Bloc<CloudSyncEvent, CloudSyncState> {
  final ISyncRepository _syncRepository;

  CloudSyncBloc({required ISyncRepository syncRepository})
      : _syncRepository = syncRepository,
        super(const CloudSyncInitial()) {
    on<SyncTriggered>(_onSyncTriggered);
  }

  Future<void> _onSyncTriggered(
    SyncTriggered event,
    Emitter<CloudSyncState> emit,
  ) async {
    emit(const CloudSyncProgress(progress: 0.0, message: 'Initializing sync...'));
    try {
      await _syncRepository.syncData(
        onProgress: (progress, message) {
          emit(CloudSyncProgress(progress: progress, message: message));
        },
      );
      emit(const CloudSyncSuccess());
    } on FreshDatabaseException {
      emit(const CloudSyncNoDataToSync());
    } on AlreadySyncedException {
      emit(const CloudSyncAlreadySynced());
    } catch (e) {
      emit(CloudSyncFailure(e.toString()));
    }
  }
}
