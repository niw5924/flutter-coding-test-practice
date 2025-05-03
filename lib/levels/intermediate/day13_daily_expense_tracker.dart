import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day13Page extends StatefulWidget {
  const Day13Page({super.key});

  @override
  State<Day13Page> createState() => _Day13PageState();
}

class _Day13PageState extends State<Day13Page> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String selectedCategory = "식비";
  List<ItemModel> itemModelList = [];

  String get todayKey {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String selectedDateKey = "";
  List<String> allDateKeys = [];

  @override
  void initState() {
    super.initState();
    selectedDateKey = todayKey;
    loadDateKeysAndItems();
  }

  Future<void> loadDateKeysAndItems() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().toList()..sort();
    if (!keys.contains(todayKey)) {
      keys.add(todayKey);
    }
    setState(() {
      allDateKeys = keys;
    });
    await loadItem(selectedDateKey);
  }

  Future<void> loadItem(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(dateKey);
    setState(() {
      selectedDateKey = dateKey;
      itemModelList = data != null
          ? data.map((e) => ItemModel.fromMap(jsonDecode(e))).toList()
          : [];
    });
  }

  Future<void> addItem() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (name.isEmpty || price <= 0) return;

    setState(() {
      itemModelList.add(ItemModel(
        name: name,
        price: price,
        category: selectedCategory,
      ));
    });

    final encodedList =
        itemModelList.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(todayKey, encodedList);

    _nameController.clear();
    _priceController.clear();
  }

  int getTotalByCategory(String category) {
    return itemModelList
        .where((item) => item.category == category)
        .fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("하루 소비 기록 앱")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            allDateKeys.isEmpty
                ? const CircularProgressIndicator()
                : DropdownMenu<String>(
                    initialSelection: selectedDateKey,
                    onSelected: (value) {
                      if (value != null) loadItem(value);
                    },
                    dropdownMenuEntries: allDateKeys
                        .map((key) => DropdownMenuEntry(value: key, label: key))
                        .toList(),
                  ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "항목명"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(hintText: "금액"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownMenu<String>(
              initialSelection: selectedCategory,
              onSelected: (value) => setState(() {
                selectedCategory = value!;
              }),
              dropdownMenuEntries: [
                DropdownMenuEntry(value: '식비', label: '식비'),
                DropdownMenuEntry(value: '교통', label: '교통'),
                DropdownMenuEntry(value: '카페', label: '카페'),
                DropdownMenuEntry(value: '기타 등', label: '기타 등'),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: selectedDateKey == todayKey ? addItem : null,
              child: const Text("추가하기"),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: itemModelList.isNotEmpty
                  ? ListView.builder(
                      itemCount: itemModelList.length,
                      itemBuilder: (context, index) {
                        final item = itemModelList[index];
                        return Card(
                          child: ListTile(
                            leading: Text(item.category),
                            title: Text(item.name),
                            subtitle: Text("${item.price}원"),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("리스트가 비어있습니다.")),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("식비: ${getTotalByCategory("식비")}원"),
                const SizedBox(width: 8),
                Text("교통: ${getTotalByCategory("교통")}원"),
                const SizedBox(width: 8),
                Text("카페: ${getTotalByCategory("카페")}원"),
                const SizedBox(width: 8),
                Text("기타 등: ${getTotalByCategory("기타 등")}원"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final int price;
  final String category;

  const ItemModel({
    required this.name,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'category': category,
      };

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'],
      price: map['price'],
      category: map['category'],
    );
  }
}
