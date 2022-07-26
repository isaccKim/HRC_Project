// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ranking_board_design/ranking_borad_design.dart';

class GetPersonData extends StatelessWidget {
  final String documentId;
  final int number;
  final bool isTime;
  BuildContext context;

  GetPersonData({
    Key? key,
    required this.documentId,
    required this.number,
    required this.isTime,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (number < 3) {
            return rankingTopTreeDesign(
                data, number + 1, isTime, documentId, context);
          }
          return rankingDesign(data, number + 1, isTime, documentId, context);
        }

        return Text('loading...');
      }),
    );
  }
}
