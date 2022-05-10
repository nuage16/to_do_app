import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/models/todo_item_model.dart';

class ToDoDatabase {
  // ignore: constant_identifier_names
  static const String DBNAME = 'todo_app';

  static final ToDoDatabase instance = ToDoDatabase.init();

  static Database? _database;

  ToDoDatabase.init();

  Future<Database> get database async {
    //Check if database already exists
    //if (_database != null) return _database!;

    _database = await _initDB('$DBNAME.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //final dbPath = await getDatabasesPath();

    ///Instead of using the default database in file storage system,
    ///application documents directory is used
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final path = join(appDocPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //final idType = 'STRING PRIMARY KEY';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT';

    await db
        .execute('''
  CREATE TABLE $tableName (
    ${ToDoItemFields.id} $idType,
    ${ToDoItemFields.toDoName} $textType,
    ${ToDoItemFields.isDone} $boolType,
    ${ToDoItemFields.dueDate} $textType
  )
''')
        // ignore: avoid_print
        .then((value) => print('$tableName table successfully added!'))
        // ignore: avoid_print
        .onError((error, stackTrace) => print(error));
  }

  Future<ToDoItem> createToDoItem(ToDoItem toDoItem) async {
    final db = await instance.database;
    final id = await db.insert(tableName, toDoItem.toJson());

    return toDoItem.copy(id: id);
  }

  Future<ToDoItem> readToDo(int id) async {
    final db = await instance.database;

    ///Using the where and whereArgs syntax is more secured because
    ///it prevents sql injection attacks
    final maps = await db.query(
      tableName,
      columns: ToDoItemFields.values,
      where: '${ToDoItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return ToDoItem.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ToDoItem>> readAllToDoItems() async {
    final db = await instance.database;
    const orderBy = '${ToDoItemFields.dueDate} DESC';
    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => ToDoItem.fromJson(json)).toList();
  }

  Future<int> updateToDoItem(ToDoItem toDoItem) async {
    final db = await instance.database;

    return db.update(tableName, toDoItem.toJson(),
        where: '${ToDoItemFields.id} = ?', whereArgs: [toDoItem.id]);
  }

  Future<int> deleteToDoItem(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableName, where: '${ToDoItemFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
