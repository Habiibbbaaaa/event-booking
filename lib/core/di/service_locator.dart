import 'package:booking/core/di/local_storage.dart';
import 'package:booking/core/networking/dio_factory.dart';
import 'package:booking/features/event_details/data/event_details_repo.dart';
import 'package:booking/features/login/data/repo/login_repo.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  //  Dio object
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.getDio(),
  );

  //  registerRepo object
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepo(getIt<Dio>()),
  );

  //loginrepo object
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<Dio>()));

  // LocalStorage object
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorage(),
  );

  // EventDetailsRepo object
getIt.registerLazySingleton<EventDetailsRepo>(
  () => EventDetailsRepo(getIt<Dio>()),
);
}

// void setupLocalStorage() {
//   //FlutterSecureStorage object
//   //عشان هي dependency للlocal storage
//   // getIt.registerLazySingleton<FlutterSecureStorage>(
//   //   () => const FlutterSecureStorage(),
//   // );

//   // localstorage object
//   getIt.registerLazySingleton<LocalStorage>(
//     () => LocalStorage(),
//   );
// }
