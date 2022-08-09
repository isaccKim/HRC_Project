import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:hrc_project/running_main/counter.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';


final List numbers = [
  ['calorie', '124', 'kcal'],
  ['distance', '4.34', 'km'],
  ['pace', '5.55', 'pace'],
  ['time', '22:30', 'minute']
];

class startcounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
///
/// Home page
///
class start extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<start> {
  // Controller
  final CountdownController _controller =
      new CountdownController(autoStart: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(230, 205, 110, 252),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Countdown(
              controller: _controller,
              seconds: 5,
              build: (_, double time,) => Text(
                time.toInt().toString(),
                style: TextStyle(
                  fontSize: 100,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JostSemi',
                ),
              ),
              onFinished: (){
                Navigator.pop(context);
                     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return stop();
                              },
                            ),
                          );
              },
              interval: Duration(seconds: 1),
            ),
          ],
        ),
      ),
    );
  }
}