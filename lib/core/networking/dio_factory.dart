import 'package:booking/core/networking/api_constants.dart';
import 'package:booking/core/networking/interceptor/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static late Dio _dio; // Private على مستوى الكلاس

  static Dio getDio() {
    const duration = Duration(seconds: 30);

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'apikey': ApiConstants.publishableKey,
          'Content-Type': 'application/json',
        },
        receiveTimeout: duration,
        connectTimeout: duration,
        sendTimeout: duration,
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );

    // add interceptor to the requests
    _dio.interceptors.add(AuthInterceptor());
    print('CURRENT BASE URL: ${_dio.options.baseUrl}');
    return _dio;
  }
}
