// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../running_main/showmap.dart';
import 'email_verify_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userHeightController = TextEditingController();
  final _userWeightController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confrimPasswordController.dispose();
    _userNameController.dispose();
    _userHeightController.dispose();
    _userWeightController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confrimPasswordController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty &&
        _userHeightController.text.isNotEmpty &&
        _userWeightController.text.isNotEmpty) {
      if (_emailController.text.trim().contains('@handong')) {
        if (passwordConfirmed()) {
          final newUser =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          addUserDetails(
            _userNameController.text.trim(),
            _emailController.text.trim(),
            double.parse(_userHeightController.text.trim()),
            double.parse(_userWeightController.text.trim()),
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

          //  data set 방식 함수 호출
          // addUserDetails(
          //   newUser,
          //   _userNameController.text.trim(),
          //   _userHeightController.text.trim(),
          //   _emailController.text.trim(),
          //   int.parse(_userWeightController.text.trim()),
          // );
        } else {
          //  password alert
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
                              '경고',
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: Text(
                            '비밀번호를 다시 확인해 주십시오.',
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
      } else {
        // handong email form alert
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
                            '경고',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          '올바른 이메일 형식이 아닙니다. \n "handong" 이메일이 필요합니다.',
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
                          '경고',
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        '모든 정보를 기입해주세요.',
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
  }

  Future addUserDetails(
      String username, String email, double height, double weight) async {
    await FirebaseFirestore.instance.collection('users').add({
      'user name': username,
      'email': email,
      'height': height,
      'weight': weight,
    });
  }

  //  data set 방식
  // Future addUserDetails(UserCredential newUser, String firstName,
  //     String lastName, String email, int age) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(newUser.user!.uid)
  //       .set({
  //     'first name': firstName,
  //     'last name': lastName,
  //     'email': email,
  //     'age': age,
  //   });
  // }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confrimPasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('image/Logo1.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),

                  SizedBox(height: 30),

                  //  profile section
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          height: 260,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: Color.fromARGB(255, 46, 36, 80),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            'User profile',
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  186, 104, 186, 1), //Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),

                      //  User name textField
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 180, 100, 0),
                        child: TextField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            suffixIcon: GestureDetector(
                              child: Icon(
                                Icons.cancel,
                                color: Color.fromRGBO(129, 97, 208, 0.75),
                              ),
                              onTap: () => _userNameController.clear(),
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
                            hintText: 'User Name',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  //  ID/PW section
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          height: 285,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: Color.fromARGB(255, 46, 36, 80),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            'ID/PW',
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  186, 104, 186, 1), //Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
                        child: Column(
                          children: [
                            //  email textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: TextField(
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
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Email',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            //  password textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
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
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Password',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            //  confirm password textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: TextField(
                                obscureText: true,
                                controller: _confrimPasswordController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Color.fromRGBO(129, 97, 208, 0.75),
                                    ),
                                    onTap: () =>
                                        _confrimPasswordController.clear(),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Confirm Password',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 25),

                  //  User's body data section
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          height: 215,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            color: Color.fromARGB(255, 46, 36, 80),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Center(
                          child: Text(
                            'Body info',
                            style: TextStyle(
                              color: Color.fromRGBO(
                                  186, 104, 186, 1), //Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
                        child: Column(
                          children: [
                            //  height textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: TextField(
                                controller: _userHeightController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.height),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Color.fromRGBO(129, 97, 208, 0.75),
                                    ),
                                    onTap: () => _userHeightController.clear(),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Your height (cm)',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            //  weight textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: TextField(
                                controller: _userWeightController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.monitor_weight_outlined),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Color.fromRGBO(129, 97, 208, 0.75),
                                    ),
                                    onTap: () => _userWeightController.clear(),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Your weight (kg)',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 25),

                  //  Sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: signUp,
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
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
                        'I am a member!?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          ' Login now',
                          style: TextStyle(
                            color: Color.fromARGB(255, 158, 232, 249),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
