// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String user_name = '';
  String email = '';
  String user_image = '';
  double weight = 0;
  double height = 0;

  // Get user data from cloud Firestore
  Future _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then(
          (value) => {
            user_name = value['user_name'],
            email = value['email'],
            user_image = value['user_image'],
            weight = value['weight'],
            height = value['height'],
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //  user profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 46, 36, 80),
                ),
                child: Stack(
                  children: [
                    //  profile setting button (modify)
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.edit,
                              color: Color.fromRGBO(61, 110, 230, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: _getUserData(),
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 21, bottom: 21),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromRGBO(248, 103, 248, 0.95),
                                        Color.fromRGBO(61, 90, 230, 1)
                                      ],
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.grey[200],
                                    foregroundImage: NetworkImage(user_image),
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 75,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${user_name}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${email}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),

            //  user body information section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 46, 36, 80),
                ),
                child: Stack(
                  children: [
                    //  profile setting button (modify)
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.edit,
                              color: Color.fromRGBO(61, 110, 230, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {},
                                    child: RadiantGradientMask(
                                      child: Icon(
                                        Icons.monitor_weight_outlined,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    )),
                                SizedBox(height: 5),
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '${weight} ' + 'kg',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 2,
                              height: 105,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Color.fromRGBO(129, 97, 208, 0.75),
                                        Color.fromRGBO(186, 104, 186, 1)
                                      ]),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {},
                                    child: RadiantGradientMask(
                                      child: Icon(
                                        Icons.height,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    )),
                                SizedBox(height: 5),
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '${height} ' + 'cm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //  Log in and out section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 46, 36, 80),
                ),
                child: Stack(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.outgoing_mail,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.outgoing_mail,
                            color: Colors.white,
                            size: 35,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Send authentication mail',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(61, 90, 230, 1),
          Color.fromRGBO(61, 90, 203, 0.27),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
