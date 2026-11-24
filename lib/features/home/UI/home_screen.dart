import 'package:booking/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _darkBg = Color(0xFF0E1413);
  static const Color _emeraldPrimary = Color(0xFF1E6F68);
  static const Color _emeraldGlow = Color(0xFF2EC4B6);
  static const Color _textLight = Color(0xFFF3F6F5);
  static const Color _textMuted = Color(0xFF9BA8A5);

  // غيّري اسم الصورة هنا لو اسم ملفك جوه assets/images/ مختلف
  static const String _heroImageAsset = 'assets/images/de.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header غامق بسيط
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Evently.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      color: _textLight,
                    ),
                  ),
                  Text(
                    'Smart Venue Booking',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // صورة محلية مودرن مدمجة مع الخلفية الغامقة
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _heroImageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF16201E),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.meeting_room_outlined,
                              size: 56,
                              color: _emeraldGlow,
                            ),
                          );
                        },
                      ),
                      // تدرج غامق يدمج الصورة مع الخلفية
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _darkBg.withOpacity(0.15),
                              _darkBg.withOpacity(0.75),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // عنوان واضح ومباشر على خلفية غامقة
              const Text(
                'Book the right space,\nwithout the back-and-forth.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: _textLight,
                  height: 1.16,
                  letterSpacing: -0.8,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Filter by capacity, date, and time with real-time availability.',
                style: TextStyle(
                  fontSize: 15,
                  color: _textMuted,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // زرار واحد في الآخر
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.eventDetailsScreen,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _emeraldPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Find a Venue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 19),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
