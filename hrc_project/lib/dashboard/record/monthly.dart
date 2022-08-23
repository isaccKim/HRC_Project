import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog.dart';

DateTime currnetTime = DateTime.now();
DateTime? _selected;

String monthlyFormat(DateTime t) {
  var text = DateFormat('yyyy MMMM');
  return text.format(t);
}

class Monthly extends StatefulWidget {
  Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  @override
  Widget build(BuildContext context) {
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
                  'Monthly Running ',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_selected == null)
                      Text(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          monthlyFormat(DateTime.now()))
                    else
                      Text(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        monthlyFormat(_selected!),
                      ),
                    // month selector icon button
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(2022, 7),
                            lastDate: DateTime(
                                DateTime.now().year, DateTime.now().month),
                            initialDate: _selected ?? DateTime.now(),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _selected = date;
                              });
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: MonthlyChart()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: MonthlyRunRecord()),
          ),
        ],
      ),
    );
  }
}

class MonthlyChart extends StatefulWidget {
  MonthlyChart({Key? key}) : super(key: key);

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  Widget _MonthChart(Map<int, double> mp, BuildContext context) {
    int currentIndex = 0;
    monthly.clear();
    runningRecord.clear();

    double monthlyDistance = 0;
    int monthlyrunningTime = 0;
    double monthlyPace = 0;

    return FutureBuilder(
      future: getMonthlyIdData(),
      builder: (context, snapshot) {
        // data : test data , 실제데이터로 수정 필요
        final data = FirebaseFirestore.instance.collection('test_data');
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: runningId.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: data.doc(runningId[index]).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> temp =
                        snapshot.data!.data() as Map<String, dynamic>;
                    recordUpdate(runningRecord, temp['date'],
                        double.parse(temp['distance'].toStringAsFixed(2)));

                    if (currentIndex == runningId.length - 1) {
                      mapToList(runningRecord, monthly);

                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: LineChart(mainData()),
                        ),
                      );
                    } else {
                      currentIndex++;
                      return const SizedBox.shrink();
                    }
                  } else {
                    return SizedBox.shrink();
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
      minX: 1,
      maxX: _selected != null
          ? lastDayOfMonth(_selected!)
          : lastDayOfMonth(currnetTime),
      minY: 0,
      maxY: findMaxinMap(runningRecord),
      lineBarsData: [
        LineChartBarData(
          spots: monthly,
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 234, 241, 247),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 15:
        text = const Text('15', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 25:
        text = const Text('25', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(0, 255, 255, 255)),
        child: _MonthChart(runningRecord, context),
      ),
    );
  }
}

List<String> runningId = [];
Map<int, double> runningRecord = {};
List<FlSpot> monthly = [];

Future getMonthlyIdData() async {
  runningId.clear();
  if (_selected != null) {
    await FirebaseFirestore.instance
        .collection('test_data')
        .orderBy('date', descending: false)
        .where('date', isGreaterThan: _selected)
        .where('date',
            isLessThanOrEqualTo:
                DateTime(_selected!.year, _selected!.month + 1))
        .get()
        .then(((value) => value.docs.forEach((element) {
              runningId.add(element.reference.id);
            })));
  } else {
    await FirebaseFirestore.instance
        .collection('test_data')
        .orderBy('date', descending: false)
        .where('date',
            isGreaterThan: DateTime(DateTime.now().year, DateTime.now().month))
        .where('date',
            isLessThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month + 1))
        .get()
        .then(((value) => value.docs.forEach((element) {
              runningId.add(element.reference.id);
            })));
  }
}

//중복되는 날짜는 값을 합하여 한 기록으로 만들어주는 함수
void recordUpdate(Map<int, double> mp, Timestamp timestamp, double dist) {
  int keys = int.parse(DateFormat('d').format(timestamp.toDate()));
  if (mp.containsKey(keys)) {
    mp.update(keys, (value) => value + double.parse(dist.toStringAsFixed(2)));
  } else {
    mp[keys] = dist;
  }
}

void mapToList(Map<int, double> mp, List<FlSpot> list) {
  int lastDay = _selected == null
      ? lastDayOfMonth(DateTime.now()).toInt()
      : lastDayOfMonth(_selected!).toInt();
  for (int i = 0; i < lastDay; i++) {
    if (mp.containsKey(i + 1)) {
      list.add(FlSpot((i + 1).toDouble(), mp[i + 1]!.toDouble()));
    } else {
      list.add(FlSpot((i + 1).toDouble(), 0));
    }
  }
}

double lastDayOfMonth(DateTime selectMonth) {
  String mth = DateFormat('M').format(selectMonth);
  switch (int.parse(mth)) {
    case 2:
      return 28;
    case 4:
    case 6:
    case 9:
    case 11:
      return 30;
    default:
      return 31;
  }
}

// --------------------------------- monthlyRunning Record Widget ---------------------------------
class MonthlyRunRecord extends StatefulWidget {
  MonthlyRunRecord({Key? key}) : super(key: key);

  @override
  State<MonthlyRunRecord> createState() => _MonthlyRunRecordState();
}

class _MonthlyRunRecordState extends State<MonthlyRunRecord> {
  int currentIndex = 0;
  double sumDist = 0;
  int sumTime = 0;
  double sumPace = 0;

  Widget _MonthlyReocd(BuildContext context) {
    return FutureBuilder(
      future: getMonthlyIdData(),
      builder: (context, snapshot) {
        final data = FirebaseFirestore.instance.collection('test_data');
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: runningId.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: data.doc(runningId[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> temp =
                          snapshot.data!.data() as Map<String, dynamic>;

                      sumDist +=
                          double.parse(temp['distance'].toStringAsFixed(2));

                      sumTime += double.parse(temp['time'].toString()).toInt();

                      // sumPace += double.parse(temp['pace'].toStringAsFixed(2));

                      if (currentIndex == runningId.length - 1) {
                        sumDist = double.parse(sumDist.toStringAsFixed(2));
                        currentIndex = -1;
                        return Text('$sumDist : $sumTime');
                      } else {
                        currentIndex++;
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _MonthlyReocd(context);
  }
}
