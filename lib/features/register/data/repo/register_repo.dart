import 'package:booking/core/networking/api_constants.dart';
import 'package:booking/core/networking/api_error_handler.dart';
import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/register/data/repo/register_request_model.dart';
import 'package:dio/dio.dart';

class RegisterRepo {
  final Dio _dio;

  RegisterRepo(this._dio);

  Future<ApiResult<dynamic>> register(
    RegisterRequestModel registerModel,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: registerModel.toJson(),
      );

      return Success(response.data);
    } on DioException catch (e) {
      return ApiError(ApiErrorHandler.handle(e));
    }
  }
}
