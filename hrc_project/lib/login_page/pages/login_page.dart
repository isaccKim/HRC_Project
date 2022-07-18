// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../running_main/showmap.dart';
import 'email_verify_page.dart';
import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    // // loading circle
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EmailVerify();
            },
          ),
        );
      }
    } catch (e) {
      // // pop the loading circle
      // Navigator.of(context).pop();
      //  email or password error
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
                          '경고',
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
                        '이메일 혹은 비밀번호를 확인해 주십시오.',
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

    // // pop the loading circle
    // Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // HRC Logo
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

                  //  password textField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            color: Color.fromRGBO(129, 97, 208, 0.75),
                          ),
                          onTap: () => _passwordController.clear(),
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
                        hintText: 'Password',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),

                  Column(
                    children: [
                      //  Sign in button
                      GestureDetector(
                        onTap: signIn,
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
                                color: Color.fromARGB(255, 158, 232, 249),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
