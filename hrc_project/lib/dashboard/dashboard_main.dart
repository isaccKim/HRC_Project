import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrc_project/dashboard/summaryBox.dart';
import 'package:hrc_project/dashboard/rundata_list.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  //currentPage - 1 : day / 2 : week / 3 : month / 4 : year
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 35, 25, 60),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Positioned(
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      children: const [
                        SizedBox(
                          height: 60,
                        ),
                        // Image.asset(
                        //   'image/profile_1.png',
                        //   width: 40,
                        //   height: 35,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.70,
                    ),
                    Positioned(top: 100, child: RunBox()),
                    //Day, Week, Year Box
                    Positioned(
                      width: MediaQuery.of(context).size.width * 0.9,
                      top: 75,
                      left: 21,
                      child: SizedBox(
                        height: 54,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(63, 16, 99, 0.55),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        currentPage = 1;
                                      });
                                    },
                                    child: const Text(
                                      'Day',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(210, 241, 255, 236),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        currentPage = 2;
                                      });
                                    },
                                    child: const Text(
                                      'Week',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(210, 241, 255, 236),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        currentPage = 3;
                                      });
                                    },
                                    child: const Text(
                                      'Month',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(210, 241, 255, 236),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        currentPage = 4;
                                      });
                                    },
                                    child: const Text(
                                      'Year',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(210, 241, 255, 236),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 26,
                  color: Colors.red,
                ),
                Expanded(
                  child: BodyLayOut(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
