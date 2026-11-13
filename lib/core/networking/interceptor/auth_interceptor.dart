import 'package:booking/core/di/app_constants.dart';
import 'package:booking/core/di/local_storage.dart';
import 'package:booking/core/di/service_locator.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getIt<LocalStorage>().getString(
      AppConstants.token,
    );

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    print('Request: ${options.path}');
    print('Authorization header: ${options.headers['Authorization']}');

    handler.next(options);
    //بيكمل الريكويست بعد ما يحط ال توكن
    // لو مفيش اصلا توكن ودي اول مرا بيكمل الريكويست برضو من غير ما يضيف حاجه
  }
}
