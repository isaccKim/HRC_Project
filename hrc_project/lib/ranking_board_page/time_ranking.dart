import 'package:flutter/material.dart';

class TimeRank extends StatefulWidget {
  const TimeRank({Key? key}) : super(key: key);

  @override
  State<TimeRank> createState() => _TimeRankState();
}

class _TimeRankState extends State<TimeRank> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: Center(
          child: Text(
            'time ranking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
