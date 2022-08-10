import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:fl_chart/fl_chart.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:intl/intl.dart';

import '../read_data/get_weekly_data.dart';

DateTime now = DateTime.now();
int currentDay = now.weekday;
DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
DateTime endOfWeek =
    now.add(Duration(days: DateTime.daysPerWeek - now.weekday - 1));

DateTime date1 = firstDayOfWeek;
DateTime date2 = endOfWeek;

DateTime titleFirstOfWeek = date1;
DateTime titleEndOfWeek = date2;

String convertTimeStamp(Timestamp timestamp) {
  var text = DateFormat('EE');
  return text.format(timestamp.toDate());
}

String formatTimeStamp(DateTime t) {
  var text = DateFormat('MM/dd/EE');
  return text.format(t);
}

List<FlSpot> weeks = [
  // 0 : Sun ~ 6 ; Sat
];

class Weekly extends StatefulWidget {
  Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  @override
  Widget build(BuildContext context) {
    date1 = firstDayOfWeek;
    date2 = endOfWeek;
    return Container(
      decoration: boxdeco,
      height: MediaQuery.of(context).size.height * 0.64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: prefer_const_constructors
                Text(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  'Weekly Running ',
                ),
                SelectDate(),
              ],
            ),
          ),
          Divider(height: MediaQuery.of(context).size.height * 0.035),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: const WeeklyChart()),
          ),
          Divider(height: MediaQuery.of(context).size.height * 0.035),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(children: [
              ChartPage_Distance(context),
              Divider(height: 15, color: Colors.white.withOpacity(0))
            ]),
            Column(children: [
              ChartPage_Running_duration(context),
              Divider(height: 15, color: Colors.white.withOpacity(0))
            ]),
            Column(children: [
              ChartPage_Running_pace(context),
              Divider(height: 15, color: Colors.white.withOpacity(0))
            ]),
          ])
        ],
      ),
    );
  }
}

//Chart
class WeeklyChart extends StatefulWidget {
  const WeeklyChart({Key? key}) : super(key: key);

  @override
  _WeeklyChartState createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(0, 255, 255, 255)),
        child: _MakeChart(result, context),
      ),
    );
  }

//Axis Title
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 234, 241, 247),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('Sun', style: style);
        break;
      case 4:
        text = const Text('Mon', style: style);
        break;
      case 6:
        text = const Text('Tue', style: style);
        break;
      case 8:
        text = const Text('Wed', style: style);
        break;
      case 10:
        text = const Text('Thur', style: style);
        break;
      case 12:
        text = const Text('Fri', style: style);
        break;
      case 14:
        text = const Text('Sat', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

//Chart data
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color.fromARGB(0, 255, 255, 255),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color.fromARGB(0, 255, 255, 255),
            strokeWidth: 2,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 0)),
      minX: 2,
      maxX: 14,
      minY: 0,
      maxY: findMaxinMap(result),
      lineBarsData: [
        LineChartBarData(
          spots: weeks,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  Future getData() async {
    testId.clear();
    await FirebaseFirestore.instance
        .collection('test_data')
        .orderBy('date', descending: false)
        .where('date', isGreaterThan: titleFirstOfWeek)
        .where('date', isLessThanOrEqualTo: titleEndOfWeek)
        .get()
        .then(((value) => value.docs.forEach((element) {
              testId.add(element.reference.id);
            })));
  }

  Widget _MakeChart(Map<int, double> results, BuildContext context) {
    Record_Weekly.dist = 0;
    Record_Weekly.pace = 0;
    Record_Weekly.t = 0;
    int currentIndex = 0;
    results.clear();
    weeks.clear();
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        final data = FirebaseFirestore.instance.collection('test_data');
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: testId.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: data.doc(testId[index]).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> temp =
                        snapshot.data!.data() as Map<String, dynamic>;
                    updates(result, convertTimeStamp(temp['date']),
                        temp['distance']);
                    // print("${results.toString()} : $index");

                    setState(() {
                      Record_Weekly.dist += temp['distance'];
                      Record_Weekly.t += int.parse(temp['time'].toString());
                      Record_Weekly.pace += temp['pace'];
                    });

                    if (currentIndex == testId.length - 1) {
                      mapToList(mps: results, lists: weeks);
                      // print(weeks.toString());
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: LineChart(mainData()),
                          ));
                    } else {
                      currentIndex++;
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  double findMaxinMap(Map<int, double> mp) {
    double max = 0.0;
    for (var element in mp.entries) {
      max = element.value > max ? element.value : max;
    }
    return max;
  }
}

FlSpot dataToXY(String a, double b) {
  if (a == 'Sun') {
    return FlSpot(2, b);
  } else if (a == 'Mon') {
    return FlSpot(4, b);
  } else if (a == 'Tue') {
    return FlSpot(6, b);
  } else if (a == 'Wed') {
    return FlSpot(8, b);
  } else if (a == 'Thu') {
    return FlSpot(10, b);
  } else if (a == 'Fri') {
    return FlSpot(12, b);
  } else if (a == 'Sat') {
    return FlSpot(14, b);
  }
  return const FlSpot(0, 0);
}

void updates(Map<int, double> mp, String weeksday, double dist) {
  int keys = convertWeeksDaytoKey(weeksday);
  if (mp.containsKey(keys)) {
    mp.update(keys, (value) => value + dist);
  } else
    mp[keys] = dist;
}

int convertWeeksDaytoKey(String weeksday) {
  if (weeksday == 'Sun') {
    return 2;
  } else if (weeksday == 'Mon') {
    return 4;
  } else if (weeksday == 'Tue') {
    return 6;
  } else if (weeksday == 'Wed') {
    return 8;
  } else if (weeksday == 'Thu') {
    return 10;
  } else if (weeksday == 'Fri') {
    return 12;
  } else {
    return 14;
  }
}

List<String> testId = [];
List<double> testDis = [];
Map<String, dynamic> testMap = {};
Map<int, double> result = {};

//데이터 가공  : Map으로 저장했던 running data -> FlSpot List로 바꾸기
void mapToList({required Map<int, double> mps, required List<FlSpot> lists}) {
  for (int keys = 2; keys <= 14; keys += 2) {
    if (mps.containsKey(keys)) {
      lists.add(FlSpot(keys.toDouble(), mps[keys]!.toDouble()));
    } else {
      lists.add(FlSpot(keys.toDouble(), 0));
    }
  }
}

//weekly data 가져오기

class Record_Weekly {
  static double dist = 0;
  static double pace = 0;
  static int t = 0;
}
