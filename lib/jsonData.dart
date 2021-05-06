import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/accordian/gf_accordian.dart';
import 'package:getwidget/components/alert/gf_alert.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/floating_widget/gf_floating_widget.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/types/gf_alert_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;


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

Widget getShops(context) {
  return FutureBuilder(
      future: aGetRetail(context),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data['shops']['data'].length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return GFCard(
                        boxFit: BoxFit.cover,
                        titlePosition: GFPosition.start,
                        title: GFListTile(
                          titleText: snapshot.data['shops']['data'][Index]
                          ['title'],
                          subtitleText: snapshot.data['shops']['data'][Index]
                          ['subtitle'],
                        ),
                        content:
                        Text(snapshot.data['shops']['data'][Index]['desc']),
                        image: Image.asset("assets/data/images/" +
                            snapshot.data['shops']['data'][Index]['img']),
                        buttonBar: GFButtonBar(
                          children: <Widget>[
                            GFButton(
                              onPressed: () {
                                launch(snapshot.data['shops']['data'][Index]
                                ['link']);
                              },
                              text: 'View More',
                            ),
                            GFButton(
                              color: GFColors.SECONDARY,
                              onPressed: () async {
                                if (snapshot.data['shops']['data'][Index]
                                ['map'] !=
                                    '') {
                                  await showDialog(
                                      context: context,
                                      builder: (_) => GFFloatingWidget(
                                          child: GFAlert(
                                              type: GFAlertType.fullWidth,
                                              title: snapshot.data['shops']
                                              ['data'][Index]['title'],
                                              contentChild: GFImageOverlay(
                                                  height: 350,
                                                  width: 700,
                                                  image: AssetImage(
                                                      "assets/data/images/" +
                                                          snapshot.data['shops']
                                                          ['data']
                                                          [Index]['map'])),
                                              bottombar: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: <Widget>[
                                                  new GFButton(
                                                    color: GFColors.DANGER,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              ))));
                                }
                              },
                              text: 'View Map',
                            )
                          ],
                        ));
                  }),
            )
          ]);
        } else {
          return GFLoader();
        }
      });
}

Widget getFood(context) {
  return FutureBuilder(
      future: aGetRetail(context),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data['food']['data'].length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return GFCard(
                      boxFit: BoxFit.cover,
                      titlePosition: GFPosition.start,
                      title: GFListTile(
                        titleText: snapshot.data['food']['data'][Index]
                        ['title'],
                        subtitleText: snapshot.data['food']['data'][Index]
                        ['subtitle'],
                      ),
                      content:
                      Text(snapshot.data['food']['data'][Index]['desc']),
                      image: Image.asset("assets/data/images/" +
                          snapshot.data['food']['data'][Index]['img']),
                      buttonBar: GFButtonBar(
                        children: <Widget>[
                          GFButton(
                            onPressed: () {
                              launch(
                                  snapshot.data['food']['data'][Index]['link']);
                            },
                            text: 'View More',
                          ),
                          GFButton(
                            color: GFColors.SECONDARY,
                            onPressed: () async {
                              if (snapshot.data['food']['data'][Index]['map'] !=
                                  '') {
                                await showDialog(
                                    context: context,
                                    builder: (_) => GFFloatingWidget(
                                        child: GFAlert(
                                            type: GFAlertType.fullWidth,
                                            title: snapshot.data['food']['data']
                                            [Index]['title'],
                                            contentChild: GFImageOverlay(
                                                height: 350,
                                                width: 700,
                                                image: AssetImage(
                                                    "assets/data/images/" +
                                                        snapshot.data['food']
                                                        ['data'][Index]
                                                        ['map'])),
                                            bottombar: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: <Widget>[
                                                new GFButton(
                                                  color: GFColors.DANGER,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            ))));
                              }
                            },
                            text: 'View Map',
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ]);
        } else {
          return GFLoader();
        }
      });
}

Widget getDepartures(context) {
  List<String> columns = ['Airline', 'FLIGHT #', 'DESTINATION', 'DEPART'];
  return FutureBuilder(
    future: aGetDepartures(context),
    // ignore: missing_return
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData && !snapshot.hasError) {
        return Container(
          child: DataTable(
              showBottomBorder: true,
              columnSpacing: 8.0,
              columns: columns
                  .map((e) => DataColumn(
                  label: Text(e,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))))
                  .toList(),
              rows: [
                ...snapshot.data.map((e) => DataRow(cells: [
                  DataCell(Text(e['provider'])),
                  DataCell(Text(e['flightNumber'])),
                  DataCell(Text(e['departureAirport']['name'])),
                  DataCell(Text(e['departureTime'].split("T")[0] +
                      "\n" +
                      e['departureTime'].split("T")[1].split("Z")[0])),
                ]))
              ]),
        );
      } else {
        return GFLoader();
      }
    },
  );
}

Widget getArrivals(context) {
  List<String> columns = ['Airline', 'FLIGHT #', 'From', 'DUE'];
  return FutureBuilder(
    future: aGetArrivals(context),
    // ignore: missing_return
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData && !snapshot.hasError) {
        return Container(
          child: DataTable(
              showBottomBorder: true,
              columnSpacing: 8.0,
              columns: columns
                  .map((e) => DataColumn(
                  label: Text(e,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))))
                  .toList(),
              rows: [
                ...snapshot.data.map((e) => DataRow(cells: [
                  DataCell(Text(e['provider'])),
                  DataCell(Text(e['flightNumber'])),
                  DataCell(Text(e['arrivalAirport']['name'])),
                  DataCell(Text(e['arrivalTime'].split("T")[0] +
                      "\n" +
                      e['arrivalTime'].split("T")[1].split("Z")[0])),
                ]))
              ]),
        );
      } else {
        return GFLoader();
      }
    },
  );
}

Widget getHelpContent(context) {
  return FutureBuilder(
      future: aGetHelp(context),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasError && snapshot.hasData) {
          return TabBarView(
              children: snapshot.data
                  .map<Widget>((e) => Column(children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: e['questions'].length,
                      itemBuilder: (BuildContext ctxt, int Index) =>
                          GFAccordion(
                              title: e['questions'][Index]['text'],
                              contentChild: Container(
                                  height: 200,
                                  width: 400,
                                  child: Markdown(
                                    selectable: true,
                                    data: e['questions'][Index]['markdown'],
                                    extensionSet: md.ExtensionSet(
                                      md.ExtensionSet.gitHubFlavored
                                          .blockSyntaxes,
                                      [
                                        md.EmojiSyntax(),
                                        ...md.ExtensionSet.gitHubFlavored
                                            .inlineSyntaxes
                                      ],
                                    ),
                                    onTapLink: (text, url, title) =>
                                    {launch(url)},
                                    styleSheet: MarkdownStyleSheet(
                                      textAlign: WrapAlignment.start,
                                      p: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black
                                              .withOpacity(0.8)),
                                    ),
                                  ))),
                    ))
              ]))
                  .toList());
        } else {
          return GFLoader();
        }
      });
}

Widget getHelpTabs(context) {
  return FutureBuilder(
      future: aGetHelp(context),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          final List<Widget> tabs = snapshot.data
              .map<Widget>((e) => Tab(
            child: Text(
              e['title'],
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ))
              .toList();
          return Container(
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: tabs));
        } else {
          return GFLoader();
        }
      });
}

Widget getDests(context) {
  return FutureBuilder(
    future: aGetDests(context),
    builder: (context, snapshot) {
      if (snapshot.hasData && !snapshot.hasError) {
        return Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    var indx = Index;
                    return GFCard(
                        boxFit: BoxFit.cover,
                        titlePosition: GFPosition.start,
                        title: GFListTile(
                          titleText: snapshot.data[Index]['name'],
                          icon: GFIconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () =>
                              {launch(snapshot.data[Index]['link'])}),
                        ),
                        buttonBar: GFButtonBar(children: <Widget>[
                          GFAccordion(
                            title: 'Show More',
                            contentChild: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data[Index]['subs'].length,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return GFListTile(
                                    titleText: snapshot.data[indx]['subs']
                                    [Index]['name'],
                                    icon: IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () => {
                                          launch(snapshot.data[indx]['subs']
                                          [Index]['link'])
                                        }),
                                  );
                                }),
                          )
                        ]));
                  }))
        ]);
      } else {
        return GFLoader();
      }
    },
  );
}