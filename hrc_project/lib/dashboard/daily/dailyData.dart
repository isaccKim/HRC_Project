import 'package:flutter/material.dart';

class DailyRecord extends StatelessWidget {
  const DailyRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MyListView(context);
  }
}

Widget _MyListView(BuildContext context) {
  final TextStyle _textStyle = TextStyle(
    color: Colors.white.withOpacity(0.9),
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );
  Image Distance = Image.asset('image/distance.png',
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);

  Image Running_duration = Image.asset('image/hourglass.png',
      color: Colors.black.withOpacity(0.7),
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);

  Image Running_pace = Image.asset('image/running-shoe.png',
      color: Colors.black.withOpacity(0.7),
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Distance,
                        const Divider(
                          indent: 10,
                        ),
                        Text(
                          '12 km',
                          style: _textStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Running_duration,
                        const Divider(),
                        Text(
                          '00:00:12',
                          style: _textStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Running_pace,
                        const Divider(
                          indent: 10,
                        ),
                        Text(
                          '5\'22\'\'',
                          style: _textStyle,
                        ),
                      ],
                    )
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
