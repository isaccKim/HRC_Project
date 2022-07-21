import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart' as grad;

class ToDayRun {
  double distance = 0;
  double pace = 0;
  double time = 0;
}

class RunBox extends StatefulWidget {
  RunBox({Key? key}) : super(key: key);

  @override
  State<RunBox> createState() => _RunBoxState();
}

class _RunBoxState extends State<RunBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height,
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
//Stack - text : Today Run / distance / time / pace
              child: Stack(
                children: <Widget>[
//Today Run
                  Positioned(
                    left: 25,
                    top: 70,
                    child: grad.GradientText(
                      'Last Running',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromARGB(79, 195, 159, 231)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
// Distance
                  Positioned(
                    left: 200,
                    top: 160,
                    child: grad.GradientText(
                      'Distance : ',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromARGB(79, 195, 159, 231)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
// time
                  Positioned(
                    left: 40,
                    bottom: 65,
                    child: grad.GradientText(
                      'Time : ',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromARGB(79, 195, 159, 231)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
// pace
                  Positioned(
                    right: 104,
                    bottom: 65,
                    child: grad.GradientText(
                      'Pace : ',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromARGB(79, 195, 159, 231)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
