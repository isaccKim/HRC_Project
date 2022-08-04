// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_count_down.dart';

final username = 'SeowonKim';
var strToday;

String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('#yyyy-MM-dd-EEEE');
  strToday = formatter.format(now);
  return strToday;
}

class MapSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapSample> {
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
    return Scaffold(
        body: Stack(children: [
      Container(
          child: GoogleMap(
        polylines: polyline,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(target: _center, zoom: 15),
      )),
     Padding(
            padding: const EdgeInsets.only(left: 10, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'image/profile_1.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getToday(),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
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
                        offset: Offset(0, 10), // changes position of shadow
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 1.2,
                  margin: EdgeInsets.all(35.0),
                  child: Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 30,),
                          Column(
                            children: [
                              Container(
                                child: Text('Recent',style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      'image/run.png',
                                      width: 50,
                                    ),
                                  ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                child: Text('km :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Text('num :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 75,
                          ),
                          Column(
                            children: [
                              SizedBox(height: 20,),
                              Container(
                                child: Text('kcal :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: Text('pace :',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Column(
                  children: [
                    Positioned(
                      child: InkWell(
                        child: Image.asset('image/run_btn.png',
                            width: 100, height: 100),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return start();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      child: InkWell(
                        child: Image.asset('image/start_btn.png',
                            width: 60, height: 60),
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return start();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    ]));
  }
}
