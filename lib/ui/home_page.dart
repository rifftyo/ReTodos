import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/provider/theme_provider.dart';
import 'package:todolist_app/provider/todo_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _showTodoDialog(BuildContext context, {Todo? todo}) async {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);

    if (todoProvider.todoList.isEmpty) {
      todoProvider.fetchTodos();
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.all(10),
          child: const Text(
            'Todo List',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: themeProvider.isDark
                ? const Icon(
                    Icons.light_mode,
                    size: 35,
                  )
                : const Icon(
                    Icons.dark_mode,
                    size: 35,
                  ),
          ),
        ],
      ),
      body: todoProvider.todoList.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 120),
                    child: Image.asset('images/note_icon.png',
                        width: 100, height: 100),
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: todoProvider.todoList.length,
              itemBuilder: (context, index) {
                Todo todo = todoProvider.todoList[index];
                return itemList(todo, context);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTodoDialog(context); // Menampilkan dialog untuk input todo baru
        },
        shape: const StadiumBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  Widget itemList(Todo todo, BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
            decoration:
                todo.isDone ? TextDecoration.lineThrough : TextDecoration.none),
      ),
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
        _showTodoDialog(context,
            todo: todo); // Menampilkan dialog untuk edit todo
      },
    );
  }
}
