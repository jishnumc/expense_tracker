import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_local_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/src/features/auth/login/data/services/auth_service.dart';
import 'package:expense_tracker/src/features/auth/login/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/outer_layer/clients/api_client.dart';
import 'package:expense_tracker/src/outer_layer/clients/storage_client.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Clients
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => StorageClient(plugin: sl()));

  // Services
  sl.registerLazySingleton(() => sl<ApiClient>().getService<AuthService>());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
