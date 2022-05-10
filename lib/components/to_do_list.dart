import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo_item_model.dart';
import 'package:to_do_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/time_utils.dart';
import '../provider/date_provider.dart';
import 'package:to_do_app/components/bottom_modal.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Icon? searchPrefixIcon;
  Icon? searchSufixIcon;
  Icon? itemLeadWidget;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  List<ToDoItem> filteredList = [];
  List<ToDoItem> completedList = [];
  late bool completedIsHidden;

  @override
  void initState() {
    searchPrefixIcon = const Icon(Icons.search);
    itemLeadWidget = const Icon(Icons.check_box);
    completedIsHidden = true;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _updateController.dispose();
    super.dispose();
  }

  bool filterByCompletion(ToDoItem item) {
    if (item.isDone) {
      completedList.add(item);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _toDoProvider = Provider.of<ToDoProvider>(context);
    final _dateProvider = Provider.of<DateProvider>(context);

    //Empty list on every rebuild
    filteredList.clear();
    completedList.clear();

    if (_toDoProvider.allToDoItems != null) {
      if (_dateProvider.filterDate != null) {
        DateTime filter = TimeUtils.getDate(_dateProvider.filterDate!);

        filteredList = _toDoProvider.allToDoItems!.where((element) {
          //This filters the list by date
          if (element.dueDate == filter ||
              element.dueDate.isAfter(filter) &&
                  element.dueDate.isBefore(filter.add(
                    const Duration(days: 1),
                  ))) {
            //Separate completed todo from not completed
            return filterByCompletion(element);
          }
          return false;
        }).toList();
      } else {
        //When 'All' is tapped, list need not be filtered
        //filteredList = _toDoProvider.allToDoItems!;
        List<ToDoItem> list = _toDoProvider.allToDoItems!.where((element) {
          //Separate completed todo from not completed
          return filterByCompletion(element);
        }).toList();

        filteredList = list;
      }

      if (filteredList.isNotEmpty || completedList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //To-Do List
              Expanded(
                child: ListView(
                  physics: const ScrollPhysics(),
                  children: [
                    ///This list holds the uncompleted tasks
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 16.0,
                        ),
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = filteredList[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                            child: Dismissible(
                              key: UniqueKey(),
                              background: onDeleteBg(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                childAlign: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 16.0),
                              ),
                              secondaryBackground: onDeleteBg(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                childAlign: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16.0),
                              ),
                              onDismissed: (direction) async {
                                setState(() {
                                  // Remove the item from the data source.
                                  _toDoProvider.deleteToDoItemFromDB(item.id);
                                  // filteredList.removeAt(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${item.toDoName} is deleted')));
                              },
                              child: Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  onTap: () {
                                    _updateController.text = item.toDoName;
                                    //Show a Bottom Modal Sheet
                                    getModalSheet(
                                        context: context,
                                        controller: _updateController,
                                        add: false,
                                        object: item);
                                  },
                                  selectedTileColor:
                                      Theme.of(context).primaryColor,
                                  leading: leadingWidget(index, _toDoProvider,
                                      filteredList[index].isDone),
                                  title: Text(
                                    item.toDoName,
                                    style: item.isDone
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.black54)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                    ListTile(
                        onTap: () {
                          setState(() {
                            completedIsHidden = !completedIsHidden;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 0,
                        leading: completedIsHidden
                            ? const Icon(Icons.keyboard_arrow_down)
                            : const Icon(Icons.keyboard_arrow_up),
                        title: const Text('Completed')),

                    ///This list holds the completed tasks
                    Visibility(
                      visible: completedIsHidden,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: completedList.length,
                          itemBuilder: ((context, index) {
                            final item = completedList[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4.0),
                              child: Dismissible(
                                key: UniqueKey(),
                                background: onDeleteBg(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  childAlign: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 16.0),
                                ),
                                secondaryBackground: onDeleteBg(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  childAlign: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                ),
                                onDismissed: (direction) async {
                                  _toDoProvider.deleteToDoItemFromDB(item.id);

                                  // Remove the item from the data source.
                                  setState(() {
                                    completedList.removeAt(index);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${item.toDoName} is deleted')));
                                  });
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    onTap: () {
                                      _updateController.text = item.toDoName;
                                      //Show a Bottom Modal Sheet
                                      getModalSheet(
                                          context: context,
                                          controller: _updateController,
                                          add: false,
                                          object: item);
                                    },
                                    selectedTileColor:
                                        Theme.of(context).primaryColor,
                                    leading: leadingWidget(index, _toDoProvider,
                                        completedList[index].isDone),
                                    title: Text(
                                      item.toDoName,
                                      style: item.isDone
                                          ? const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.black54)
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child:
            Text('Empty List!', style: Theme.of(context).textTheme.headline6),
      ),
    );
  }

  Widget onDeleteBg({begin, end, childAlign, padding}) {
    return Container(
      padding: padding,
      alignment: childAlign,
      child: const Icon(
        Icons.delete_outline,
        color: Colors.redAccent,
      ),
    );
  }

  Widget leadingWidget(int index, provider, value) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      value: value,
      onChanged: (bool? val) {
        provider.updateToDoItemFromDB(ToDoItem(
            id: filteredList[index].id,
            toDoName: filteredList[index].toDoName,
            isDone: val!,
            dueDate: filteredList[index].dueDate));
      },
    );
  }
}
