import 'package:booking/core/networking/api_constants.dart';
import 'package:booking/core/networking/api_error_handler.dart';
import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/login/data/repo/login_request_model.dart';
import 'package:dio/dio.dart';

class LoginRepo {
  final Dio _dio;

  LoginRepo(this._dio);

  Future<ApiResult<dynamic>> login(
    LoginRequestModel loginModel,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: loginModel.toJson(),
      );
      return Success(response.data['token']);
    } on DioException catch (e) {
      return ApiError(ApiErrorHandler.handle(e));
    }
  }
}
