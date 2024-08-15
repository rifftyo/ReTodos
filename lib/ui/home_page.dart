import 'package:flutter/material.dart';
import 'package:todolist_app/helpers/database_helper.dart';
import 'package:todolist_app/models/todo.dart';

class HomePage extends StatefulWidget {
  final Function changeTheme;
  final bool isDark;

  const HomePage({super.key, required this.changeTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Todo>> _todoList;

  @override
  void initState() {
    super.initState();
    _refreshTodoList();
  }

  void _refreshTodoList() {
    setState(() {
      _todoList = DatabaseHelper.instance.fetchTodos();
    });
  }

  void _changeStatus(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  Future<void> _showTodoDialog({Todo? todo}) async {
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
                  if (todo == null) {
                    final newTodo = Todo(
                      title: title,
                      isDone: false,
                    );
                    await DatabaseHelper.instance.insertTodo(newTodo);
                  } else {
                    todo.title = title;
                    await DatabaseHelper.instance.updateTodo(todo);
                  }
                  Navigator.of(context).pop();
                  _refreshTodoList();
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
              widget.changeTheme();
            },
            icon: widget.isDark
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
      body: FutureBuilder<List<Todo>>(
        future: _todoList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/icon_blank_notes.png'),
                      const SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text(
                          'No Todo',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Todo todo = snapshot.data![index];
                    return itemList(todo, context);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTodoDialog(); // Menampilkan dialog untuk input todo baru
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
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
            decoration:
                todo.isDone ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      leading: IconButton(
        onPressed: () async {
          _changeStatus(todo);
          await DatabaseHelper.instance.updateTodo(todo);
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
              await DatabaseHelper.instance.deleteTodo(todo.id!);
              _refreshTodoList();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 20,
            )),
      ),
      onTap: () {
        _showTodoDialog(todo: todo); // Menampilkan dialog untuk edit todo
      },
    );
  }
}
