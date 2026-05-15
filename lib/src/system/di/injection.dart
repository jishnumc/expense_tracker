import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_local_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/src/features/auth/login/data/services/auth_service.dart';
import 'package:expense_tracker/src/features/auth/login/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/outer_layer/clients/api_client.dart';
import 'package:expense_tracker/src/outer_layer/clients/storage_client.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/phone_validator.dart';
import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_remote_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/src/features/transaction/data/services/transaction_service.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/category_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Storage
  sl.registerLazySingleton(() => StorageClient(plugin: sl()));

  // Data Sources (Local first)
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  // Clients
  sl.registerLazySingleton(() => ApiClient(authLocalDataSource: sl()));

  // Services
  sl.registerLazySingleton(() => sl<ApiClient>().getService<AuthService>());
  sl.registerLazySingleton(
    () => sl<ApiClient>().getService<TransactionService>(),
  );

  // Data Sources (Remote)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ITransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  // Validators
  sl.registerLazySingleton(() => PhoneValidator());

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      phoneValidator: sl(),
    ),
  );
  sl.registerFactory(() => CategoryBloc(transactionRepository: sl()));
}
