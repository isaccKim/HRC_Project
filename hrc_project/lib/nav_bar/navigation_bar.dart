import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrc_project/ranking_board_page/ranking_board.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/setting_page/setting_page.dart';

import '../dashboard/daysRun.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPage> {
  int selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const RankingBoardPage(),
    MapSample(),
    RunBox(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      extendBody: true,

      //  Test navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.shifting,
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.white,
      //   unselectedItemColor: Colors.white,
      //   onTap: _navigateBottomBar,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.equalizer),
      //       label: 'Ranking',
      //       backgroundColor: Color.fromRGBO(46, 36, 70, 1),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Color.fromRGBO(46, 36, 70, 1),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //       backgroundColor: Color.fromRGBO(46, 36, 70, 1),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Setting',
      //       backgroundColor: Color.fromRGBO(46, 36, 70, 1),
      //     ),
      //   ],
      // )

      //  Gnav bar
      bottomNavigationBar: Container(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 0.2,
                blurRadius: 4,
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Color.fromRGBO(159, 101, 230, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color.fromRGBO(46, 36, 70, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                child: GNav(
                    selectedIndex: 1,
                    tabBorderRadius: 45,
                    haptic: true,
                    duration: const Duration(
                        milliseconds: 450), // tab animation duration
                    backgroundColor: const Color.fromRGBO(46, 36, 70, 1),
                    color: Colors.white,
                    activeColor: Colors.white,
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 16, bottom: 16),
                    gap: 8,
                    iconSize: 30,
                    onTabChange: _navigateBottomBar,
                    tabs: const [
                      GButton(
                        icon: Icons.equalizer,
                        text: 'Ranking',
                      ),
                      GButton(
                        icon: Icons.home,
                        text: 'Home',
                      ),
                      GButton(
                        icon: Icons.person,
                        text: 'Dashboard',
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Setting',
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
