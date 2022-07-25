import 'package:flutter/material.dart';

class PersonrankWidget extends StatefulWidget {
  @override
  _PersonrankWidgetState createState() => _PersonrankWidgetState();
}

class _PersonrankWidgetState extends State<PersonrankWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator PersonrankWidget - COMPONENT

    return Container(
        width: 330,
        height: 120,
        child: Stack(children: <Widget>[
          Container(
              width: 330,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color.fromRGBO(46, 36, 70, 1),
              )),
          Text(
            'user nickname',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Inter',
                fontSize: 16,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          Text(
            '00:00',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Inter',
                fontSize: 25,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          Text(
            'n th',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontFamily: 'Inter',
                fontSize: 45,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                    begin: Alignment(2.3651448799455466e-8, 0.8379887938499451),
                    end: Alignment(-0.8379887938499451, 2.3651656633205675e-8),
                    colors: [
                      Color.fromRGBO(149, 0, 186, 1),
                      Color.fromRGBO(61, 90, 230, 0)
                    ]),
              )),
        ]));
  }
}
