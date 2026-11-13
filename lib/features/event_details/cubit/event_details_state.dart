import 'package:booking/features/event_details/cubit/venue_model.dart';

abstract class EventDetailsState {}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsSuccess extends EventDetailsState {
  final List<VenueModel> venues;
  EventDetailsSuccess(this.venues);
}

class EventDetailsError extends EventDetailsState {
  final String message;
  EventDetailsError(this.message);
}