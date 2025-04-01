import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _items = [];

  @override
  Widget build(BuildContext context) {
    addTodo() {
      final todo = _controller.text.trim();
      setState(() {
        _items.add(TodoItem(text: todo));
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('할 일 목록')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "할 일을 입력하세요"),
                ),
              ),
              const SizedBox(width: 50),
              ElevatedButton(
                onPressed: addTodo,
                child: const Text("추가하기"),
              ),
            ],
          ),
          if (_items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    return CheckboxListTile(
                      title: Text(
                        item.text,
                        style: TextStyle(
                          decoration:
                              item.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      value: item.isDone,
                      onChanged: (value) {
                        setState(() {
                          item.isDone = value!;
                        });
                      },
                    );
                  }),
            ),
        ],
      ),
    );
  }
}

class TodoItem {
  final String text;
  bool isDone;

  TodoItem({
    required this.text,
    this.isDone = false,
  });
}
