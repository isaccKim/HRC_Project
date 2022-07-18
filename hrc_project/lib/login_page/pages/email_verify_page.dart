// ignore_for_file: prefer_const_constructors

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
                  '인증 이메일 전송 요청하기',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
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

              SizedBox(height: MediaQuery.of(context).size.height * 0.25),

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
