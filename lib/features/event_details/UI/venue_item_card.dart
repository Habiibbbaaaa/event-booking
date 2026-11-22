import 'package:booking/features/event_details/cubit/venue_model.dart';
import 'package:flutter/material.dart';
// import VenueModel

class VenueItemCard extends StatelessWidget {
  final VenueModel venue;
  final VoidCallback onBook;
  final bool isBooking;

  const VenueItemCard({
    super.key,
    required this.venue,
    required this.onBook,
    this.isBooking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              venue.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Type: ${venue.type} • Capacity: ${venue.capacity}'),
            Text('Price: ${venue.pricePerHour} / hour'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isBooking ? null : onBook,
                child: isBooking
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Book Venue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
