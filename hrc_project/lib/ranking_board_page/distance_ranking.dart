import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/ranking_board_page/get_person_data/get_person_data.dart';

class DistanceRank extends StatefulWidget {
  const DistanceRank({Key? key}) : super(key: key);

  @override
  State<DistanceRank> createState() => _DistanceRankState();
}

class _DistanceRankState extends State<DistanceRank> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
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

  @override
  Widget build(BuildContext context) {
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
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return GetPersonData(
                        documentId: docIDs[index],
                        number: index,
                        isTime: false,
                      );
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
}
