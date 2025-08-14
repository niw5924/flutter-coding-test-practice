import 'package:flutter/material.dart';
import 'package:flutter_coding_test_practice/levels/intermediate/day25_http_users_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 코딩 테스트 연습',
      theme: ThemeData(primarySwatch: Colors.blue),

      /// 이 부분만 바꿔야 함.
      home: Day25Page(),
    );
  }
}
