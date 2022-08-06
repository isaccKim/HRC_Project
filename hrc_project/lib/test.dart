import 'package:flutter/material.dart';

void main() {
  runApp(const TestPage());
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.blue,
            width: 30,
            height: MediaQuery.of(context).size.height,
          ),
          // child: Text(
          //   'WOW',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 30,
          //   ),
          // ),
        ),
      ),
    );
  }
}
