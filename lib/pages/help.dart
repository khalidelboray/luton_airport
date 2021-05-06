import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/comp/drawer.dart';
import 'package:luton_airport/jsonData.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() =>  _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('LLA - Help Me'),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          bottom: PreferredSize(preferredSize: Size.fromHeight(50.0),child: getHelpTabs(context) ),
        ),
        drawer: MyDrawer(),
        body: getHelpContent(context),
      )
  );
}