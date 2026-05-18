import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_local_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/data_sources/auth_remote_data_source.dart';
import 'package:expense_tracker/src/features/auth/login/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/src/features/auth/login/data/services/auth_service.dart';
import 'package:expense_tracker/src/features/auth/login/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/outer_layer/clients/api_client.dart';
import 'package:expense_tracker/src/outer_layer/clients/storage_client.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/phone_validator.dart';
import 'package:expense_tracker/src/outer_layer/database/database_client.dart';
import 'package:expense_tracker/src/features/transaction/data/data_sources/category_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:expense_tracker/src/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/bloc.dart';
import 'package:expense_tracker/src/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:expense_tracker/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:expense_tracker/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/src/outer_layer/notifications/notification_client.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/amount_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/src/features/transaction/data/services/transaction_service.dart';
import 'package:expense_tracker/src/features/profile/domain/repositories/sync_repository.dart';
import 'package:expense_tracker/src/features/profile/data/repositories/sync_repository_impl.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/cloud_sync_bloc.dart';

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
  sl.registerLazySingleton(() => DatabaseClient());
  sl.registerLazySingleton<INotificationClient>(() => NotificationClient());

  // Services
  sl.registerLazySingleton(() => sl<ApiClient>().getService<AuthService>());
  sl.registerLazySingleton(
    () => sl<ApiClient>().getService<TransactionService>(),
  );

  // Data Sources (Remote)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Data Sources (Local)
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      dbClient: sl(),
    ),
  );
  sl.registerLazySingleton<ITransactionRepository>(
    () => TransactionRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ISyncRepository>(
    () => SyncRepositoryImpl(sl(), sl(), sl()),
  );

  // Validators
  sl.registerLazySingleton(() => PhoneValidator());
  sl.registerLazySingleton(() => const AmountValidator());

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      authRepository: sl(),
      phoneValidator: sl(),
      syncRepository: sl(),
    ),
  );
  sl.registerFactory(() => CategoryBloc(transactionRepository: sl()));
  sl.registerFactory(() => ProfileBloc(profileRepository: sl()));
  sl.registerFactory(
    () => TransactionBloc(
      transactionRepository: sl(),
      profileRepository: sl(),
      notificationClient: sl(),
    ),
  );
  sl.registerFactory(() => TransactionListBloc(transactionRepository: sl()));
  sl.registerFactory(
    () => TransactionSummaryBloc(
      transactionRepository: sl(),
      profileRepository: sl(),
    ),
  );
  sl.registerFactory(() => CloudSyncBloc(syncRepository: sl()));
}
