import 'dart:math';

import 'package:flutter/material.dart';

class Day10Page extends StatefulWidget {
  const Day10Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day10PageState();
}

class _Day10PageState extends State<Day10Page> {
  final list = ["가위", "바위", "보"];
  String computerChoice = "";
  String myChoice = "";
  String result = "";

  void select(String mySelect) {
    final random = Random().nextInt(3);

    setState(() {
      computerChoice = list[random];
      myChoice = mySelect;

      if (computerChoice == myChoice) {
        result = "무승부입니다.";
      } else if (computerChoice == "가위" && myChoice == "바위" ||
          computerChoice == "바위" && myChoice == "보" ||
          computerChoice == "보" && myChoice == "가위") {
        result = "나의 승리입니다.";
      } else {
        result = "나의 패배입니다.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("가위바위보 게임")),
      body: Center(
        child: Column(
          children: [
            Text("가위, 바위, 보 중에 하나 선택하세요."),
            ElevatedButton(
              onPressed: () => select("가위"),
              child: Text("가위"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => select("바위"),
              child: Text("바위"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => select("보"),
              child: Text("보"),
            ),
            const SizedBox(height: 12),
            Text("컴퓨터의 결과: $computerChoice"),
            const SizedBox(height: 12),
            Text("나의 결과: $myChoice"),
            const SizedBox(height: 12),
            Text("승부 결과: $result"),
          ],
        ),
      ),
    );
  }
}
