import 'package:get_it/get_it.dart';
import 'package:cat_app/core/network/dio_factory.dart';
import 'package:cat_app/features/home/data/datasources/home_api_service.dart';
import 'package:cat_app/features/home/data/repositories/home_repository.dart';
import 'package:cat_app/features/home/presentation/cubit/home_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // ===== Features =====

  // Home Feature
  // Cubit
  getIt.registerFactory(() => HomeCubit(getIt()));

  // Repository
  getIt.registerLazySingleton(() => HomeRepository(getIt()));

  // Data Sources
  getIt.registerLazySingleton(() => HomeApiService(getIt()));

  // ===== Core =====

  // ===== External =====

  // Dio Factory
  getIt.registerLazySingleton(() => DioFactory().dio);
}
