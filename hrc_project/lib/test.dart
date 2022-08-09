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
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return rcSelectDialogWidget(
                      context: context,
                      boxHeight: 370,
                      topBarHeight: 30,
                      topBarText: 'RC 선택하기',
                      topBarTextSize: 15,
                      mainText: '',
                      mainTextSize: 17,
                      executableFuc1: () {},
                      executableFuc2: () {},
                      executableFuc3: () {},
                      executableFuc4: () {},
                      executableFuc5: () {},
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
