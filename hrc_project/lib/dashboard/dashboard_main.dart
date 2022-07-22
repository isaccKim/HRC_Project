import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrc_project/dashboard/chart/rundata_list.dart';
import 'package:hrc_project/dashboard/dailyrun.dart';
import 'package:hrc_project/dashboard/weekly.dart';

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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
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
                    indicator: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(235, 149, 230, 0.33),
                          Color.fromRGBO(175, 136, 235, 0.38),
                          Color.fromRGBO(143, 165, 243, 0.31),
                        ]),
                        borderRadius: BorderRadius.circular(25.0)),
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: Expanded(
                  child: TabBarView(
                    children: [
                      MainBox.getContainer(Daily()),
                      MainBox.getContainer(Weekly()),
                      MainBox.getContainer(Weekly()),
                      MainBox.getContainer(Weekly()),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Expanded(
                  child: TabBarView(
                    children: [
                      DailyRecord(),
                      Text('test2'),
                      Text('test3'),
                      Text('test4'),
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
  static BoxDecoration boxdeco = BoxDecoration(
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
  );

  static Widget getContainer(Widget body) {
    return Container(decoration: boxdeco, child: body);
  }
}
