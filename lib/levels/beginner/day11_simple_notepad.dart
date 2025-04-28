import 'package:flutter/material.dart';

class Day11Page extends StatefulWidget {
  const Day11Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day11PageState();
}

class _Day11PageState extends State<Day11Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메모장")),
      body: Column(),
    );
  }
}