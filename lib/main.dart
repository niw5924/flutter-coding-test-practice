import 'package:flutter/material.dart';

import 'levels/beginner/todo_list.dart';

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
      home: TodoListPage(),
    );
  }
}
