import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrc_project/ranking_board_page/distance_ranking.dart';
import 'package:hrc_project/ranking_board_page/rc_ranking.dart';
import 'package:hrc_project/ranking_board_page/time_ranking.dart';
import '../dialog_page/show_dialog.dart';

class RankingBoardPage extends StatefulWidget {
  const RankingBoardPage({Key? key}) : super(key: key);

  @override
  State<RankingBoardPage> createState() => _RankingBoardPageState();
}

class _RankingBoardPageState extends State<RankingBoardPage> {
  bool isExite = true;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (isExite) {
      isExite = false;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return alternativeDialog(
              context,
              200,
              30,
              '앱 종료하기',
              15,
              '앱을 종료하시겠습니까?',
              17,
              Navigator.of(context).pop,
              SystemNavigator.pop,
              () {},
              () {},
              () {
                isExite = true;
              },
            );
          });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 35, 25, 60),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 35, 25, 60),
            elevation: 0.8,
            toolbarHeight: 15,
            bottom: PreferredSize(
              preferredSize: const Size(0, 57),
              child: TabBar(
                overlayColor:
                    MaterialStateProperty.all(Colors.black.withOpacity(0)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                unselectedLabelColor: Colors.grey[500],
                labelColor: Colors.white,
                labelPadding: const EdgeInsets.only(bottom: 5),
                labelStyle: const TextStyle(
                    fontFamily: 'JostSemi',
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
                indicatorPadding: const EdgeInsets.only(bottom: 5),
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Color.fromRGBO(248, 103, 248, 0.7),
                ),
                tabs: const [
                  Tab(
                    text: 'Distance',
                    //icon: Icon(Icons.north, size: 40),
                  ),
                  Tab(
                    text: 'Time',
                    //icon: Icon(Icons.timer_outlined, size: 40),
                  ),
                  Tab(
                    text: 'RC',
                  ),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              DistanceRank(),
              TimeRank(),
              RcRank(),
            ],
          ),
        ),
      ),
    );
  }
}
