import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_app/models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb('todo.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      date TEXT,
      isDone INTEGER NOT NULL
    )
    ''');
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await instance.database;
    await db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> fetchTodos() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<void> deleteTodo(int id) async {
    final db = await instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await instance.database;
    await db
        .update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
