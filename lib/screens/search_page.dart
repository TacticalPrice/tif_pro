import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tif_pro/bloc/events_bloc.dart';
import 'package:tif_pro/bloc/events_event.dart';
import 'package:tif_pro/bloc/events_state.dart';
import 'package:tif_pro/screens/event_details.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  final List<dynamic> eventsData;
  const SearchPage({super.key, required this.eventsData});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  Future<void> _searchEvents(String query) async {
    BlocProvider.of<EventsBloc>(context).add(SearchEventsEvent(query));
  }

  @override
  void initState() {
    super.initState();

    // Listen to changes in the search controller text
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _loadAllEvents(); // Load all events when the text is empty
      }
    });
  }

  void _loadAllEvents() {
    BlocProvider.of<EventsBloc>(context).add(LoadEventsEvent());
  }

  String formatDateTime(String dateTime) {
  final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  final outputFormat = DateFormat("E, MMM dd • hh:mm a");
  final parsedDate = inputFormat.parse(dateTime);
  return outputFormat.format(parsedDate);
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _loadAllEvents();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF120D26),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF120D26),
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventsLoadedState) {
            final searchEventsData = state.eventsData;

            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Color(0xFF5669FF),
                          ),
                          onPressed: () {
                            _searchEvents(_searchController.text);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Type Event Name',
                            hintStyle: TextStyle(
                                fontSize: 20, color: Color(0xFF000000)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchEventsData.isNotEmpty
                          ? searchEventsData.length
                          : widget.eventsData!.length,
                      itemBuilder: (BuildContext context, index) {
                        var event = searchEventsData.isNotEmpty
                            ? searchEventsData[index]
                            : widget.eventsData![index];
                        var eventId = event['id'];
                        var eventTitle = event?['title'];
                        var eventDescription = event?['description'];
                        var eventBannerImage = event?['banner_image'];
                        var eventDateTime = event?['date_time'];
                        var eventOrganiserName = event?['organiser_name'];
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetails(
                                    eventId: eventId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 106,
                              width: 327,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF575C8A).withOpacity(0.1),
                                    blurRadius: 35,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventDetails(
                                              eventId: eventId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 92,
                                        width: 79,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image:
                                                NetworkImage(eventBannerImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          formatDateTime(eventDateTime),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF5669FF),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        eventTitle,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF120D26),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          //Text(),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is EventsErrorState) {
            return Text('Error: ${state.errorMessage}');
          } else {
            return Text('Unknown State');
          }
        },
      ),
    );
  }
}
