import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/provider/todo_provider.dart';
import 'package:todolist_app/widgets/dialog_add_todo.dart';

Widget itemList(Todo todo, BuildContext context) {
  final todoProvider = Provider.of<TodoProvider>(context);

  return Opacity(
    opacity: todo.isDone ? 0.3 : 1.0,
    child: ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
            decoration:
                todo.isDone ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      subtitle: todo.date != null ? Text(todo.date!) : null,
      leading: IconButton(
        onPressed: () async {
          todoProvider.toggleStatus(todo);
        },
        icon: todo.isDone
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
      ),
      trailing: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
            onPressed: () async {
              await todoProvider.deleteTodo(todo.id!);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 20,
            )),
      ),
      onTap: () {
        showTodoDialog(context,
            todo: todo); // Menampilkan dialog untuk edit todo
      },
    ),
  );
}
