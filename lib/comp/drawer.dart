import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/utils/createDrawerBodyItem.dart';


var items = [
  {
    'text': 'Home',
    'icon': Icons.home,
    'route': '/home'
  },
  {
    'text':  'Inside LLA',
    'icon':  Icons.home_filled,
    'route': '/inside'
  },
  {
    'text':  'Flights',
    'icon':  Icons.flight,
    'route': '/flights'
  },
  {
    'text': 'Destinations',
    'icon': Icons.directions,
    'route':'/dests'
  },
  {
    'text': 'Help',
    'icon': Icons.live_help_rounded,
    'route': '/help'
  },
];

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.

      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image:  AssetImage('assets/images/logo.png')
              )
          ),
          child: Stack(children: <Widget>[
            Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Text("London Luton Airport",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500
                    )
                )
            ),
          ]
          ),

        ),
        ...items.map((e) => createDrawerBodyItem(context,e)).toList()
      ],
    ),
  );
}