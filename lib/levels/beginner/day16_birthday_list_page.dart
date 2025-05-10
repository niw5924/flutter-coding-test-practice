import 'package:flutter/material.dart';

class Day16Page extends StatefulWidget {
  const Day16Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day16PageState();
}

class _Day16PageState extends State<Day16Page> {
  final nameController = TextEditingController();
  DateTime? selectedDate;
  List list = [];

  void add() {
    final name = nameController.text.trim();
    if (name.isEmpty || selectedDate == null) return;

    setState(() {
      list.add({
        'name': name,
        'birthday': selectedDate,
      });
    });
  }

  String getDay(DateTime birthday) {
    final DateTime now = DateTime.now();
    final thisYearBirthday = DateTime(now.year, birthday.month, birthday.day);
    final nextYearBirthday =
        DateTime(now.year + 1, birthday.month, birthday.day);

    DateTime closeBirthday =
        thisYearBirthday.isBefore(now) ? nextYearBirthday : thisYearBirthday;

    final diff = closeBirthday.difference(now).inDays;

    if (diff == 0) {
      return "🎉 D-Day";
    } else {
      return "D-$diff";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("생일리스트")),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "이름을 입력하세요"),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(DateTime.now().year + 1),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(selectedDate != null
                    ? "${selectedDate!.year} - ${selectedDate!.month.toString().padLeft(2, '0')} - ${selectedDate!.day.toString().padLeft(2, '0')}"
                    : "생일을 선택하세요"),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: add,
            child: Text("추가하기"),
          ),
          const SizedBox(height: 12),
          if (list.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final birthdayList = list[index];
                  final listName = birthdayList['name'];
                  final listBirthday = birthdayList['birthday'];

                  return Text("$listName - "
                      "${listBirthday.year} - "
                      "${listBirthday.month.toString().padLeft(2, '0')} - "
                      "${listBirthday.day.toString().padLeft(2, '0')} "
                      "(${getDay(listBirthday)})");
                },
              ),
            ),
        ],
      ),
    );
  }
}
