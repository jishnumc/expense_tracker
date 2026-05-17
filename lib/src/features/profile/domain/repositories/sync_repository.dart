abstract interface class ISyncRepository {
  Future<void> syncData({
    required void Function(double progress, String message) onProgress,
  });
  Future<void> restoreDataFromServer();
}
