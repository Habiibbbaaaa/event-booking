import 'package:booking/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static late Dio _dio;

  static Dio getDio() {
    Duration duration = Duration(seconds: 30);
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveTimeout: duration,
      connectTimeout: duration,
      sendTimeout: duration,
      // headers:{
      //   ''
      // }
    ));

    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
        ///////////
        enabled: kDebugMode));
    return _dio;
  }
}
