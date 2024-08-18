import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/provider/theme_provider.dart';
import 'package:todolist_app/provider/todo_provider.dart';
import 'package:todolist_app/widgets/dialog_add_todo.dart';
import 'package:todolist_app/widgets/item_todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
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
              );
            },
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: const Text('Search Your Todo',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    onChanged: (value) {
                      todoProvider.searchTodos(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search Here...",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Consumer<TodoProvider>(
                  builder: (context, todoProvider, _) {
                    return todoProvider.searchEmpty
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 45),
                              child: Text(
                                'No Todos Found',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: todoProvider.todoList.length,
                              itemBuilder: (context, index) {
                                Todo todo = todoProvider.todoList[index];
                                return itemList(todo, context);
                              },
                            ),
                          );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoDialog(context); // Menampilkan dialog untuk input todo baru
        },
        shape: const StadiumBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
