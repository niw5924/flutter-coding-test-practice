import 'dart:async';

import 'package:flutter/material.dart';

class Day8Page extends StatefulWidget {
  const Day8Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day8PageState();
}

class _Day8PageState extends State<Day8Page> {
  final _controller = TextEditingController();
  Timer? timer;
  int remainingTime = 0;
  String message = '';
  bool isRunning = false;

  void startTimer() {
    final duration = int.tryParse(_controller.text.trim());

    if (duration != null) {
      setState(() {
        remainingTime = duration;
        isRunning = true;
        message = '';
      });

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime--;

          if (remainingTime == 0) {
            timer.cancel();
            isRunning = false;
            message = '타이머 종료!';
          }
        });
      });
    } else {
      setState(() {
        message = "유효한 값을 입력해주세요.";
      });
    }
  }

  void resetTimer() {
    timer?.cancel();
    _controller.clear();
    setState(() {
      isRunning = false;
      message = '';
      remainingTime = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("타이머 앱")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            enabled: !isRunning,
            decoration: InputDecoration(hintText: "초를 입력하세요."),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isRunning ? null : startTimer,
            child: Text("시작"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: !isRunning ? null : resetTimer,
            child: Text("초기화"),
          ),
          const SizedBox(height: 12),
          if (isRunning) Text('$remainingTime'),
          const SizedBox(height: 12),
          if (message.isNotEmpty) Text(message),
        ],
      ),
    );
  }
}
