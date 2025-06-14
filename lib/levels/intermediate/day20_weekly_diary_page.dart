import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day20Page extends StatefulWidget {
  const Day20Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day20PageState();
}

class _Day20PageState extends State<Day20Page> with TickerProviderStateMixin {
  late final TabController _tabController;
  final _controller = TextEditingController();
  final List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];
  int currentTabIndex = 0;
  String currentWeekDay = "월";
  final Map<String, String> diaryTexts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(_handleTabChange);
    loadDiary();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadDiary() async {
    final prefs = await SharedPreferences.getInstance();

    for (String day in weekDays) {
      final saved = prefs.getString('diary_$day');
      if (saved != null) {
        diaryTexts[day] = saved;
      }
    }
    _controller.text = diaryTexts[currentWeekDay] ?? '';
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    currentTabIndex = _tabController.index;
    print(currentTabIndex);
    currentWeekDay = weekDays[currentTabIndex];
    print(currentWeekDay);
    _controller.text = diaryTexts[currentWeekDay] ?? '';
  }

  Future<void> save() async {
    diaryTexts[currentWeekDay] = _controller.text.trim();
    final prefs = await SharedPreferences.getInstance();

    if (diaryTexts[currentWeekDay] != null) {
      prefs.setString('diary_$currentWeekDay', diaryTexts[currentWeekDay]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("주간 일기장"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            for (int i = 0; i < weekDays.length; i++) Tab(text: weekDays[i])
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(7, (index) {
          return Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: "일기를 작성하세요."),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: save,
                child: Text("저장"),
              )
            ],
          );
        }),
      ),
    );
  }
}
