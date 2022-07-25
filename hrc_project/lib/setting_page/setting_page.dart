// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/dialog_page/show_dialog.dart';
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

  //  Get user data from cloud Firestore
  Future _getUserData() async {
    final user = await FirebaseAuth.instance.currentUser;
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

  //  Update user data from cloud Firestore
  Future editProfile() async {
    final user = await FirebaseAuth.instance.currentUser;
    String newUserImage = '';

    try {
      // loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      if (isImageEdited) {
        final deleteUserProfileImage = await FirebaseStorage.instance
            .ref()
            .child('profile_image')
            .child(user!.uid);

        await deleteUserProfileImage.delete();

        final userProfileImage = await FirebaseStorage.instance
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
            return flexibleDialog(context, 200, 30, '알림', 15,
                '계정 정보가 업데이트되었습니다.', 17, () {}, () {}, () {}, () {});
          });
    } catch (e) {
      //  pop the loading circle
      Navigator.of(context).pop();
      //  update data format alert
      showDialog(
          context: context,
          builder: (context) {
            return flexibleDialog(context, 200, 30, '알림', 15, e.toString(), 20,
                () {}, () {}, () {}, () {});
          });
    }
  }

  //  data update 방식
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

  //  Delete user data and account from firebase
  Future deleteUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final deleteUserProfileImage = await FirebaseStorage.instance
        .ref()
        .child('profile_image')
        .child(user.uid);

    //  delete user profile image
    await deleteUserProfileImage.delete();

    //  delete user data
    await userData.delete();

    //  delete user account
    await user.delete();

    await FirebaseAuth.instance.signOut();
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

  //  ImagePicker camera function
  void camera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 100, maxHeight: 150);
    setState(() {
      if (image != null) {
        _userImage = File(image.path);
        isImageEdited = true;
        isUserDataChanged();
      }
    });
    Navigator.of(context).pop();
  }

  //  ImagePicker gallery function
  void gallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100, maxHeight: 150);
    setState(() {
      if (image != null) {
        _userImage = File(image.path);
        isImageEdited = true;
        isUserDataChanged();
      }
    });
    Navigator.of(context).pop();
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
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
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
                const SizedBox(height: 20),

                //  user profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 225,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
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
                                              padding: const EdgeInsets.all(4),
                                              height: 100,
                                              width: 100,
                                              decoration: const BoxDecoration(
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
                                                    ? const Icon(
                                                        Icons.account_circle,
                                                        size: 75,
                                                        color: Colors.grey,
                                                      )
                                                    : null,
                                              ),
                                            ),

                                            //  Image edit floating button
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return imageDialog(
                                                          context,
                                                          camera,
                                                          gallery);
                                                    });
                                              },
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
                                                      boxShadow: const [
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
                                        const SizedBox(height: 20),
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
                                                style: const TextStyle(
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

                const SizedBox(height: 20),

                //  user body information section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
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
                                                child: const Icon(
                                                  Icons.monitor_weight_outlined,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Weight',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
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
                                                    suffixIcon: const Text(
                                                      'kg',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    suffixIconConstraints:
                                                        const BoxConstraints(
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
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        186, 104, 186, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(width: 35),

                                          //user height
                                          Column(
                                            children: [
                                              RadiantGradientMask(
                                                child: const Icon(
                                                  Icons.height,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text(
                                                'Height',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
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
                                                                .circular(15),
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
                                                                .circular(15),
                                                      ),
                                                      fillColor: Colors.grey
                                                          .withOpacity(0),
                                                      filled: true,
                                                      isDense: true,
                                                      suffixIcon: const Text(
                                                        'cm',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      suffixIconConstraints:
                                                          const BoxConstraints(
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
                                                  style: const TextStyle(
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

                const SizedBox(height: 20),

                //  edit profile button
                GestureDetector(
                  onTap: isEdited
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return alternativeDialog(
                                  context,
                                  200,
                                  30,
                                  '프로필 업데이트',
                                  15,
                                  '수정한 내용을 저장하시겠습니까?',
                                  17,
                                  Navigator.of(context).pop,
                                  editProfile,
                                  () {},
                                  () {});
                            },
                          );
                        }
                      : () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 325),
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          isEdited
                              ? const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                )
                              : const BoxShadow(),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              isEdited
                                  ? const Color.fromRGBO(129, 97, 208, 0.45)
                                  : const Color.fromARGB(255, 46, 36, 80),
                              isEdited
                                  ? const Color.fromARGB(255, 61, 90, 230)
                                  : const Color.fromARGB(255, 46, 36, 80),
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
                          const SizedBox(width: 15),
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

                const SizedBox(height: 20),

                //  Logout and Leaving membership section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 190,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Color.fromARGB(255, 46, 36, 80),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: const Color.fromARGB(255, 46, 36, 80),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return alternativeDialog(
                                    context,
                                    200,
                                    30,
                                    '로그아웃',
                                    15,
                                    '로그아웃하시겠습니까?',
                                    17,
                                    FirebaseAuth.instance.signOut, () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (route) => false);
                                }, () {}, () {});
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: const Color.fromARGB(255, 46, 36, 80),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return alternativeDialog(
                                    context,
                                    200,
                                    30,
                                    '회원탈퇴하기',
                                    15,
                                    '계정을 삭제하시겠습니까?',
                                    17,
                                    Navigator.of(context).pop,
                                    confirmDialog(
                                        context,
                                        email,
                                        Navigator.of(context).pop,
                                        deleteUserData,
                                        () {},
                                        () {}),
                                    () {},
                                    () {});
                              },
                            );
                          },
                          icon: RadiantGradientMask2(
                            child: const Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          label: const Text(
                            'Leaving the membership',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromRGBO(255, 125, 125, 1),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) {
                        //         return alternativeDialog(
                        //             context,
                        //             200,
                        //             30,
                        //             '회원탈퇴하기',
                        //             15,
                        //             '계정을 삭제하시겠습니까?',
                        //             17,
                        //             Navigator.of(context).pop,
                        //             confirmDialog(
                        //                 context,
                        //                 email,
                        //                 Navigator.of(context).pop,
                        //                 deleteUserData,
                        //                 () {},
                        //                 () {}),
                        //             () {},
                        //             () {});
                        //       },
                        //     );
                        //   },
                        //   child: Container(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         RadiantGradientMask2(
                        //           child: const Icon(
                        //             Icons.sentiment_dissatisfied,
                        //             color: Colors.white,
                        //             size: 45,
                        //           ),
                        //         ),
                        //         const SizedBox(width: 15),
                        //         const Text(
                        //           'Leaving the membership',
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 20,
                        //             color: Color.fromRGBO(255, 125, 125, 1),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Row(
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
                            ])
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//  Icon gradient funcfion1
class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
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

//  Icon gradient funcfion2
class RadiantGradientMask2 extends StatelessWidget {
  RadiantGradientMask2({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
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
