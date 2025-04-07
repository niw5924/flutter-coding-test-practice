import 'dart:math';

import 'package:flutter/material.dart';

class Day7Page extends StatefulWidget {
  const Day7Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day7PageState();
}

class _Day7PageState extends State<Day7Page> {
  int number = 0;
  bool isShowed = false;
  final _controller = TextEditingController();
  String answerText = "";

  void startGame() {
    setState(() {
      number = Random().nextInt(999) + 1;
      isShowed = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isShowed = false;
      });
    });
  }

  void checkAnswer() {
    final controllerText = _controller.text.trim();
    final myAnswer = int.tryParse(controllerText);

    setState(() {
      if (myAnswer != null) {
        if (number == myAnswer) {
          answerText = "정답입니다.";
        } else {
          answerText = "오답입니다.";
        }
      } else {
        answerText = "유효한 값을 입력해주세요.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("숫자 기억 게임")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: startGame,
            child: Text("게임 시작"),
          ),
          const SizedBox(height: 12),
          if (isShowed) Text("$number"),
          const SizedBox(height: 12),
          if (!isShowed && number != 0)
            Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "정답을 입력하세요"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: checkAnswer,
                  child: Text("정답 확인"),
                ),
                Text(answerText),
              ],
            ),
        ],
      ),
    );
  }
}
