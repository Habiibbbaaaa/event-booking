import 'package:booking/core/di/app_constants.dart';
import 'package:booking/core/di/local_storage.dart';
import 'package:booking/core/di/service_locator.dart';
import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/login/cubit/login_state.dart';
import 'package:booking/features/login/data/repo/login_repo.dart';
import 'package:booking/features/login/data/repo/login_request_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login(LoginRequestModel loginModel) async {
    emit(LoginLoading());

    final result = await _loginRepo.login(loginModel);
//_registerRepo object from RegisterRepo to call register function
// register fanction is the method in repo

    if (result is Success) {
      emit(LoginSuccess());
      await getIt<LocalStorage>().setString(
        AppConstants.token,
        result.data,
      );
    } else if (result is ApiError) {
      //emit(RegisterError(result.error.));
      final errorModel = (result as ApiError).apiErrorModel;
      emit(LoginError(errorModel.message ?? 'An error occurred'));
////////////////////////
    }
  }
}
