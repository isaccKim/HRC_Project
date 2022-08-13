import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrc_project/ranking_board_page/read_data/get_person_data.dart';
import 'package:hrc_project/ranking_board_page/ranking_board_design/ranking_borad_design.dart';

import '../dialog_page/show_dialog.dart';

class DistanceRank extends StatefulWidget {
  const DistanceRank({Key? key}) : super(key: key);

  @override
  State<DistanceRank> createState() => _DistanceRankState();
}

class _DistanceRankState extends State<DistanceRank>
    with AutomaticKeepAliveClientMixin {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];
  List<String> docIDs2 = [];

  //  4th or below
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('sum_distance', isNotEqualTo: 0)
        //  데이터 정렬!!
        .orderBy('sum_distance', descending: true)
        .limit(100)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (doccument) {
              docIDs.add(doccument.reference.id);
            },
          ),
        );
  }

  //  3rd or higher
  Future getDocId2() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('sum_distance', isNotEqualTo: 0)
        //  데이터 정렬!!
        .orderBy('sum_distance', descending: true)
        .limit(100)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (doccument) {
              docIDs2.add(doccument.reference.id);
            },
          ),
        );
  }

  Future refreshPage() {
    setState(() {
      docIDs.clear();
      docIDs2.clear();
    });
    return Future.delayed(Duration(milliseconds: 0));
  }

  final typeKey = GlobalKey(); //  page up
  final userKey = GlobalKey(); //  find user record

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: const Color.fromARGB(255, 35, 25, 60),
          color: const Color.fromRGBO(220, 76, 220, 0.8),
          onRefresh: refreshPage,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getDocId2(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (docIDs2.length > 2) {
                            return Column(
                              children: [
                                GetPersonData(
                                  documentId: docIDs2[0],
                                  number: 0,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                                GetPersonData(
                                  documentId: docIDs2[1],
                                  number: 1,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                                GetPersonData(
                                  documentId: docIDs2[2],
                                  number: 2,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                              ],
                            );
                          } else if (docIDs2.length > 1) {
                            return Column(
                              children: [
                                GetPersonData(
                                  documentId: docIDs2[0],
                                  number: 0,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                                GetPersonData(
                                  documentId: docIDs2[1],
                                  number: 1,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                                const SizedBox(height: 200),
                              ],
                            );
                          } else if (docIDs2.isNotEmpty) {
                            return Column(
                              children: [
                                GetPersonData(
                                  documentId: docIDs2[0],
                                  number: 0,
                                  isTime: false,
                                  context: context,
                                  typeKey: typeKey,
                                  userKey: userKey,
                                ),
                                const SizedBox(height: 80),
                              ],
                            );
                          } else {
                            return noData(false, context, typeKey);
                          }
                        } else {
                          return const Padding(
                            padding: EdgeInsets.only(top: 300.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getDocId(),
                      builder: (context, snapshot) {
                        return ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: docIDs.length + 1,
                          itemBuilder: (context, index) {
                            if (docIDs.length != index && index > 2) {
                              return GetPersonData(
                                documentId: docIDs[index],
                                number: index,
                                isTime: false,
                                context: context,
                                typeKey: typeKey,
                                userKey: userKey,
                              );
                            } else if (index > 2) {
                              return const SizedBox(height: 60);
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          separatorBuilder: (context, index) {
                            if (index > 2) {
                              return Divider(
                                height: 15,
                                color: Colors.white.withOpacity(0),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              // page up button
              Padding(
                padding: const EdgeInsets.only(bottom: 130.0, right: 7),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      Scrollable.ensureVisible(typeKey.currentContext!,
                          duration: const Duration(milliseconds: 600));
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(147, 99, 201, 1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // find user button
              Padding(
                padding: const EdgeInsets.only(bottom: 75.0, right: 7),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      var nullCheck = userKey.currentContext;
                      if (nullCheck != null) {
                        Scrollable.ensureVisible(userKey.currentContext!,
                            duration: const Duration(milliseconds: 600));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(customSnackBar('랭킹 정보가 없습니다.'));
                      }
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(61, 90, 230, 1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
