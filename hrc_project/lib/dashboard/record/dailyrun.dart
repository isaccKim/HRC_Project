import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:firebase_core/firebase_core.dart';

class ToDayRun {
  double distance = 0;
  double pace = 0;
  double time = 0;
}

class Daily extends StatefulWidget {
  Daily({Key? key}) : super(key: key);

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),

//Stack - text : Today Run / distance / time / pace
          child: Stack(
            children: <Widget>[
//Today Run
              Positioned(
                left: MediaQuery.of(context).size.width * 0.6,
                top: 20,
                child: IconButton(
                    onPressed: () {
                      double testDist = Random().nextInt(10).toDouble();
                      int testTime = Random().nextInt(4);
                      double testSp = Random().nextInt(5).toDouble();
                      addTestData(testDist, testTime, testSp);
                    },
                    icon: Icon(Icons.add_circle)),
              ),

              Positioned(
                left: 10,
                top: 30,
                child: Column(
                  children: [
                    grad.GradientText(
                      'Daily Running',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromARGB(79, 195, 159, 231)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ],
                ),
              ),
// Distance
              Positioned(
                left: 10,
                top: 250,
                child: grad.GradientText(
                  'Distance : ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
// time
              Positioned(
                left: 10,
                bottom: 100,
                child: grad.GradientText(
                  'Time : ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
// pace
              Positioned(
                right: 60,
                bottom: 100,
                child: grad.GradientText(
                  'Pace : ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    ;
  }
}

class Save extends StatefulWidget {
  Save({Key? key}) : super(key: key);

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  @override
  Widget build(BuildContext context) {
    Image Distance = Image.asset('image/distance.png',
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    Image Running_duration = Image.asset('image/hourglass.png',
        color: Colors.black.withOpacity(0.7),
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    Image Running_pace = Image.asset('image/running-shoe.png',
        color: Colors.black.withOpacity(0.7),
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);
    return Container();
  }
}

final List<String> entries = <String>[];

Future addTestData(
  double dist,
  int t,
  double sp,
) async {
  await FirebaseFirestore.instance.collection('test_data').add({
    'distacne': dist,
    'time': t,
    'pace': sp,
    'date': DateTime.now(),
  });
}
