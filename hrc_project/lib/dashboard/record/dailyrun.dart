import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hrc_project/dashboard/read_data/get_daily_data.dart';
import 'package:hrc_project/dashboard/widget_source/source.dart';
import 'package:intl/intl.dart';

import '../dashboard_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

final List<String> entries = <String>[];

class TextFormat extends grad.GradientText {
  TextFormat(super.data, {Key? key, super.style, required super.gradient});
}

class DailyMain extends StatefulWidget {
  const DailyMain({Key? key}) : super(key: key);

  @override
  State<DailyMain> createState() => _DailyMainState();
}

class _DailyMainState extends State<DailyMain> {
  List<String> docsId = [];

  Future getRunDocs() async {
    final user = await FirebaseAuth.instance.currentUser;
    final runningData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('running record');
    docsId.clear();
    await runningData
        //  데이터 정렬!!
        .orderBy('date', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (doccument) {
              docsId.add(doccument.reference.id);
            },
          ),
        );
  }

  Future refreshPage() {
    setState(() {
      docsId.clear();
    });
    return Future.delayed(Duration(milliseconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      child: Expanded(
        child: FutureBuilder(
          future: getRunDocs(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: docsId.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    decoration: boxdeco,
                    height: MediaQuery.of(context).size.height * 0.6655,
                    child: DailyBoxDesign(latestDocsId: docsId[index]),
                  );
                } else {
                  return Column(
                    children: [
                      Divider(
                          height: MediaQuery.of(context).size.height * 0.03),
                      GetDailyData(docsId: docsId[index]),
                    ],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class DailyBoxDesign extends StatelessWidget {
  final String latestDocsId;

  const DailyBoxDesign({
    Key? key,
    required this.latestDocsId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('running record');
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07,
          vertical: MediaQuery.of(context).size.width * 0.08),
      child: FutureBuilder<DocumentSnapshot>(
        future: data.doc(latestDocsId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> runData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ignore: prefer_const_constructors
                        Text(
                          'Daily Running',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatTimeStamp(runData['date']),
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          )),
                        )
                      ],
                    ),
                  ],
                ),
                //traking images
                const SizedBox(height: 200),
                // Distance
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance :    ${runData['distance']}km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 10),
                    //time
                    Text(
                      'Time :    ${timeTextFormat(runData['time'])}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 10),
                    //pace
                    Text(
                      'Pace :    ${runData['pace']} m/s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  String formatTimeStamp(Timestamp timestamp) {
    var text = DateFormat('y/MM/dd');
    return text.format(timestamp.toDate());
  }
}
