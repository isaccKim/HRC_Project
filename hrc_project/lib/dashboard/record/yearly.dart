import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:hrc_project/dashboard/widget_source/source.dart';

//-------------------------variable , function------------------------
DateTime? _selected;

String yearText(DateTime dt) {
  var text = DateFormat('yyyy');
  return text.format(dt);
}

List<String> yearDocsId = [];
Map<int, double> yearRecord = {};
List<FlSpot> _data = [];

double findMaxinMap(Map<int, double> mp) {
  double max = 0.0;
  for (var element in mp.entries) {
    max = element.value > max ? element.value : max;
  }
  return max;
}

Future getYearlyIdData() async {
  yearDocsId.clear();
  if (_selected != null) {
    await FirebaseFirestore.instance
        .collection('test_data')
        .orderBy('date', descending: false)
        .where('date', isGreaterThan: DateTime(_selected!.year - 1, 12, 31))
        .where('date',
            isLessThanOrEqualTo: DateTime(
              _selected!.year + 1,
            ))
        .get()
        .then(((value) => value.docs.forEach((element) {
              yearDocsId.add(element.reference.id);
            })));
  } else {
    await FirebaseFirestore.instance
        .collection('test_data')
        .orderBy('date', descending: false)
        .where('date', isGreaterThan: DateTime(DateTime.now().year - 1, 12, 31))
        .where('date', isLessThanOrEqualTo: DateTime(DateTime.now().year + 1))
        .get()
        .then(((value) => value.docs.forEach((element) {
              yearDocsId.add(element.reference.id);
            })));
  }
}

void recordUpdate(Map<int, double> mp, Timestamp timestamp, double dist) {
  int keys = int.parse(DateFormat('M').format(timestamp.toDate()));
  if (mp.containsKey(keys)) {
    mp.update(keys, (value) => value + double.parse(dist.toStringAsFixed(2)));
  } else {
    mp[keys] = dist;
  }
}

void mapToList(Map<int, double> mp, List<FlSpot> list) {
  for (int i = 1; i <= 12; i++) {
    if (mp.containsKey(i)) {
      double yPoint = double.parse(mp[i]!.toDouble().toStringAsFixed(2));
      list.add(FlSpot(i.toDouble(), yPoint));
    } else {
      list.add(FlSpot(i.toDouble(), 0));
    }
  }
}

//-------------------------- Main Box Widget-------------------------
class Yearly extends StatefulWidget {
  Yearly({Key? key}) : super(key: key);

  @override
  State<Yearly> createState() => _YearlyState();
}

class _YearlyState extends State<Yearly> {
  @override
  Widget build(BuildContext context) {
    //main box
    return Container(
      decoration: boxdeco,
      height: MediaQuery.of(context).size.height * 0.64,
//-------------title widget-------------------
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//title : yearly running
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
                  'Yearly Running ',
                ),
// Text : year (ex. 2022)
                Row(
                  children: [
                    if (_selected == null)
                      Text(
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          yearText(DateTime.now()))
                    else
                      Text(
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        yearText(_selected!),
                      ),
// select year widget
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Select Year"),
                                content: Container(
                                  // Need to use container to add size constraint.
                                  width: 300,
                                  height: 300,
                                  child: YearPicker(
                                    firstDate: DateTime(DateTime.now().year, 1),
                                    lastDate:
                                        DateTime(DateTime.now().year + 3, 1),
                                    initialDate: DateTime.now(),
                                    // save the selected date to _selectedDate DateTime variable.
                                    // It's used to set the previous selected date when
                                    // re-showing the dialog.
                                    selectedDate: _selected == null
                                        ? DateTime.now()
                                        : _selected!,
                                    onChanged: (DateTime dateTime) {
                                      // close the dialog when year is selected.
                                      Navigator.pop(context);
                                      setState(() {
                                        _selected = dateTime;
                                      });
                                      // Do something with the dateTime selected.
                                      // Remember that you need to use dateTime.year to get the year
                                    },
                                  ),
                                ),
                              );
                            },
                          );
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
          const Divider(height: 20),
          //------------------chart------------------
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: YearChart(),
            ),
          ),
        ],
      ),
    );
  }
}

//------------------ year chart / record widget ------------------------
class YearChart extends StatefulWidget {
  YearChart({Key? key}) : super(key: key);

  @override
  State<YearChart> createState() => _YearChartState();
}

class _YearChartState extends State<YearChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

//chart widget
  Widget _YearChart(Map<int, double> mp, BuildContext contxt) {
    int currentIndex = 0;
    _data.clear();
    yearRecord.clear();

    double sumDist = 0;
    int sumTime = 0;
    double sumPace = 0;
    return FutureBuilder(
      future: getYearlyIdData(),
      builder: (context, snapshot) {
        final data = FirebaseFirestore.instance.collection('test_data');

        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: yearDocsId.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: data.doc(yearDocsId[index]).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> temp =
                        snapshot.data!.data() as Map<String, dynamic>;
                    recordUpdate(yearRecord, temp['date'],
                        double.parse(temp['distance'].toStringAsFixed(2)));

                    sumDist +=
                        double.parse(temp['distance'].toStringAsFixed(2));
                    sumTime += double.parse(temp['time'].toString()).toInt();
                    sumPace += double.parse(temp['pace'].toStringAsFixed(2));

                    if (currentIndex == yearDocsId.length - 1) {
                      mapToList(yearRecord, _data);

                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: LineChart(mainData()),
                            ),
                          ),
                          Divider(
                              height:
                                  MediaQuery.of(context).size.height * 0.035),
// sum of year record
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  ChartPage_Distance(context),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                    '${sumDist.toStringAsFixed(2)} km',
                                    style: const TextStyle(
                                        color:
                                            // Color.fromARGB(255, 99, 214, 124),
                                            Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ChartPage_Running_duration(context),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                    '$sumTime hr',
                                    style: const TextStyle(
                                        color:
                                            // Color.fromARGB(255, 99, 214, 124),
                                            Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ChartPage_Running_pace(context),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Text(
                                    '${(double.parse(sumPace.toStringAsFixed(2)) / yearDocsId.length).toStringAsFixed(2)} m/s',
                                    style: const TextStyle(
                                        color:
                                            // Color.fromARGB(255, 99, 214, 124),
                                            Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 234, 241, 247),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Jan', style: style);
        break;
      case 3:
        text = const Text('Mar', style: style);
        break;
      case 5:
        text = const Text('May', style: style);
        break;
      case 7:
        text = const Text('Jul', style: style);
        break;
      case 9:
        text = const Text('Sep', style: style);
        break;
      case 11:
        text = const Text('Nov', style: style);
        break;
      default:
        text = const Text('');
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
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: findMaxinMap(yearRecord),
      lineBarsData: [
        LineChartBarData(
          spots: _data,
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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(0, 255, 255, 255)),
        child: _YearChart(yearRecord, context),
      ),
    );
  }
}
