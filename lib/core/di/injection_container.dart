import 'package:get_it/get_it.dart';
import 'package:cat_app/core/network/dio_factory.dart';

final sl = GetIt.instance; // sl is short for service locator

Future<void> init() async {
  // ===== Features =====

  // Home Feature


  // ===== Core =====


  // ===== External =====

  // Dio Factory
  sl.registerLazySingleton(() => DioFactory().dio);
}
