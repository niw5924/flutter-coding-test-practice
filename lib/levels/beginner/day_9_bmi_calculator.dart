import 'package:flutter/material.dart';

class Day9Page extends StatefulWidget {
  const Day9Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day9PageState();
}

class _Day9PageState extends State<Day9Page> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? bmi;
  String? bmiStatus;

  void calBMI() {
    final heightCM = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());

    if (heightCM != null && weight != null) {
      final heightM = heightCM / 100;

      setState(() {
        bmi = weight / (heightM * heightM);
        if (bmi! < 18.5) {
          bmiStatus = "저체중";
        } else if (bmi! < 23) {
          bmiStatus = "정상";
        } else if (bmi! < 25) {
          bmiStatus = "과체중";
        } else {
          bmiStatus = "비만";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI 계산")),
      body: Column(
        children: [
          TextField(
            controller: _heightController,
            decoration: InputDecoration(hintText: "키 입력 (cm)"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(hintText: "몸무게 입력 (kg)"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: calBMI,
            child: Text("BMI 계산하기"),
          ),
          const SizedBox(height: 24),
          if (bmi != null) Text('BMI: ${bmi!.toStringAsFixed(1)}'),
          const SizedBox(height: 12),
          if (bmiStatus != null) Text("상태: $bmiStatus"),
        ],
      ),
    );
  }
}
