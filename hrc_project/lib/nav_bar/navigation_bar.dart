import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrc_project/dashboard/dashboard_main.dart';
import 'package:hrc_project/dialog_page/show_dialog.dart';
import 'package:hrc_project/ranking_board_page/ranking_board.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/setting_page/setting_page.dart';
import 'package:hrc_project/test.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPage> {
  int selectedIndex = 1;
  //bool isExite = true;

  void _navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const RankingBoardPage(),
    MapSample(), //Map sample
    //MapSample(),
    const DashBoard(),
    const SettingPage(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   BackButtonInterceptor.add(myInterceptor);
  // }

  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   // if (isExite) {
  //   //   isExite = false;
  //   //   showDialog(
  //   //       context: context,
  //   //       builder: (context) {
  //   //         return alternativeDialog(
  //   //           context,
  //   //           200,
  //   //           30,
  //   //           '앱 종료하기',
  //   //           15,
  //   //           '앱을 종료하시겠습니까?',
  //   //           17,
  //   //           Navigator.of(context).pop,
  //   //           SystemNavigator.pop,
  //   //           () {},
  //   //           () {},
  //   //           () {
  //   //             isExite = true;
  //   //           },
  //   //         );
  //   //       });
  //   // }

  //   return true;
  // }

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
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            height: 65,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromRGBO(46, 36, 70, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 4),
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
                  iconSize: 45,
                  onTabChange: _navigateBottomBar,
                  tabs: const [
                    GButton(
                      icon: Icons.equalizer,
                      text: 'Ranking',
                      textStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      textStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Dashboard',
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Setting',
                      textStyle: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
