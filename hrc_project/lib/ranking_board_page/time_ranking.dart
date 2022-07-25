import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrc_project/ranking_board_page/get_uesr_data/get_person_data.dart';

class TimeRank extends StatefulWidget {
  const TimeRank({Key? key}) : super(key: key);

  @override
  State<TimeRank> createState() => _TimeRankState();
}

class _TimeRankState extends State<TimeRank> {
  String user_name = '';
  double? sum_time;
  String user_image = '';
  Text? stringWidget;
  late List<String> personData;

  // //  Get user data from cloud Firestore
  // Future _getUserData() async {
  //   final user = await FirebaseAuth.instance.currentUser;
  //   final userData =
  //       await FirebaseFirestore.instance.collection('users').doc(user!.uid);

  //   await userData.get().then(
  //         (value) => {
  //           user_name = value['user_name'],
  //           sum_time = value['sum_time'],
  //           user_image = value['user_image'],
  //         },
  //       );
  // }

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 25, 60),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      CollectionReference usersFile =
                          FirebaseFirestore.instance.collection('users');
                      return FutureBuilder(
                          future: usersFile.doc(docIDs[index]).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
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
                          }
                          // stringWidget =
                          //     GetPersonData(documentId: docIDs[index]);
                          // personData =
                          //     GetPersonData(documentId: docIDs[index]);
                          // user_image = personData[0];
                          // user_name = personData[1];
                          // sum_time = double.parse(personData[2]);

                          // trailing: Container(
                          //   padding: EdgeInsets.all(4),
                          //   height: 100,
                          //   width: 100,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     gradient: LinearGradient(
                          //       begin: Alignment.topRight,
                          //       end: Alignment.bottomLeft,
                          //       colors: [
                          //         Color.fromRGBO(248, 103, 248, 0.95),
                          //         Color.fromRGBO(61, 90, 230, 1)
                          //       ],
                          //     ),
                          //   ),
                          //   child: CircleAvatar(
                          //     radius: 45,
                          //     backgroundColor: Colors.grey[200],
                          //     foregroundImage: NetworkImage(user_image),
                          //     child: Icon(
                          //       Icons.account_circle,
                          //       size: 75,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),

                          // child: Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          //   child: Container(
                          //     height: 130,
                          //     decoration: const BoxDecoration(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(15),
                          //       ),
                          //       color: Color.fromARGB(255, 46, 36, 80),
                          //     ),
                          //     child: Stack(
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.only(
                          //               left: 10, top: 21, bottom: 21),
                          //           child: Row(
                          //             children: [
                          //               Container(
                          //                 padding: const EdgeInsets.all(4),
                          //                 height: 100,
                          //                 width: 100,
                          //                 decoration: const BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   gradient: LinearGradient(
                          //                     begin: Alignment.topRight,
                          //                     end: Alignment.bottomLeft,
                          //                     colors: [
                          //                       Color.fromRGBO(248, 103, 248, 0.95),
                          //                       Color.fromRGBO(61, 90, 230, 1)
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 child: CircleAvatar(
                          //                   radius: 45,
                          //                   backgroundColor: Colors.grey[200],
                          //                   foregroundImage:
                          //                       NetworkImage(user_image),
                          //                   child: const Icon(
                          //                     Icons.account_circle,
                          //                     size: 75,
                          //                     color: Colors.grey,
                          //                   ),
                          //                 ),
                          //               ),
                          //               const SizedBox(width: 7),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     top: 20, bottom: 10),
                          //                 child: Column(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     Text(
                          //                       '${user_name}',
                          //                       style: const TextStyle(
                          //                         color: Colors.white,
                          //                         fontSize: 20,
                          //                         fontWeight: FontWeight.bold,
                          //                       ),
                          //                     ),
                          //                     const SizedBox(height: 10),
                          //                     Text(
                          //                       '${sum_time.toString()}',
                          //                       style: const TextStyle(
                          //                         color: Colors.white,
                          //                         fontSize: 13,
                          //                         fontWeight: FontWeight.bold,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          );
                      // return Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ListTile(
                      //     title:
                      //         GetUserName(documentId: docIDs[index]),
                      //     tileColor: Colors.grey[100],
                      //   ),
                      // );
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
