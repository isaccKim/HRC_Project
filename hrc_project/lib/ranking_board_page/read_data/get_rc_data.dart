import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ranking_board_design/rc_ranking_board_design.dart';

class GetRcData extends StatefulWidget {
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
  State<GetRcData> createState() => _GetRcDataState();
}

class _GetRcDataState extends State<GetRcData> {
  Future getUserRCData() async {
    String userRC = '';
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userData.get().then((value) => {
          userRC = value['user_RC'],
        });

    return userRC;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference rcCollection =
        FirebaseFirestore.instance.collection('rc');
    return FutureBuilder<DocumentSnapshot>(
      future: rcCollection.doc(widget.documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (widget.number == 0) {
            return rcRanking1st(
                data, widget.number + 1, widget.documentId, context);
          } else if (widget.number == 1) {
            return rcRanking2nd(
                data, widget.number + 1, widget.documentId, context);
          } else if (widget.number == 2) {
            return rcRanking3rd(
                data, widget.number + 1, widget.documentId, context);
          }
          return rcRankingDesign(
              data, widget.number + 1, widget.documentId, context);
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
