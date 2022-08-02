import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class Monthly extends StatefulWidget {
  Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 30,
            top: 35,
          ),
          child: Row(
            children: [
              grad.GradientText(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                'Monthly Running',
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromARGB(79, 195, 159, 231)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      months = [];
                      weekly_sum = 0;
                    });
                  },
                  icon: Icon(Icons.cleaning_services))
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: MonthlyChart(),
        ),
      ],
    );
  }
}

class MonthlyRecord extends StatefulWidget {
  MonthlyRecord({Key? key}) : super(key: key);

  @override
  State<MonthlyRecord> createState() => _MonthlyRecordState();
}

class _MonthlyRecordState extends State<MonthlyRecord> {
  final TextStyle _textStyle = TextStyle(
    color: Colors.white.withOpacity(0.9),
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  @override
  Widget build(BuildContext context) {
    //image
    Image Distance = Image.asset('image/distance.png',
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    Image Running_duration = Image.asset('image/hourglass.png',
        color: Colors.black.withOpacity(0.7),
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    Image Running_pace = Image.asset('image/running-shoe.png',
        color: Colors.black.withOpacity(0.7),
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(179, 100, 40, 211).withOpacity(0.74),
            const Color.fromARGB(145, 43, 143, 193)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: Colors.amber.shade100,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Test',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          Divider(height: MediaQuery.of(context).size.height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Distance,
                  const Divider(
                    indent: 10,
                  ),
                  Text(
                    '${weekly_sum} km',
                    style: _textStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Running_duration,
                  const Divider(),
                  Text(
                    '00:00:12',
                    style: _textStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Running_pace,
                  const Divider(
                    indent: 10,
                  ),
                  Text(
                    '5\'22\'\'',
                    style: _textStyle,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({Key? key}) : super(key: key);

  @override
  _MonthlyChartState createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  randomDataCreate() {
    for (int i = 0; i < 31; i++) {
      int test = Random().nextInt(10);
      test = test < 5 ? test + 3 : test;
      weekly_sum += test;
      months.add(FlSpot(i.toDouble(), test.toDouble()));
    }
  }

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
              child: LineChart(
                mainData(),
              ),
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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 234, 241, 247),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    randomDataCreate();
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
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 0)),
      minX: 0,
      maxX: 31,
      minY: 0,
      maxY: 12,
      lineBarsData: [
        LineChartBarData(
          spots: months,
          isCurved: true,
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

List<FlSpot> months = [];

double weekly_sum = 0;
