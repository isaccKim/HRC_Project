import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        elevation: 0,
        title: Text('이메일 인증'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AuthPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text(
                '인증 이메일 전송 요청하기',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: FirebaseAuth.instance.currentUser!.sendEmailVerification,
            icon: Icon(Icons.email),
            label: Text('인증 이메일 전송'),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
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
                      backgroundColor: Colors.white,
                      child: Container(
                          height: 100,
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 30,
                                color: Colors.deepPurpleAccent,
                                child: Center(
                                  child: Text(
                                    '오류',
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              Center(
                                child: Text(
                                  '이메일 인증을 완료해 주세요.',
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
            icon: Icon(Icons.email),
            label: Text('로그인 하기'),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurpleAccent),
          ),
        ],
      )),
    );
  }
}
