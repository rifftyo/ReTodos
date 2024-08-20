import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/provider/time_picker_provider.dart';
import 'package:todolist_app/provider/todo_provider.dart';

Future<void> showTodoDialog(BuildContext context, {Todo? todo}) async {
  final TextEditingController _controller =
      TextEditingController(text: todo?.title ?? '');

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Consumer<TimePickerProvider>(
                    builder: (context, timePicker, child) {
                      final selectedDate = timePicker.selectedDateTime;
                      return TextButton(
                        child: Text(
                          selectedDate != null
                              ? DateFormat('dd/MM/yy HH:mm')
                                  .format(selectedDate)
                              : todo?.date != null
                                  ? todo!.date.toString()
                                  : 'Set Alarm',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () async {
                          timePicker.selectDateTime(context);
                        },
                      );
                    },
                  )),
              TextButton(
                child: Text(todo == null ? 'Simpan' : 'Update'),
                onPressed: () async {
                  final String title = _controller.text;
                  if (title.isNotEmpty) {
                    final todoProvider =
                        Provider.of<TodoProvider>(context, listen: false);
                    final timePickerProvider =
                        Provider.of<TimePickerProvider>(context, listen: false);
                    final timeSet = timePickerProvider.selectedDateTime;
                    if (todo == null) {
                      final newTodo = Todo(
                        title: title,
                        date: timeSet != null
                            ? DateFormat('dd/MM/yy HH:mm').format(timeSet)
                            : null,
                        isDone: false,
                      );
                      await todoProvider.addTodo(newTodo);
                    } else {
                      todo.title = title;
                      todo.date = timeSet != null
                          ? DateFormat('dd/MM/yy HH:mm').format(timeSet)
                          : todo.date;
                      await todoProvider.updateTodo(todo);
                    }
                    Navigator.of(context).pop();
                    timePickerProvider.resetSelectedDateTime();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
