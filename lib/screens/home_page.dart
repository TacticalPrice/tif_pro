import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tif_pro/bloc/events_bloc.dart';
import 'package:tif_pro/bloc/events_state.dart';
import 'package:tif_pro/screens/event_details.dart';
import 'package:tif_pro/screens/search_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? eventsData = [];
  
  String formatDateTime(String dateTime) {
  final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  final outputFormat = DateFormat("E, MMM dd • hh:mm a");
  final parsedDate = inputFormat.parse(dateTime);
  return outputFormat.format(parsedDate);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: Text(
          'Events',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF120D26)),
        ),
        centerTitle: false,
        actions: [
          Row(
            children: [
              IconButton(
                color: Color(0xFF060518),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage(
                                eventsData: eventsData ?? [],
                              )));
                },
                icon: Icon(Icons.search),
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.menu,
                color: Color(0xFF060518),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EventsLoadedState) {
            final eventsData = state.eventsData;
            return ListView.builder(
                itemCount: eventsData!.length,
                itemBuilder: (BuildContext context, index) {
                  var event = eventsData?[index];
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
                                    )));
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
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 92,
                                  width: 79,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: NetworkImage(eventBannerImage),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    formatDateTime(eventDateTime),
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF5669FF)),
                                  ),
                                ),
                                Text(
                                  eventTitle,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF120D26),
                                      fontWeight: FontWeight.w500),
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
                });
          } else {
            return Text('Unknown state.');
          }
        },
      ),
    );
  }
}
