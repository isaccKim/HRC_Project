// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
) {
  return Dialog(
    backgroundColor: Colors.white.withOpacity(0),
    child: Container(
        height: boxHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: topBarHeight,
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
                  '$topBarText',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: topBarTextSize,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '$mainText',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: mainTextSize,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        executableFuc1();
                        executableFuc2();
                        executableFuc3();
                        executableFuc4();
                      },
                      child: Text('예'),
                    ),
                    SizedBox(width: 50),
                    TextButton(
                      onPressed: () {
                        //  pop the alert
                        Navigator.of(context).pop();
                      },
                      child: Text('아니요'),
                    )
                  ],
                )
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
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: topBarHeight,
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
                  '$topBarText',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: topBarTextSize,
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
                    SizedBox(height: 15),
                    Text(
                      '$mainText',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mainTextSize,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        //  pop the alert
                        Navigator.of(context).pop();
                        executableFuc1();
                        executableFuc2();
                        executableFuc3();
                        executableFuc4();
                      },
                      child: Text('확인'),
                    )
                  ],
                ),
              ),
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
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 45,
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
                  '프로필 사진 선택',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        size: 80,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '카메라로 사진 찍기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 2,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
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
                      onTap: () async {
                        galleryFunc();
                      },
                      child: Icon(
                        Icons.image,
                        size: 80,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '갤러리에서 선택하기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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
            height: 275,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      '계정 삭제',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        '계정을 삭제하면 데이터는 되돌릴 수 없습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 125, 125, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
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
                    SizedBox(height: 10),
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 125, 125, 1),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 125, 125, 1),
                              ),
                              borderRadius: BorderRadius.circular(30),
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
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_tryValidation()) {
                            executableFuc1();
                            executableFuc2();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return flexibleDialog(context, 150, 30, '알림',
                                      15, '계정이 삭제되었습니다.', 15, () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/', (route) => false);
                                  }, () {}, () {}, () {});
                                });
                            executableFuc3();
                            executableFuc4();
                          }
                        },
                        child: Text('확인했습니다'),
                      ),
                      SizedBox(width: 50),
                      TextButton(
                        onPressed: () {
                          //  pop the alert
                          Navigator.of(context).pop();
                        },
                        child: Text('취소하기'),
                      )
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
