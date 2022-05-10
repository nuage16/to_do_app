import 'package:flutter/foundation.dart';
import 'package:to_do_app/db/todo_db.dart';
import 'package:to_do_app/models/todo_item_model.dart';

class ToDoProvider extends ChangeNotifier {
  ToDoProvider() {
    // ignore: avoid_print
    print('Fetching data...');
    // ignore: avoid_print
    getAllToDoItemsFromDB().then((value) => print('Data fetched!'));
  }

  // ignore: non_constant_identifier_names
  final ToDoDatabase _ToDoItemDB = ToDoDatabase.init();
  List<ToDoItem>? _allToDoItems;

  List<ToDoItem>? get allToDoItems => _allToDoItems;

  getAllToDoItemsFromDB() async {
    _allToDoItems = await _ToDoItemDB.readAllToDoItems();
    print('Fetching all ToDoItems...');
    print(_allToDoItems);
    notifyListeners();
  }

  Future<ToDoItem?> ToDoItemFromDB(id) async {
    return await _ToDoItemDB.readToDo(id);
  }

  void addToDoItemToDB(value) async {
    _ToDoItemDB.createToDoItem(value).then((value) => print('Data added!'));
    getAllToDoItemsFromDB();
    notifyListeners();
  }

  void updateToDoItemFromDB(value) async {
    await _ToDoItemDB.updateToDoItem(value);
    getAllToDoItemsFromDB();
    notifyListeners();
  }

  void deleteToDoItemFromDB(id) async {
    await ToDoDatabase.instance.deleteToDoItem(id);
    getAllToDoItemsFromDB();
    notifyListeners();
  }

  // void setDateFilter(DateTime currDate) {
  //   notifyListeners();
  // }
}
