import 'package:booking/core/networking/api_constants.dart';
import 'package:booking/core/networking/api_error_handler.dart';
import 'package:booking/core/networking/api_result.dart';
import 'package:booking/features/event_details/cubit/venue_model.dart';
import 'package:dio/dio.dart';

class EventDetailsRepo {
  final Dio _dio;

  EventDetailsRepo(this._dio);

  // Future<ApiResult<List<VenueModel>>> getAvailableVenues({
  //   required String eventType,
  //   required int guests,
  //   required String type,
  //   required DateTime date,
  //   required String startTime,
  //   required int duration,
  // }) async {
  //   try {
  //     final response = await _dio.get(
  //       ApiConstants.venues,
  //       queryParameters: {
  //         'type': type,
  //         'capacity': 'gte.$guests',
  //         'event_type': eventType,
  //         'date': date.toIso8601String(),
  //         'start_time': startTime,
  //         'duration': duration,
  //       },
  //     );

  //     List<VenueModel> venues = (response.data as List)
  //         .map((json) => VenueModel.fromJson(json))
  //         .toList();

  //     return Success(venues);
  //   } on DioException catch (e) {
  //     return ApiError(ApiErrorHandler.handle(e));
  //   }
  // }
  Future<ApiResult<List<VenueModel>>> getAvailableVenues({
    required String eventType,
    required int guests,
    required String type,
    required DateTime date,
    required String startTime,
    required int duration,
  }) async {
    try {
      // 📌 هنا الحل المعماري السليم:
      // بنستدعي دالة (RPC) في Supabase اسمها get_available_venues
      // وبنبعت لها كل شروط المستخدم (التاريخ، الوقت، المدة، والعدد، والنوع)
      // الدالة دي في الباك إند هي اللي بتقارن بجدول الـ bookings وترجع الأماكن الفاضية بس!

      final response = await _dio.post(
        '/rpc/get_available_venues', // مسار الـ RPC Function في Supabase PostgREST
        data: {
          'p_event_type': eventType,
          'p_guests': guests,
          'p_type': type,
          'p_date':
              date.toIso8601String().split('T')[0], // التاريخ فقط (YYYY-MM-DD)
          'p_start_time': startTime,
          'p_duration': duration,
        },
      );

      // تحويل الـ JSON الخام النظيف إلى لستة VenueModel
      List<VenueModel> venues = (response.data as List)
          .map((json) => VenueModel.fromJson(json))
          .toList();

      return Success(venues);
    } on DioException catch (e) {
      return ApiError(ApiErrorHandler.handle(e));
    }
  }
}
