import 'package:booking/features/event_details/cubit/venue_model.dart';
import 'package:flutter/material.dart';
// import VenueModel

class VenueItemCard extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback onBookPressed; // زرار الحجز لما المستخدم يضغطه

  const VenueItemCard({
    super.key,
    required this.venue,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Capacity: ${venue.capacity} guests'),
            Text('Price: \$${venue.pricePerHour} / hour'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onBookPressed, // هنا بينادي دالة الحجز
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
