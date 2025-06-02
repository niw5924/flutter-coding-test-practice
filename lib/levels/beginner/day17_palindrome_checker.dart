import 'package:flutter/material.dart';

class Day17Page extends StatefulWidget {
  const Day17Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day17PageState();
}

class _Day17PageState extends State<Day17Page> {
  final _controller = TextEditingController();
  List palindrome = [];
  List palindromeList = [];

  void check() {
    final text = _controller.text.trim();

    for (int i = text.length - 1; i >= 0; i--) {
      palindrome.add(text[i]);
    }
    final reversed = palindrome.join();
    setState(() {
      if (text == reversed) {
        palindromeList.add(PalindromeItem(sentence: reversed, isTrue: true));
      } else {
        palindromeList.add(PalindromeItem(sentence: reversed, isTrue: false));
      }
    });

    _controller.clear();
    palindrome.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회문검사기")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "문장을 입력하세요."),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: check,
              child: Text("검사하기"),
            ),
            const SizedBox(height: 12),
            if (palindromeList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: palindromeList.length,
                  itemBuilder: (context, index) {
                    return palindromeList[index];
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PalindromeItem extends StatelessWidget {
  final String sentence;
  final bool isTrue;

  const PalindromeItem({
    super.key,
    required this.sentence,
    required this.isTrue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(sentence)),
        Text(
          isTrue ? "회문입니다." : "회문이 아닙니다.",
          style: TextStyle(
            color: isTrue ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
