// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/dialog_page/show_dialog.dart';

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

      //  Reset password email alert
      showDialog(
          context: context,
          builder: (context) {
            return flexibleDialog(context, 200, 30, '알림', 15,
                '비밀번호 재설정 이메일이\n발송되었습니다.', 17, () {}, () {}, () {}, () {});
          });
    } on FirebaseAuthException catch (e) {
      //  Email form alert
      showDialog(
          context: context,
          builder: (context) {
            return flexibleDialog(context, 200, 30, '알림', 15,
                e.message.toString(), 15, () {}, () {}, () {}, () {});
          });
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
                            FocusScope.of(context).unfocus();
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
                    child: TextField(
                      // onSubmitted: ((value) {
                      //   passwordReset();
                      // }),
                      keyboardType: TextInputType.emailAddress,
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

                  //  SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),

                  //  Reset password email send button
                  GestureDetector(
                    onTap: passwordReset,
                    child: Container(
                      width: (MediaQuery.of(context).size.width * 0.6),
                      height: 45,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: const [
                              Color.fromRGBO(129, 97, 208, 0.75),
                              Color.fromRGBO(186, 104, 186, 1)
                            ]),
                      ),
                      child: Center(
                        child: Text(
                          'Send an email',
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
