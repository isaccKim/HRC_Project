import 'package:flutter/material.dart';
import 'package:hrc_project/ranking_board_page/distance_ranking.dart';
import 'package:hrc_project/ranking_board_page/time_ranking.dart';

class RankingBoardPage extends StatefulWidget {
  const RankingBoardPage({Key? key}) : super(key: key);

  @override
  State<RankingBoardPage> createState() => _RankingBoardPageState();
}

class _RankingBoardPageState extends State<RankingBoardPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 35, 25, 60),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 35, 25, 60),
              elevation: 0,
              toolbarHeight: 10,
              bottom: const TabBar(
                unselectedLabelColor: Colors.blue,
                labelColor: Colors.red,
                indicator: BoxDecoration(
                  color: Colors.black,
                ),
                tabs: [
                  Tab(
                    icon: Icon(Icons.directions_car),
                    text: 'Time',
                  ),
                  Tab(
                    icon: Icon(Icons.directions_car),
                    text: 'Distance',
                  ),
                ],
              ),
            ),
            body: const TabBarView(children: [
              TimeRank(),
              DistanceRank(),
            ]),
          )),
    );
  }
}
