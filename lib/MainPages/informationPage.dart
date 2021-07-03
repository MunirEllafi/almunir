import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/UniversalWidgets.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
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
          children: <Widget>[
            title(
                'حول التطبيق', false, Colors.white, CrossAxisAlignment.center),
            SizedBox(height: 50),
            title('المصادر', false, Colors.white, CrossAxisAlignment.end),
            cards(
                false,
                'احصائيات فايروس كورونا مصدرها موقع worldometers الّذي يعتمد على \'المركز الوطني لمكافحة الأمراض _ ليبيا\' كمرجع له',
                'https://www.worldometers.info/coronavirus/country/libya/',
                'https://www.facebook.com/NCDC.LY/',
                'زيارة الأول'),
            SizedBox(height: 25),
            cards(
                true,
                'ارقام النجدة مصدرها صفحة   \'منظمة حقول حرة\'',
                'https://www.facebook.com/FreeFieldsFoundation/',
                '',
                'زيارة الصفحة'),
            SizedBox(height: 25),
            cards(true, 'الايقونات المستخدمة من موقع \'iconfinder\'',
                'https://www.iconfinder.com/Wichai_Wi', '', 'زيارة الموقع'),
            SizedBox(height: 25),
            cards(
                true,
                'ايقونة التطبيق والصورة المستخدمة في الواجهة الرئيسية مصدرها موقع \'freepik\'',
                'https://www.freepik.com/free-photos-vectors/people',
                '',
                'زيارة الموقع'),
            SizedBox(height: 25),
            cards(true, 'بعض الرموز المستخدمة مصدرها مكتبة \'Font Awesome\'',
                'https://fontawesome.com/6?next=%2F', '', 'زيارة الموقع'),
            SizedBox(height: 25),
            cards(
                true,
                'صور الالغام المستخدمة صور للتوضيح فقط وليست ملك لمبرمج التطبيق',
                'https://fontawesome.com/6?next=%2F',
                'no',
                ''),
            SizedBox(height: 15),
            title('تواصل مع المبرمج', false, Colors.white,
                CrossAxisAlignment.end),
            cards(true, 'تواصل مع المبرمج عن طريق البريد الالكتروني', 'mail',
                '', 'من هنا'),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget cards(one, content, firstUrl, secondUrl, btnText) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'munirelafi@gmail.com',
      query:
          'subject=Message from Libya Services&body=', //add subject and body here
    );
    if (firstUrl == 'mail') {
      firstUrl = params.toString();
    }
    return RoundedWidget(
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flex(
              textDirection: TextDirection.rtl,
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(
                    content,
                    style: TextStyle(color: Colors.orange, fontSize: 14),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                secondUrl != 'no'
                    ? Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            callButton(() async {
                              if (await canLaunch(firstUrl)) {
                                launch(firstUrl);
                              } else {}
                            }, btnText, Colors.white, Colors.orange),
                            !one
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(height: 5),
                                      callButton(() {
                                        launch(secondUrl);
                                      }, 'زيارة الثاني', Colors.white,
                                          Colors.orange),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        Colors.white);
  }
}
