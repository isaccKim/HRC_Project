import 'package:flutter/material.dart';

class DailyRecord extends StatelessWidget {
  const DailyRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MyListView(context);
  }
}

Widget _MyListView(BuildContext context) {
  return ListView.separated(
    // scrollDirection: Axis.horizontal,

    itemCount: entries.length,
    itemBuilder: (BuildContext cntx, int index) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(179, 100, 40, 211).withOpacity(0.74),
              const Color.fromARGB(145, 43, 143, 193)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          //color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        height: 110,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${entries[index]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.run_circle_outlined, size: 50),
                          SizedBox(
                            width: 10,
                          ),
                          Text('test'),
                        ],
                      ),
                    ),
                    Icon(Icons.run_circle_outlined, size: 50),
                    Icon(Icons.run_circle_outlined, size: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    //리스트 박스별 구분
    separatorBuilder: (BuildContext contxt, int index) {
      return const Divider(
        height: 30.0,
      );
    },
  );
}

final List<String> entries = <String>[
  'Date : 7/2',
  'Date : 7/3',
  'Date : 7/4',
  'Date : 7/5',
  'Date : 7/6',
  'Date : 7/7',
  'Date : 7/8',
  'Date : 7/9',
  'Date : 7/10',
  'Date : 7/11',
  'Date : 7/12'
];
