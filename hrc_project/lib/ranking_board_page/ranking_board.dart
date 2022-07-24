import 'package:flutter/material.dart';

class RankingBoardPage extends StatefulWidget {
  const RankingBoardPage({Key? key}) : super(key: key);

  @override
  State<RankingBoardPage> createState() => _RankingBoardPageState();
}

class _RankingBoardPageState extends State<RankingBoardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
          child: Center(
        child: Text(
          "Ranking!!!",
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
          ),
        ),
      )),
    );
  }
}
