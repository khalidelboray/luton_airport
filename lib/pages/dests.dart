import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/comp/drawer.dart';
import 'package:luton_airport/jsonData.dart';

class Dests extends StatefulWidget {
  @override
  _DestsState createState() =>  _DestsState();
}

class _DestsState extends State<Dests> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('LLA - Destinations'),
      // automaticallyImplyLeading: false,
      backgroundColor: Colors.green,
    ),
    drawer: MyDrawer(),
    body: getDests(context),
  );
}