import 'dart:convert';
import 'package:flutter/cupertino.dart';

Future aGetAssetsAT(context,banana) async {
  String data = await DefaultAssetBundle.of(context).loadString("assets/data/$banana.json");
  final jsonResult = json.decode(data);
  return jsonResult;
}

Future<Map> aGetRetail(context) async {
  return await aGetAssetsAT(context, 'retail');
}

Future aGetDests(context) async {
  return await aGetAssetsAT(context, 'dests');
}

Future aGetHelp(context) async {
  return await aGetAssetsAT(context, 'help');
}

Future<List<dynamic>> aGetDepartures(context) async {
  final data = await aGetAssetsAT(context, 'flights');
  return data['departures'];
}

Future<List<dynamic>> aGetArrivals(context) async {
  final data = await aGetAssetsAT(context, 'flights');
  return data['arrivals'];
}