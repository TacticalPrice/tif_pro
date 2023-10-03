import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];

  List<dynamic> get eventsData => [];
}

class EventsLoadingState extends EventsState {}

class EventsLoadedState extends EventsState {
  final List<dynamic> eventsData;

  EventsLoadedState(this.eventsData);

  @override
  List<Object> get props => [eventsData];
}

class EventsErrorState extends EventsState {
  final String errorMessage;

  EventsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class EventDetailsLoadingState extends EventsState {}

class EventDetailsLoadedState extends EventsState {
  final Map<String, dynamic> eventDetails;

  EventDetailsLoadedState(this.eventDetails);

  @override
  List<Object> get props => [eventDetails];
}

class EventDetailsErrorState extends EventsState {
  final String errorMessage;

  EventDetailsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

