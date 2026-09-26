import 'package:booking/core/di/service_locator.dart';
import 'package:booking/core/routes/app_routes.dart';
import 'package:booking/features/login/UI/widget/login_screen.dart';
import 'package:booking/features/login/cubit/login_cubit.dart';
import 'package:booking/features/login/data/repo/login_repo.dart';
import 'package:booking/features/register/UI/widget/register_screen.dart';
import 'package:booking/features/register/cubit/register_cubit.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registerscreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(getIt<RegisterRepo>()),
            child: const RegisterScreen(),
          ),
        );

      case AppRoutes.loginscreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(getIt<LoginRepo>()),
            child: const LoginScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
