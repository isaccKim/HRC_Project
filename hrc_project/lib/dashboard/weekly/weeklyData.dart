import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;

class WeeklyRecord extends StatefulWidget {
  WeeklyRecord({Key? key}) : super(key: key);

  @override
  State<WeeklyRecord> createState() => _WeeklyRecordState();
}

class _WeeklyRecordState extends State<WeeklyRecord> {
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
                    '12 km',
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
