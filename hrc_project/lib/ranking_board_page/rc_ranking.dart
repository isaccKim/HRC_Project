import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hrc_project/ranking_board_page/ranking_board_design/rc_ranking_board_design.dart';
import 'package:hrc_project/ranking_board_page/read_data/get_rc_data.dart';

class RcRank extends StatefulWidget {
  const RcRank({Key? key}) : super(key: key);

  @override
  State<RcRank> createState() => _RcRankState();
}

class _RcRankState extends State<RcRank> with AutomaticKeepAliveClientMixin {
  List<String> docIDs = [];
  List<String> docIDs2 = [];
  String userRC = '';

  //  4th or below
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('rc')
        //  데이터 정렬!!
        .orderBy('sum_distance', descending: true)
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
        .collection('rc')
        //  데이터 정렬!!
        .orderBy('sum_distance', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (doccument) {
              docIDs2.add(doccument.reference.id);
            },
          ),
        );
  }

  //  Get user RC data
  Future getUserRCData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then((value) => {
          userRC = value['user_RC'],
        });
  }

  Future refreshPage() {
    setState(() {
      docIDs.clear();
      docIDs2.clear();
      userRC = '';
    });
    return Future.delayed(Duration(milliseconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: const Color.fromARGB(255, 35, 25, 60),
          color: const Color.fromRGBO(220, 76, 220, 0.8),
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                //  3rd or higher
                FutureBuilder(
                  future: getDocId2(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (docIDs2.length > 2) {
                        return Column(
                          children: [
                            GetRcData(
                              documentId: docIDs2[0],
                              number: 0,
                              context: context,
                              userRC: userRC,
                            ),
                            GetRcData(
                              documentId: docIDs2[1],
                              number: 1,
                              context: context,
                              userRC: userRC,
                            ),
                            GetRcData(
                              documentId: docIDs2[2],
                              number: 2,
                              context: context,
                              userRC: userRC,
                            ),
                          ],
                        );
                      } else {
                        return noData(context);
                      }
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(top: 300.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                //  Read user RC data
                FutureBuilder(
                  future: getUserRCData(),
                  builder: ((context, snapshot) {
                    //  4th or below list view
                    return FutureBuilder(
                      future: getDocId(),
                      builder: (context, snapshot) {
                        return ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: docIDs.length + 1,
                          itemBuilder: (context, index) {
                            if (docIDs.length != index && index > 2) {
                              return GetRcData(
                                documentId: docIDs[index],
                                number: index,
                                context: context,
                                userRC: userRC,
                              );
                            } else if (index > 2) {
                              return const SizedBox(height: 80);
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
                    );
                  }),
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
