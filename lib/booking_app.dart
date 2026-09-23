// import 'package:booking/core/routes/app_router.dart';
// import 'package:booking/core/routes/app_routes.dart';
// import 'package:flutter/material.dart';

// class BookingApp extends StatelessWidget {
//   const BookingApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: AppRoutes.registerscreen,
//       onGenerateRoute: AppRouter.onGenerateRoutes,
//     );
//   }
// }
import 'package:booking/core/di/service_locator.dart';
import 'package:booking/features/register/data/repo/register_repo.dart';
import 'package:booking/features/register/presentation/UI/widget/register_screen.dart';
import 'package:booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => RegisterCubit(
          getIt<RegisterRepo>(),
        ),
        child: const RegisterScreen(),
      ),
    );
  }
}
