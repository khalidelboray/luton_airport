import 'package:luton_airport/comp/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('London Luton Airport - Home'),
      ),
      drawer: MyDrawer(),
      body: Center(

        child: Column(
          children: [
            ListTile(
              title: Text(
                'Welcome to LLA',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(
                child: Markdown(
                    selectable: true,
                    data:
                    'At London Luton Airport, you’ll find a wide range of cheap holidays and flights, all in one place. Why spend hours browsing for different suppliers when you can find all the best flights, hotels and holidays from London Luton Airport right here? Whether you’re looking for a full holiday, a hotel, or just a flight, we’ve got you covered. Just enter your destination and the dates of your holiday, and we’ll find exactly what you’re looking for. Fancy a [city break](https://travel.london-luton.co.uk/city-breaks)? Or maybe a [last-minute getaway](https://travel.london-luton.co.uk/last-minute-holidays)? Perhaps you’d prefer a bit of hard-earned [winter sun](https://travel.london-luton.co.uk/winter-sun-holidays)? Whatever your preference, you’ll be able to choose from a variety of cheap holidays and flights from London Luton Airport. While you’re here, don’t forget to sign up for our [newsletter](https://travel.london-luton.co.uk/newsletter-sign-up) to be kept up to date with all our latest special offers',
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                      ],
                    ),
                    onTapLink: (text, url, title) => {launch(url)},
                    styleSheet: MarkdownStyleSheet(
                      textAlign: WrapAlignment.start,
                      p: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.8)
                      ),
                    )
                )
            )
          ],
        ),
      ));
}