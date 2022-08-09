// ignore_for_file: prefer_const_constructors, unnecessary_new, deprecated_member_use, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:hrc_project/running_main/util.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:percent_indicator/percent_indicator.dart';

final username = 'SeowonKim';
var strToday;

final List sum_record = [
  ['Kuyper','Distance','30','5','0.3'],
  ['Kuyper','Time', '48', '5','0.6'],
];

class Goal_data{
  Util ut = new Util();
  void set_data(){
    ut.getUserData();
    int temp = 1;
    int temp_prc = 1;
    
    sum_record[0][2] = ut.u_sum_dist;
    sum_record[1][2] = ut.u_sum_time;

    temp = int.parse(ut.u_sum_dist);
    temp_prc = {temp / 30 * 100} as int;
      sum_record[0][4] = temp_prc;
    temp = int.parse(ut.u_sum_time);
    temp_prc = {temp / 5 * 100} as int;
    sum_record[1][4] = temp_prc;

  }
}


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

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Goal_data gd = new Goal_data();
    gd.set_data;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
                  child: Container(
                            height: MediaQuery.of(context).size.height*0.3,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sum_record.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                  child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                    color:  Color.fromARGB(0, 18, 13, 65).withOpacity(0.8),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height*0.04,
                                        ),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Running Record',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${sum_record[index][0]} RC',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                          SizedBox(height: 20,),
                          Image.asset(
                    'image/profile_1.png',
                    width: 34,
                    height: 34,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Row(
                         children: [
                           SizedBox(
                             width: MediaQuery.of(context).size.width*0.04,
                           ),
                           Text('Progress',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),),
                         ]
                       ),
                       SizedBox(
                         width: MediaQuery.of(context).size.width*0.5,
                       ),
                       Text('${sum_record[index][4]}%',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Center(
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width*0.73,
                    animation: true,
                    lineHeight: MediaQuery.of(context).size.height*0.01,
                    animationDuration: 2000,
                    percent: sum_record[index][4]/100,
                    barRadius: Radius.circular(20),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.greenAccent,
                  ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            ),
            Container(
              child: Row(
                  children: [
                     SizedBox(
                      width: MediaQuery.of(context).size.width*0.05,
                    ),
                    Text('${sum_record[index][1]}',
                    style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                    ),
                     SizedBox(
                      width: MediaQuery.of(context).size.width*0.015,
                    ),
                    Image.asset('image/distance.png',
                          width: MediaQuery.of(context).size.width*0.04,
                          height: MediaQuery.of(context).size.width*0.04,
                          ),
                          SizedBox(
                      width: MediaQuery.of(context).size.width*0.02,
                    ),
                           Text('${sum_record[index][2]} km',
                    style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.26,
                    ),
                    Text('October ',
                    style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                    ),
                    Image.asset('image/run.png',
                          width: MediaQuery.of(context).size.width*0.04,
                          height: MediaQuery.of(context).size.width*0.04,
                          ),
                          SizedBox(
                      width: MediaQuery.of(context).size.width*0.01,
                    ),
                           Text('${sum_record[index][3]}',
                    style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ],
              ),
            )
                  
                      ],
                    ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                ),
                

                SizedBox(
                  height: 70,
                ),
                Center(
                  child: Column(
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
                ),
              ],
            ),
          ),
    ]));
  }
}
