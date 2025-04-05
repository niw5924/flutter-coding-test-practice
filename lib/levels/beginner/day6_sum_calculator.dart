import 'package:flutter/material.dart';

class Day6Page extends StatefulWidget {
  const Day6Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day6PageState();
}

class _Day6PageState extends State<Day6Page> {
  final _controller = TextEditingController();
  int? sum;

  void sumNumber(String value) {
    final input = _controller.text.trim();
    int? inputNumber = int.tryParse(input);

    /// 내가 한 방식(공식 이용)
    // if (inputNumber != null && inputNumber > 0) {
    //   setState(() {
    //     sum = inputNumber * (inputNumber + 1) ~/ 2;
    //   });
    // } else {
    //   setState(() {
    //     sum = null;
    //   });
    // }

    /// reduce 함수 활용(리스트의 전체 합 구할때 유용
    if (inputNumber != null && inputNumber > 0) {
      List numberList = List.generate(inputNumber, (i) => i + 1);
      int total = numberList.reduce((a, b) => a + b);

      setState(() {
        sum = total;
      });
    } else {
      setState(() {
        sum = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("숫자합계 계산")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: (value) => sumNumber(value),
          ),
          const SizedBox(height: 12),
          if (sum != null) Text("$sum"),
        ],
      ),
    );
  }
}
