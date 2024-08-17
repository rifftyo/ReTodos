import 'package:flutter/material.dart';
import 'package:todolist_app/helpers/database_helper.dart';
import 'package:todolist_app/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todoList = [];
  List<Todo> _filteredTodoList = [];
  bool _searchEmpty = false;

  List<Todo> get todoList =>
      _filteredTodoList.isEmpty ? _todoList : _filteredTodoList;

  bool get searchEmpty => _searchEmpty;

  Future<void> fetchTodos() async {
    _todoList = await DatabaseHelper.instance.fetchTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await DatabaseHelper.instance.insertTodo(todo);
    await fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await DatabaseHelper.instance.updateTodo(todo);
    await fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    await fetchTodos();
  }

  void toggleStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    updateTodo(todo);
  }

  searchTodos(String value) {
    if (value.isEmpty) {
      _filteredTodoList = _todoList;
      _searchEmpty = false;
    } else {
      _filteredTodoList = _todoList
          .where(
              (item) => item.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
      _searchEmpty = _filteredTodoList.isEmpty;
    }
    notifyListeners();
  }
}
