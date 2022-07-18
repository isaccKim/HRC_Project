// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/main.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0),
            content: Container(
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
                          '알림',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        '비밀번호 재설정 이메일이 발송되었습니다.',
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
    } on FirebaseAuthException catch (e) {
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
                          '경고',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    //Flexible widget 메시지 내용에 따라 유연하게 Text 위치 조정
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.message.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Center(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Enter your Email and we will send you a password reset link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  //  email textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            color: Color.fromRGBO(129, 97, 208, 0.75),
                          ),
                          onTap: () => _emailController.clear(),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Email address',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: passwordReset,
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
                          'Reset password',
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
            ),
          ),
        ),
      ),
    );
  }
}
