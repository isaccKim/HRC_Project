import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:hrc_project/dashboard/weekly/weeklyLineChart.dart';

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
          child: grad.GradientText(
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
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: WeeklyChart(),
        ),
      ],
    );
  }
}
