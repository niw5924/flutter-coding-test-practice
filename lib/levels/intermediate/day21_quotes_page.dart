import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day21Page extends StatefulWidget {
  const Day21Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day21PageState();
}

class _Day21PageState extends State<Day21Page> {
  List quotes = [];
  List<bool> fav = [];
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    loadQuotesAndPrefs();
  }

  Future<void> loadQuotesAndPrefs() async {
    final jsonString = await rootBundle.loadString('assets/day21_quotes.json');
    quotes = jsonDecode(jsonString);
    print(quotes);

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < quotes.length; i++) {
      final isFavorite = prefs.getBool('quote$i') ?? false;
      fav.add(isFavorite);
      print(fav);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayList = [];
    List<int> originalIndices = [];

    for (int i = 0; i < quotes.length; i++) {
      if (!isChecked || fav[i]) {
        displayList.add(quotes[i]);
        print(displayList);
        originalIndices.add(i);
        print(originalIndices);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("명언 즐겨찾기"),
        actions: [
          Switch(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value;
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final quote = displayList[index];
          final originalIndex = originalIndices[index];

          return Card(
            child: ListTile(
              title: Text(quote['quote']),
              subtitle: Text(quote['author']),
              trailing: GestureDetector(
                onTap: () async {
                  setState(() {
                    fav[originalIndex] = !fav[originalIndex];
                  });

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool(
                      'quote$originalIndex', fav[originalIndex]);
                },
                child: Icon(
                  fav[originalIndex] ? Icons.star : Icons.star_border,
                  color: fav[originalIndex] ? Colors.amber : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
