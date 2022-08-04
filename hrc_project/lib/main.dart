// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/counter.dart';
import 'package:hrc_project/running_main/savePage.dart';
import 'package:hrc_project/running_main/stop.dart';
import 'package:hrc_project/running_main/temp.dart';
import 'login_page/pages/start_page.dart';
import 'running_main/showmap.dart';
import 'running_main/temp_2.dart';
import 'running_main/tester.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapSample(),
    );
  }
}
