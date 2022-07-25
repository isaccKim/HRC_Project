// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetPersonData extends StatelessWidget {
  final String documentId;

  GetPersonData({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Text('${data['user_image']}' +
              '@^@' +
              '${data['user_name']}' +
              '@^@' +
              '${data['sum_time']}' +
              '@^@' +
              '${data['sum_distance']}');
        }

        return Text('loading...');
      }),
    );
  }
}
