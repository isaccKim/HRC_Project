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
          backgroundColor: const Color.fromARGB(255, 35, 25, 60),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 35, 25, 60),
            elevation: 0.8,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size(0, 57),
              child: TabBar(
                overlayColor:
                    MaterialStateProperty.all(Colors.black.withOpacity(0)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                unselectedLabelColor: Colors.grey[500],
                labelColor: Colors.white,
                labelPadding: const EdgeInsets.only(bottom: 5),
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                indicatorPadding: const EdgeInsets.only(bottom: 5),
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Color.fromRGBO(248, 103, 248, 0.7),
                ),
                tabs: const [
                  Tab(
                    text: 'Time',
                    //icon: Icon(Icons.timer_outlined, size: 40),
                  ),
                  Tab(
                    text: 'Distance',
                    //icon: Icon(Icons.north, size: 40),
                  ),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              TimeRank(),
              DistanceRank(),
            ],
          ),
        ),
      ),
    );
  }
}
