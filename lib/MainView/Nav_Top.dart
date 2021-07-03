import 'package:flutter/material.dart';
import 'package:almunir/MainPages/MinesPage.dart';
import 'package:almunir/MainPages/informationPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../MainPages/HomePage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  Widget view = mainView();
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'خدمات ليبيا',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: view,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            switch (index) {
              case 0:
                {
                  setState(() {
                    view = InformationPage();
                  });
                }
                break;
              case 1:
                {
                  setState(() {
                    view = emergency_page();
                  });
                }
                break;
              case 2:
                {
                  setState(() {
                    view = mainView();
                  });
                }
                break;
            }
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.deepOrange,
          selectedIconTheme: IconThemeData(size: 26),
          unselectedItemColor: Colors.orange,
          selectedLabelStyle:
              TextStyle(color: Colors.orangeAccent, fontSize: 0),
          items: [
            BottomNavigationBarItem(
              title: Text("حول"),
              icon: Icon(
                Icons.info_outline,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('الطوارئ'),
              icon: Icon(
                FontAwesomeIcons.firstAid,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("الرئيسية"),
              icon: Icon(
                Icons.home,
              ),
            ),
          ]),
    );
  }
}
