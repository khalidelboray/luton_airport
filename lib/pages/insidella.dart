import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:luton_airport/comp/drawer.dart';
import 'package:luton_airport/jsonData.dart';
class InsideLLA extends StatefulWidget {
  @override
  _InsideLLAState createState() =>  _InsideLLAState();
}

class _InsideLLAState extends State<InsideLLA> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Inside LLA'),
            // automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text('Shops',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Tab(
                  child: Text('Food & Drinks',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            )
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            getShops(context),
            getFood(context)
          ],
        ),
      )
  );
}