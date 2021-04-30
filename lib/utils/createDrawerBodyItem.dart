import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    BuildContext context,
    e
    ) => ListTile(
  title: Row(
    children: <Widget>[
      Icon(e['icon'],color: Colors.green.withOpacity(0.7)),
      Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          e['text'], style: TextStyle(fontSize: 18),
        ),
      )
    ],
  ),
  onTap:() => Navigator.pushReplacementNamed(context, e['route']),
);
