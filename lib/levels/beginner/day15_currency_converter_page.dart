import 'package:flutter/material.dart';

class Day15Page extends StatefulWidget {
  const Day15Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day15PageState();
}

class _Day15PageState extends State<Day15Page> {
  final exchangeRates = [
    {'country': '🇺🇸 미국', 'unit': 'USD', 'rate': 1375.5},
    {'country': '🇯🇵 일본', 'unit': 'JPY', 'rate': 8.8},
    {'country': '🇪🇺 유럽', 'unit': 'EUR', 'rate': 1512.3},
  ];
  final _controller = TextEditingController();
  int? inputValue;

  void calculate() {
    final input = _controller.text.trim();
    final value = int.tryParse(input);

    if (value != null) {
      setState(() {
        inputValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("환율 계산기")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "금액을 입력하세요."),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: calculate,
            child: Text("계산하기"),
          ),
          const SizedBox(height: 12),
          ...exchangeRates.map((item) {
            final rate = item['rate'] as num;
            final result = inputValue != null
                ? (inputValue! / rate).toStringAsFixed(2)
                : "0";

            return Text(
              "${item['country']} $result ${item['unit']}",
            );
          }),
        ],
      ),
    );
  }
}
