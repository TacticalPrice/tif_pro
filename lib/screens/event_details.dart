import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tif_pro/bloc/events_bloc.dart';
import 'package:tif_pro/bloc/events_event.dart';
import 'package:tif_pro/bloc/events_state.dart';

class EventDetails extends StatefulWidget {
  final int eventId;
  const EventDetails({super.key, required this.eventId});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  Map<String, dynamic>? eventDetails = {};
  late EventsBloc _eventsBloc;

  Future<void> _getEventDetails() async {
    _eventsBloc.add(LoadEventDetailsEvent(widget.eventId));
  }

  void _loadAllEvents() {
    BlocProvider.of<EventsBloc>(context).add(LoadEventsEvent());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _eventsBloc = BlocProvider.of<EventsBloc>(context); // Get the Bloc instance
    _getEventDetails();
  }

  String formatDateTime(String dateTimeString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final outputFormat = DateFormat("dd MMMM, yyyy");
    final parsedDate = inputFormat.parse(dateTimeString);
    return outputFormat.format(parsedDate);
  }

  String formatDate(String dateTimeString) {
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final outputFormat = DateFormat("EEEE, hh:mm a");
    final parsedDate = inputFormat.parse(dateTimeString);
    return outputFormat.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (state is EventDetailsLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is EventDetailsLoadedState) {
          eventDetails = state.eventDetails;
          return _buildEventDetails();
        } else {
          return Text('Unknown State');
        }
      },
    ));
  }

  Widget _buildEventDetails() {
    var eventBanner = eventDetails?['banner_image'];
    var eventTitle = eventDetails?['title'];
    var organiserUrl = eventDetails?['organiser_icon'];
    var organiserName = eventDetails?['organiser_name'];
    var eventDateTime = eventDetails?['date_time'];
    var eventVenueName = eventDetails?['venue_name'];
    var eventVenueCity = eventDetails?['venue_city'];
    var eventVenueCountry = eventDetails?['venue_country'];
    var eventDescription = eventDetails?['description'];
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Set mainAxisSize to MainAxisSize.min
              children: [
                Stack(
                  children: [
                    Container(
                      height: 244,
                      child: Image(
                        image: NetworkImage(eventBanner ?? ''),
                        fit: BoxFit
                            .cover, // Make the image cover the available space
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _loadAllEvents();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 80,
                      child: Text(
                        'Event Details',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFFFFFFF).withOpacity(0.3),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.bookmark,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(31.0),
                  child: Text(
                    eventTitle ?? '',
                    style: TextStyle(fontSize: 35, color: Color(0xFF120D26)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: NetworkImage(organiserUrl ?? ''),
                        width: 54,
                        height: 51,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 10),
                            child: Text(
                              organiserName ?? '',
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF0D0C26)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Text(
                              'organizer',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF0D0C26)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF5669FF)),
                        child: Icon(Icons.calendar_month),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatDateTime(eventDateTime) ?? ''),
                        SizedBox(height: 5,),
                        Text(
                          formatDate(eventDateTime) ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF747688),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF5669FF)),
                        child: Icon(Icons.location_on),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          eventVenueName ?? '',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF120D26)),
                        ),
                        Row(
                          children: [
                            Text(
                              eventVenueCity ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF747688)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              eventVenueCountry ?? '',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF747688)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'About Event',
                    style: TextStyle(color: Color(0xFF120D26), fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    eventDescription ?? '',
                    style: TextStyle(fontSize: 16, color: Color(0xFF120D26)),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: Color(0xFF5669FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 105.0),
                    child: Text(
                      'BOOK NOW',
                      style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF3D56F0),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
