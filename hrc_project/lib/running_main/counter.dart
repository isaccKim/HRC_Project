// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hrc_project/running_main/stop.dart';
import 'package:hrc_project/running_main/temp.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final distance = 0;


class counter extends StatefulWidget {
  @override
  _counterScreenState createState() => _counterScreenState();
}

String timeValue = "00:00:00";

class _counterScreenState extends State<counter> {
  

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
                      'ss',
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
                width: MediaQuery.of(context).size.width / 6,
              ),
              Column(
                children: [
                  Container(
                    child: Text(
                      'ss',
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
                '0',
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
            child: InkWell(
              child: Image.asset('image/stop_btn.png', width: 100, height: 100),
              onTap: () {
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
            ),
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
              child: Image.asset(
                'image/play_btn.png',
                width: 50,
                height: 50,
              ),
              onPressed: () {
                ;
              }),
        ]));
  }
}
