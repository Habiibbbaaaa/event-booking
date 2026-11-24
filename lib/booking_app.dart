import 'package:booking/core/routes/app_router.dart';
import 'package:booking/core/routes/app_routes.dart';
import 'package:booking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.homescreen, //  خليناها تبدأ بشاشة الـ Login
      onGenerateRoute: AppRouter.onGenerateRoutes,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
