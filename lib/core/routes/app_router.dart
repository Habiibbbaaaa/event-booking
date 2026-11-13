import 'package:booking/core/di/service_locator.dart';
import 'package:booking/core/routes/app_routes.dart';
import 'package:booking/features/event_details/UI/event_details_screen.dart';
import 'package:booking/features/event_details/data/event_details_repo.dart';
import 'package:booking/features/login/UI/widget/login_screen.dart';
import 'package:booking/features/login/cubit/login_cubit.dart';
import 'package:booking/features/login/data/repo/login_repo.dart';
import 'package:booking/features/register/UI/widget/register_screen.dart';
import 'package:booking/features/register/cubit/register_cubit.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking/features/home/UI/home_screen.dart';

import '../../features/event_details/cubit/event_details_cubit.dart';

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

      case AppRoutes.homescreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case AppRoutes.eventDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            // بنجيب الـ EventDetailsRepo من GetIt ونحقنه جوه الـ EventDetailsCubit
            create: (context) => EventDetailsCubit(getIt<EventDetailsRepo>()),
            child: const EventDetailsScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
