import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tif_pro/bloc/events_event.dart';
import 'package:tif_pro/bloc/events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsLoadingState()) {
    on<LoadEventsEvent>(_mapLoadEventsToState);
    on<SearchEventsEvent>(_mapSearchEventsToState);
    on<LoadEventDetailsEvent>(_mapLoadEventDetailsToState);
  }

  void _mapLoadEventsToState(LoadEventsEvent event, Emitter<EventsState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sde-007.api.assignment.theinternetfolks.works/v1/event'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final eventsData = responseData['content']['data'] ?? [];
        emit(EventsLoadedState(eventsData));
      } else if (response.statusCode == 400) {
        emit(EventsErrorState('Error fetching events.'));
      } else {
        emit(EventsErrorState('An unknown error occurred.'));
      }
    } catch (_) {
      emit(EventsErrorState('An unknown error occurred.'));
    }
  }

  void _mapSearchEventsToState(SearchEventsEvent event, Emitter<EventsState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=${event.query}'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final searchEventsData = responseData['content']['data'] ?? [];
        emit(EventsLoadedState(searchEventsData));
      } else if (response.statusCode == 400) {
        emit(EventsErrorState('Error fetching events.'));
      } else {
        emit(EventsErrorState('An unknown error occurred.'));
      }
    } catch (_) {
      emit(EventsErrorState('An unknown error occurred.'));
    }
  }

  void _mapLoadEventDetailsToState(LoadEventDetailsEvent event, Emitter<EventsState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://sde-007.api.assignment.theinternetfolks.works/v1/event/${event.eventId}'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final eventDetails = responseData['content']['data'] ?? {};
        emit(EventDetailsLoadedState(eventDetails));
      } else if (response.statusCode == 400) {
        emit(EventDetailsErrorState('Error fetching event details.'));
      } else {
        emit(EventDetailsErrorState('An unknown error occurred.'));
      }
    } catch (_) {
      emit(EventDetailsErrorState('An unknown error occurred.'));
    }
  }


  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    // Event mapping moved to individual methods
  }
}
