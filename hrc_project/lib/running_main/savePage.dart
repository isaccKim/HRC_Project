// ignore_for_file: prefer_const_constructors, sort_child_properties_last, import_of_legacy_library_into_null_safe

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/nav_bar/navigation_bar.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;
import 'util.dart';

double? t_distance;
double? t_pace;
double? t_t;

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
        if(docsId.length!=0){
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
      backgroundColor:  const Color.fromARGB(255, 35, 25, 60),
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
                                      SizedBox(width: MediaQuery.of(context).size.width *
                                                0.4),
                                    Row(
                                      children: [
                                        Container(
                                          child: InkWell(
                                            child: Image.asset('image/run_blue.png',
                                                width: MediaQuery.of(context).size.width*0.05, 
                                                height: MediaQuery.of(context).size.width*0.05),
                                            onTap: () {
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
                                            width: MediaQuery.of(context).size.width *0.02),
                                        Container(
                                          child: InkWell(
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color:
                                                    Color.fromARGB(255, 111, 221, 157),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.08),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sum_record.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0))),
                                        color: Color.fromARGB(0, 18, 13, 65)
                                            .withOpacity(0.8),
                                        child: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.32,
                                                      ),
                                                      Image.asset(
                                                        'image/profile_1.png',
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        height: MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width*0.01,
                                                      ),
                                                      Text(user_name,
                                                      style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                      )
                                                    ],
                                                  ),
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
                                                      '${sum_record[index][4]} %',
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
                                                      percent: prc[index],
                                                      barRadius: Radius.circular(20),
                                                      linearStrokeCap:
                                                          LinearStrokeCap.roundAll,
                                                      progressColor: Colors.greenAccent,
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
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                      ),
                                                      Text(
                                                        '${sum_record[index][1]}',
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
                                                        '${sum_record[index][2]}',
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
                                                        '${sum_record[index][3]}',
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
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          Column(
                            children: [
                              Container(
                                child: Column(children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width * 0.15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.of(context).size.width *
                                                    0.1),
                                        child: Text(
                                          '${numbers[1][1]} km',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Run',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 79, 82, 77),
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  CustomPaint(
                                      painter: CustomCircularProgress(
                                          value: controller.value)),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Container(
                                    child: 
                                        Text(
                                          'Goal',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Color.fromARGB(255, 142, 214, 120),
                                              fontStyle: FontStyle.italic),
                                        ),
                                  ),
                                ]),
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.33,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 57, 59, 155)
                                      .withOpacity(0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                         FutureBuilder(
                future: getRunDocs(),
                builder: (context, snapshot) {
                  return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 24.0),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: numbers.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0))),
                                      color: Color.fromARGB(0, 84, 121, 177)
                                          .withOpacity(0.8),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 100),
                                            child: Container(
                                              child: Text(
                                                numbers[index][0],
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            numbers[index][1],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 80),
                                            child: Container(
                                              child: Text(
                                                numbers[index][2],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Color.fromARGB(255, 0, 0, 0),
                                                ),
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
                }
              ),

                    ],
                );
               }
             ),
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
