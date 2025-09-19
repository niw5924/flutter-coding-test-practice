import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Day27Page extends StatefulWidget {
  const Day27Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day27PageState();
}

class _Day27PageState extends State<Day27Page> {
  List<dynamic> quizList = [];

  Future<void> loadQuiz() async {
    final jsonString = await rootBundle.loadString('assets/day27_quiz.json');

    final quiz = jsonDecode(jsonString);
    print(quiz.runtimeType);
    setState(() {
      quizList = quiz.map((e) => QuizItem.fromJson(e)).toList()..shuffle();
    });
    print(quizList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('단어 퀴즈')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loadQuiz,
              child: const Text('시작'),
            ),
            ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: quizList.length,
              itemBuilder: (context, index) {
                final quizItem = quizList[index];
                final options = quizItem.options;

                return Column(
                  children: [
                    Text(quizItem.question),
                    ListView.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey,
                          padding: const EdgeInsets.all(8),
                          child: Text(options[index]),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuizItem {
  final String question;
  final List<dynamic> options;
  final String answer;

  const QuizItem({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      question: json['question'],
      options: json['options'],
      answer: json['answer'],
    );
  }
}
