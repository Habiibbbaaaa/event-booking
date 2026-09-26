import 'package:booking/core/networking/api_error_model.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class ApiError<T> extends ApiResult<T> {
  final ApiErrorModel apiErrorModel; // ✅ تحديد كائن الإيرور بوضوح بدلاً من T
  const ApiError(this.apiErrorModel);
}
