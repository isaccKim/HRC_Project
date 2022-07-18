import 'package:flutter/material.dart';
import 'dart:async';

final distance = 4.23;

class counter extends StatefulWidget {
  const counter({Key? key}) : super(key: key);

  @override
  State<counter> createState() => _counterState();
}

class _counterState extends State<counter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 75, 221, 201),
      body: MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 75, 221, 201),
      body: Center(
        child: MyStopWatch(),
      ),
    );
  }
}

class MyStopWatch extends StatefulWidget {
  @override
  _MyStopWatchState createState() => _MyStopWatchState();
}

class _MyStopWatchState extends State<MyStopWatch> {
  bool isStartPressed = false;
  bool isStopPressed = false;
  bool isResetPressed = false;
  String timeValue = "00:00:00";
  Stopwatch stopwatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void callTimer() {
    Timer(duration, keepRunningStopWatch);
  }

  void keepRunningStopWatch() {
    setState(() {
      timeValue = getStopwatchValue();
    });
    callTimer();
  }

  String getStopwatchValue() {
    return (stopwatch.elapsed.inHours.toString().padLeft(2, "0") +
        ":" +
        (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
        ":" +
        (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0"));
  }

  void startStopWatch() {
    setState(() {
      isStartPressed = true;
    });
    stopwatch.start();
    callTimer();
    // window.console.debug('startStopwatch called');
  }

  void stopStopWatch() {
    stopwatch.stop();
  }

  void resetStopWatch() {
    stopwatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 75, 221, 201),
      body: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    child: Text(
                      timeValue,
                      style: TextStyle(
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      'time',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 71, 71, 71),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 100,
              ),
              Column(
                children: [
                  Container(
                    child: Text(
                      '5.55..',
                      style: TextStyle(
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      'pace',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 71, 71, 71),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Center(
            child: Container(
              child: Text(
                '$distance',
                style: TextStyle(
                    fontSize: 90,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Text(
              'km',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 30,
                color: Color.fromARGB(255, 71, 71, 71),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            child: Image.asset('image/stop_btn.png'),
          )
        ],
      ),
    );
  }

  Widget getButtons() {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          RaisedButton(
              child: Text('Start'),
              onPressed: () {
                startStopWatch();
              }),
          RaisedButton(
              child: Image.asset(
                'image/play_btn.png',
                width: 50,
                height: 50,
              ),
              onPressed: () {
                stopStopWatch();
              }),

          // RaisedButton(
          //   child:Text('Reset'),
          //   onPressed:(){resetStopWatch();}
          // )
        ]));
  }
}
