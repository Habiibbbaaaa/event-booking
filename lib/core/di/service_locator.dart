import 'package:booking/core/networking/dio_factory.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Register Dio
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.getDio(),
  );

  // Register Repository
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(getIt<Dio>()),
  );
}
