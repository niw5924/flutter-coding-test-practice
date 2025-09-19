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
  QuizItem? currentQuiz;
  String? selectedAnswer;
  int score = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await loadQuiz();
    startQuiz();
  }

  Future<void> loadQuiz() async {
    final jsonString = await rootBundle.loadString('assets/day27_quiz.json');

    final quiz = jsonDecode(jsonString);
    print(quiz.runtimeType);

    setState(() {
      quizList = quiz.map((e) => QuizItem.fromJson(e)).toList()..shuffle();
    });
  }

  void startQuiz() async {
    if (quizList.isEmpty) {
      currentQuiz = null;
      return;
    }

    setState(() {
      currentQuiz = quizList.removeAt(0);
      print(quizList);
      print(currentQuiz);
    });
  }

  void submit() async {
    if (currentQuiz!.answer == selectedAnswer) {
      print('정답입니다.');
      setState(() {
        score += 1;
      });
    } else {
      print('오답입니다.');
    }

    setState(() {
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('단어 퀴즈')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (currentQuiz != null) ...[
              Text(currentQuiz!.question),
              const SizedBox(height: 12),
              ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: currentQuiz!.options.length,
                itemBuilder: (context, index) {
                  final options = currentQuiz!.options[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = options;
                      });
                      print(selectedAnswer);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          color: selectedAnswer == options
                              ? Colors.blue
                              : Colors.transparent,
                          width: 3.0,
                        ),
                      ),
                      child: Text(options),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (selectedAnswer != null)
                ElevatedButton(
                  onPressed: () {
                    submit();
                    startQuiz();
                  },
                  child: const Text('제출'),
                ),
            ],
            Text('$score / 5'),
            // ListView.separated(
            //   separatorBuilder: (_, __) => const Divider(),
            //   physics: NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: quizList.length,
            //   itemBuilder: (context, index) {
            //     final quizItem = quizList[index];
            //     final options = quizItem.options;
            //
            //     return Column(
            //       children: [
            //         Text(quizItem.question),
            //         ListView.separated(
            //           separatorBuilder: (_, __) => const SizedBox(height: 6),
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           itemCount: options.length,
            //           itemBuilder: (context, index) {
            //             return Container(
            //               color: Colors.grey,
            //               padding: const EdgeInsets.all(8),
            //               child: Text(options[index]),
            //             );
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // ),
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
