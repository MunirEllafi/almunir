import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/UniversalWidgets.dart';
import '../onlineDataGetter/covidData.dart' as getCovid;

class mainView extends StatefulWidget {
  @override
  _mainViewState createState() => _mainViewState();
}

List data;

class _mainViewState extends State<mainView> {
  bool serverError;
  var response;
  String date = '';
  List<Map<String, String>> sympImages = [
    {'image': 'assets/covid/breathing.png', 'description': 'صعوبة في ‏التنفس'},
    {'image': 'assets/covid/cough.png', 'description': 'السعال الجاف'},
    {'image': 'assets/covid/fever.png', 'description': 'حمّى'},
    {'image': 'assets/covid/headache.png', 'description': 'الصداع'},
    {'image': 'assets/covid/tiredness.png', 'description': 'الإرهاق'}
  ];
  List<Map<String, String>> protectImage = [
    {'image': 'assets/covid/washHand.png', 'description': 'غسل اليدين'},
    {'image': 'assets/covid/noTouchingFace.png', 'description': 'لا تلمس وجهك'},
    {'image': 'assets/covid/wearMask.png', 'description': 'ارتدي قناع'},
    {'image': 'assets/covid/handSanitizer.png', 'description': 'تعقيم اليدين'},
    {'image': 'assets/covid/cleanTools.png', 'description': 'تعقيم المقتنيات'},
    {
      'image': 'assets/covid/socialDestancing.png',
      'description': 'التباعد الاجتماعي'
    },
    {'image': 'assets/covid/noTraveling.png', 'description': 'عدم السفر'},
  ];

  Future<void> getData() async {
    if (data != null) {
      setState(() {
        serverError = false;
      });
      return;
    }
    response = await getCovid.initiate();
    if (mounted) {
      if (response != false) {
        setState(() {
          serverError = false;
          data = jsonDecode(response);
        });
      } else {
        setState(() {
          data = null;
          serverError = true;
        });
      }
    }
    date = data[3]['date']
        .toString()
        .replaceRange(0, data[3]['date'].indexOf(':') + 2, '');
  }

  @override
  void initState() {
    getData();
    Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((result) {
      if (mounted) {
        if (result != ConnectivityResult.none) {
          setState(() {
            data = null;
          });
          getData();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.orange,
      onRefresh: () async {
        setState(() {
          data = null;
        });
        getData();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: ClipPath(
                      clipper: MyClipper(),
                      child: Image(
                        image: AssetImage('assets/home.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'خلّيك فالحوش',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  title('آخر التحديثات', false, Colors.white,
                      CrossAxisAlignment.end),
                  Text(
                    date, // 'بتاريخ :${data[3]['date']}'
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(5),
                height: 300,
                child: data == null
                    ? Center(
                        child: SpinKitDualRing(
                          color: Colors.deepOrange,
                        ),
                      )
                    : serverError
                        ? Center(
                            child: Text(
                              'تحقق من الاتصال بالانترنت',
                              style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontSize: 28,
                              ),
                            ),
                          )
                        : Flex(
                            direction: Axis.vertical,
                            children: <Widget>[
                              statusNumber(
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Color.fromRGBO(60, 190, 36, 1.0),
                                    size: 28,
                                  ),
                                  data[2]['value'],
                                  'شفاء',
                                  Color.fromRGBO(60, 190, 36, 1.0),
                                  ''),
                              Divider(
                                color: Colors.deepOrangeAccent,
                                endIndent: 25,
                                indent: 25,
                              ),
                              statusNumber(
                                  Icon(
                                    Icons.offline_bolt,
                                    color: Colors.orange,
                                    size: 28,
                                  ),
                                  data[0]['value'],
                                  'مصاب',
                                  Colors.orange,
                                  data[3]['new']),
                              Divider(
                                color: Colors.deepOrangeAccent,
                                endIndent: 25,
                                indent: 25,
                              ),
                              statusNumber(
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red[600],
                                    size: 28,
                                  ),
                                  data[1]['value'],
                                  'وفاة',
                                  Colors.red[600],
                                  data[3]['death']),
                            ],
                          ),
              ),
              title('طرق الوقاية من فايروس كوفيد-19', false, Colors.white,
                  CrossAxisAlignment.end),
              Container(
                height: 200,
                width: double.infinity,
                child: scrollList(protectImage),
              ),
              title('أعراض الاصابة بفايروس كوفيد-19', false, Colors.white,
                  CrossAxisAlignment.end),
              Container(
                height: 200,
                width: double.infinity,
                child: scrollList(sympImages),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Flex(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        'ظهرت عليك هذه الأعراض؟!',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).devicePixelRatio > 2.5
                                    ? 13
                                    : 16),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: callButton(() {
                        launch("tel://1404"); //0918808233
                      }, 'بلّغ هنا', Colors.orange, Colors.white),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: callButton(() {
                        launch("tel://1415"); //0918808233
                      }, 'او هنا', Colors.orange, Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }

  Widget scrollList(image) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                child: Image.asset(
                  image[i]['image'],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                height: 35,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  image[i]['description'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      wordSpacing: 1.5,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      reverse: true,
      itemCount: image.length,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget statusNumber(topIcon, number, status, textColor, _new) {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                                status == 'مصاب'
                                    ? 'اجمالي الاصابات'
                                    : 'اجمالي حالات ال$status',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: textColor, fontSize: 12))),
                        Expanded(
                            flex: 2,
                            child: Text(number,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 24, color: textColor))),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                                _new != '' ? '$_new+' : 'لا يوجد حالات جديدة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: _new.isEmpty ? 12 : 16))),
                        Expanded(
                          flex: 1,
                          child: Text(
                            status,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              topIcon.icon,
              size: 50,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
