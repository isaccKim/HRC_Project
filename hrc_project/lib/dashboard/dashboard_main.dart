import 'package:flutter/material.dart';
import 'package:hrc_project/dashboard/daily/dailyData.dart';
import 'package:hrc_project/dashboard/weekly/weeklyData.dart';
import 'package:hrc_project/dashboard/daily/dailyrun.dart';
import 'package:hrc_project/dashboard/monthly/monthly.dart';
import 'package:hrc_project/dashboard/weekly/weekly.dart';

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
            Divider(height: MediaQuery.of(context).size.height * 0.02),
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
                      MainBox.getContainer(Monthly()),
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
                      Column(
                        children: [
                          Divider(
                            height: MediaQuery.of(context).size.height * 0.035,
                          ),
                          Expanded(child: DailyRecord()),
                        ],
                      ),
                      Column(
                        children: [
                          Divider(
                            height: MediaQuery.of(context).size.height * 0.035,
                          ),
                          WeeklyRecord()
                        ],
                      ),
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
