// import 'package:booking/core/theme/app_theme.dart';
// import 'package:booking/features/event_details/cubit/event_details_cubit.dart';
// import 'package:booking/features/event_details/cubit/event_details_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EventDetailsScreen extends StatefulWidget {
//   const EventDetailsScreen({super.key});

//   @override
//   State<EventDetailsScreen> createState() => _EventDetailsScreenState();
// }

// class _EventDetailsScreenState extends State<EventDetailsScreen> {
//   final _guestsController = TextEditingController();
//   final _durationController = TextEditingController();
//   final PageController _pageController = PageController(viewportFraction: 0.84);

//   static const Map<String, int> _eventTypeToId = {
//     'Workshop': 1,
//     'Corporate Event': 2,
//     'Conference': 3,
//     'Networking Event': 4,
//   };

//   String _selectedEventType = 'Workshop';
//   String _selectedVenueType = 'indoor';
//   DateTime? _selectedDate;
//   TimeOfDay? _startTime;

//   bool _showOverlayDeck = false;
//   int _activeCardIndex = 0;

//   @override
//   void dispose() {
//     _guestsController.dispose();
//     _durationController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   String _formatDate(DateTime date) {
//     final year = date.year.toString().padLeft(4, '0');
//     final month = date.month.toString().padLeft(2, '0');
//     final day = date.day.toString().padLeft(2, '0');
//     return '$year-$month-$day';
//   }

//   void _onSearchPressed() {
//     final guests = int.tryParse(_guestsController.text.trim()) ?? 0;
//     final duration = int.tryParse(_durationController.text.trim()) ?? 0;

//     if (guests > 0 &&
//         duration > 0 &&
//         _selectedDate != null &&
//         _startTime != null) {
//       final formattedTime =
//           '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';

//       context.read<EventDetailsCubit>().getAvailableVenues(
//             eventType: _selectedEventType,
//             guests: guests,
//             type: _selectedVenueType,
//             date: _selectedDate!,
//             startTime: formattedTime,
//             duration: duration,
//           );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please select date, start time, and fill all fields correctly!',
//           ),
//           backgroundColor: AppTheme.error,
//         ),
//       );
//     }
//   }

//   void _onBookVenue(dynamic venue) {
//     final guests = int.tryParse(_guestsController.text.trim()) ?? 0;
//     final duration = int.tryParse(_durationController.text.trim()) ?? 0;

//     if (guests <= 0 ||
//         duration <= 0 ||
//         _selectedDate == null ||
//         _startTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please select date, start time, and fill all fields first!',
//           ),
//           backgroundColor: AppTheme.error,
//         ),
//       );
//       return;
//     }

//     final formattedTime =
//         '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00';

//     context.read<EventDetailsCubit>().bookVenue(
//           venueId: venue.id,
//           eventTypeId: _eventTypeToId[_selectedEventType]!,
//           date: _selectedDate!,
//           startTime: formattedTime,
//           duration: duration,
//           guests: guests,
//           eventType: _selectedEventType,
//           pricePerHour: (venue.pricePerHour as num).toDouble(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         backgroundColor: AppTheme.background,
//         foregroundColor: AppTheme.textPrimary,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Book Event Details',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: AppTheme.textPrimary,
//           ),
//         ),
//       ),
//       body: BlocConsumer<EventDetailsCubit, EventDetailsState>(
//         listener: (context, state) {
//           if (state is EventDetailsSuccess) {
//             setState(() {
//               _activeCardIndex = 0;
//               _showOverlayDeck = true;
//             });
//             if (_pageController.hasClients) {
//               _pageController.jumpToPage(0);
//             }
//           } else if (state is EventDetailsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppTheme.error,
//               ),
//             );
//           } else if (state is BookingSuccess) {
//             setState(() => _showOverlayDeck = false);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Venue booked successfully!'),
//                 backgroundColor: AppTheme.success,
//               ),
//             );
//           } else if (state is BookingError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppTheme.error,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final List<dynamic> venues =
//               state is EventDetailsSuccess ? state.venues : const [];
//           final bool isSearching = state is EventDetailsLoading;
//           final bool isBooking = state is BookingLoading;

//           return Stack(
//             children: [
//               // 1. صفحة التفاصيل الأساسية (تظل في الخلفية)
//               SafeArea(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Text(
//                         'Event & Space Criteria',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           color: AppTheme.textPrimary,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Set your event requirements to check live venue availability.',
//                         style: TextStyle(
//                           fontSize: 13.5,
//                           color: AppTheme.textSecondary,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                         padding: const EdgeInsets.all(18),
//                         decoration: BoxDecoration(
//                           color: AppTheme.surface,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: AppTheme.border),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             DropdownButtonFormField<String>(
//                               value: _selectedEventType,
//                               dropdownColor: AppTheme.surfaceElevated,
//                               style: const TextStyle(
//                                 color: AppTheme.textPrimary,
//                                 fontSize: 14.5,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               decoration: const InputDecoration(
//                                 labelText: 'Event Type',
//                                 prefixIcon: Icon(
//                                   Icons.event_note_rounded,
//                                   color: AppTheme.accent,
//                                   size: 20,
//                                 ),
//                               ),
//                               items: const [
//                                 DropdownMenuItem(
//                                   value: 'Workshop',
//                                   child: Text('Workshop'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'Corporate Event',
//                                   child: Text('Corporate Event'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'Conference',
//                                   child: Text('Conference'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'Networking Event',
//                                   child: Text('Networking Event'),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   setState(() => _selectedEventType = value);
//                                 }
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _guestsController,
//                                     keyboardType: TextInputType.number,
//                                     style: const TextStyle(
//                                       color: AppTheme.textPrimary,
//                                       fontSize: 14.5,
//                                     ),
//                                     decoration: const InputDecoration(
//                                       labelText: 'Guests',
//                                       hintText: 'e.g., 50',
//                                       prefixIcon: Icon(
//                                         Icons.groups_rounded,
//                                         color: AppTheme.accent,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: TextField(
//                                     controller: _durationController,
//                                     keyboardType: TextInputType.number,
//                                     style: const TextStyle(
//                                       color: AppTheme.textPrimary,
//                                       fontSize: 14.5,
//                                     ),
//                                     decoration: const InputDecoration(
//                                       labelText: 'Duration (Hrs)',
//                                       hintText: 'e.g., 3',
//                                       prefixIcon: Icon(
//                                         Icons.hourglass_bottom_rounded,
//                                         color: AppTheme.accent,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             DropdownButtonFormField<String>(
//                               value: _selectedVenueType,
//                               dropdownColor: AppTheme.surfaceElevated,
//                               style: const TextStyle(
//                                 color: AppTheme.textPrimary,
//                                 fontSize: 14.5,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               decoration: const InputDecoration(
//                                 labelText: 'Venue Type',
//                                 prefixIcon: Icon(
//                                   Icons.meeting_room_outlined,
//                                   color: AppTheme.accent,
//                                   size: 20,
//                                 ),
//                               ),
//                               items: const [
//                                 DropdownMenuItem(
//                                   value: 'indoor',
//                                   child: Text('Indoor'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'outdoor',
//                                   child: Text('Outdoor'),
//                                 ),
//                               ],
//                               onChanged: (value) {
//                                 if (value != null) {
//                                   setState(() => _selectedVenueType = value);
//                                 }
//                               },
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _PickerTileButton(
//                                     icon: Icons.calendar_today_rounded,
//                                     label: _selectedDate == null
//                                         ? 'Select Date'
//                                         : _formatDate(_selectedDate!),
//                                     isSelected: _selectedDate != null,
//                                     onTap: () async {
//                                       final pickedDate = await showDatePicker(
//                                         context: context,
//                                         initialDate:
//                                             _selectedDate ?? DateTime.now(),
//                                         firstDate: DateTime.now(),
//                                         lastDate: DateTime.now()
//                                             .add(const Duration(days: 365)),
//                                       );
//                                       if (pickedDate != null) {
//                                         setState(
//                                             () => _selectedDate = pickedDate);
//                                       }
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _PickerTileButton(
//                                     icon: Icons.access_time_rounded,
//                                     label: _startTime == null
//                                         ? 'Start Time'
//                                         : _startTime!.format(context),
//                                     isSelected: _startTime != null,
//                                     onTap: () async {
//                                       final pickedTime = await showTimePicker(
//                                         context: context,
//                                         initialTime:
//                                             _startTime ?? TimeOfDay.now(),
//                                       );
//                                       if (pickedTime != null) {
//                                         setState(() => _startTime = pickedTime);
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       if (isSearching)
//                         const SizedBox(
//                           height: 54,
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: AppTheme.accent,
//                               strokeWidth: 2.5,
//                             ),
//                           ),
//                         )
//                       else
//                         SizedBox(
//                           height: 54,
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.search_rounded, size: 20),
//                             label: const Text(
//                               'Search Available Venues',
//                               style: TextStyle(
//                                 fontSize: 15.5,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             onPressed: _onSearchPressed,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               // 2. طبقة الكروت العائمة فوق صفحة التفاصيل (Swipe يمين وشمال)
//               if (_showOverlayDeck)
//                 Positioned.fill(
//                   child: GestureDetector(
//                     onTap: () => setState(() => _showOverlayDeck = false),
//                     child: Container(
//                       color: Colors.black.withOpacity(0.62),
//                       child: SafeArea(
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 20),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Matched Venues (${venues.length})',
//                                           style: const TextStyle(
//                                             color: AppTheme.textPrimary,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w800,
//                                           ),
//                                         ),
//                                         const Text(
//                                           'Swipe left or right to browse',
//                                           style: TextStyle(
//                                             color: AppTheme.textSecondary,
//                                             fontSize: 12.5,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     IconButton(
//                                       onPressed: () => setState(
//                                           () => _showOverlayDeck = false),
//                                       style: IconButton.styleFrom(
//                                         backgroundColor: AppTheme.surface,
//                                         foregroundColor: AppTheme.textPrimary,
//                                         side: const BorderSide(
//                                             color: AppTheme.border),
//                                       ),
//                                       icon: const Icon(Icons.close_rounded,
//                                           size: 20),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               SizedBox(
//                                 height:
//                                     (MediaQuery.of(context).size.height * 0.44)
//                                         .clamp(300.0, 355.0),
//                                 child: venues.isEmpty
//                                     ? Center(
//                                         child: Container(
//                                           margin: const EdgeInsets.symmetric(
//                                               horizontal: 24),
//                                           padding: const EdgeInsets.all(24),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.surface,
//                                             borderRadius:
//                                                 BorderRadius.circular(24),
//                                             border: Border.all(
//                                                 color: AppTheme.border),
//                                           ),
//                                           child: const Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                 Icons.event_busy_rounded,
//                                                 color: AppTheme.accent,
//                                                 size: 36,
//                                               ),
//                                               SizedBox(height: 10),
//                                               Text(
//                                                 'No venues available for these criteria.',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: AppTheme.textPrimary,
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     : PageView.builder(
//                                         controller: _pageController,
//                                         itemCount: venues.length,
//                                         onPageChanged: (index) {
//                                           setState(
//                                               () => _activeCardIndex = index);
//                                         },
//                                         itemBuilder: (context, index) {
//                                           final venue = venues[index];
//                                           final isCurrent =
//                                               index == _activeCardIndex;

//                                           return AnimatedScale(
//                                             scale: isCurrent ? 1.0 : 0.94,
//                                             duration: const Duration(
//                                                 milliseconds: 220),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 12),
//                                               child: _VenueSwipeCard(
//                                                 venue: venue,
//                                                 isBooking: isBooking,
//                                                 onBook: () =>
//                                                     _onBookVenue(venue),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                               ),
//                               const SizedBox(height: 10),
//                               if (venues.length > 1)
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(venues.length, (i) {
//                                     final active = i == _activeCardIndex;
//                                     return AnimatedContainer(
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       margin: const EdgeInsets.symmetric(
//                                           horizontal: 4),
//                                       width: active ? 20 : 7,
//                                       height: 7,
//                                       decoration: BoxDecoration(
//                                         color: active
//                                             ? AppTheme.accent
//                                             : AppTheme.border,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                               const SizedBox(height: 12),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _VenueSwipeCard extends StatelessWidget {
//   final dynamic venue;
//   final bool isBooking;
//   final VoidCallback onBook;

//   const _VenueSwipeCard({
//     required this.venue,
//     required this.isBooking,
//     required this.onBook,
//   });

//   String _title() {
//     try {
//       final val = venue.name;
//       if (val != null && val.toString().trim().isNotEmpty) {
//         return val.toString();
//       }
//     } catch (_) {}
//     try {
//       final val = venue.title;
//       if (val != null && val.toString().trim().isNotEmpty) {
//         return val.toString();
//       }
//     } catch (_) {}
//     return 'Venue #${venue.id}';
//   }

//   String _subtitle() {
//     final parts = <String>[];
//     try {
//       final type = venue.type;
//       if (type != null && type.toString().isNotEmpty) {
//         parts.add(type.toString().toUpperCase());
//       }
//     } catch (_) {}
//     try {
//       final cap = venue.capacity;
//       if (cap != null) {
//         parts.add('Up to $cap guests');
//       }
//     } catch (_) {}
//     try {
//       final loc = venue.location;
//       if (loc != null && loc.toString().isNotEmpty) {
//         parts.add(loc.toString());
//       }
//     } catch (_) {}
//     return parts.isEmpty ? 'Curated Event Space' : parts.join(' • ');
//   }

// // assest path ////////////////////////////////////////////////////////////////////////////
//   String _assetPath() {
//     try {
//       final img = venue.image ?? venue.imageUrl ?? venue.assetPath;
//       if (img != null && img.toString().trim().isNotEmpty) {
//         final str = img.toString().trim();
//         if (str.startsWith('assets/')) return str;
//         return 'assets/images/$str';
//       }
//     } catch (_) {}

//     String type = '';
//     try {
//       type = (venue.type ?? '').toString().toLowerCase().trim();
//     } catch (_) {}

//     int capacity = 0;
//     try {
//       final cap = venue.capacity;
//       if (cap is int) {
//         capacity = cap;
//       } else if (cap != null) {
//         capacity = int.tryParse(cap.toString()) ?? 0;
//       }
//     } catch (_) {}

//     if (type == 'outdoor') {
//       if (capacity >= 80) return 'assets/images/v5.png';
//       return 'assets/images/v7.png';
//     }

//     if (capacity >= 80) return 'assets/images/v2.png';
//     if (capacity >= 30) return 'assets/images/v3.png';
//     return 'assets/images/v6.png';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final price = venue.pricePerHour;

//     return Container(
//       decoration: BoxDecoration(
//         color: AppTheme.surfaceElevated,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: AppTheme.border, width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.45),
//             blurRadius: 24,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             flex: 5,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(24),
//               ),
//               child: Image.asset(
//                 _assetPath(),
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     color: AppTheme.surface,
//                     alignment: Alignment.center,
//                     child: const Icon(
//                       Icons.apartment_rounded,
//                       size: 44,
//                       color: AppTheme.accent,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _title(),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: AppTheme.textPrimary,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   _subtitle(),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: AppTheme.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Price / Hour',
//                           style: TextStyle(
//                             color: AppTheme.textSecondary,
//                             fontSize: 11,
//                           ),
//                         ),
//                         const SizedBox(height: 1),
//                         Text(
//                           '$price EGP',
//                           style: const TextStyle(
//                             color: AppTheme.accent,
//                             fontSize: 15.5,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: ElevatedButton(
//                         onPressed: isBooking ? null : onBook,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 18),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(13),
//                           ),
//                         ),
//                         child: isBooking
//                             ? const SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Text(
//                                 'Book Now',
//                                 style: TextStyle(
//                                   fontSize: 13.5,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PickerTileButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _PickerTileButton({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       onPressed: onTap,
//       style: OutlinedButton.styleFrom(
//         backgroundColor:
//             isSelected ? AppTheme.surfaceElevated : AppTheme.background,
//         foregroundColor:
//             isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
//         side: BorderSide(
//           color:
//               isSelected ? AppTheme.accent.withOpacity(0.6) : AppTheme.border,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 17,
//             color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Text(
//               label,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 13.5,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:booking/core/theme/app_theme.dart';
import 'package:booking/features/event_details/cubit/event_details_cubit.dart';
import 'package:booking/features/event_details/cubit/event_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _guestsController = TextEditingController();
  final _durationController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.84);

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

  bool _showOverlayDeck = false;
  int _activeCardIndex = 0;

  @override
  void dispose() {
    _guestsController.dispose();
    _durationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _onSearchPressed() {
    final guests = int.tryParse(_guestsController.text.trim()) ?? 0;
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;

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
            'Please select date, start time, and fill all fields correctly!',
          ),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _onBookVenue(dynamic venue) {
    final guests = int.tryParse(_guestsController.text.trim()) ?? 0;
    final duration = int.tryParse(_durationController.text.trim()) ?? 0;

    if (guests <= 0 ||
        duration <= 0 ||
        _selectedDate == null ||
        _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select date, start time, and fill all fields first!',
          ),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final formattedTime =
        '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00';

    context.read<EventDetailsCubit>().bookVenue(
          venueId: venue.id,
          eventTypeId: _eventTypeToId[_selectedEventType]!,
          date: _selectedDate!,
          startTime: formattedTime,
          duration: duration,
          guests: guests,
          eventType: _selectedEventType,
          pricePerHour: (venue.pricePerHour as num).toDouble(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Book Event Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<EventDetailsCubit, EventDetailsState>(
        listener: (context, state) {
          if (state is EventDetailsSuccess) {
            setState(() {
              _activeCardIndex = 0;
              _showOverlayDeck = true;
            });
            if (_pageController.hasClients) {
              _pageController.jumpToPage(0);
            }
          } else if (state is EventDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.error,
              ),
            );
          } else if (state is BookingSuccess) {
            setState(() => _showOverlayDeck = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venue booked successfully!'),
                backgroundColor: AppTheme.success,
              ),
            );
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final List<dynamic> venues =
              state is EventDetailsSuccess ? state.venues : const [];
          final bool isSearching = state is EventDetailsLoading;
          final bool isBooking = state is BookingLoading;

          return Stack(
            children: [
              // 1. صفحة التفاصيل الأساسية (تظل في الخلفية)
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Event & Space Criteria',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Set your event requirements to check live venue availability.',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedEventType,
                              dropdownColor: AppTheme.surfaceElevated,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Event Type',
                                prefixIcon: Icon(
                                  Icons.event_note_rounded,
                                  color: AppTheme.accent,
                                  size: 20,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Workshop',
                                  child: Text('Workshop'),
                                ),
                                DropdownMenuItem(
                                  value: 'Corporate Event',
                                  child: Text('Corporate Event'),
                                ),
                                DropdownMenuItem(
                                  value: 'Conference',
                                  child: Text('Conference'),
                                ),
                                DropdownMenuItem(
                                  value: 'Networking Event',
                                  child: Text('Networking Event'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedEventType = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _guestsController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 14.5,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Guests',
                                      hintText: 'e.g., 50',
                                      prefixIcon: Icon(
                                        Icons.groups_rounded,
                                        color: AppTheme.accent,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _durationController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 14.5,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Duration (Hrs)',
                                      hintText: 'e.g., 3',
                                      prefixIcon: Icon(
                                        Icons.hourglass_bottom_rounded,
                                        color: AppTheme.accent,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedVenueType,
                              dropdownColor: AppTheme.surfaceElevated,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Venue Type',
                                prefixIcon: Icon(
                                  Icons.meeting_room_outlined,
                                  color: AppTheme.accent,
                                  size: 20,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'indoor',
                                  child: Text('Indoor'),
                                ),
                                DropdownMenuItem(
                                  value: 'outdoor',
                                  child: Text('Outdoor'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedVenueType = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _PickerTileButton(
                                    icon: Icons.calendar_today_rounded,
                                    label: _selectedDate == null
                                        ? 'Select Date'
                                        : _formatDate(_selectedDate!),
                                    isSelected: _selectedDate != null,
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDate ?? DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 365)),
                                      );
                                      if (pickedDate != null) {
                                        setState(
                                            () => _selectedDate = pickedDate);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _PickerTileButton(
                                    icon: Icons.access_time_rounded,
                                    label: _startTime == null
                                        ? 'Start Time'
                                        : _startTime!.format(context),
                                    isSelected: _startTime != null,
                                    onTap: () async {
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            _startTime ?? TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        setState(() => _startTime = pickedTime);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (isSearching)
                        const SizedBox(
                          height: 54,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.accent,
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 54,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.search_rounded, size: 20),
                            label: const Text(
                              'Search Available Venues',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: _onSearchPressed,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 2. طبقة الكروت العائمة فوق صفحة التفاصيل (Swipe يمين وشمال)
              if (_showOverlayDeck)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => _showOverlayDeck = false),
                    child: Container(
                      color: Colors.black.withOpacity(0.62),
                      child: SafeArea(
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Matched Venues (${venues.length})',
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const Text(
                                          'Swipe left or right to browse',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () => setState(
                                          () => _showOverlayDeck = false),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppTheme.surface,
                                        foregroundColor: AppTheme.textPrimary,
                                        side: const BorderSide(
                                            color: AppTheme.border),
                                      ),
                                      icon: const Icon(Icons.close_rounded,
                                          size: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              //////////////// sized box for card
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height * 0.46)
                                        .clamp(320.0, 380.0),
                                child: venues.isEmpty
                                    ? Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            border: Border.all(
                                                color: AppTheme.border),
                                          ),
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.event_busy_rounded,
                                                color: AppTheme.accent,
                                                size: 36,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'No venues available for these criteria.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppTheme.textPrimary,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : PageView.builder(
                                        controller: _pageController,
                                        itemCount: venues.length,
                                        onPageChanged: (index) {
                                          setState(
                                              () => _activeCardIndex = index);
                                        },
                                        itemBuilder: (context, index) {
                                          final venue = venues[index];
                                          final isCurrent =
                                              index == _activeCardIndex;

                                          return AnimatedScale(
                                            scale: isCurrent ? 1.0 : 0.94,
                                            duration: const Duration(
                                                milliseconds: 220),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: _VenueSwipeCard(
                                                venue: venue,
                                                isBooking: isBooking,
                                                onBook: () =>
                                                    _onBookVenue(venue),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              const SizedBox(height: 10),
                              if (venues.length > 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(venues.length, (i) {
                                    final active = i == _activeCardIndex;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: active ? 20 : 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? AppTheme.accent
                                            : AppTheme.border,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    );
                                  }),
                                ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////,,,,,,,,,,,,,,,,,,,
class _VenueSwipeCard extends StatelessWidget {
  final dynamic venue;
  final bool isBooking;
  final VoidCallback onBook;

  const _VenueSwipeCard({
    required this.venue,
    required this.isBooking,
    required this.onBook,
  });

  String _title() {
    try {
      final val = venue.name;
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString();
      }
    } catch (_) {}
    try {
      final val = venue.title;
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString();
      }
    } catch (_) {}
    return 'Venue #${venue.id}';
  }

  String _subtitle() {
    final parts = <String>[];
    try {
      final type = venue.type;
      if (type != null && type.toString().isNotEmpty) {
        parts.add(type.toString().toUpperCase());
      }
    } catch (_) {}
    try {
      final cap = venue.capacity;
      if (cap != null) {
        parts.add('Up to $cap guests');
      }
    } catch (_) {}
    try {
      final loc = venue.location;
      if (loc != null && loc.toString().isNotEmpty) {
        parts.add(loc.toString());
      }
    } catch (_) {}
    return parts.isEmpty ? 'Curated Event Space' : parts.join(' • ');
  }

// assest path ////////////////////////////////////////////////////////////////////////////
  String _assetPath() {
    try {
      final img = venue.image ?? venue.imageUrl ?? venue.assetPath;
      if (img != null && img.toString().trim().isNotEmpty) {
        final str = img.toString().trim();
        if (str.startsWith('assets/')) return str;
        return 'assets/images/$str';
      }
    } catch (_) {}

    String type = '';
    try {
      type = (venue.type ?? '').toString().toLowerCase().trim();
    } catch (_) {}

    int capacity = 0;
    try {
      final cap = venue.capacity;
      if (cap is int) {
        capacity = cap;
      } else if (cap != null) {
        capacity = int.tryParse(cap.toString()) ?? 0;
      }
    } catch (_) {}

    if (type == 'outdoor') {
      if (capacity >= 80) return 'assets/images/v5.png';
      return 'assets/images/v7.png';
    }

    if (capacity >= 80) return 'assets/images/v2.png';
    if (capacity >= 30) return 'assets/images/v3.png';
    return 'assets/images/v6.png';
  }

////////
  @override
  Widget build(BuildContext context) {
    final price = venue.pricePerHour;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Image.asset(
                _assetPath(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.surface,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.apartment_rounded,
                      size: 46,
                      color: AppTheme.accent,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _title(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _subtitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Price / Hour',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '$price EGP',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isBooking ? null : onBook,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: isBooking
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Book Now',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerTileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PickerTileButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? AppTheme.surfaceElevated : AppTheme.background,
        foregroundColor:
            isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
        side: BorderSide(
          color:
              isSelected ? AppTheme.accent.withOpacity(0.6) : AppTheme.border,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 17,
            color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
