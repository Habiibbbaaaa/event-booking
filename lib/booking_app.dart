import 'package:booking/core/routes/app_router.dart';
import 'package:booking/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.registerscreen,
      onGenerateRoute: AppRouter.onGenerateRoutes,
    );
  }
}
