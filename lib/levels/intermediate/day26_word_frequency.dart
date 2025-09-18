import 'package:flutter/material.dart';

class Day26Page extends StatefulWidget {
  const Day26Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day26PageState();
}

class _Day26PageState extends State<Day26Page> {
  final _controller = TextEditingController();
  Map<String, int> word = {};

  void _submit() {
    final t = _controller.text.trim();
    final st = t.split(' ');

    setState(() {
      word = {};
    });

    for (final (index, value) in st.indexed) {
      final cleanValue = value
          .replaceAll('.', '')
          .replaceAll(',', '')
          .replaceAll('!', '')
          .replaceAll('?', '')
          .toLowerCase();
      print(cleanValue);

      /// 공백 제거
      if (cleanValue.isEmpty) continue;

      setState(() {
        if (word[cleanValue] == null) {
          word[cleanValue] = 1;
        } else {
          word[cleanValue] = word[cleanValue]! + 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = word.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text('단어 빈도수 계산')),
      body: Column(
        children: [
          const Text('문장을 입력해주세요.'),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '문장',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('검사하기'),
          ),
          const SizedBox(height: 12),
          if (word.isNotEmpty)
            Column(
              children: [
                for (final e in sorted) Text('${e.key}: ${e.value}'),
              ],
            ),
        ],
      ),
    );
  }
}
