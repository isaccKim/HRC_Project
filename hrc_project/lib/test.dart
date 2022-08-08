import 'package:flutter/material.dart';
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
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return rcSelectDialog(
                      context,
                      270,
                      30,
                      'RC 선택하기',
                      15,
                      'WOW',
                      17,
                      () {},
                      () {},
                      () {},
                      () {},
                      () {},
                    );
                  });
            },
            child: const Text('RC select'),
          ),
        ),
      ),
    );
  }
}
