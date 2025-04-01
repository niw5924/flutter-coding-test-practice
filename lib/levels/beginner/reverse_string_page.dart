import 'package:flutter/material.dart';

class ReverseStringPage extends StatefulWidget {
  const ReverseStringPage({super.key});

  @override
  State<ReverseStringPage> createState() => _ReverseStringPageState();
}

class _ReverseStringPageState extends State<ReverseStringPage> {
  final TextEditingController _controller = TextEditingController();
  String string = "";

  flipString() {
    final string2 = _controller.text.trim();

    setState(() {
      string = string2.split('').reversed.join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("문자열 거꾸로 출력")),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "문자열을 입력"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: flipString, child: const Text("뒤집기")),
          const SizedBox(height: 12),
          Text(string),
        ],
      ),
    );
  }
}
