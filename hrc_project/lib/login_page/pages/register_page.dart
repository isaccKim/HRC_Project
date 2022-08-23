// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrc_project/dialog_page/show_dialog.dart';
import '../../setting_page/rc_select_button.dart';
import 'email_verify_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userHeightController = TextEditingController();
  final _userWeightController = TextEditingController();
  File? _userImage;

  //  RC state
  String userRC = 'none';
  bool isEdited = false;
  int selectedIndex = 3;

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    widget.showLoginPage();
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    _userHeightController.dispose();
    _userWeightController.dispose();
    super.dispose();
  }

  //  Firesbase firecloud data upload
  Future signUp() async {
    // loading circle
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (_userImage != null) {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _userNameController.text.isNotEmpty &&
          _userHeightController.text.isNotEmpty &&
          _userWeightController.text.isNotEmpty &&
          isEdited) {
        //  email form validation
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text.trim())) {
          //  handong email 한정 계정 생성하기
          // if (_emailController.text.trim().contains('@handong')) {
          if (passwordConfirmed()) {
            try {
              double.parse(_userHeightController.text.trim());
              double.parse(_userWeightController.text.trim());
              try {
                final newUser =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                final _userProfileImage = FirebaseStorage.instance
                    .ref()
                    .child('profile_image')
                    .child(newUser.user!.uid);

                await _userProfileImage.putFile(_userImage!);
                final _user_image = await _userProfileImage.getDownloadURL();

                //  data set 방식 함수 호출
                await addUserDetails(
                  newUser,
                  _userNameController.text.trim(),
                  _emailController.text.trim(),
                  _user_image.trim(),
                  double.parse(_userHeightController.text.trim()),
                  double.parse(_userWeightController.text.trim()),
                  userRC.trim(),
                );

                //  data add 방식 함수 호출
                // await addUserDetails(
                //   _userNameController.text.trim(),
                //   _emailController.text.trim(),
                //   _user_image.trim(),
                //   double.parse(_userHeightController.text.trim()),
                //   double.parse(_userWeightController.text.trim()),
                // );

                //  Add a document subcollection
                await addSubCollection(newUser);

                //  pop the loading circle
                Navigator.of(context).pop();

                //  email verify page push
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EmailVerify();
                    },
                  ),
                );
              } on FirebaseAuthException catch (e) {
                //  pop the loading circle
                Navigator.of(context).pop();
                //  account creation error alert
                showDialog(
                    context: context,
                    builder: (context) {
                      return flexibleDialog(context, 200, 30, '알림', 15,
                          e.message.toString(), 14, () {}, () {}, () {}, () {});
                    });
              }
            } catch (e) {
              //  pop the loading circle
              Navigator.of(context).pop();

              // height, weight form alert
              showDialog(
                  context: context,
                  builder: (context) {
                    return flexibleDialog(context, 200, 30, '알림', 15,
                        e.toString(), 15, () {}, () {}, () {}, () {});
                  });
            }
          } else {
            //  pop the loading circle
            Navigator.of(context).pop();
            //  password form alert
            showDialog(
                context: context,
                builder: (context) {
                  return flexibleDialog(
                      context,
                      200,
                      30,
                      '알림',
                      15,
                      '비밀번호를 다시 확인해 주십시오.\n(7자 이상의 비밀번호를 사용해 주세요)',
                      14,
                      () {},
                      () {},
                      () {},
                      () {});
                });
          }
        } else {
          //  pop the loading circle
          Navigator.of(context).pop();
          // handong email form alert
          showDialog(
              context: context,
              builder: (context) {
                return flexibleDialog(context, 200, 30, '알림', 15,
                    '올바른 형식의 이메일을 입력해주세요.', 15, () {}, () {}, () {}, () {});
              });
        }
      }
      //  Information write error
      else {
        //  pop the loading circle
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return flexibleDialog(context, 200, 30, '알림', 15,
                  '모든 정보를 기입해주십시오.', 17, () {}, () {}, () {}, () {});
            });
      }
    }
    //  Profile image select alert
    else {
      //  pop the loading circle
      Navigator.of(context).pop();

      showDialog(
          context: context,
          builder: (context) {
            return flexibleDialog(context, 200, 30, '알림', 15,
                '프로필 이미지를 선택해 주십시오.', 17, () {}, () {}, () {}, () {});
          });
    }
  }

  //  data add 방식
  // Future addUserDetails(
  //     String username, String email, String user_image, double height, double weight) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'user_Fname': username,
  //     'email': email,
  //     'user_image': user_image,
  //     'height': height,
  //     'weight': weight,
  //     'sum_distance': 0,
  //     'sum_time': 0,
  //   });
  // }

  //  data set 방식
  Future addUserDetails(UserCredential newUser, String username, String email,
      String user_image, double height, double weight, String userRC) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.user!.uid)
        .set({
      'user_name': username,
      'email': email,
      'user_image': user_image,
      'height': height,
      'weight': weight,
      'sum_distance': 0,
      'sum_time': 0,
      'user_RC': userRC,
    });
  }

  //  Add a document subcollection
  Future addSubCollection(UserCredential newUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.user!.uid)
        .collection('running record')
        .add({
      'distance': 0,
      'time': 0,
      'pace': 0,
      'date': DateTime.now(),
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
            _confirmPasswordController.text.trim() &&
        _passwordController.text.trim().length > 6) {
      return true;
    } else {
      return false;
    }
  }

  //  ImagePicker camera function
  void camera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 100, maxHeight: 150);
    setState(() {
      if (image != null) {
        _userImage = File(image.path);
      }
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).pop();
    });
  }

  //  ImagePicker gallery function
  void gallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxHeight: 150);
    setState(
      () {
        if (image != null) {
          _userImage = File(image.path);
        }
      },
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context).pop();
    });
  }

  //  Get user RC data
  void getRCData(int index) {
    setState(() {
      userRC = rcNames[index];
      selectedIndex = index;
      isEdited = true;
    });
  }

  final rcNames = [
    'Philadelphos',
    'Sonyangwon',
    'Torrey',
    'none',
    'Jangkiryeo',
    'Carmichael',
    'Kuyper'
  ];

  //  ID/PW validator
  final ValueNotifier<int> emailValidate = ValueNotifier<int>(0);
  final ValueNotifier<int> passwordLength = ValueNotifier<int>(0);
  final ValueNotifier<int> passwordIdentical = ValueNotifier<int>(0);

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
                  //  page back arrow
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            widget.showLoginPage();
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
                        padding: const EdgeInsets.only(top: 8.5),
                        child: SvgPicture.asset(
                          'image/Logo.svg',
                          height: 80,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),

                  //  profile section
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          height: 280,
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
                        padding: const EdgeInsets.only(top: 4),
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

                      // profile image picker dialog
                      Padding(
                        padding: const EdgeInsets.only(top: 55.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return imageDialog(
                                        context, camera, gallery);
                                  });
                            },

                            // User profile image circle
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: _userImage == null
                                      ? EdgeInsets.all(0)
                                      : EdgeInsets.all(6),
                                  height: 120,
                                  width: 120,
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
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: _userImage != null
                                        ? FileImage(_userImage!)
                                        : null,
                                    child: _userImage == null
                                        ? Icon(
                                            Icons.add,
                                            size: 45,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //  User name textField
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 170, 70, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ' User name',
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
                              textInputAction: TextInputAction.none,
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
                                  borderSide: BorderSide(
                                      color: Colors.deepPurpleAccent),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                hintText: 'User Name',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 25),

                  //  RC select button
                  rcSelectButton(
                    context,
                    isEdited,
                    selectedIndex,
                    getRCData,
                    () {},
                    () {},
                  ),

                  SizedBox(height: 25),

                  //  ID/PW section
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          height: 445,
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
                        padding: const EdgeInsets.only(top: 7),
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
                        padding: const EdgeInsets.fromLTRB(0, 55, 0, 10),
                        child: Column(
                          children: [
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
                                  Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(value!.trim()) &&
                                            value.isNotEmpty) {
                                          emailValidate.value = 1;
                                        } else {
                                          emailValidate.value = 0;
                                        }
                                      },
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        suffixIcon: GestureDetector(
                                            child: Icon(
                                              Icons.cancel,
                                              color: Color.fromRGBO(
                                                  129, 97, 208, 0.75),
                                            ),
                                            onTap: () {
                                              _emailController.clear();
                                              emailValidate.value = 0;
                                            }),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintText: 'Email address',
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // email validator
                            Padding(
                              padding: const EdgeInsets.only(left: 55, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: emailValidate,
                                    builder: (context, value, child) {
                                      return Row(
                                        children: [
                                          value == 0
                                              ? Icon(
                                                  Icons.done,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.done,
                                                  color: Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                                  size: 20,
                                                ),
                                          Text(
                                            ' Valid email form',
                                            style: TextStyle(
                                              color: value == 0
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            //  password textFormField
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
                                  Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.length > 6 &&
                                            value.isNotEmpty) {
                                          passwordLength.value = 1;
                                        } else {
                                          passwordLength.value = 0;
                                        }
                                      },
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                            child: Icon(
                                              Icons.cancel,
                                              color: Color.fromRGBO(
                                                  129, 97, 208, 0.75),
                                            ),
                                            onTap: () {
                                              _passwordController.clear();
                                              passwordLength.value = 0;
                                            }),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintText: 'Password',
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // password validator
                            Padding(
                              padding: const EdgeInsets.only(left: 55, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: passwordLength,
                                    builder: (context, value, child) {
                                      return Row(
                                        children: [
                                          value == 0
                                              ? Icon(
                                                  Icons.done,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.done,
                                                  color: Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                                  size: 20,
                                                ),
                                          Text(
                                            ' Password of 7 or more digits',
                                            style: TextStyle(
                                              color: value == 0
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            //  confirm password textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' Confirm Password',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value ==
                                                _passwordController.text
                                                    .trim() &&
                                            value!.length > 6) {
                                          passwordIdentical.value = 1;
                                        } else {
                                          passwordIdentical.value = 0;
                                        }
                                      },
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      controller: _confirmPasswordController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                            child: Icon(
                                              Icons.cancel,
                                              color: Color.fromRGBO(
                                                  129, 97, 208, 0.75),
                                            ),
                                            onTap: () {
                                              _confirmPasswordController
                                                  .clear();
                                              passwordIdentical.value = 0;
                                            }),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        hintText: 'Confirm Password',
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // confirm password validator
                            Padding(
                              padding: const EdgeInsets.only(left: 55, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: passwordIdentical,
                                    builder: (context, value, child) {
                                      return Row(
                                        children: [
                                          value == 0
                                              ? Icon(
                                                  Icons.done,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.done,
                                                  color: Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                                  size: 20,
                                                ),
                                          Text(
                                            ' Identical password',
                                            style: TextStyle(
                                              color: value == 0
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.lightBlueAccent
                                                      .withOpacity(0.9),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
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
                          height: 275,
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
                        padding: const EdgeInsets.only(top: 7),
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' Height',
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
                                    keyboardType: TextInputType.number,
                                    controller: _userHeightController,
                                    decoration: InputDecoration(
                                      suffixText: '(cm)',
                                      suffixStyle: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      prefixIcon: Icon(Icons.height),
                                      suffixIcon: GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          color: Color.fromRGBO(
                                              129, 97, 208, 0.75),
                                        ),
                                        onTap: () =>
                                            _userHeightController.clear(),
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
                                      hintText: 'Your height (cm)',
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            //  weight textField
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' Weight',
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
                                      signUp();
                                    }),
                                    keyboardType: TextInputType.number,
                                    controller: _userWeightController,
                                    decoration: InputDecoration(
                                      suffixText: '(kg)',
                                      suffixStyle: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                      prefixIcon:
                                          Icon(Icons.monitor_weight_outlined),
                                      suffixIcon: GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          color: Color.fromRGBO(
                                              129, 97, 208, 0.75),
                                        ),
                                        onTap: () =>
                                            _userWeightController.clear(),
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
                                      hintText: 'Your weight (kg)',
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 40),

                  //  Sign up button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        signUp();
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width * 0.6),
                        height: 45,
                        decoration: BoxDecoration(
                          boxShadow: [
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

                  //  not a member? register now comment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am a member?',
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
                            fontSize: 15,
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
