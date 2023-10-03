import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class LoadEventsEvent extends EventsEvent {}

class SearchEventsEvent extends EventsEvent {
  final String query;

  SearchEventsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class LoadEventDetailsEvent extends EventsEvent {
  final int eventId;

  LoadEventDetailsEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}


