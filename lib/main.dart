import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainView/Nav_Top.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'خدمات ليبيا',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange,
          textTheme: GoogleFonts.cairoTextTheme(
            Theme.of(context).textTheme,
          ),
      ),
      routes: {
        '/': (context) => MyHomePage(),
      },
    );
  }
}
