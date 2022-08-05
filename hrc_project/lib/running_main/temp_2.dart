// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/savePage.dart';
import 'package:intl/intl.dart';
import 'counter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:google_fonts/google_fonts.dart';
final username = 'SeowonKim';

String ?tempTime;
DateTime now = DateTime.now();
final DateTime currentTime = new DateTime(now.year, now.month, now.day);



class temp2 extends StatefulWidget {
  @override
  State<temp2> createState() => MapSampleState();
}


class MapSampleState extends State<temp2> {
  final Set<Polyline> polyline = {};
  Location _location = Location();
  
  late GoogleMapController _mapController;
  LatLng _center = const LatLng(0, 0);
  List<LatLng> route = [];

  double _dist = 0;
  late String _displayTime;
  late int _time;
  late int _lastTime;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

@override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

    void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 15)));

      if (route.length > 0) {
        appendDist = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        _dist = _dist + appendDist;
        int timeDuration = (_time - _lastTime);

        if (_lastTime != null && timeDuration != 0) {
          _speed = (appendDist / (timeDuration / 100)) * 3.6;
          if (_speed != 0) {
            _avgSpeed = _avgSpeed + _speed;
            _speedCounter++;
          }
        }
      }
      _lastTime = _time;
      route.add(loc);

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.deepOrange));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 75, 221, 201),
      body: Stack(
        children: [
          Container(
            width: 0,
            height: 0,
          child: GoogleMap(
        polylines: polyline,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11),
      )
      ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 20,
                    height: 80,
                  ),
                  SizedBox(height: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x50C9EF).withOpacity(0.7),
                              const Color(0X53DFA9).withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset:
                                  Offset(0, 10), // changes position of shadow
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width / 1.1,
                        width: 200,
                        margin: EdgeInsets.all(35.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 27,
                            ),
                            Container(
                              child: StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: 0,
                          builder: (context, snap) {
                            _time = snap.data!;
                            _displayTime =
                                StopWatchTimer.getDisplayTimeHours(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeMinute(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeSecond(_time);
                            return Text(_displayTime,
                             style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 30,
                                ),
                                );
                          },
                        )
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 87, 85, 85),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: 300,
                                child: Divider(
                                    color: Color.fromARGB(255, 141, 137, 137),
                                    thickness: 2.0)),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        (_dist / 1000).toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'km',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 92, 89, 89),
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      child: Image.asset('image/play_btn.png',
                                          width: 60, height: 60),
                                      onTap: () {
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return counter();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        _speed.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'pace',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 92, 89, 89),
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      child: Image.asset('image/stop_btn.png',
                                          width: 50, height: 50),
                                      onTap: () {
                                        startcounter();
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return savePage();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}