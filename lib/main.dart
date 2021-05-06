import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/pages/dests.dart';
import 'package:luton_airport/pages/flights.dart';
import 'package:luton_airport/pages/help.dart';
import 'package:luton_airport/pages/home.dart';
import 'package:luton_airport/pages/insidella.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title:
    'London Luton Airport App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: HomePage(),
    routes: {
      '/home': (context) => HomePage(),
      '/inside': (context) => InsideLLA(),
      '/flights': (context) => Flights(),
      '/help': (context)=> Help(),
      '/dests': (context) => Dests()
    },
  );
}