import 'package:booking/core/networking/api_error_handler.dart';
import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/event_details/cubit/venue_model.dart';
import 'package:dio/dio.dart';

class EventDetailsRepo {
  final Dio _dio;

  EventDetailsRepo(this._dio);

  Future<ApiResult<List<VenueModel>>> getAvailableVenues({
    required String eventType,
    required int guests,
    required String type,
    required DateTime date,
    required String startTime,
    required int duration,
  }) async {
    try {
      final response = await _dio.post(
        '/rest/v1/rpc/get_available_venues',
        data: {
          'p_event_type': eventType,
          'p_guests': guests,
          'p_type': type,
          'p_date': date.toIso8601String().split('T')[0],
          'p_start_time': startTime,
          'p_duration': duration,
        },
      );

      List<VenueModel> venues = (response.data as List)
          .map((json) => VenueModel.fromJson(json))
          .toList();

      return Success(venues);
    } on DioException catch (e) {
      return ApiError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> bookVenue({
    required int venueId,
    required int eventTypeId,
    required DateTime date,
    required String startTime,
    required int duration,
    required int guests,
    required String eventType,
    double pricePerHour = 0,
  }) async {
    try {
      final formattedDate = date.toIso8601String().split('T')[0];

      // حساب end_time من startTime (HH:mm:ss أو HH:mm) + duration بالساعات
      final parts = startTime.split(':');
      final startHour = int.tryParse(parts[0]) ?? 0;
      final startMinute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startHour,
        startMinute,
      );
      final endDateTime = startDateTime.add(Duration(hours: duration));

      final normalizedStartTime =
          '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}:00';
      final normalizedEndTime =
          '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}:00';

      final Map<String, dynamic> body = {
        'venue_id': venueId,
        'event_type_id': eventTypeId,
        'booking_date': formattedDate,
        'start_time': normalizedStartTime,
        'end_time': normalizedEndTime,
        'duration_hours': duration,
        'guest_count': guests,
        'total_price': pricePerHour * duration,
        'status': 'confirmed',
      };

      // if (eventTypeId != null) {
      //   body['event_type_id'] = eventTypeId;
      // }

      await _dio.post(
        '/rest/v1/bookings',
        data: body,
      );

      return const Success(null);
    } on DioException catch (e) {
      return ApiError(ApiErrorHandler.handle(e));
    }
  }
}
