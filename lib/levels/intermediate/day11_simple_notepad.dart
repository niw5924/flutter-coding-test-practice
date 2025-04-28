import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day11Page extends StatefulWidget {
  const Day11Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day11PageState();
}

class _Day11PageState extends State<Day11Page> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<Memo> memo = [];

  @override
  void initState() {
    super.initState();
    loadMemo();
  }

  void loadMemo() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? memoList = prefs.getStringList('memoList');

    if (memoList != null) {
      setState(() {
        memo = memoList.map((e) => Memo.fromJson(e)).toList();
      });
    }
  }

  void saveMemo() async {
    final prefs = await SharedPreferences.getInstance();
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    final newMemo = Memo(title: title, content: content);

    setState(() {
      memo.add(newMemo);
    });

    final memoList = memo.map((e) => e.toJson()).toList();
    await prefs.setStringList('memoList', memoList);

    _titleController.clear();
    _contentController.clear();
  }

  void deleteMemo(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      memo.removeAt(index);
    });

    final memoList = memo.map((e) => e.toJson()).toList();
    await prefs.setStringList('memoList', memoList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메모장")),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: "제목"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(hintText: "내용"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: saveMemo,
            child: Text("저장"),
          ),
          const SizedBox(height: 12),
          memo.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: memo.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MemoDetailPage(
                                title: memo[index].title,
                                content: memo[index].content,
                              ),
                            ),
                          ),
                          onLongPress: () => deleteMemo(index),
                          tileColor: Colors.grey[200],
                          title: Text(memo[index].title),
                        ),
                      );
                    },
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Text("메모가 없습니다."),
                  ),
                )
        ],
      ),
    );
  }
}

class Memo {
  final String title;
  final String content;

  Memo({
    required this.title,
    required this.content,
  });

  String toJson() => '$title|$content';

  factory Memo.fromJson(String json) {
    final parts = json.split('|');
    return Memo(title: parts[0], content: parts[1]);
  }
}

class MemoDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const MemoDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Text(content),
    );
  }
}
