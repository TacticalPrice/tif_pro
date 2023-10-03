import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tif_pro/bloc/events_bloc.dart';
import 'package:tif_pro/bloc/events_event.dart';
import 'package:tif_pro/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc()..add(LoadEventsEvent()),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
