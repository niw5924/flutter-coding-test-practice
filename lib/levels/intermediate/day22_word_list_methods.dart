import 'package:flutter/material.dart';

class Day22Page extends StatefulWidget {
  const Day22Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day22PageState();
}

class _Day22PageState extends State<Day22Page> {
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  List<String> wordList = [];
  String searchQuery = '';

  void addWord() {
    final word = _controller.text.trim();

    setState(() {
      if (word.isNotEmpty && !wordList.contains(word)) {
        wordList.add(word);
      }
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWordList =
        wordList.where((word) => word.contains(searchQuery)).toList();
    print(filteredWordList);

    return Scaffold(
      appBar: AppBar(
        title: const Text("단어 리스트"),
        actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    wordList.sort((a, b) => a.compareTo(b));
                  });
                },
                child: Text("A-Z 순 정렬"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    wordList = wordList.reversed.toList();
                  });
                },
                child: Text("최신순 정렬"),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "단어를 추가하세요."),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: addWord,
                  child: Text("추가"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller2,
                  decoration: InputDecoration(
                    hintText: "단어를 검색하세요",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text("현재 단어 개수: ${wordList.length}"),
                const SizedBox(height: 12),
                wordList.isEmpty
                    ? Text("단어를 추가해주세요.")
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredWordList.length,
                        itemBuilder: (context, index) {
                          final word = filteredWordList[index];

                          return Card(
                            child: ListTile(
                              title: Text(word),
                              trailing: GestureDetector(
                                onTap: () async {
                                  final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("단어 삭제"),
                                                const SizedBox(height: 8),
                                                Text("단어를 삭제하시겠습니까?"),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: Text("취소"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child: Text("확인"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                  if (confirmed == true) {
                                    setState(() {
                                      wordList.removeAt(
                                          filteredWordList.indexOf(word));
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("단어를 삭제했습니다.")));
                                  }
                                },
                                child: Icon(Icons.delete_forever),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
