import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/provider/todo_provider.dart';

Future<void> showTodoDialog(BuildContext context, {Todo? todo}) async {
    final TextEditingController _controller =
        TextEditingController(text: todo?.title ?? '');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(todo == null ? 'Input To Do' : 'Edit To Do'),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Input New Todo'),
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(todo == null ? 'Simpan' : 'Update'),
              onPressed: () async {
                final String title = _controller.text;
                if (title.isNotEmpty) {
                  final todoProvider =
                      Provider.of<TodoProvider>(context, listen: false);
                  if (todo == null) {
                    final newTodo = Todo(
                      title: title,
                      isDone: false,
                    );
                    await todoProvider.addTodo(newTodo);
                  } else {
                    todo.title = title;
                    await todoProvider.updateTodo(todo);
                  }
                  Navigator.of(context).pop();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }