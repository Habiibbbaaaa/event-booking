import 'package:booking/core/di/service_locator.dart';
import 'package:booking/core/routes/app_routes.dart';
import 'package:booking/features/register/presentation/UI/widget/register_screen.dart';
import 'package:booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registerscreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => RegisterCubit(getIt()),
                  child: RegisterScreen(),
                ));
    }
  }
}
