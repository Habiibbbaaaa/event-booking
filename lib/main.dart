import 'package:booking/booking_app.dart';
import 'package:booking/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://abivxrzvdszisfibzlxf.supabase.co',
    publishableKey: 'sb_publishable_tHLQG7LIyBZaRKiwPDL9lg_AS41HEYI',
  );

  setupGetIt();
  runApp(const BookingApp());
}
