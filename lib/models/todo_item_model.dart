const String tableName = 'todo';

class ToDoItemFields {
//This represents all the fields of the model object
  static const String id = 'id';
  static const String toDoName = 'toDoName';
  static const String isDone = 'isDone';
  static const String dueDate = 'dueDate';

  //This makes sure that all columns are read from the ToDoItem object
  static final List<String> values = [
    //Add all fields
    id, toDoName, isDone, dueDate
  ];
}

class ToDoItem {
  int? id;
  String toDoName;
  bool isDone;
  DateTime dueDate;

  ToDoItem(
      {this.id,
      required this.toDoName,
      required this.isDone,
      required this.dueDate});

  ToDoItem copy({
    int? id,
    String? toDoName,
    bool? isDone,
    DateTime? dueDate,
  }) =>
      ToDoItem(
        id: id ?? this.id,
        toDoName: toDoName ?? this.toDoName,
        isDone: isDone ?? this.isDone,
        dueDate: dueDate ?? this.dueDate,
      );

  Map<String, Object?> toJson() => {
        ToDoItemFields.id: id,
        ToDoItemFields.toDoName: toDoName,
        ToDoItemFields.isDone: isDone ? 1 : 0,
        ToDoItemFields.dueDate: dueDate.toIso8601String(),
      };

  static ToDoItem fromJson(Map<String, Object?> json) => ToDoItem(
        id: json[ToDoItemFields.id] as int,
        toDoName: json[ToDoItemFields.toDoName] as String,
        dueDate: DateTime.parse(json[ToDoItemFields.dueDate] as String),
        isDone: json[ToDoItemFields.isDone] == 1,
      );

//Sample data
  static List<ToDoItem> toDoList = [
    ToDoItem(
        id: 0,
        toDoName: "Setup Flutter",
        isDone: true,
        dueDate: DateTime.now()),
    ToDoItem(
        id: 1, toDoName: "Learn Dart", isDone: false, dueDate: DateTime.now()),
    ToDoItem(
        id: 2,
        toDoName: "Learn Flutter",
        isDone: false,
        dueDate: DateTime.now()),
    ToDoItem(
        id: 3,
        toDoName: "Create Flutter To-Do App",
        isDone: false,
        dueDate: DateTime.now()),
    ToDoItem(id: 4, toDoName: "Submit", isDone: false, dueDate: DateTime.now()),
  ];
}
