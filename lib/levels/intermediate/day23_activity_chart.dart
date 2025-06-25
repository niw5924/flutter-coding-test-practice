import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day23Page extends StatefulWidget {
  const Day23Page({super.key});

  @override
  State<Day23Page> createState() => _Day23PageState();
}

class _Day23PageState extends State<Day23Page> {
  int healthRecord = 0;
  int studyRecord = 0;
  int meditationRecord = 0;

  bool? isCheckedHealth = false;
  bool? isCheckedStudy = false;
  bool? isCheckedMeditation = false;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    initRecord();
  }

  String formatted(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> initRecord() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      healthRecord = pref.getInt('${formatted(now)}_health') ?? 0;
      studyRecord = pref.getInt('${formatted(now)}_study') ?? 0;
      meditationRecord = pref.getInt('${formatted(now)}_meditation') ?? 0;
    });
  }

  Future<void> addRecord() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      if (isCheckedHealth!) {
        healthRecord += 1;
        pref.setInt('${formatted(now)}_health', healthRecord);
      }
      if (isCheckedStudy!) {
        studyRecord += 1;
        pref.setInt('${formatted(now)}_study', studyRecord);
      }
      if (isCheckedMeditation!) {
        meditationRecord += 1;
        pref.setInt('${formatted(now)}_meditation', meditationRecord);
      }
    });
  }

  List<String> getLast7Dates() {
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return formatted(date);
    });
  }

  Future<List<Map<String, int>>> getLast7DaysData() async {
    final pref = await SharedPreferences.getInstance();
    final dates = getLast7Dates();

    return dates.map((date) {
      return {
        '운동': pref.getInt('${date}_health') ?? 0,
        '공부': pref.getInt('${date}_study') ?? 0,
        '명상': pref.getInt('${date}_meditation') ?? 0,
      };
    }).toList();
  }

  Future<List<BarChartGroupData>> getGroupedBarGroups() async {
    final data = await getLast7DaysData();

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final record = entry.value;

      return BarChartGroupData(
        x: index,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: record['운동']!.toDouble(), width: 8, color: Colors.green),
          BarChartRodData(
              toY: record['공부']!.toDouble(), width: 8, color: Colors.blue),
          BarChartRodData(
              toY: record['명상']!.toDouble(), width: 8, color: Colors.purple),
        ],
      );
    }).toList();
  }

  Widget getGroupedChart() {
    return Expanded(
      child: FutureBuilder<List<BarChartGroupData>>(
        future: getGroupedBarGroups(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return BarChart(
            BarChartData(
              barGroups: snapshot.data!,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dates = getLast7Dates();
                      final dateStr = dates[value.toInt()];
                      final weekday =
                          DateFormat('E').format(DateTime.parse(dateStr));
                      return Text(weekday);
                    },
                  ),
                ),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("날짜별 활동 그래프")),
      body: Column(
        children: [
          Text('오늘 날짜: ${formatted(now)}'),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isCheckedHealth,
                onChanged: (value) {
                  setState(() => isCheckedHealth = value);
                },
              ),
              const Text("운동"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isCheckedStudy,
                onChanged: (value) {
                  setState(() => isCheckedStudy = value);
                },
              ),
              const Text("공부"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isCheckedMeditation,
                onChanged: (value) {
                  setState(() => isCheckedMeditation = value);
                },
              ),
              const Text("명상"),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: addRecord,
            child: const Text("기록 추가"),
          ),
          const SizedBox(height: 24),
          const Text("최근 7일 활동 기록",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          getGroupedChart(),
          const SizedBox(height: 12),
          const Text("운동: 초록 / 공부: 파랑 / 명상: 보라"),
        ],
      ),
    );
  }
}
