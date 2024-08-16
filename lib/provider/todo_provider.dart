import 'package:flutter/material.dart';
import 'package:todolist_app/helpers/database_helper.dart';
import 'package:todolist_app/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todoList = [];

  List<Todo> get todoList => _todoList;

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
}
