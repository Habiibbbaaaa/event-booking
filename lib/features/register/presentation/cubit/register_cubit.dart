import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:booking/features/register/data/repo/register_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel registerModel) async {
    emit(RegisterLoading());

    final result = await _registerRepo.register(registerModel);
    //_registerRepo object from RegisterRepo to call register function
    // register fanction is the method in repo

    if (result is Success) {
      emit(RegisterSuccess());
    } else if (result is ApiError) {
      emit(RegisterError(result.error.toString()));
    }
  }
}
