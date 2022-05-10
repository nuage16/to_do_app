import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo_item_model.dart';
import 'package:to_do_app/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class ToDoItemTile extends StatefulWidget {
  final Function onDeleteBg;
  final ToDoItem item;
  final Function onItemDismissed;

  ToDoItemTile(
      {required this.onDeleteBg,
      required this.item,
      required this.onItemDismissed});

  @override
  State<ToDoItemTile> createState() => _ToDoItemTileState();
}

class _ToDoItemTileState extends State<ToDoItemTile> {
  @override
  Widget build(BuildContext context) {
    final _toDoProvider = Provider.of<ToDoProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Dismissible(
        key: UniqueKey(),
        background: widget.onDeleteBg(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          childAlign: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 16.0),
        ),
        secondaryBackground: widget.onDeleteBg(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          childAlign: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
        ),
        onDismissed: (direction) async {
          // _toDoProvider.deleteToDoItemFromDB(widget.list[index].id);

          // Remove the item from the data source.
          // setState(() {
          //   filteredList.removeAt(index);
          //   ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('${item.toDoName} is deleted')));
          // });
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            onTap: () {
              // _updateController.text = item.toDoName;
              // //Show a Bottom Modal Sheet
              // getModalSheet(
              //     context: context,
              //     controller: _updateController,
              //     add: false,
              //     object: item);
            },
            selectedTileColor: Theme.of(context).primaryColor,
            //leading: leadingWidget(index, _toDoProvider),
            title: Text(
              widget.item.toDoName,
              style: widget.item.isDone
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
