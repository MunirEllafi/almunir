import 'package:location/location.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../components/UniversalWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

class emergency_page extends StatefulWidget {
  @override
  _emergency_pageState createState() => _emergency_pageState();
}

class _emergency_pageState extends State<emergency_page> {
  List<String> images = [
    'assets/LandMines/claymore.png',
    'assets/LandMines/greenHandGranate.png',
    'assets/LandMines/handGranate.png',
    'assets/LandMines/mortar.png',
    'assets/LandMines/mortar_shells.png',
    'assets/LandMines/other_claymore.png',
    'assets/LandMines/tm-46.png',
    'assets/LandMines/tripwire_mine.png',
  ];
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Location location;

  Future<void> getLocation() async {
    location = new Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  sendMessage(String number) async {
    if (Platform.isAndroid) {
      await launch('sms:' +
          number +
          '?body=يوجد جسم غريب هنا :\n https://maps.google.com/?q=${_locationData.latitude},${_locationData.longitude}');
    } else if (Platform.isIOS) {
      await launch('sms:' +
          number +
          '&body=يوجد جسم غريب هنا :\n https://maps.google.com/?q=${_locationData.latitude},${_locationData.longitude}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: backgroundColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                imageSlideView(
                  imageList: images,
                  height: 350,
                  reverse: true,
                  slideShow: true,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'شفتهم؟! خليك بعيد',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            title('مخلفات حرب او اجسام غريبة', false, Colors.white,
                CrossAxisAlignment.end),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              child: Text(
                'اذا صادف وان رأيت جسم غريب او مخلفات حرب من قذائف او حتى رصاص لا تقترب وضع علامة مميزة لتنبيه الآخرين وقم بالتبليغ فوراً.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                textDirection: TextDirection.rtl,
              ),
            ),
            title('بلًغ عن طريق منظمة حقول حرة', false, Colors.white,
                CrossAxisAlignment.end),
            contact('0924753909', '0217315052', true),
            title('بلًغ عن طريق المركز الليبي', false, Colors.white,
                CrossAxisAlignment.end),
            contact('0918808234', '0918808233', false),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget contact(firstNumber, secondNumber, one) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Text(
            'اتصل',
            style: TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500),
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 5),
              Expanded(
                child: callButton(() {
                  launch("tel://$secondNumber"); //0918808233
                }, 'او هنا', Colors.orange, Colors.white),
                flex: 1,
              ),
              SizedBox(width: 5),
              Expanded(
                child: callButton(() {
                  launch("tel://$firstNumber"); //0918808233
                }, 'هنا', Colors.orange, Colors.white),
                flex: 1,
              ),
              SizedBox(width: 5),
            ],
          ),
          Text(
            'ارسل موقعك',
            style: TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500),
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              !one ? SizedBox(width: 5) : Container(),
              !one
                  ? Expanded(
                      flex: 2,
                      child: callButton(() async {
                        await getLocation();
                        sendMessage("$secondNumber");
                      }, 'او هنا', Colors.orange, Colors.white),
                    )
                  : Container(),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: callButton(() async {
                  await getLocation();
                  sendMessage('$firstNumber');
                }, 'هنا', Colors.orange, Colors.white),
              ),
              SizedBox(width: 5),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
