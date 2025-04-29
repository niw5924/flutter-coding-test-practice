import 'dart:async';

import 'package:flutter/material.dart';

class Day12Page extends StatefulWidget {
  const Day12Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day12PageState();
}

class _Day12PageState extends State<Day12Page> {
  final _controller = TextEditingController();
  final String password = '1234';
  String resultText = '';
  int incorrectNumber = 0;
  bool enabled = true;
  int remainingSeconds = 30;

  void submit() {
    final submitPwd = _controller.text.trim();

    setState(() {
      if (submitPwd == password) {
        resultText = "로그인 성공";
      } else {
        resultText = "비밀번호가 틀렸습니다";
        incorrectNumber += 1;

        if (incorrectNumber >= 3) {
          enabled = false;
          resultText = "로그인 잠금: $remainingSeconds초 후 다시 시도하세요.";

          Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {
              remainingSeconds -= 1;
              resultText = "로그인 잠금: $remainingSeconds초 후 다시 시도하세요.";

              if (remainingSeconds <= 0) {
                timer.cancel();
                enabled = true;
                resultText = "이제 다시 시도할 수 있어요.";
                incorrectNumber = 0;
                remainingSeconds = 30;
              }
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 맞추기")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            enabled: enabled,
            decoration: InputDecoration(hintText: "비밀번호를 입력하세요."),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: enabled ? submit : null,
            child: const Text("비밀번호 제출"),
          ),
          const SizedBox(height: 12),
          if (resultText.isNotEmpty) Text(resultText),
        ],
      ),
    );
  }
}
