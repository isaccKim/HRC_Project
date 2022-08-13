// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrc_project/login_page/auth/auth_page.dart';
import 'package:hrc_project/nav_bar/navigation_bar.dart';
import 'email_verify_page.dart';
import 'forgot_pw_page.dart';
import '/dialog_page/show_dialog.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // bool isLogin = true;
  // bool isExite = true;

  //  Signin
  Future signIn() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // loading circle
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          //  pop the loading circle
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          _emailController.clear();
          _passwordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationBarPage();
              },
            ),
          );
        } else {
          //  pop the loading circle
          Navigator.of(context).pop();
          _emailController.clear();
          _passwordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EmailVerify();
              },
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.of(context).pop();

        //  email or password error
        showDialog(
            context: context,
            builder: (context) {
              return flexibleDialog(context, 200, 30, '알림', 15,
                  e.message.toString(), 17, () {}, () {}, () {}, () {});
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return flexibleDialog(context, 200, 30, '알림', 15, '모든 정보를 기입해주십시오.',
                17, () {}, () {}, () {}, () {});
          });
    }
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // if (isExite && isLogin) {
    //   isExite = false;
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return alternativeDialog(
    //           context,
    //           200,
    //           30,
    //           '앱 종료하기',
    //           15,
    //           '앱을 종료하시겠습니까?',
    //           17,
    //           Navigator.of(context).pop,
    //           SystemNavigator.pop,
    //           () {},
    //           () {},
    //           () {
    //             isExite = true;
    //           },
    //         );
    //       });
    // }
    // isLogin = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'JostMain',
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.2),
                  child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return flexibleDialog(context, 210, 30, '알림', 15, '로그인 에러.', 15,
                () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }, () {}, () {}, () {});
          } else if (snapshot.hasData) {
            return NavigationBarPage();
          } else {
            //  Login page
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 35, 25, 60),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // exit icon button
                          Padding(
                            padding: EdgeInsets.only(right: 20, top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    FocusScope.of(context).unfocus();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return alternativeDialog(
                                            context,
                                            200,
                                            30,
                                            '앱 종료하기',
                                            15,
                                            '앱을 종료하시겠습니까?',
                                            17,
                                            Navigator.of(context).pop,
                                            SystemNavigator.pop,
                                            () {},
                                            () {},
                                            () {},
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //  HRC Logo
                          Align(
                            heightFactor: 0.85,
                            child: Row(
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
                          ),

                          SizedBox(height: 30),

                          //  email textField
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
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
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    suffixIcon: GestureDetector(
                                      child: Icon(
                                        Icons.cancel,
                                        color:
                                            Color.fromRGBO(129, 97, 208, 0.75),
                                      ),
                                      onTap: () => _emailController.clear(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
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

                          SizedBox(height: 7),

                          //  password textField
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' Password',
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
                                  onSubmitted: ((value) {
                                    signIn();
                                  }),
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: GestureDetector(
                                      child: Icon(
                                        Icons.cancel,
                                        color:
                                            Color.fromRGBO(129, 97, 208, 0.75),
                                      ),
                                      onTap: () => _passwordController.clear(),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'Password',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 15),

                          //  Forgot Password? comment
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _emailController.clear();
                                    _passwordController.clear();
                                    //isLogin = false;
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ForgotPasswordPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 158, 232, 249),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.23),

                          //  Sign in button
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  signIn();
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width * 0.6),
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

                              SizedBox(height: 20),

                              //  not a member? register now
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Not a member? ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.showRegisterPage,
                                    child: Text(
                                      ' Register now',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 158, 232, 249),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
