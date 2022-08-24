import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';

import 'package:intl/intl.dart';

class GetDailyData extends StatelessWidget {
  final String docsId;
  const GetDailyData({Key? key, required this.docsId}) : super(key: key);

  String formatTimeStamp(Timestamp timestamp) {
    var text = DateFormat('MM/dd');
    return text.format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('running record');

    return FutureBuilder<DocumentSnapshot>(
        future: data.doc(docsId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> runData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Container(
              decoration: boxdeco,
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text('Date : ${formatTimeStamp(runData['date'])}',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Distance(context),
                            Divider(
                                height: 15, color: Colors.white.withOpacity(0)),
                            Text(
                              '${runData['distance'].toStringAsFixed(2)} km',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Running_duration(context),
                            Divider(
                                height: 15, color: Colors.white.withOpacity(0)),
                            Text(
                              timeTextFormat(runData['time']),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Running_pace(context),
                            Divider(
                                height: 15, color: Colors.white.withOpacity(0)),
                            Text(
                              '${runData['pace'].toStringAsFixed(2)} m/s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
