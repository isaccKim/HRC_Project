import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hrc_project/ranking_board_page/get_person_data/get_person_data.dart';

class TimeRank extends StatefulWidget {
  const TimeRank({Key? key}) : super(key: key);

  @override
  State<TimeRank> createState() => _TimeRankState();
}

class _TimeRankState extends State<TimeRank>
    with AutomaticKeepAliveClientMixin {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        //  데이터 정렬!!
        .orderBy('sum_time', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (doccument) {
              docIDs.add(doccument.reference.id);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: docIDs.length + 1,
                    itemBuilder: (context, index) {
                      if (docIDs.length != index) {
                        return GetPersonData(
                          documentId: docIDs[index],
                          number: index,
                          isTime: true,
                          context: context,
                        );
                      } else {
                        return const SizedBox(height: 80);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(height: 15);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
