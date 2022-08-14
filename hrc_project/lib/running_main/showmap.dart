import 'package:carousel_slider/carousel_slider.dart';
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

var strToday;
late double u_sum_dist;
late String tmep;
late int  u_sum_time;
late int number;
late String u_rc =' ' ;
late double u_rc_distance = 0;

List<String> running_num = [];
var prc = [0.0, 0.0];

final List<dynamic> sum_record = [
  ['0', 'Distance', '0', '0', '0'], //km/number/percent
  ['0', 'Time', '0', '0', '0'], //minute/number/percent
];

Future getUserData() async {
  final user = await FirebaseAuth.instance.currentUser;
  final userData =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid);
  await userData.get().then(
        (value) => {
          user_name = value['user_name'],
          email = value['email'],
          u_sum_dist = value['sum_distance'],
          u_sum_time = value['sum_time'],
          u_rc = value['user_RC'],
        },
      );
  await FirebaseFirestore.instance.collection('users').get().then(
        (snapshot) => snapshot.docs.forEach(
          (doccument) {
            running_num.add(doccument.reference.id);
          },
        ),
      );
  final rcData =
      await FirebaseFirestore.instance.collection('rc').doc('Kuyper');
  await userData.get().then(
        (value) => {
          u_rc_distance = value['sum_distance'],
        },
      );

  number = running_num.length;
  double temp_dist = 1;
  int temp_time = 1;
  double temp_prc = 1;
  sum_record[0][0] = u_rc;
  sum_record[1][0] = u_rc;
  sum_record[0][2] = u_sum_dist.toString() + ' km';
  sum_record[1][2] = (u_sum_time / 3600).toStringAsFixed(2) + ' hours';

  temp_dist = u_sum_dist;
  temp_prc = temp_dist / 30 * 100;
  prc[0] = temp_prc / 100; // 거리 퍼센트
  if (prc[0] > 1) {
    prc[0] = 1.0;
  }
  if(temp_prc>=100)temp_prc=100;
  sum_record[0][4] = temp_prc.toStringAsFixed(1); //temp_prc;
  temp_time = u_sum_time;
  temp_prc = temp_time / 15 * 100 / 3600;
  
  if(temp_prc>=100)temp_prc=100;
  prc[1] = temp_prc / 100; // 시간 퍼센트
  if (prc[1] > 1) {
    prc[1] = 1.0;
  }
  sum_record[1][4] = temp_prc.toStringAsFixed(1); // temp_prc;
}

String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('#yyyy-MM-dd-EEEE');
  strToday = formatter.format(now);
  return strToday;
}

String getMonth() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('MMMM');
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

      if (route.length >= 2) {
        appendDist = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        if (appendDist > 3) {
          _dist = _dist + appendDist;
        }
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
                    user_name,
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
            FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  return CarouselSlider(
                        options: CarouselOptions(height: MediaQuery.of(context).size.height*0.34),
                        items: [0,1].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            color: Color.fromARGB(0, 18, 13, 65)
                                .withOpacity(0.8),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Running Record',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${sum_record[i][0]} RC',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Image.asset(
                                      'image/profile_1.png',
                                      width: 34,
                                      height: 34,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          Text(
                                            'Progress',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                        ),
                                        Text(
                                          '${sum_record[i][4]} %',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(7.0),
                                      child: Center(
                                        child: new LinearPercentIndicator(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.73,
                                          animation: true,
                                          lineHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          animationDuration: 2000,
                                          percent: prc[i],
                                          barRadius: Radius.circular(20),
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          progressColor: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          Text(
                                            '${sum_record[i][1]}',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.015,
                                          ),
                                          Image.asset(
                                            'image/distance.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Text(
                                            '${sum_record[i][2]}',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                          ),
                                          Text(
                                            getMonth(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Image.asset(
                                            'image/run.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          Text(
                                            '${sum_record[i][3]}',
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
                          );
                        }).toList(),
                      );
                }),
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
