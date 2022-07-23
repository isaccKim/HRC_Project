// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

Dialog alternativeDialog(
  BuildContext context,
  double boxHeight,
  double topBarHeight,
  String topBarText,
  double topBarTextSize,
  String mainText,
  double mainTextSize,
  Function executableFuc1,
  Function executableFuc2,
  Function executableFuc3,
  Function executableFuc4,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: topBarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(129, 97, 208, 0.75),
                      Color.fromRGBO(186, 104, 186, 1)
                    ]),
              ),
              child: Center(
                child: Text(
                  '$topBarText',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: topBarTextSize,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '$mainText',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: mainTextSize,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          executableFuc1();
                          executableFuc2();
                          executableFuc3();
                          executableFuc4();
                        },
                        child: Text('예')),
                    SizedBox(width: 50),
                    TextButton(
                        onPressed: () {
                          //  pop the alert
                          Navigator.of(context).pop();
                        },
                        child: Text('아니요'))
                  ],
                )
              ],
            )
          ],
        )),
  );
}

Dialog felxibeDialog() {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(129, 97, 208, 0.75),
                      Color.fromRGBO(186, 104, 186, 1)
                    ]),
              ),
              child: Center(
                child: Text(
                  '경고',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            //Flexible widget 메시지 내용에 따라 유연하게 Text 위치 조정
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
  );
}
