// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../auth/auth_page.dart';

class StartpageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 101, 50, 230),
      body: Container(
        child: Stack(
          children: [
            //background image
            Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/Backgroundimage.png'),
                    fit: BoxFit.fitHeight,
                    opacity: 175,
                  ),
                ),
              ),
            ),
            //  Logo image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Container(
                      width: 202,
                      height: 108,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('image/Logo1.png'),
                            fit: BoxFit.fitWidth),
                      )),
                ),
              ],
            ),
            //  start button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AuthPage();
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.6),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Color.fromRGBO(129, 97, 208, 0.75),
                                  Color.fromRGBO(186, 104, 186, 1)
                                ]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
