import 'package:flutter/material.dart';

class Day4Page extends StatefulWidget {
  const Day4Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day4PageState();
}

class _Day4PageState extends State<Day4Page> {
  final TextEditingController _controller = TextEditingController();
  String? result;
  int? age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("성인 판별 앱")),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              result = _controller.text.trim();
              age = int.tryParse(result!);

              if (age != null) {
                if (age! > 19) {
                  setState(() {
                    result = "성인입니다.";
                  });
                } else if (age! <= 19 && age! > 0) {
                  setState(() {
                    result = "미성년자입니다.";
                  });
                } else {
                  setState(() {
                    result = "양수를 입력해주세요.";
                  });
                }
              } else {
                setState(() {
                  result = "유효한 값이 아닙니다.";
                });
              }
            },
            child: const Text("성인 판별"),
          ),
          if (result != null) Text(result!),
        ],
      ),
    );
  }
}
