import 'package:flutter/material.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:hrc_project/dashboard/record/dailyrun.dart';
import 'package:hrc_project/dashboard/record/monthly.dart';
import 'package:hrc_project/dashboard/record/weekly.dart';
import 'package:hrc_project/dashboard/record/yearly.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 35, 25, 60),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'image/profile_1.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'test',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'test',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: SizedBox(
                height: 54,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(63, 16, 99, 0.55),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: TabBar(
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    indicator: tapindicator,
                    labelColor: Color.fromARGB(255, 115, 192, 247),
                    unselectedLabelColor: Color.fromARGB(255, 152, 134, 246),
                    tabs: const [
                      Tab(
                        text: 'Day',
                      ),
                      Tab(
                        text: 'Week',
                      ),
                      Tab(
                        text: 'Month',
                      ),
                      Tab(
                        text: 'Year',
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                child: Expanded(
                  child: TabBarView(
                    children: [
                      DailyMain(),
                      Weekly(),
                      MainBox.getContainer(Monthly()),
                      MainBox.getContainer(Yearly()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainBox extends Container {
  static Widget getContainer(Widget body) {
    return Container(decoration: boxdeco, child: body);
  }

  static Widget setContainer(Widget body, double heights) {
    return Container(decoration: boxdeco, height: heights, child: body);
  }
}
