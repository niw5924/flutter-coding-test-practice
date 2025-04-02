import 'package:flutter/material.dart';

class SquareCalculatorPage extends StatefulWidget {
  const SquareCalculatorPage({super.key});

  @override
  State<StatefulWidget> createState() => _SquareCalculatorPageState();
}

class _SquareCalculatorPageState extends State<SquareCalculatorPage> {
  final TextEditingController _controller = TextEditingController();
  int? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("숫자 제곱근")),
      body: Column(
        children: [
          Text("숫자를 입력하세요:"),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            onChanged: (value) {
              final parsed = int.tryParse(value);

              if (parsed != null) {
                setState(() {
                  result = parsed * parsed;
                });
              } else {
                setState(() {
                  result = null;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          if (result != null) Text("제곱 결과: $result"),
        ],
      ),
    );
  }
}
