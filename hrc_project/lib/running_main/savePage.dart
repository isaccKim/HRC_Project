// ignore_for_file: prefer_const_constructors, sort_child_properties_last, import_of_legacy_library_into_null_safe

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/counter.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
//import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math' as math;

final username = 'SeowonKim';
final dist = 4;
String saveDay() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('EEEE MMMM dd Run');
  strToday = formatter.format(now);
  return strToday;
}
final List numbers = [
  ['calorie', '124', 'kcal'],
  ['distance', '4.34', 'km'],
  ['pace', '5.55', 'pace'],
  ['time', '22:30', 'minute']
];

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
      backgroundColor: Color.fromARGB(95, 11, 2, 95),
      body: Stack(
        children: [
          Column(
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
                          Text(
                            '$username',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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

              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 18, 13, 65).withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.height - 100,
                    child: Column(
                      children: [
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
                        Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.width * 0.18,),
                            Container(
                              child: Text(
                                '67 km',
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
                              child: Text('Friday',
                                style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 109, 114, 107),
                                      fontStyle: FontStyle.italic),),
                            ),

                        CustomPaint(
                            painter: CustomCircularProgress(
                                value: controller.value)),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.18,
                        ),
                        Container(
                          child:      Text('Steps',
                              style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 142, 214, 120),
                                    fontStyle: FontStyle.italic),),
                        ),
                        Container(
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
                                  color: Color.fromARGB(255, 155, 114, 221),
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 113, 200, 206),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                              Row(
                                children:[ 
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.08,
                                  ),
                                  Image.asset('image/run_blue.png',
                                  width: MediaQuery.of(context).size.width * 0.06,
                                  height: MediaQuery.of(context).size.width * 0.06,),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                                  Container(
                                  child: Text(
                                    'Stense',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                ]
                              ),
                                  Padding(
                            padding: const EdgeInsets.only(left:30 ,right: 30),
                            child: SfSlider(
                              min: 1,
                              max: 5,
                              value: _value,
                              interval: 1,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              minorTicksPerInterval: 1,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.04,),
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            //color: Color.fromARGB(255, 71, 255, 215)
                            //  .withOpacity(0.6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Container(
                                   child: InkWell(
                        child: Image.asset('image/profile_1.png',
                            width: 40, height: 40),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MapSample();
                              },
                            ),
                          );
                        },
                      ),
                                ),
                                SizedBox( width : MediaQuery.of(context).size.width*0.03 ),
                                Container(
                                   child: InkWell(
                      child: Text('Save',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(255, 111, 221, 157),
                                  ),
                                  ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MapSample();
                              },
                            ),
                          );
                        },
                      ),
                                ),

                              ],
                            ),

                          ),
                        ),
                      ],
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
}

class CustomCircularProgress extends CustomPainter {
  final double value;

  CustomCircularProgress({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCenter(center: center, width: 170, height: 170),
      vmath.radians(140),
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
      vmath.radians(140),
      vmath.radians(dist*10* value),
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
