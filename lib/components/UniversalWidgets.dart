import 'dart:async';
import 'package:flutter/material.dart';

Widget title(title, div, color, cross) {
  return Column(
    crossAxisAlignment: cross,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 25, 5),
        child: Text(
          title,
          style: TextStyle(
              color: color,
              fontSize: cross == CrossAxisAlignment.center ? 24 : 18,
              fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
      div == true ? divide(15.0, 0.0) : Container(),
    ],
  );
}

Widget divide(_indent, _height) {
  return Column(
    children: <Widget>[
      SizedBox(height: _height),
      Divider(
        height: 2,
        thickness: 1,
        indent: _indent,
        endIndent: _indent,
      ),
    ],
  );
}

Widget callButton(pressed, text, _color, textColor) {
  return RoundedWidget(
      FlatButton(
        onPressed: pressed,
        color: _color,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
      _color);
}

List<Color> backgroundColors() {
  List<Color> _colors = [];
  var i = 900;
  while (i > 0) {
    _colors.add(Colors.orange[i]);
    i -= 100;
  }
  return _colors;
}

class imageSlideView extends StatelessWidget {
  List<String> imageList;
  double height;
  bool reverse;
  bool slideShow;

  imageSlideView(
      {@required this.imageList,
      @required this.height,
      @required this.reverse,
      @required this.slideShow});

  PageController _controller = new PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (slideShow) {
      Timer.periodic(Duration(seconds: 5), (t) {
        reveresCheck(reverse);
      });
    }
    return Stack(children: <Widget>[
      Container(
          height: height,
          width: double.infinity,
          child: PageView(
              reverse: reverse,
              controller: _controller,
              onPageChanged: (index) {
                _index = index;
              },
              children: imageList
                  .map((e) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(e), fit: BoxFit.contain)),
                      ))
                  .toList())),
      Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              direction: Axis.horizontal,
              children: <Widget>[
                navButton(Icons.arrow_back_ios, () {
                  reveresCheck(reverse);
                }),
                navButton(Icons.arrow_forward_ios, () {
                  reveresCheck(!reverse);
                })
              ]))
    ]);
  }

  Widget navButton(icon, func) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Container(
        height: 150,
        width: 30,
        color: Colors.white.withOpacity(0.08),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  void reveresCheck(revered) {
    if (revered) {
      if (_index < imageList.length - 1) {
        _index++;
      } else {
        _index = 0;
      }
    } else {
      if (_index > 0) {
        _index--;
      } else {
        _index = imageList.length - 1;
      }
    }
    if (_controller.hasClients) {
      _controller.animateToPage(_index,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget RoundedWidget(_child, _color) {
  return Material(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    elevation: 10.0,
    color: _color,
    clipBehavior: Clip.antiAlias,
    child: _child,
  );
}
