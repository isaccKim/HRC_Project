// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

//  with yes and no textbutton
Dialog alternativeDialog(
  BuildContext context,
  double boxHeight,
  double topBarHeight,
  String topBarText,
  double topBarTextSize,
  String mainText,
  double mainTextSize,
  Function executableFuc1,
  Function executableFuc2,
  Function executableFuc3,
  Function executableFuc4,
  Function executableFuc5,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                '$topBarText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: topBarTextSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '$mainText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mainTextSize,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 50,
                    color: Colors.white.withOpacity(0),
                    child: ElevatedButton(
                      onPressed: () async {
                        executableFuc1();
                        executableFuc2();
                        executableFuc3();
                        executableFuc4();
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          elevation: 0,
                          primary: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                          )),
                      child: Text(
                        '예',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 50,
                    color: Colors.white.withOpacity(0),
                    child: ElevatedButton(
                      onPressed: () {
                        executableFuc5();
                        //  pop the alert
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          elevation: 0,
                          primary: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          )),
                      child: Text(
                        '아니요',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )),
  );
}

//  with confirm textbutton
Dialog flexibleDialog(
  BuildContext context,
  double boxHeight,
  double topBarHeight,
  String topBarText,
  double topBarTextSize,
  String mainText,
  double mainTextSize,
  Function executableFuc1,
  Function executableFuc2,
  Function executableFuc3,
  Function executableFuc4,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                '$topBarText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: topBarTextSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '$mainText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mainTextSize,
                ),
              ),
            ),
            //Flexible widget 메시지 내용에 따라 유연하게 Text 위치 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 50,
                    color: Colors.white.withOpacity(0),
                    child: ElevatedButton(
                      onPressed: () async {
                        //  pop the alert
                        Navigator.of(context).pop();
                        executableFuc1();
                        executableFuc2();
                        executableFuc3();
                        executableFuc4();
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          elevation: 0,
                          primary: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          )),
                      child: Text(
                        '예',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
  );
}

//  ImagePicker dialog
Dialog imageDialog(
  BuildContext context,
  Function cameraFunc,
  Function galleryFunc,
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                '프로필 사진 선택',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        cameraFunc();
                      },
                      child: Icon(
                        Icons.photo_camera,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '카메라로 사진 찍기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                // SizedBox(
                //   width: 2,
                //   height: 100,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //       gradient: LinearGradient(
                //           begin: Alignment.bottomRight,
                //           end: Alignment.topLeft,
                //           colors: [
                //             Color.fromRGBO(129, 97, 208, 0.75),
                //             Color.fromRGBO(186, 104, 186, 1)
                //           ]),
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        galleryFunc();
                      },
                      child: Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '갤러리에서 선택하기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            //Flexible widget 메시지 내용에 따라 유연하게 Text 위치 조정
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 50,
                    color: Colors.white.withOpacity(0),
                    child: ElevatedButton(
                      onPressed: () async {
                        //  pop the alert
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          elevation: 0,
                          primary: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          )),
                      child: Text(
                        '취소하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
  );
}

//  Confirm textfield dialog
Function confirmDialog(
  BuildContext context,
  String userEmail,
  Function executableFuc1,
  Function executableFuc2,
  Function executableFuc3,
  Function executableFuc4,
) {
  return () {
    final _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String userInput = '';

    bool _tryValidation() {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        return true;
      }
      return false;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   height: 30,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(10),
                //       topRight: Radius.circular(10),
                //     ),
                //     gradient: LinearGradient(
                //         begin: Alignment.bottomRight,
                //         end: Alignment.topLeft,
                //         colors: [
                //           Color.fromRGBO(129, 97, 208, 0.75),
                //           Color.fromRGBO(186, 104, 186, 1)
                //         ]),
                //   ),
                //   child: Center(
                //     child: Text(
                //       '계정 삭제',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15,
                //       ),
                //     ),
                //   ),
                // ),
                Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.only(top: 30),
                    //   child: Text(
                    //     '계정을 삭제하면 데이터는\n되돌릴 수 없습니다.',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       color: Color.fromRGBO(255, 125, 125, 1),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15,
                    //     ),
                    //   ),
                    // ),

                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 5),
                      child: Text(
                        '계정을 삭제하려면 ID(email)를 입력하세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    //  email confirm textField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          key: ValueKey(1),
                          validator: (value) {
                            if (value != userEmail) {
                              return 'ID를 올바르게 입력해주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userInput = value!;
                          },
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(
                                Icons.cancel,
                                color: Color.fromRGBO(129, 97, 208, 0.75),
                              ),
                              onTap: () => _emailController.clear(),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 125, 125, 1),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 125, 125, 1),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: '${userEmail}',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          height: 60,
                          color: Colors.white.withOpacity(0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_tryValidation()) {
                                executableFuc1();
                                executableFuc2();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return flexibleDialog(context, 150, 30,
                                          '알림', 15, '계정이 삭제되었습니다.', 15, () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/', (route) => false);
                                      }, () {}, () {}, () {});
                                    });
                                executableFuc3();
                                executableFuc4();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                elevation: 0,
                                primary: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  ),
                                )),
                            child: Text(
                              '확인했습니다',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          height: 50,
                          color: Colors.white.withOpacity(0),
                          child: ElevatedButton(
                            onPressed: () {
                              //  pop the alert
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                elevation: 0,
                                primary: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                  ),
                                )),
                            child: Text(
                              '취소하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  };
}

//  Dialog with user profile
Container userProfile(
  BuildContext context,
  String user_name,
  String user_image,
  String email,
  String rank,
  Function executableFuc1,
  Function executableFuc2,
  Function executableFuc3,
  Function executableFuc4,
) {
  return Container(
    child: Stack(
      children: [
        Dialog(
          backgroundColor: Colors.white.withOpacity(0),
          child: Stack(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 70),

                    //  user name, email
                    Column(
                      children: [
                        Text(
                          '${user_name}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          email.lastIndexOf('@') < 3
                              ? '${email}'
                              : email = email.replaceRange(
                                  3,
                                  '${email}'.indexOf('@'),
                                  '*' * ('${email}'.indexOf('@') - 3)),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            height: 50,
                            color: Colors.white.withOpacity(0),
                            child: ElevatedButton(
                              onPressed: () async {
                                //  pop the alert
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  Navigator.of(context).pop();
                                });
                                executableFuc1();
                                executableFuc2();
                                executableFuc3();
                                executableFuc4();
                              },
                              style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  elevation: 0,
                                  primary: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  )),
                              child: Text(
                                '닫기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //  User profile image circle
        Padding(
          padding: const EdgeInsets.only(bottom: 180.0),
          child: Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0.25,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ],
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
                    radius: 45,
                    backgroundColor: Colors.grey[200],
                    foregroundImage: NetworkImage(user_image),
                    child: const Icon(
                      Icons.account_circle,
                      size: 75,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80, left: 80),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: rankBadge(rank),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//  Rank badget color
List<Color> rankBadge(String rank) {
  if (rank == '1') {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(147, 99, 201, 1),
      const Color.fromRGBO(129, 97, 208, 1),
    ];
  } else if (rank == '2') {
    return [
      const Color.fromRGBO(186, 104, 186, 1),
      const Color.fromRGBO(159, 101, 190, 1),
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(99, 97, 210, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else if (rank == '3') {
    return [
      const Color.fromRGBO(129, 97, 208, 1),
      const Color.fromRGBO(95, 93, 215, 1),
      const Color.fromRGBO(76, 93, 220, 1),
      const Color.fromRGBO(61, 90, 230, 1),
    ];
  } else {
    return [];
  }
}
