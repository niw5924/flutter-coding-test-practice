import 'package:flutter/material.dart';

class Day14Page extends StatefulWidget {
  const Day14Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day14PageState();
}

class _Day14PageState extends State<Day14Page> {
  final textController = TextEditingController(text: '0');
  List inputText = ['0'];
  int result = 0;

  void input(String data) {
    setState(() {
      if (inputText.length == 1 &&
          inputText.first == '0' &&
          '0123456789'.contains(data)) {
        inputText = [data];
      } else {
        inputText.add(data);
      }
      textController.text = inputText.join();
    });
  }

  void calculate() {
    try {
      final expression = inputText.join();

      // 1. 문자열 수식을 숫자와 연산자로 나누기 (토큰화)
      final List<String> tokens = [];
      String current = '';
      for (int i = 0; i < expression.length; i++) {
        final char = expression[i];
        if ('0123456789.'.contains(char)) {
          current += char; // 숫자 또는 소수점이면 이어붙이기
        } else if ('+-*/'.contains(char)) {
          if (current.isNotEmpty) {
            tokens.add(current); // 이전 숫자 토큰 추가
            current = '';
          }
          tokens.add(char); // 연산자 토큰 추가
        }
      }
      if (current.isNotEmpty) tokens.add(current); // 마지막 숫자 처리

      // 2. 후위 표기식으로 변환 (Shunting Yard 알고리즘)
      final List<String> output = [];
      final List<String> stack = [];

      int precedence(String op) => (op == '+' || op == '-') ? 1 : 2;

      for (final token in tokens) {
        if ('+-*/'.contains(token)) {
          // 연산자일 경우, 우선순위 비교해서 스택에서 꺼내기
          while (
              stack.isNotEmpty && precedence(stack.last) >= precedence(token)) {
            output.add(stack.removeLast());
          }
          stack.add(token); // 현재 연산자 push
        } else {
          output.add(token); // 숫자는 그대로 출력
        }
      }

      while (stack.isNotEmpty) {
        output.add(stack.removeLast()); // 남은 연산자 출력
      }

      // 3. 후위 표기식 계산 (스택 사용)
      final List<double> resultStack = [];

      for (final token in output) {
        if ('+-*/'.contains(token)) {
          // 연산자일 경우, 두 개의 숫자 pop
          final b = resultStack.removeLast();
          final a = resultStack.removeLast();

          double r;
          switch (token) {
            case '+':
              r = a + b;
              break;
            case '-':
              r = a - b;
              break;
            case '*':
              r = a * b;
              break;
            case '/':
              r = a / b;
              break;
            default:
              throw Exception("Unknown operator");
          }

          resultStack.add(r); // 결과 다시 push
        } else {
          resultStack.add(double.parse(token)); // 숫자일 경우 push
        }
      }

      final result = resultStack.last.toInt(); // 결과값

      setState(() {
        textController.text = result.toString();
        inputText = [result.toString()];
      });
    } catch (e) {
      setState(() {
        textController.text = '오류';
        inputText = ['0'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("계산기")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(controller: textController),
            const SizedBox(height: 12),
            ...[
              ['1', '2', '3', '+'],
              ['4', '5', '6', '-'],
              ['7', '8', '9', '*'],
              ['.', '0', '=', '/']
            ].map(
              (row) => Row(
                children: row.map((value) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (value == '=') {
                          calculate();
                        } else {
                          input(value);
                        }
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(value, textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
