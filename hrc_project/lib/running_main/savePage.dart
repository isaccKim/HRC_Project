// ignore_for_file: prefer_const_constructors, sort_child_properties_last, import_of_legacy_library_into_null_safe, unnecessary_new

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hrc_project/nav_bar/navigation_bar.dart';
import 'package:hrc_project/ranking_board_page/read_data/get_rc_data.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
import 'util.dart';
import 'package:carousel_slider/carousel_slider.dart';

double? t_distance;
double? t_pace;
double? t_t;
double? running_rate = null;
final List numbers = [
  ['calorie', '0', 'kcal'],
  ['distance', '0', 'km'],
  ['pace(km/h)', '0', 'pace'],
  ['time', ' ', 'minute']
];

String saveDay() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('EEEE MMMM dd Run');
  strToday = formatter.format(now);
  return strToday;
}

String? test;
List<String> docsId = [];
String recent_doscs_id = '0';
Future getRunDocs() async {
  final user = await FirebaseAuth.instance.currentUser;
  docsId.clear();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('running record')
      //  데이터 정렬!!
      .orderBy('date', descending: true)
      .get()
      .then(
        (snapshot) => snapshot.docs.forEach(
          (doccument) {
            docsId.add(doccument.reference.id);
          },
        ),
      );
  if (docsId.length != 0) {
    recent_doscs_id = docsId[0];
    _getOneData();
  }
}

Future _getOneData() async {
  final user = await FirebaseAuth.instance.currentUser;
  final userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('running record')
      .doc(recent_doscs_id);

  await userData.get().then(
        (value) => {
          numbers[1][1] = value['distance'].toStringAsFixed(2),
          numbers[2][1] = value['pace'].toStringAsFixed(2),
          numbers[3][1] = value['time'].toString(),
        },
      );
}

class savePage extends StatefulWidget {
  const savePage({Key? key}) : super(key: key);

  @override
  State<savePage> createState() => _savePageState();
}

class _savePageState extends State<savePage> with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double _value = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: Stack(
        children: [
          Column(
            children: [
              FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 30),
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
                                    Row(
                                      children: [
                                        Text(
                                          user_name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6),
                                        Row(
                                          children: [
                                            Container(
                                              child: InkWell(
                                                child: Image.asset(
                                                    'image/save.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1),
                                                onTap: () {
                                                  updateRunningRate();
                                                  _updateRCData();
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return NavigationBarPage();
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      getToday(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Positioned(
                          child: Row(children: [
                            Text(
                              '    ' + saveDay(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.005,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Positioned(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //gage cardx
                            ],
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.3),
                          items: [0, 1].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 1.3,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    color: Color.fromARGB(0, 18, 13, 65)
                                        .withOpacity(0.8),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Personal Record',
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  Image.asset(
                                                    'image/trophy.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  Text(
                                                    'Goal',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
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
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: Center(
                                                child:
                                                    new LinearPercentIndicator(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  animation: true,
                                                  lineHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.01,
                                                  animationDuration: 2000,
                                                  percent: prc[i],
                                                  barRadius:
                                                      Radius.circular(20),
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                  progressColor:
                                                      Colors.greenAccent,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  ),
                                                  Text(
                                                    '${sum_record[i][1]}',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.015,
                                                  ),
                                                  Image.asset(
                                                    'image/distance.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  Text(
                                                    '${sum_record[i][2]}',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.26,
                                                  ),
                                                  Text(
                                                    getMonth(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                   SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                  Image.asset(
                                                    'image/run.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        // Goal Container
                        FutureBuilder(
                          future: (_getRcData()),
                          builder: (context, snapshot) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(0, 65, 188, 226)
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.14,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.03,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'image/trophy.png',
                                        width: MediaQuery.of(context).size.width *
                                            0.09,
                                        height: MediaQuery.of(context).size.width *
                                            0.09,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.01,
                                      ),
                                      Text(
                                        'RC Goal: 100km ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color.fromARGB(255, 41, 39, 39),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.03,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              Text(
                                                'Current: ${u_rc_distance}km',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                              ),
                                              Text(
                                                '${(u_rc_distance/30*100).toStringAsFixed(2)}%',
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
                                            padding: EdgeInsets.only(top: 3),
                                            child: Center(
                                              child: new LinearPercentIndicator(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                animation: true,
                                                lineHeight: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                animationDuration: 2000,
                                                percent: prc[0],
                                                barRadius: Radius.circular(20),
                                                linearStrokeCap:
                                                    LinearStrokeCap.roundAll,
                                                progressColor: Colors.greenAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                        FutureBuilder(
                            future: getRunDocs(),
                            builder: (context, snapshot) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 24.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: numbers.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24.0))),
                                        color: Color.fromARGB(0, 78, 240, 119)
                                            .withOpacity(0.8),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                  Image.asset(
                                                    'image/run.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                  Text(
                                                    numbers[i][0],
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              numbers[i][1],
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 80),
                                              child: Container(
                                                child: Text(
                                                  numbers[i][2],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            RatingBar.builder(
   initialRating: 3,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 5,
   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) => Image.asset('image/run_blue.png'),
  //  Icon(
  //    Icons.star,
  //    color: Colors.amber,
  //  ),
   onRatingUpdate: (rating) {
     running_rate = rating;
   },
)
                        // Image.asset('image/star.png',
                        //     width: MediaQuery.of(context).size.width * 0.14,
                        //     height: MediaQuery.of(context).size.width * 0.14),
                        // Text(
                        //   'Intensity',
                        //   style: TextStyle(
                        //       fontSize: 8,
                        //       fontStyle: FontStyle.italic,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white),
                        // )
                      ],
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomCircularProgress extends CustomPainter {
  final double value;

  CustomCircularProgress({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCenter(center: center, width: 170, height: 170),
      vmath.radians(120),
      vmath.radians(260),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Color.fromARGB(31, 216, 213, 213)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 20,
    );
    canvas.saveLayer(
      Rect.fromCenter(center: center, width: 200, height: 200),
      Paint(),
    );

    const Gradient gradient = SweepGradient(
      startAngle: 1.25 * math.pi / 2,
      endAngle: 5.5 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: <Color>[
        Colors.blueAccent,
        Colors.lightBlueAccent,
      ],
    );
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 170, height: 170),
      vmath.radians(120),
      vmath.radians(dist * 3 * value),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..shader = gradient
            .createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
        ..strokeWidth = 20,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FilledRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double radius;
  final Color color;
  FilledRadio(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      this.radius = 16,
      this.color = const Color(0xFF49EF3E)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onChanged(this.value);
        },
        child: Container(
          height: this.radius * 2,
          width: this.radius * 2,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: color,
          ),
          child: Center(
            child: Container(
              height: (this.radius * 2) - 8,
              width: (this.radius * 2) - 8,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: value == groupValue
                    ? color
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Future updateRunningRate() async {
Util ut = new Util();
final user = await FirebaseAuth.instance.currentUser;

final userData =
      await FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('running record')
      .doc(recent_doscs_id)
      .update({
    'running_rate': running_rate
  });
}

_getRcData() async {
  final rcData =
      await FirebaseFirestore.instance.collection('rc').doc(u_rc);
  await rcData.get().then(
        (value) => {
          u_rc_distance = value['sum_distance'],
        }, 
      );
}

Future _updateRCData() async {
final rcData =
      await FirebaseFirestore.instance.collection('rc').doc(u_rc);
  await rcData.update({
    'temp': 32.1,
  });
  //u_sum_dist += double.parse((dist / 1000).toStringAsFixed(2));
}
