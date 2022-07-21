// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrc_project/login_page/pages/email_verify_page.dart';
import 'package:hrc_project/login_page/pages/forgot_pw_page.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/setting_page/setting_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPage> {
  int _selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ForgotPasswordPage(),
    MapSample(),
    EmailVerify(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true,
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

      bottomNavigationBar: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Color.fromRGBO(159, 101, 230, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color.fromRGBO(46, 36, 70, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: GNav(
                    tabBorderRadius: 45,
                    duration:
                        Duration(milliseconds: 10), // tab animation duration
                    backgroundColor: Color.fromRGBO(46, 36, 70, 1),
                    color: Colors.white,
                    activeColor: Colors.white,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 16, bottom: 16),
                    gap: 8,
                    iconSize: 35,
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
