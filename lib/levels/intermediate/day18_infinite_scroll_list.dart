import 'package:flutter/material.dart';

class Day18Page extends StatefulWidget {
  const Day18Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day18PageState();
}

class _Day18PageState extends State<Day18Page> {
  List<String> list = List.generate(20, (index) => "항목${index + 1}");
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        loadMoreItem();
      }
    });
  }

  Future<void> loadMoreItem() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final startIndex = list.length;
    final newList = List.generate(20, (index) => "항목${startIndex + index + 1}");

    setState(() {
      list.addAll(newList);
      isLoading = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("무한스크롤")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: list.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < list.length) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(list[index]),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
