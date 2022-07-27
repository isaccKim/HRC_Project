import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'WOWO',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      )),
    );
  }
}
