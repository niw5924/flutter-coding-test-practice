import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Day13Page extends StatefulWidget {
  const Day13Page({super.key});

  @override
  State<StatefulWidget> createState() => _Day13PageState();
}

class _Day13PageState extends State<Day13Page> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String selectedCategory = "식비";
  List<ItemModel> itemModelList = [];

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  void loadItem() async {
    final prefs = await SharedPreferences.getInstance();
  }

  void addItem() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text.trim();
    final price = int.parse(_priceController.text.trim());

    setState(() {
      itemModelList
          .add(ItemModel(name: name, price: price, category: selectedCategory));

      final itemList = itemModelList.map((e) => jsonEncode(e.toMap())).toList();
      print(itemList);
      prefs.setStringList('itemList', itemList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("하루 소비 기록 앱")),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "항목명"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(hintText: "금액"),
          ),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            initialSelection: '식비',
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
            onPressed: addItem,
            child: const Text("추가하기"),
          ),
          const SizedBox(height: 12),
          itemModelList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: itemModelList.length,
                      itemBuilder: (context, index) {
                        final itemModel = itemModelList[index];
                        return Card(
                          child: ListTile(
                            leading: Text(itemModel.category),
                            title: Text(itemModel.name),
                            subtitle: Text("${itemModel.price}"),
                          ),
                        );
                      }),
                )
              : Center(child: const Text("리스트가 비어있습니다.")),
          const SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text("식비: $foodTotal원"),
          //     const SizedBox(width: 12),
          //     Text("교통: $trafficTotal원"),
          //     const SizedBox(width: 12),
          //     Text("카페: $cafeTotal원"),
          //     const SizedBox(width: 12),
          //     Text("기타 등: $othersTotal원"),
          //   ],
          // ),
        ],
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
}
