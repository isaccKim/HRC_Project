import 'package:flutter/material.dart';

class DistanceRank extends StatefulWidget {
  const DistanceRank({Key? key}) : super(key: key);

  @override
  State<DistanceRank> createState() => _DistanceRankState();
}

class _DistanceRankState extends State<DistanceRank> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: Center(
          child: Text(
            'distance ranking',
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
