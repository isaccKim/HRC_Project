import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;

class ToDayRun {
  double distance = 0;
  double pace = 0;
  double time = 0;
}

class Daily extends StatefulWidget {
  Daily({Key? key}) : super(key: key);

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),

//Stack - text : Today Run / distance / time / pace
          child: Stack(
            children: <Widget>[
//Today Run
              Positioned(
                left: 10,
                top: 30,
                child: grad.GradientText(
                  'Last Running',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
// Distance
              Positioned(
                right: 30,
                top: 113,
                child: grad.GradientText(
                  'Distance : ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
// time
              Positioned(
                left: 30,
                bottom: 70,
                child: grad.GradientText(
                  'Time : ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
// pace
              Positioned(
                right: 50,
                bottom: 70,
                child: grad.GradientText(
                  'Pace : ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromARGB(79, 195, 159, 231)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    ;
  }
}
