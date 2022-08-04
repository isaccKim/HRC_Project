// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hrc_project/login_page/auth/auth_page.dart';
import 'login_page/pages/start_page.dart';
import 'running_main/showmap.dart';
import 'running_main/temp_2.dart';
import 'running_main/tester.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (BuildContext context) => StartPageWidget(),
      '/second': (BuildContext context) => AuthPage(),
    },
  );

  runApp(MyApp());
}

Future hideSmartPhoneBar() async {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    hideSmartPhoneBar();
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: StartPageWidget(),

    );
  }
}
