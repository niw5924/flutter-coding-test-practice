import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Day5Page extends StatefulWidget {
  const Day5Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day5PageState();
}

class _Day5PageState extends State<Day5Page> {
  List<Map<String, dynamic>> newsList = [];

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    final String jsonString =
        await rootBundle.loadString('assets/day5_news_data.json');

    setState(() {
      newsList = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("뉴스")),
      body: newsList.isEmpty
          ? Center(child: const CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];

                return Card(
                  child: ListTile(
                    title: Text(news['title']),
                    subtitle: Text(news['summary']),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NewsDetailPage(news: news))),
                  ),
                );
              },
            ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news['title'])),
      body: Column(
        children: [
          Text(news['author']),
          const SizedBox(height: 12),
          Text(news['content']),
        ],
      ),
    );
  }
}
