import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/ranking_board_page/get_person_data/get_person_data.dart';
import 'package:hrc_project/ranking_board_page/ranking_board_design/ranking_borad_design.dart';

class TimeRank extends StatefulWidget {
  const TimeRank({Key? key}) : super(key: key);

  @override
  State<TimeRank> createState() => _TimeRankState();
}

class _TimeRankState extends State<TimeRank>
    with AutomaticKeepAliveClientMixin {
  final user = FirebaseAuth.instance.currentUser!;
  bool reload = true;
  List<String> docIDs = [];
  List<String> docIDs2 = [];

  //  4th or below
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('sum_time', isNotEqualTo: 0)
        //  데이터 정렬!!
        .orderBy('sum_time', descending: true)
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
        .where('sum_time', isNotEqualTo: 0)
        //  데이터 정렬!!
        .orderBy('sum_time', descending: true)
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
      reload = true;
    });
    return Future.delayed(Duration(milliseconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
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
                              isTime: true,
                              context: context,
                            ),
                            GetPersonData(
                              documentId: docIDs2[1],
                              number: 1,
                              isTime: true,
                              context: context,
                            ),
                            GetPersonData(
                              documentId: docIDs2[2],
                              number: 2,
                              isTime: true,
                              context: context,
                            ),
                          ],
                        );
                      } else if (docIDs2.length > 1) {
                        return Column(
                          children: [
                            GetPersonData(
                              documentId: docIDs2[0],
                              number: 0,
                              isTime: true,
                              context: context,
                            ),
                            GetPersonData(
                              documentId: docIDs2[1],
                              number: 1,
                              isTime: true,
                              context: context,
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
                              isTime: true,
                              context: context,
                            ),
                            const SizedBox(height: 80),
                          ],
                        );
                      } else {
                        return noData(true, context);
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
                            isTime: true,
                            context: context,
                          );
                        } else if (index > 2) {
                          return const SizedBox(height: 80);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      separatorBuilder: (context, index) {
                        if (index > 2) {
                          return const Divider(height: 15);
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
