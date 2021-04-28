import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

ArgResults argResults;
Map dispatch = {
  'help':getHelp,
  'dests':getDestinations,
  'retail':getRetail,
  'flights':getFlights
};
Future<void> main(List<String> arguments) async {
  final scriptPath = dirname(Platform.script.toFilePath());
  final ArgParser argParser = new ArgParser()
    ..addOption('fetch',
        allowed: ['all', 'help', 'dests', 'retail', 'flights'],
        allowedHelp: {
            'help':'Fetch help questions',
            'dests':'Fetch destinations',
            'retail':'Fetch shops & food and drinks stuff',
            'flights':'Fetch departures and arrivals flights',
            'all': 'One For All'
        },
        abbr: 'f',
        defaultsTo: 'all',
        help: 'Set what to fetch from the website, defaults to "all"')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: "Displays this help information.");
  argResults = argParser.parse(arguments);
  if (argResults['help']) {
    print("""
** HELP **
${argParser.usage}
    """);
    exit(0);
  }

  final String task = argResults['fetch'];
  if(task == 'all') {
    for(var key in dispatch.keys) {
      print(argParser.findByNameOrAlias('fetch').allowedHelp[key]);
      var data = await dispatch[key]();
      var pathToFile = join(scriptPath, '..\\assets\\data\\', '$key.json');
      var file = await File(pathToFile).create(recursive: true);
      await file.writeAsString(jsonEncode(data));
    }
  } else {
    print(argParser.findByNameOrAlias('fetch').allowedHelp[task]);
    var data = await dispatch[task]();
    var pathToFile = join(scriptPath, '..\\assets\\data\\', '$task.json');
    var file = await File(pathToFile).create(recursive: true);
    await file.writeAsString(jsonEncode(data));
  }
}

Uri aURI(host,path) {
  return Uri.https(host,path);
}

String urlFor(host,path) {
  return Uri.https(host, path).toString();
}

String textAt(e,selector) {
  return e.querySelector(selector).text.trim();
}

String textFor(e) {
  return e.text.trim();
}
Future<List> getHelp() async {
  List questions;
  final resp = await http.get(aURI('travel.london-luton.co.uk', 'helpme'));
  var document;
  if (resp.statusCode == 200) {
    document = parse(resp.body);
    var sections = document
        .querySelectorAll('.nbf_tpl_pagesection_tab')
        .getRange(1, 7)
        .toList();
    questions = sections.map((e) {
      var id = e.attributes['aria-controls'];
      var qs = document.querySelectorAll('#$id > div > div > h3');
      return {
        'title': textFor(e.children[1]),
        'questions': qs.map((e) {
          var html = e.nextElementSibling.innerHtml;
          var md = html2md.convert(html);
          var regExp = RegExp(r'\[.*?\]\((.*?)\)');
          var matches = regExp.allMatches(md);
          matches.forEach((match) {
            if (match.group(1).toString().startsWith('/')) {
              md = md.replaceAll(match.group(1).toString(),
                  'https://travel.london-luton.co.uk${match.group(1).toString()}');
            }
          });
          return {'text': textFor(e), 'markdown': md};
        }).toList()
      };
    }).toList();
  }
  return questions;
}

Future<List> getDestinations() async {
  List dests;
  final resp =
      await http.get(aURI('travel.london-luton.co.uk', 'destinations'));
  var document;
  if (resp.statusCode == 200) {
    document = parse(resp.body);
    var destsElems =
        document.querySelector('#destinationchildnodes_iter').children;
    dests = destsElems.map((e) {
      var main = e.querySelector(
          '.nbf_tpl_pagesection_linked_norwd.destination_linked > a');
      var subs = e.querySelectorAll(
          '.nbf_tpl_pagesection_linked_norwd.nbf_tpl_it.destchild_linked > a');
      var msubs = subs.map((e) {
        return {
          'link': urlFor('travel.london-luton.co.uk', e.attributes['href']),
          'name': textAt(e,'div > div.nbf_tpl_text.destinationchild')
        };
      }).toList();
      if (e.querySelector(
              '.nbf_tpl_pagesection_conditional.childtab_condition') !=
          null) {
        msubs.addAll(e
            .querySelectorAll(
                '.nbf_tpl_pagesection_linked_norwd.nbf_tpl_it.childnode_linked2')
            .map((s) {
          return {
            'link': urlFor('travel.london-luton.co.uk',
                    s.querySelector('a').attributes['href']),
            'name': textAt(s,'a > div > div.nbf_tpl_text.destinationchild2')
          };
        }).toList());
      }
      return {
        'link': urlFor('travel.london-luton.co.uk', main.attributes['href']),
        'name': textAt(main, 'div > div > h3'),
        'subs': msubs
      };
    }).toList();
  } else {
    print('HTTP Error');
  }
  return dests;
}

Future<Map<String, Map>> getRetail() async {
  final resp = await http
      .get(aURI('www.london-luton.co.uk', 'retail-and-shop-listing'));
  var document;
  var retail = <String, Map<String, List>>{
    'shops': {'filters': [], 'data': []},
    'food': {'filters': [], 'data': []}
  };
  if (resp.statusCode == 200) {
    var mapF = (option) => option.innerHtml.replaceAll(RegExp(r'&amp;'), '&');
    var whereF = (e) => e != 'Filter' && e != 'Clear filters';
    document = parse(resp.body);
    retail['shops']['filters'] = document
        .querySelectorAll('[data-category-filter="shopping"] option')
        .map(mapF)
        .where(whereF)
        .toList();
    retail['food']['filters'] = document
        .querySelectorAll('[data-category-filter="food"] option')
        .map(mapF)
        .where(whereF)
        .toList();
    var fcards = document.querySelectorAll(
        'div.retailListing__tab[data-tab-content="food"] > div.row.retailListing__listings > div > .card');
    retail['food']['data'] = fcards.map((e) {
      var imgSrc = e.getElementsByTagName('img').first.attributes['src'];
      var uri = aURI('www.london-luton.co.uk', imgSrc);
      var fname = imgSrc.split('/').last.split('?').first;
      downloadImage(uri, fname);
      var mapFile = aURI(
          'www.london-luton.co.uk',
          e
              .querySelector(
                  '.card--actions.retailListing--card__actions > a.btn.btn--centre.trigger')
              .attributes['data-image']);
      var mapFileName =
          Uri.decodeFull(mapFile.toString()).split('/').last.split('?').first;

      if (mapFileName != 'www.london-luton.co.uk') {
        downloadImage(mapFile, mapFileName);
      }
      return {
        'img': fname,
        'desc': textAt(e,'.card--content.retailListing--card__content > p'),
        'title': textAt(e,
                'div.card--content.retailListing--card__content > div > div.col.col-8 > h4'),
        'subtitle': textAt(e, '.retailListing__subtitle'),
        'name': e.parent.attributes['data-shopname'],
        'category':
            e.parent.attributes['data-category'].split(';').toSet().toList(),
        'link': e
            .querySelector('.card--actions.retailListing--card__actions > a')
            .attributes['href'],
        'map': mapFileName
      };
    }).toList();
    var scards = document.querySelectorAll(
        'div.retailListing__tab[data-tab-content="shopping"] > div.row.retailListing__listings > div > .card');
    retail['shops']['data'] = scards.map((e) {
      var imgSrc = e.getElementsByTagName('img').first.attributes['src'];
      var uri = aURI('www.london-luton.co.uk', imgSrc);
      var fname = imgSrc.split('/').last.split('?').first;
      downloadImage(uri, fname);
      var mapFile = aURI(
          'www.london-luton.co.uk',
          e
              .querySelector(
                  '.card--actions.retailListing--card__actions > a.btn.btn--centre.trigger')
              .attributes['data-image']);
      var mapFileName =
          Uri.decodeFull(mapFile.toString()).split('/').last.split('?').first;

      if (mapFileName != 'www.london-luton.co.uk') {
        downloadImage(mapFile, mapFileName);
      }
      return {
        'img': fname,
        'desc': textAt(e,'.card--content.retailListing--card__content > p'),
        'title': textAt(e,
                'div.card--content.retailListing--card__content > div > div.col.col-8 > h4'),
        'subtitle': textAt(e, '.retailListing__subtitle'),
        'name': e.parent.attributes['data-shopname'],
        'category':
            e.parent.attributes['data-category'].split(';').toSet().toList(),
        'link': e
            .querySelector('.card--actions.retailListing--card__actions > a')
            .attributes['href'],
        'map': mapFileName
      };
    }).toList();
  }
  return retail;
}

Future<Map<String, List>> getFlights() async {
  final resp = await http.get(aURI('www.london-luton.co.uk', 'flights'));
  var document;
  // ignore: omit_local_variable_types
  Map<String, List> elements = {'departures': [], 'arrivals': []};
  if (resp.statusCode == 200) {
    document = parse(resp.body);
    elements['departures'].addAll(document
        .getElementsByClassName('flight-details saveflightList departures')
        .map((e) => jsonDecode(e.children.last.innerHtml))
        .toList());
  } else {
    throw Exception('Failed to fetch page');
  }
  elements['arrivals'].addAll(document
      .getElementsByClassName('flight-details saveflightList arrivals')
      .map((e) => jsonDecode(e.nextElementSibling.innerHtml))
      .toList());
  return elements;
}

Future<File> downloadImage(Uri url, String filename) async {
  var client = http.Client();
  var req = await client.get(Uri.decodeFull(url.toString()));
  var bytes = req.bodyBytes;
  var pathToFile = join(dirname(Platform.script.toFilePath()),
      '..\\assets\\data\\images\\', filename);
  var file = await File('$pathToFile').create(recursive: true);
  await file.writeAsBytes(bytes);
  return file;
}
