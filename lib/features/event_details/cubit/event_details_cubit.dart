import 'package:booking/features/event_details/cubit/event_details_state.dart';
import 'package:booking/features/event_details/cubit/venue_model.dart';
import 'package:booking/features/event_details/data/event_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking/core/networking/api_result.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventDetailsRepo _eventDetailsRepo;

  EventDetailsCubit(this._eventDetailsRepo) : super(EventDetailsInitial());

  Future<void> getAvailableVenues({
    required String eventType,
    required int guests,
    required String type,
    required DateTime date,
    required String startTime,
    required int duration,
  }) async {
    emit(EventDetailsLoading());

    final result = await _eventDetailsRepo.getAvailableVenues(
      eventType: eventType,
      guests: guests,
      type: type,
      date: date,
      startTime: startTime,
      duration: duration,
    );

    if (result is Success) {
      final venues = (result as Success<List<VenueModel>>).data;
      emit(EventDetailsSuccess(venues));
    } else if (result is ApiError) {
      final errorModel = (result as ApiError).apiErrorModel;
      emit(EventDetailsError(errorModel.message ?? 'An error occurred'));
    }
  }
}
