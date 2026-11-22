import 'package:booking/features/event_details/cubit/event_details_cubit.dart';
import 'package:booking/features/event_details/cubit/event_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// عدّلي مسار الاستيراد ده حسب مكان ملف VenueItemCard في مشروعك
import 'venue_item_card.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _guestsController = TextEditingController();
  final _durationController = TextEditingController();

  static const Map<String, int> _eventTypeToId = {
    'Workshop': 1,
    'Corporate Event': 2,
    'Conference': 3,
    'Networking Event': 4,
  };

  String _selectedEventType = 'Workshop';
  String _selectedVenueType = 'indoor';
  DateTime? _selectedDate;
  TimeOfDay? _startTime;

  @override
  void dispose() {
    _guestsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Book Event Details'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. اختيار نوع الـ Event مطابق لجدول event_type
              DropdownButtonFormField<String>(
                value: _selectedEventType,
                decoration: const InputDecoration(
                    labelText: 'Event Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Workshop', child: Text('Workshop')),
                  DropdownMenuItem(
                      value: 'Corporate Event', child: Text('Corporate Event')),
                  DropdownMenuItem(
                      value: 'Conference', child: Text('Conference')),
                  DropdownMenuItem(
                      value: 'Networking Event',
                      child: Text('Networking Event')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedEventType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 2. عدد الضيوف
              TextField(
                controller: _guestsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Number of Guests',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // 3. نوع المكان (Indoor / Outdoor)
              DropdownButtonFormField<String>(
                value: _selectedVenueType,
                decoration: const InputDecoration(
                    labelText: 'Venue Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'indoor', child: Text('Indoor')),
                  DropdownMenuItem(value: 'outdoor', child: Text('Outdoor')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedVenueType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 4. اختيار التاريخ
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate.toString().split(' ')[0]}'),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 5. اختيار وقت البداية
              OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(_startTime == null
                    ? 'Select Start Time'
                    : 'Start Time: ${_startTime!.format(context)}'),
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() => _startTime = pickedTime);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 6. مدة الفعالية بالساعات
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Duration (Hours)',
                    hintText: 'e.g., 3',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

              // 7. زرار البحث مع متابعة حالات البحث والحجز
              BlocConsumer<EventDetailsCubit, EventDetailsState>(
                listener: (context, state) {
                  if (state is EventDetailsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red),
                    );
                  } else if (state is BookingSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Venue booked successfully!'),
                          backgroundColor: Colors.green),
                    );
                  } else if (state is BookingError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is EventDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () {
                      final guests =
                          int.tryParse(_guestsController.text.trim()) ?? 0;
                      final duration =
                          int.tryParse(_durationController.text.trim()) ?? 0;

                      if (guests > 0 &&
                          duration > 0 &&
                          _selectedDate != null &&
                          _startTime != null) {
                        final formattedTime =
                            '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';

                        context.read<EventDetailsCubit>().getAvailableVenues(
                              eventType: _selectedEventType,
                              guests: guests,
                              type: _selectedVenueType,
                              date: _selectedDate!,
                              startTime: formattedTime,
                              duration: duration,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please select date, start time, and fill all fields correctly!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Search Available Venues',
                        style: TextStyle(fontSize: 16)),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 8. عرض القاعات المتاحة مع زرار الحجز
              SizedBox(
                height: 250,
                child: BlocBuilder<EventDetailsCubit, EventDetailsState>(
                  builder: (context, state) {
                    if (state is EventDetailsSuccess) {
                      final venues = state.venues;
                      if (venues.isEmpty) {
                        return const Center(
                            child: Text(
                                'No venues available for these criteria.'));
                      }

                      return ListView.builder(
                        itemCount: venues.length,
                        itemBuilder: (context, index) {
                          final venue = venues[index];

                          return VenueItemCard(
                            venue: venue,
                            isBooking: state is BookingLoading,
                            onBook: () {
                              final guests =
                                  int.tryParse(_guestsController.text.trim()) ??
                                      0;
                              final duration = int.tryParse(
                                      _durationController.text.trim()) ??
                                  0;

                              if (guests <= 0 ||
                                  duration <= 0 ||
                                  _selectedDate == null ||
                                  _startTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please select date, start time, and fill all fields first!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final formattedTime =
                                  '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00';

                              context.read<EventDetailsCubit>().bookVenue(
                                    venueId: venue.id,
                                    eventTypeId:
                                        _eventTypeToId[_selectedEventType]!,
                                    date: _selectedDate!,
                                    startTime: formattedTime,
                                    duration: duration,
                                    guests: guests,
                                    eventType: _selectedEventType,
                                    pricePerHour: venue.pricePerHour.toDouble(),
                                  );
                            },
                          );
                        },
                      );
                    }
                    return const Center(
                        child: Text('Select options and search for venues.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
