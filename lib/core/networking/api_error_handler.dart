import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            status: 0,
            message: 'Connection timeout',
          );

        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            status: 0,
            message: 'Send timeout',
          );

        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            status: 0,
            message: 'Receive timeout',
          );

        case DioExceptionType.connectionError:
          return ApiErrorModel(
            status: 0,
            message: 'No internet connection',
          );

        case DioExceptionType.badResponse:
          return _handleBadResponse(error);

        case DioExceptionType.cancel:
          return ApiErrorModel(
            status: 0,
            message: 'Request cancelled',
          );

        case DioExceptionType.badCertificate:
          return ApiErrorModel(
            status: 0,
            message: 'Bad certificate',
          );

        case DioExceptionType.unknown:
          return ApiErrorModel(
            status: 0,
            message: 'Something went wrong',
          );

        case DioExceptionType.transformTimeout:
          return ApiErrorModel(
            status: 0,
            message: 'Transform timeout',
          );
      }
    }

    return ApiErrorModel(
      status: 0,
      message: 'Unknown error',
    );
  }

  static ApiErrorModel _handleBadResponse(DioException error) {
    if (error.response?.data is Map<String, dynamic>) {
      return ApiErrorModel.fromJson(
        error.response!.data,
      );
    }

    return ApiErrorModel(
      status: error.response?.statusCode,
      message: error.response?.statusMessage,
    );
  }
}
