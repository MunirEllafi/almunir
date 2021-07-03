import 'package:connectivity/connectivity.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future initiate() async {
  var c = await Connectivity().checkConnectivity();
  var client = Client();
  if ((c != ConnectivityResult.none)) {
    Response response = await client
        .get(Uri.parse('https://www.worldometers.info/coronavirus/country/libya/'));
    var document = parse(response.body);
    List<Element> name = document.querySelectorAll('#maincounter-wrap h1');
    List<Element> value = document.querySelectorAll(
        '#maincounter-wrap span');
    Element newCases =
        document.querySelector('#news_block strong');
    Element newDeath = document.querySelector('strong:nth-child(2)');
    Element date=document.querySelector('#page-top+ div');
    List<Map<String, dynamic>> linkMap = [];
    var i = 0;
    while (i < name.length) {
      linkMap.add({
        'name': name[i].text,
        'value': value[i].text,
      });
      i += 1;
    }
    i = 0;
    String _cases = '';
    while (newCases != null && i < newCases.text.length) {
      if (int.tryParse(newCases.text[i]) != null) {
        _cases += newCases.text[i];
      }
      i++;
    }
    i = 0;
    String _deaths = '';
    while (newDeath != null && i < newDeath.text.length) {
      if (int.tryParse(newDeath.text[i]) != null) {
        _deaths += newDeath.text[i];
      }
      i++;
    }
    linkMap.add({
      'new': _cases,
      'death': _deaths,
      'date':date.text
    });
    client.close();
    return json.encode(linkMap);
  } else {
    return false;
  }
}
