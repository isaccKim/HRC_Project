import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ranking_board_design/rc_ranking_board_design.dart';

class GetRcData extends StatelessWidget {
  final String documentId;
  final int number;
  BuildContext context;

  GetRcData({
    Key? key,
    required this.documentId,
    required this.number,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference rcCollection =
        FirebaseFirestore.instance.collection('rc');
    return FutureBuilder<DocumentSnapshot>(
      future: rcCollection.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (number == 0) {
            return rcRanking1st(data, number + 1, documentId, context);
          } else if (number == 1) {
            return rcRanking2nd(data, number + 1, documentId, context);
          } else if (number == 2) {
            return rcRanking3rd(data, number + 1, documentId, context);
          }
          return rcRankingDesign(data, number + 1, documentId, context);
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
