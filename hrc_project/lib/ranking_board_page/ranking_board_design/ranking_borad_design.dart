import 'package:flutter/material.dart';

//  3rd or higher
Widget rankingTopTreeDesign(
    Map<String, dynamic> data, int number, bool isTime, String documentId) {
  return Center(
    child: Text(
      'wow',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

//  4th or below
Widget rankingDesign(
    Map<String, dynamic> data, int number, bool isTime, String documentId) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Container(
      height: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Color.fromARGB(255, 46, 36, 80),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //  Ranking
              Flexible(
                fit: FlexFit.tight,
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: ' th',
                          style: TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //  user name, statistic
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${data['user_name']}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      isTime
                          ? Text.rich(
                              TextSpan(
                                text: '${data['sum_time']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: ' hr',
                                    style: TextStyle(fontSize: 23),
                                  ),
                                ],
                              ),
                            )
                          : Text.rich(
                              TextSpan(
                                text: '${data['sum_distance']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: ' km',
                                    style: TextStyle(fontSize: 23),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),

              //  user profile image
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromRGBO(248, 103, 248, 0.95),
                        Color.fromRGBO(61, 90, 230, 1)
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[200],
                    foregroundImage: NetworkImage(data['user_image']),
                    child: const Icon(
                      Icons.account_circle,
                      size: 75,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
