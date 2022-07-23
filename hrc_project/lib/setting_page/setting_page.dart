// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEdited = false;
  bool isNameEdited = false;
  bool isWeightEdited = false;
  bool isHeightEdited = false;
  bool isImageEdited = false;

  final _userNameController = TextEditingController();
  final _userWeightController = TextEditingController();
  final _userHeightController = TextEditingController();
  File? _userImage;

  String user_name = '';
  String email = '';
  String user_image = '';
  double weight = 0;
  double height = 0;

  // Get user data from cloud Firestore
  Future _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then(
          (value) => {
            user_name = value['user_name'],
            email = value['email'],
            weight = value['weight'],
            height = value['height'],
            user_image = value['user_image'],
          },
        );
  }

  Future editProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    String newUserImage = '';

    try {
      // loading circle
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      if (isImageEdited) {
        final deleteUserProfileImage = FirebaseStorage.instance
            .ref()
            .child('profile_image')
            .child(user!.uid);

        await deleteUserProfileImage.delete();

        final userProfileImage = FirebaseStorage.instance
            .ref()
            .child('profile_image')
            .child(user.uid);

        await userProfileImage.putFile(_userImage!);
        newUserImage = await userProfileImage.getDownloadURL();
      }

      updateUserDatails(
        _userNameController.text.trim(),
        newUserImage.trim(),
        _userHeightController.text.trim().isNotEmpty
            ? double.parse(_userHeightController.text.trim())
            : height,
        _userWeightController.text.trim().isNotEmpty
            ? double.parse(_userWeightController.text.trim())
            : weight,
      );

      //  pop the loading circle
      Navigator.of(context).pop();

      //  update completion alert
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white.withOpacity(0),
            child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
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
                        '계정 정보가 업데이트되었습니다.',
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
    } catch (e) {
      //  pop the loading circle
      Navigator.of(context).pop();
      //  update data format alert
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white.withOpacity(0),
            child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
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
                              '$e',
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

  //  update user data from cloud Firestore
  Future updateUserDatails(String newUserName, String newUserImage,
      double newHeight, double newWeight) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    if (_userNameController.text.trim().isNotEmpty) {
      await userData.update({'user_name': newUserName});
    }

    if (isImageEdited) {
      await userData.update({'user_image': newUserImage});
    }

    if (newHeight != height) {
      await userData.update({'height': newHeight});
    }

    if (newWeight != weight) {
      await userData.update({'weight': newWeight});
    }

    //  reload page
    setState(() {
      isEdited = false;
      isNameEdited = false;
      isWeightEdited = false;
      isHeightEdited = false;
      isImageEdited = false;

      _userNameController.clear();
      _userHeightController.clear();
      _userWeightController.clear();
      _userImage = null;
    });
  }

  @override
  void initState() {
    _userNameController.addListener(isUserDataChanged);
    _userWeightController.addListener(isUserDataChanged);
    _userHeightController.addListener(isUserDataChanged);
    super.initState();
  }

  //  Check for changed fields
  void isUserDataChanged() {
    if (_userNameController.text.trim().isNotEmpty ||
        _userWeightController.text.trim().isNotEmpty ||
        _userHeightController.text.trim().isNotEmpty ||
        isImageEdited) {
      isEdited = true;
    } else {
      isEdited = false;
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userHeightController.dispose();
    _userWeightController.dispose();
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
            isNameEdited = false;
            isWeightEdited = false;
            isHeightEdited = false;
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                //  user profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 225,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 46, 36, 80),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                  future: _getUserData(),
                                  builder: (context, snapshot) {
                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            //  User profile image circle
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        248, 103, 248, 0.95),
                                                    Color.fromRGBO(
                                                        61, 90, 230, 1)
                                                  ],
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 45,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                foregroundImage: _userImage ==
                                                        null
                                                    ? NetworkImage(user_image)
                                                    : FileImage(_userImage!)
                                                        as ImageProvider,
                                                child: user_image == ''
                                                    ? Icon(
                                                        Icons.account_circle,
                                                        size: 75,
                                                        color: Colors.grey,
                                                      )
                                                    : null,
                                              ),
                                            ),

                                            //  update profile image button
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0),
                                                      child: Container(
                                                          height: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              Container(
                                                                height: 45,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            30),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomRight,
                                                                      end: Alignment.topLeft,
                                                                      colors: [
                                                                        Color.fromRGBO(
                                                                            129,
                                                                            97,
                                                                            208,
                                                                            0.75),
                                                                        Color.fromRGBO(
                                                                            186,
                                                                            104,
                                                                            186,
                                                                            1)
                                                                      ]),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '프로필 사진 선택',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          final picker =
                                                                              ImagePicker();
                                                                          final image = await picker.pickImage(
                                                                              source: ImageSource.camera,
                                                                              imageQuality: 100,
                                                                              maxHeight: 150);
                                                                          setState(
                                                                              () {
                                                                            if (image !=
                                                                                null) {
                                                                              _userImage = File(image.path);
                                                                              isImageEdited = true;
                                                                              isUserDataChanged();
                                                                            }
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .photo_camera,
                                                                          size:
                                                                              80,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                        '카메라로 사진 찍기',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2,
                                                                    height: 100,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              30),
                                                                        ),
                                                                        gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.bottomRight,
                                                                            end: Alignment.topLeft,
                                                                            colors: [
                                                                              Color.fromRGBO(129, 97, 208, 0.75),
                                                                              Color.fromRGBO(186, 104, 186, 1)
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          final picker =
                                                                              ImagePicker();
                                                                          final image = await picker.pickImage(
                                                                              source: ImageSource.gallery,
                                                                              imageQuality: 100,
                                                                              maxHeight: 150);
                                                                          setState(
                                                                              () {
                                                                            if (image !=
                                                                                null) {
                                                                              _userImage = File(image.path);
                                                                              isImageEdited = true;
                                                                              isUserDataChanged();
                                                                            }
                                                                          });
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .image,
                                                                          size:
                                                                              80,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                        '갤러리에서 선택하기',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                    );
                                                  },
                                                );
                                              },
                                              //  Image edit floating button
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 65,
                                                  left: 65,
                                                ),
                                                child: Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[200],
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black,
                                                            spreadRadius: 0.5,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(0, 4)),
                                                      ]),
                                                  child: Icon(
                                                    Icons.photo_camera_outlined,
                                                    color: Colors.grey[600],
                                                    size: 23,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Stack(
                                          children: [
                                            //  edit user name textfield
                                            Container(
                                              height: 40,
                                              width: 250,
                                              child: TextField(
                                                onTap: () {
                                                  isNameEdited = true;
                                                },
                                                onSubmitted: (value) {
                                                  isNameEdited = false;
                                                },
                                                controller: _userNameController,
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white
                                                            .withOpacity(0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent
                                                            .withOpacity(0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  fillColor: Colors.grey
                                                      .withOpacity(0),
                                                  filled: true,
                                                  hintText: '${user_name}',
                                                  hintStyle: TextStyle(
                                                    color: isNameEdited
                                                        ? Colors.white
                                                            .withOpacity(0)
                                                        : Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      186, 104, 186, 1),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${email}',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                //  user body information section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 46, 36, 80),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                    future: _getUserData(),
                                    builder: (context, snapshot) {
                                      return Row(
                                        children: [
                                          //  user weight
                                          Column(
                                            children: [
                                              RadiantGradientMask(
                                                child: Icon(
                                                  Icons.monitor_weight_outlined,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Weight',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              //  edit user weight textfield
                                              SizedBox(
                                                height: 40,
                                                width: 110,
                                                child: TextField(
                                                  onTap: () {
                                                    isWeightEdited = true;
                                                  },
                                                  onSubmitted: (value) {
                                                    isWeightEdited = false;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _userWeightController,
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withOpacity(0)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent
                                                              .withOpacity(0)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    fillColor: Colors.grey
                                                        .withOpacity(0),
                                                    filled: true,
                                                    isDense: true,
                                                    suffixIcon: Text(
                                                      'kg',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    suffixIconConstraints:
                                                        BoxConstraints(
                                                            minHeight: 34),
                                                    hintText: '${weight}',
                                                    hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isWeightEdited
                                                          ? Colors.white
                                                              .withOpacity(0)
                                                          : Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        186, 104, 186, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(width: 35),

                                          //user height
                                          Column(
                                            children: [
                                              RadiantGradientMask(
                                                child: Icon(
                                                  Icons.height,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Height',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              //  edit user height textfield
                                              SizedBox(
                                                height: 40,
                                                width: 120,
                                                child: TextField(
                                                  onTap: () {
                                                    isHeightEdited = true;
                                                  },
                                                  onSubmitted: (value) {
                                                    isHeightEdited = false;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _userHeightController,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .deepPurpleAccent
                                                                .withOpacity(
                                                                    0)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      fillColor: Colors.grey
                                                          .withOpacity(0),
                                                      filled: true,
                                                      isDense: true,
                                                      suffixIcon: Text(
                                                        'cm',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      suffixIconConstraints:
                                                          BoxConstraints(
                                                              minHeight: 34),
                                                      hintText: '${height}',
                                                      hintStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isHeightEdited
                                                            ? Colors.white
                                                                .withOpacity(0)
                                                            : Colors.white,
                                                        fontSize: 20,
                                                      )),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        186, 104, 186, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                //  edit profile button
                GestureDetector(
                  onTap: isEdited
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white.withOpacity(0),
                                child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                end: Alignment.topLeft,
                                                colors: [
                                                  Color.fromRGBO(
                                                      129, 97, 208, 0.75),
                                                  Color.fromRGBO(
                                                      186, 104, 186, 1)
                                                ]),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '프로필 업데이트',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(height: 20),
                                            Center(
                                              child: Text(
                                                '수정한 내용을 저장하시겠습니까?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      //  pop the alert
                                                      Navigator.of(context)
                                                          .pop();
                                                      editProfile();
                                                    },
                                                    child: Text('저장하기')),
                                                SizedBox(width: 50),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('취소'))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              );
                            },
                          );
                        }
                      : () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              isEdited
                                  ? Color.fromRGBO(129, 97, 208, 0.45)
                                  : Color.fromARGB(255, 46, 36, 80),
                              isEdited
                                  ? Color.fromARGB(255, 61, 90, 230)
                                  : Color.fromARGB(255, 46, 36, 80),
                            ]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            color: isEdited ? Colors.white : Colors.grey[600],
                            size: 35,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Edit profile',
                            style: TextStyle(
                              color: isEdited ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                //  Log in and out section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color.fromARGB(255, 46, 36, 80),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white.withOpacity(0),
                                  child: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomRight,
                                                  end: Alignment.topLeft,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        129, 97, 208, 0.75),
                                                    Color.fromRGBO(
                                                        186, 104, 186, 1)
                                                  ]),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '로그아웃',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(height: 20),
                                              Center(
                                                child: Text(
                                                  '로그아웃하시겠습니까?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await FirebaseAuth
                                                            .instance
                                                            .signOut();
                                                        //  pop the alert
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('예')),
                                                  SizedBox(width: 50),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('아니요'))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white.withOpacity(0),
                                  child: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomRight,
                                                  end: Alignment.topLeft,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        129, 97, 208, 0.75),
                                                    Color.fromRGBO(
                                                        186, 104, 186, 1)
                                                  ]),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '로그아웃',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(height: 20),
                                              Center(
                                                child: Text(
                                                  '계정을 삭제하시겠습니까?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                      onPressed: () async {},
                                                      child: Text('예')),
                                                  SizedBox(width: 50),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('아니요'))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                );
                              },
                            );
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RadiantGradientMask2(
                                  child: Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'Leaving the membership',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromRGBO(255, 125, 125, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Version : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  '0.0.1 (beta)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 63, 92, 238),
          Color.fromARGB(68, 66, 97, 224),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class RadiantGradientMask2 extends StatelessWidget {
  RadiantGradientMask2({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 125, 125, 1),
          Color.fromRGBO(255, 125, 125, 0.27),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
