import 'package:flutter/material.dart';

class RunBox extends StatefulWidget {
  RunBox({Key? key}) : super(key: key);

  @override
  State<RunBox> createState() => _RunBoxState();
}

class _RunBoxState extends State<RunBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            height: 318,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(179, 100, 40, 211).withOpacity(0.74),
                    const Color.fromARGB(145, 43, 143, 193)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(179, 120, 68, 216).withOpacity(0.74),
                  Color.fromARGB(145, 170, 104, 186)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              children: const [
                SizedBox(
                  width: 50,
                ),
                Text('Day'),
                SizedBox(
                  width: 50,
                ),
                Text('Week'),
                SizedBox(
                  width: 50,
                ),
                Text('Month'),
                SizedBox(
                  width: 50,
                ),
                Text('Year'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
