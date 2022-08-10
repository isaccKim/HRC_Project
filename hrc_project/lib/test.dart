import 'package:flutter/material.dart';
import 'dialog_page/rc_select_dialog.dart';
import 'dialog_page/show_dialog.dart';

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
          child: Align(
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () {},
        ),
      )),
    );
  }
}
