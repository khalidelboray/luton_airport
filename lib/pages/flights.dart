import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/jsonData.dart';
import 'package:luton_airport/comp/drawer.dart';

class Flights extends StatefulWidget {

  @override
  _FlightsState createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {

  @override
  Widget build(BuildContext context) =>
      DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                title: Text('LLA - Flights'),
                // automaticallyImplyLeading: false,
                backgroundColor: Colors.green,
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text('Departures',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Tab(
                      child: Text('Arrivals',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                )
            ),
            drawer: MyDrawer(),
            body: TabBarView(
              children: [
                getDepartures(context),
                getArrivals(context)
              ],
            ),
          )
      );
}