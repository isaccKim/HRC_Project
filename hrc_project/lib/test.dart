import 'package:flutter/material.dart';
import 'package:hrc_project/ranking_board_page/distance_ranking.dart';
import 'package:hrc_project/ranking_board_page/time_ranking.dart';

void main() {
  runApp(const TestPage());
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: []));
  }
}
