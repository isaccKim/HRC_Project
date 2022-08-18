// ignore_for_file: prefer_const_constructors

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../auth/auth_page.dart';
import '/dialog_page/show_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _emailController.dispose();
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.of(context).pop();
    return true;
  }

  Future passwordReset() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // pop the loading circle
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context, rootNavigator: true).pop();
      });

      Future.delayed(const Duration(milliseconds: 900), () {
        //  Reset password email alert
        showDialog(
            context: context,
            builder: (context) {
              return flexibleDialog(context, 200, 30, '알림', 15,
                  '비밀번호 재설정 이메일이\n발송되었습니다.', 17, () {}, () {}, () {}, () {});
            });
      });
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context, rootNavigator: true).pop();
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        //  Email form alert
        showDialog(
            context: context,
            builder: (context) {
              return flexibleDialog(context, 200, 30, '알림', 15,
                  e.message.toString(), 15, () {}, () {}, () {}, () {});
            });
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
                    padding: EdgeInsets.only(left: 20, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
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

                  //  HRC Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SvgPicture.asset(
                          'image/Logo.svg',
                          height: 80,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text.rich(
                      TextSpan(
                        text: 'Enter your ',
                        children: const [
                          TextSpan(
                            text: 'ID(email)',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          TextSpan(
                            text: ' and we will send you a password reset link',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  //  email textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' ID(email)',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        TextField(
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
                      ],
                    ),
                  ),

                  //  SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.28),

                  //  Reset password email send button
                  GestureDetector(
                    onTap: () {
                      // WidgetsBinding.instance.addPostFrameCallback(
                      //   (_) async {
                      //     await showDialog(
                      //       barrierDismissible: false,
                      //       context: context,
                      //       builder: (context) {
                      //         return Center(child: CircularProgressIndicator());
                      //       },
                      //     );
                      //   },
                      // );
                      HapticFeedback.heavyImpact();
                      passwordReset();
                    },
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
