// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/login_page/pages/login_page.dart';
import '../../running_main/showmap.dart';
import '../auth/auth_page.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  String user_name = '';
  String email = '';
  File? user_image;

  Future _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then(
          (value) => {
            user_name = value['user_name'],
            email = value['email'],
            user_image = value['user_image'],
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
          child: Column(
        children: [
          // page back arrow
          Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AuthPage();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              //  HRC Logo
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/Logo1.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
              SizedBox(height: 50),
              Container(
                child: Text(
                  'Request to send authentication email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 40),

              //  Verify Button
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: Color.fromARGB(255, 46, 36, 80),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        return Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                Icons.add,
                                size: 45,
                                color: Colors.grey,
                              ),
                              radius: 62,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: user_image != null
                                  ? FileImage(user_image!)
                                  : null,
                            ),
                            Text('${user_name}'),
                          ],
                        );
                      })
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.white.withOpacity(0),
                        child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Color.fromRGBO(129, 97, 208, 0.75),
                                          Color.fromRGBO(186, 104, 186, 1)
                                        ]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '알림',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22),
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      '이메일이 발송 되었습니다.\n메일함에 보이지 않는다면 스팸함을 확인하여 주십시오.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  );
                },
                icon: Icon(Icons.email),
                label: Text('인증 이메일 전송'),
                style:
                    ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
              ),

              SizedBox(height: 70),

              //  Sign in button
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.currentUser!.reload();
                  if (FirebaseAuth.instance.currentUser!.emailVerified) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MapSample();
                        },
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.white.withOpacity(0),
                          child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Color.fromRGBO(129, 97, 208, 0.75),
                                            Color.fromRGBO(186, 104, 186, 1)
                                          ]),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '오류',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 22),
                                  Center(
                                    child: Text(
                                      '이메일 인증을 완료하여 주십시오.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  }
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
                  child: Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
