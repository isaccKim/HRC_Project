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

class Weekly extends StatelessWidget {
  const Weekly({Key? key}) : super(key: key);

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
                grad.GradientText(
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  'Weekly Running ',
                  gradient: textGradient,
                ),
                TestTitle()
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
            child: WeeklyChart(),
          ),
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
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.42,
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(0, 255, 255, 255)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              // child: FutureBuilder(
              //     future: getData(),
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.done) {
              //     return Text(
              //         '$testMap\n ${formatTimeStamp(titleFirstOfWeek)} ~ ${formatTimeStamp(titleEndOfWeek)}');
              //   }
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }),
              child: testWidget(result, context),
            ),
          ),
        ),
      ],
    );
  }

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
      maxY: 10,
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
}

List<FlSpot> weeks = [
  // 0 : Sun ~ 6 ; Sat
  FlSpot(2, 0),
  FlSpot(4, 0),
  FlSpot(6, 0),
  FlSpot(8, 0),
  FlSpot(10, 0),
  FlSpot(12, 0),
  FlSpot(14, 0)
];

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

Future getData() async {
  testId.clear();
  await FirebaseFirestore.instance
      .collection('test_data')
      //  데이터 정렬!!
      .orderBy('date', descending: false)
      .where('date', isGreaterThan: titleFirstOfWeek)
      .where('date', isLessThanOrEqualTo: titleEndOfWeek)
      .get()
      .then(((value) => value.docs.forEach((element) {
            testId.add(element.reference.id);
          })));
  // setState(() {
  //   testMap;
  // });
}

void mapToList(Map mp, List list) {}

Widget testWidget(Map<int, double> result, BuildContext context) {
  result.clear();
  return FutureBuilder(
    future: getData(),
    builder: (context, snapshot) {
      final data = FirebaseFirestore.instance.collection('test_data');
      return ListView.builder(
        itemCount: testId.length,
        itemBuilder: (context, index) {
          return FutureBuilder<DocumentSnapshot>(
            future: data.doc(testId[index]).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> temp =
                    snapshot.data!.data() as Map<String, dynamic>;
                updates(
                    result, convertTimeStamp(temp['date']), temp['distance']);
                print("${result.toString()} : $index");
                return Text("${result.toString()} : $index");

                // weeks.add(dataToXY(convertTimeStamp(temp['date']),
                //     temp['distacne']));
              }
              return SizedBox.shrink();
            },
          );
        },
      );
    },
  );
}
