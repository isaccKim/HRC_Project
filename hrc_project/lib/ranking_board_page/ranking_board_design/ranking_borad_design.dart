// ignore_for_file: unnecessary_const, must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/dialog_page/show_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrc_project/ranking_board_page/unit_conversion.dart';

//  if there is no Data
Widget noData(bool isTime, BuildContext context, GlobalKey typeKey) {
  return Padding(
    padding: const EdgeInsets.only(top: 90.0),
    child: Column(
      children: [
        //  ranking type
        Align(
          heightFactor: 0.35,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  key: typeKey,
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: RadiantGradientMask(
                    color1: const Color.fromRGBO(248, 103, 248, 1),
                    color2: const Color.fromRGBO(220, 76, 220, 0.8),
                    color3: const Color.fromRGBO(201, 92, 201, 0.6),
                    color4: const Color.fromRGBO(186, 104, 186, 0.4),
                    x1: 1,
                    y1: -1,
                    x2: -1,
                    y2: 1,
                    child: SvgPicture.asset(
                      'image/ranking_board/type.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),

              //  Time, Distance icon
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: isTime
                      ? RadiantGradientMask(
                          color1: const Color.fromRGBO(50, 44, 255, 1),
                          color2: const Color.fromRGBO(100, 44, 255, 0.8),
                          color3: const Color.fromRGBO(186, 104, 186, 0.5),
                          color4: const Color.fromRGBO(186, 104, 186, 0.1),
                          x1: 1,
                          y1: -1,
                          x2: -1,
                          y2: 1,
                          child: const Icon(
                            Icons.timer_outlined,
                            size: 170,
                            color: Colors.white,
                          ),
                        )
                      : RadiantGradientMask(
                          color1: const Color.fromRGBO(50, 44, 255, 1),
                          color2: const Color.fromRGBO(100, 44, 255, 0.8),
                          color3: const Color.fromRGBO(186, 104, 186, 0.5),
                          color4: const Color.fromRGBO(186, 104, 186, 0.1),
                          x1: 1,
                          y1: -1,
                          x2: -1,
                          y2: 1,
                          child: const Icon(
                            Icons.north,
                            size: 170,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              //  Time, Distacne text
              Center(
                child: isTime
                    ? Padding(
                        padding: const EdgeInsets.only(top: 160.0),
                        child: Column(
                          children: const [
                            Align(
                              heightFactor: 0.5,
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 65,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 40.0),
                              child: Text(
                                'Top 100',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    // const Text.rich(TextSpan(
                    //     text: 'Time',
                    //     style: TextStyle(
                    //       fontFamily: 'Jost',
                    //       color: Colors.white,
                    //       fontSize: 65,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     children: [
                    //         TextSpan(
                    //             text: '\n Top 100',
                    // style: TextStyle(
                    //   fontFamily: 'Jost',
                    //   color: Colors.white,
                    //   fontSize: 25,
                    //             ))
                    //       ]))
                    : Padding(
                        padding: const EdgeInsets.only(top: 170.0),
                        child: Column(
                          children: const [
                            Align(
                              heightFactor: 0.5,
                              child: Text(
                                'Distance',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 130.0),
                              child: Text(
                                'Top 100',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),

        //  No Data icon, text
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              RadiantGradientMask(
                  color1: Color.fromRGBO(255, 125, 125, 1),
                  color2: Color.fromRGBO(255, 125, 125, 0.7),
                  color3: Color.fromRGBO(255, 125, 125, 0.4),
                  color4: Color.fromRGBO(255, 125, 125, 0.1),
                  x1: 0,
                  y1: -1,
                  x2: 0,
                  y2: 1,
                  child: const Icon(
                    Icons.sentiment_dissatisfied,
                    size: 80,
                    color: Colors.white,
                  )),
              const Text(
                'No Data',
                style: TextStyle(
                  fontFamily: 'Jost',
                  color: Color.fromRGBO(255, 125, 125, 1),
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//  1st, ranking type
Widget ranking1st(
    Map<String, dynamic> data,
    int number,
    bool isTime,
    String documentId,
    BuildContext context,
    GlobalKey typeKey,
    GlobalKey userKey) {
  bool isMe = false;

  final user = FirebaseAuth.instance.currentUser;

  if (documentId == user!.uid) {
    isMe = true;
  }
  return Padding(
    key: typeKey,
    padding: const EdgeInsets.only(top: 90.0),
    child: Column(
      children: [
        //  ranking type
        Align(
          heightFactor: 0.35,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: RadiantGradientMask(
                    color1: const Color.fromRGBO(248, 103, 248, 1),
                    color2: const Color.fromRGBO(220, 76, 220, 0.8),
                    color3: const Color.fromRGBO(201, 92, 201, 0.6),
                    color4: const Color.fromRGBO(186, 104, 186, 0.4),
                    x1: 1,
                    y1: -1,
                    x2: -1,
                    y2: 1,
                    child: SvgPicture.asset(
                      'image/ranking_board/type.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),

              //  Time, Distance icon
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: isTime
                      ? RadiantGradientMask(
                          color1: const Color.fromRGBO(50, 44, 255, 1),
                          color2: const Color.fromRGBO(100, 44, 255, 0.8),
                          color3: const Color.fromRGBO(186, 104, 186, 0.5),
                          color4: const Color.fromRGBO(186, 104, 186, 0.1),
                          x1: 1,
                          y1: -1,
                          x2: -1,
                          y2: 1,
                          child: const Icon(
                            Icons.timer_outlined,
                            size: 170,
                            color: Colors.white,
                          ),
                        )
                      : RadiantGradientMask(
                          color1: const Color.fromRGBO(50, 44, 255, 1),
                          color2: const Color.fromRGBO(100, 44, 255, 0.8),
                          color3: const Color.fromRGBO(186, 104, 186, 0.5),
                          color4: const Color.fromRGBO(186, 104, 186, 0.1),
                          x1: 1,
                          y1: -1,
                          x2: -1,
                          y2: 1,
                          child: const Icon(
                            Icons.north,
                            size: 170,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              //  Time, Distacne text
              Center(
                child: isTime
                    ? Padding(
                        padding: const EdgeInsets.only(top: 160.0),
                        child: Column(
                          children: const [
                            Align(
                              heightFactor: 0.5,
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 65,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 40.0),
                              child: Text(
                                'Top 100',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    // const Text.rich(TextSpan(
                    //     text: 'Time',
                    //     style: TextStyle(
                    //       fontFamily: 'Jost',
                    //       color: Colors.white,
                    //       fontSize: 65,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     children: [
                    //         TextSpan(
                    //             text: '\n Top 100',
                    // style: TextStyle(
                    //   fontFamily: 'Jost',
                    //   color: Colors.white,
                    //   fontSize: 25,
                    //             ))
                    //       ]))
                    : Padding(
                        padding: const EdgeInsets.only(top: 170.0),
                        child: Column(
                          children: const [
                            Align(
                              heightFactor: 0.5,
                              child: Text(
                                'Distance',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 130.0),
                              child: Text(
                                'Top 100',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),

        //  1st
        Stack(
          children: [
            Center(
              child: Container(
                key: isMe ? userKey : null,
                height: 400,
                width: MediaQuery.of(context).size.width * 0.85,
                child: RadiantGradientMask(
                  color1: const Color.fromRGBO(186, 104, 186, 0),
                  color2: const Color.fromRGBO(159, 101, 190, 0.5),
                  color3: const Color.fromRGBO(147, 99, 201, 0.8),
                  color4: const Color.fromRGBO(129, 97, 208, 1),
                  x1: -1,
                  y1: -1,
                  x2: 1,
                  y2: 1,
                  child: SvgPicture.asset(
                    'image/ranking_board/1st.svg',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),

            //  User profile
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 110, right: 150),
                child: UserImage(data, documentId, context, 120, 120, 6, '1'),
              ),
            ),

            //  User name, statistic
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 130, left: 130),
                child: UserNameStatic(
                    data,
                    isTime,
                    context,
                    Colors.white,
                    25,
                    Colors.white,
                    isTime ? 26 : 30,
                    Colors.white,
                    isTime ? 25 : 25),
              ),
            ),

            //  Ranking
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 235.0, left: 150),
                child: Text.rich(
                  TextSpan(
                    text: '$number',
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'st',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//  2nd
Widget ranking2nd(Map<String, dynamic> data, int number, bool isTime,
    String documentId, BuildContext context, GlobalKey userKey) {
  bool isMe = false;

  final user = FirebaseAuth.instance.currentUser;

  if (documentId == user!.uid) {
    isMe = true;
  }
  return Align(
    heightFactor: 0.4,
    child: Stack(
      children: [
        Center(
          child: Container(
            key: isMe ? userKey : null,
            height: 400,
            width: MediaQuery.of(context).size.width * 0.85,
            child: RadiantGradientMask(
              color1: const Color.fromRGBO(129, 97, 208, 0.1),
              color2: const Color.fromRGBO(129, 97, 208, 0.4),
              color3: const Color.fromRGBO(129, 97, 208, 0.7),
              color4: const Color.fromRGBO(129, 97, 208, 1),
              x1: 1,
              y1: -1,
              x2: -1,
              y2: 1,
              child: SvgPicture.asset(
                'image/ranking_board/2nd.svg',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),

        //  User profile
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 110, left: 150),
            child: UserImage(data, documentId, context, 120, 120, 6, '2'),
          ),
        ),

        //  User name, statistic
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 130, right: 130),
            child: UserNameStatic(data, isTime, context, Colors.white, 25,
                Colors.white, isTime ? 26 : 30, Colors.white, isTime ? 25 : 25),
          ),
        ),

        //  Ranking
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 235.0, right: 150),
            child: Text.rich(
              TextSpan(
                text: '$number',
                style: const TextStyle(
                  fontFamily: 'Jost',
                  color: Colors.white,
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'nd',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

//  3rd
Widget ranking3rd(Map<String, dynamic> data, int number, bool isTime,
    String documentId, BuildContext context, GlobalKey userKey) {
  bool isMe = false;

  final user = FirebaseAuth.instance.currentUser;

  if (documentId == user!.uid) {
    isMe = true;
  }
  return Stack(
    children: [
      Center(
        child: Container(
          key: isMe ? userKey : null,
          height: 400,
          width: MediaQuery.of(context).size.width * 0.85,
          child: RadiantGradientMask(
            color1: const Color.fromRGBO(129, 97, 208, 0.1),
            color2: const Color.fromRGBO(95, 93, 215, 0.4),
            color3: const Color.fromRGBO(76, 93, 220, 0.7),
            color4: const Color.fromRGBO(61, 90, 230, 1),
            x1: -1,
            y1: -1,
            x2: 1,
            y2: 1,
            child: SvgPicture.asset(
              'image/ranking_board/3rd.svg',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),

      //  User profile
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 110, right: 150),
          child: UserImage(data, documentId, context, 120, 120, 6, '3'),
        ),
      ),

      //  User name, statistic
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 130, left: 130),
          child: UserNameStatic(data, isTime, context, Colors.white, 25,
              Colors.white, isTime ? 26 : 30, Colors.white, isTime ? 25 : 25),
        ),
      ),

      //  Ranking
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 235.0, left: 150),
          child: Text.rich(
            TextSpan(
              text: '$number',
              style: const TextStyle(
                fontFamily: 'Jost',
                color: Colors.white,
                fontSize: 65,
                fontWeight: FontWeight.bold,
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: 'rd',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

//  4th or below
Widget rankingDesign(Map<String, dynamic> data, int number, bool isTime,
    String documentId, BuildContext context, GlobalKey userKey) {
  bool isMe = false;

  final user = FirebaseAuth.instance.currentUser;

  if (documentId == user!.uid) {
    isMe = true;
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Container(
      key: isMe ? userKey : null,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: isMe
            ? const Color.fromARGB(255, 116, 30, 255)
            : const Color.fromARGB(255, 46, 36, 80),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //  Ranking
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: '$number',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        color: Colors.white,
                        fontSize: number > 99
                            ? 30
                            : number > 9
                                ? 35
                                : 40,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'th',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //  User name, statistic
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, right: 5),
                  child: UserNameStatic(
                      data,
                      isTime,
                      context,
                      Colors.grey[500],
                      18,
                      Colors.white,
                      isTime ? 21 : 29,
                      Colors.white,
                      isTime ? 21 : 26),
                ),

                //  User profile image
                UserImage(data, documentId, context, 90, 90, 4, '4~'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//  Icon gradient funcfion
class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({
    required this.child,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });
  final Widget child;
  double x1, y1;
  double x2, y2;
  Color color1;
  Color color2;
  Color color3;
  Color color4;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment(x1, y1),
        end: Alignment(x2, y2),
        colors: [
          color1,
          color2,
          color3,
          color4,
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

//  User profile slot
Widget UserImage(
  Map<String, dynamic> data,
  String documentId,
  BuildContext context,
  double height,
  double width,
  double circlePadding,
  String rank,
) {
  return //  user profile image
      GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return userProfile(
                context,
                '${data['user_name']}',
                '${data['user_image']}',
                '${data['user_RC']}',
                rank,
                () {},
                () {},
                () {},
                () {});
          });
    },
    child: Container(
      padding: EdgeInsets.all(circlePadding),
      height: height,
      width: width,
      decoration: const BoxDecoration(
        // boxShadow: [
        //   isMe
        //       ? const BoxShadow(
        //           color: Colors.black,
        //           spreadRadius: 0.25,
        //           blurRadius: 2,
        //           offset: Offset(0, 1),
        //         )
        //       : const BoxShadow(),
        // ],
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
        foregroundImage: NetworkImage(data['user_image']),
        child: const Icon(
          Icons.account_circle,
          size: 75,
          color: Colors.grey,
        ),
      ),
    ),
  );
}

//  User name, statistic
Widget UserNameStatic(
  Map<String, dynamic> data,
  bool isTime,
  BuildContext context,
  Color? nameColor,
  double nameSize,
  Color? staticColor,
  double staticSize,
  Color? unitColor,
  double unitSize,
) {
  String displayedDist = convertDist('${data['sum_distance']}');
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        '${data['user_name']}',
        style: TextStyle(
          color: nameColor,
          fontSize: nameSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      isTime
          ? Text.rich(
              TextSpan(
                text: convertTime('${data['sum_time']}'),
                //text: '${data['sum_time']}',
                style: TextStyle(
                  fontFamily: 'Jost',
                  color: staticColor,
                  fontSize: staticSize,
                  //fontWeight: FontWeight.bold,
                ),
                // children: <TextSpan>[
                //   TextSpan(
                //     text: ' min',
                //     style: TextStyle(
                //       fontSize:
                //           ('${data['sum_time']}'.length > 3) ? 21 : unitSize,
                //       color: unitColor,
                //     ),
                //   ),
                // ],
              ),
            )
          : Text.rich(
              TextSpan(
                text: displayedDist,
                //text: '${data['sum_distance']}',
                style: TextStyle(
                  fontFamily: 'Jost',
                  color: staticColor,
                  fontSize: displayedDist.length > 4 ? 22 : staticSize,
                  //fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: double.parse('${data['sum_distance']}') >= 1
                        ? ' km'
                        : ' m',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize:
                          '${data['sum_distance']}'.length > 4 ? 19 : unitSize,
                      color: unitColor,
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}
