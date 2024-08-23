class Todo {
  int? id;
  String title;
  String? date;
  bool isDone;

  Todo({
    this.id,
    required this.title,
    this.date,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      isDone: map['isDone'] == 1,
    );
  }
}
